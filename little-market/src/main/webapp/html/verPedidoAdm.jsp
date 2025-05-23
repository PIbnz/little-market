<%@ page import="br.com.littlemarket.dao.PedidoDao" %>
<%@ page import="br.com.littlemarket.model.Pedido" %>
<%@ page import="br.com.littlemarket.model.ItemPedido" %>
<%@ page import="java.util.List" %>
<%@ page import="br.com.littlemarket.dao.UserDao" %>
<%@ page import="br.com.littlemarket.model.User" %>
<%@ page import="br.com.littlemarket.dao.ProdutoDao" %>
<%@ page import="br.com.littlemarket.model.Produto" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <title>Detalhes do Pedido - Admin</title>
    <link rel="stylesheet" href="../css/gerenciar.css">
</head>
<body>
    <%
        // Verificar se o usuário está logado e é admin
        User user = (User) session.getAttribute("user");
        if (user == null || user.getPermissionLevel() != 2) {
            response.sendRedirect("../html/login.jsp");
            return;
        }

        PedidoDao pedidoDao = new PedidoDao();
        UserDao userDao = new UserDao();
        ProdutoDao produtoDao = new ProdutoDao();
        
        String pedidoId = request.getParameter("id");
        Pedido pedido = null;
        
        if (pedidoId != null) {
            try {
                int pid = Integer.parseInt(pedidoId);
                List<Pedido> allPedidos = pedidoDao.getAllPedidos();
                for (Pedido p : allPedidos) {
                    if (p.getId() == pid) {
                        pedido = p;
                        break;
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    %>
    <jsp:include page="../jsp/navbar_dono.jsp" />

    <main>
        <div class="container">
            <div class="header-actions">
                <a href="verPedidosAdm.jsp" class="btn-back">← Voltar para Lista de Pedidos</a>
                <h1>Detalhes do Pedido #<%= pedido != null ? pedido.getId() : "" %></h1>
            </div>

            <% if (pedido == null) { %>
                <div class="alert alert-danger">
                    Pedido não encontrado.
                </div>
            <% } else { 
                User cliente = userDao.getUserById(pedido.getUserId());
            %>
                <div class="pedido-detalhes">
                    <div class="info-section">
                        <h2>Informações do Pedido</h2>
                        <div class="info-grid">
                            <div class="info-item">
                                <span class="label">Cliente:</span>
                                <span class="value"><%= cliente != null ? cliente.getName() : "Cliente #" + pedido.getUserId() %></span>
                            </div>
                            <div class="info-item">
                                <span class="label">Data:</span>
                                <span class="value"><%= pedido.getData() %></span>
                            </div>
                            <div class="info-item">
                                <span class="label">Status:</span>
                                <span class="status-badge <%= pedido.getStatus().toLowerCase() %>">
                                    <%= pedido.getStatus() %>
                                </span>
                            </div>
                            <div class="info-item">
                                <span class="label">Total:</span>
                                <span class="value">R$ <%= String.format("%.2f", pedido.getTotal()) %></span>
                            </div>
                        </div>
                    </div>

                    <div class="itens-section">
                        <h2>Itens do Pedido</h2>
                        <div class="itens-grid">
                            <% if (pedido.getItens() != null) { %>
                                <% for (ItemPedido item : pedido.getItens()) { 
                                    Produto produto = produtoDao.getProdutoById(item.getProdutoId());
                                %>
                                    <div class="item-card">
                                        <img src="<%= produto != null ? produto.getImagemUrl() : "" %>" 
                                             alt="<%= produto != null ? produto.getNome() : "Produto" %>" 
                                             class="item-image">
                                        <div class="item-details">
                                            <h3><%= produto != null ? produto.getNome() : ("Produto #" + item.getProdutoId()) %></h3>
                                            <p class="quantidade">Quantidade: <%= item.getQuantidade() %></p>
                                            <p class="preco-unitario">Preço unitário: R$ <%= String.format("%.2f", item.getPrecoUnitario()) %></p>
                                            <p class="subtotal">Subtotal: R$ <%= String.format("%.2f", item.getPrecoUnitario() * item.getQuantidade()) %></p>
                                        </div>
                                    </div>
                                <% } %>
                            <% } %>
                        </div>
                    </div>

                    <% if (!"concluido".equalsIgnoreCase(pedido.getStatus())) { %>
                        <div class="actions-section">
                            <form method="post" action="<%= request.getContextPath() %>/html/verPedidosAdm.jsp" 
                                  onsubmit="return confirm('Tem certeza que deseja concluir este pedido?');">
                                <input type="hidden" name="concluirId" value="<%= pedido.getId() %>">
                                <button type="submit" class="btn-concluir">Concluir Pedido</button>
                            </form>
                        </div>
                    <% } %>
                </div>
            <% } %>
        </div>
    </main>

    <footer>
        &copy; 2024 Little Market - Todos os direitos reservados.
    </footer>

    <style>
        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
        }

        .header-actions {
            display: flex;
            align-items: center;
            gap: 20px;
            margin-bottom: 30px;
        }

        .btn-back {
            background: #6c757d;
            color: white;
            text-decoration: none;
            padding: 8px 16px;
            border-radius: 4px;
            font-weight: 500;
            transition: background 0.3s ease;
        }

        .btn-back:hover {
            background: #5a6268;
        }

        .pedido-detalhes {
            background: white;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            padding: 25px;
        }

        .info-section, .itens-section {
            margin-bottom: 30px;
        }

        .info-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin-top: 15px;
        }

        .info-item {
            display: flex;
            flex-direction: column;
            gap: 5px;
        }

        .label {
            color: #666;
            font-size: 0.9em;
        }

        .value {
            font-weight: 500;
            color: #333;
        }

        .itens-grid {
            display: grid;
            gap: 20px;
            margin-top: 15px;
        }

        .item-card {
            display: flex;
            gap: 20px;
            padding: 15px;
            border: 1px solid #eee;
            border-radius: 8px;
            background: #f8f9fa;
        }

        .item-image {
            width: 100px;
            height: 100px;
            object-fit: cover;
            border-radius: 4px;
        }

        .item-details {
            flex: 1;
        }

        .item-details h3 {
            margin: 0 0 10px 0;
            color: #333;
        }

        .item-details p {
            margin: 5px 0;
            color: #666;
        }

        .subtotal {
            font-weight: bold;
            color: #28a745;
        }

        .actions-section {
            margin-top: 30px;
            padding-top: 20px;
            border-top: 1px solid #eee;
        }

        .btn-concluir {
            background: #28a745;
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 4px;
            cursor: pointer;
            font-weight: 600;
            transition: background 0.3s ease;
        }

        .btn-concluir:hover {
            background: #218838;
        }

        .status-badge {
            display: inline-block;
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 0.85em;
            font-weight: 600;
        }

        .status-badge.pendente {
            background-color: #fff3cd;
            color: #856404;
        }

        .status-badge.concluido {
            background-color: #d4edda;
            color: #155724;
        }

        .alert {
            padding: 15px;
            border-radius: 4px;
            margin-bottom: 20px;
        }

        .alert-danger {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
    </style>
</body>
</html> 