<%@ page import="br.com.littlemarket.model.User" %>
<%@ page import="br.com.littlemarket.model.Pedido" %>
<%@ page import="br.com.littlemarket.model.ItemPedido" %>
<%@ page import="br.com.littlemarket.dao.PedidoDao" %>
<%@ page import="br.com.littlemarket.model.Produto" %>
<%@ page import="br.com.littlemarket.dao.ProdutoDao" %>
<%@ page import="br.com.littlemarket.dao.UserDao" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Detalhes do Pedido - Little Market</title>
    <link rel="stylesheet" href="../css/usuario.css">
</head>
<body>
    <%
        User user = (User) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect("../html/login.jsp");
            return;
        }

        // Decide qual navbar mostrar baseado no nível do usuário
        if (user.getPermissionLevel() == 2) {
            %><jsp:include page="../jsp/navbar_dono.jsp" /><%
        } else {
            %><jsp:include page="../jsp/navbar.jsp" /><%
        }
    %>

    <main>
        <div class="container">
            <%
                PedidoDao pedidoDao = new PedidoDao();
                ProdutoDao produtoDao = new ProdutoDao();
                UserDao userDao = new UserDao();
                
                // Verifica se está visualizando um pedido específico
                String pedidoId = request.getParameter("id");
                Pedido pedido = null;
                
                if (pedidoId != null) {
                    try {
                        int pid = Integer.parseInt(pedidoId);
                        // Busca o pedido específico do usuário
                        List<Pedido> userPedidos = pedidoDao.getPedidosByUserId(user.getId());
                        for (Pedido p : userPedidos) {
                            if (p.getId() == pid) {
                                pedido = p;
                                break;
                            }
                        }
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                }

                if (pedido != null) {
                    // Verifica se o usuário tem permissão para ver este pedido
                    boolean canView = user.getPermissionLevel() == 2 || pedido.getUserId() == user.getId();
                    
                    if (!canView) {
                        %>
                        <div class="alert alert-danger">
                            Você não tem permissão para ver este pedido.
                            <a href="javascript:history.back()">Voltar</a>
                        </div>
                        <%
                    } else {
                        User cliente = userDao.getUserById(pedido.getUserId());
                        %>
                        <div class="pedido-header-nav">
                            <a href="javascript:history.back()" class="btn-back">← Voltar</a>
                            <h2>Pedido #<%= pedido.getId() %></h2>
                        </div>

                        <div class="pedido-card">
                            <div class="pedido-header">
                                <div class="pedido-info-principal">
                                    <h3>Informações do Pedido</h3>
                                    <p><strong>Cliente:</strong> <%= cliente != null ? cliente.getName() : "Cliente #" + pedido.getUserId() %></p>
                                    <p><strong>Data:</strong> <%= pedido.getData() %></p>
                                    <p><strong>Status:</strong> 
                                        <span class="status <%= pedido.getStatus().toLowerCase() %>">
                                            <%= pedido.getStatus() %>
                                        </span>
                                    </p>
                                </div>
                                <% if (user.getPermissionLevel() == 2 && !"concluido".equalsIgnoreCase(pedido.getStatus())) { %>
                                    <form method="post" action="<%= request.getContextPath() %>/html/verPedidosAdm.jsp" 
                                          onsubmit="return confirm('Tem certeza que deseja concluir este pedido?');">
                                        <input type="hidden" name="concluirId" value="<%= pedido.getId() %>">
                                        <button type="submit" class="btn-concluir">Concluir Pedido</button>
                                    </form>
                                <% } %>
                            </div>

                            <div class="itens-pedido">
                                <h4>Itens do Pedido</h4>
                                <div class="itens-lista">
                                    <% if (pedido.getItens() != null) { %>
                                        <% for (ItemPedido item : pedido.getItens()) { 
                                               Produto produto = produtoDao.getProdutoById(item.getProdutoId());
                                         %>
                                            <div class="item">
                                                <div class="item-info">
                                                    <img src="<%= produto != null ? produto.getImagemUrl() : "" %>" 
                                                         alt="<%= produto != null ? produto.getNome() : "Produto" %>" 
                                                         class="item-thumb">
                                                    <div class="item-details">
                                                        <h5><%= produto != null ? produto.getNome() : ("Produto #" + item.getProdutoId()) %></h5>
                                                        <p class="quantidade">Quantidade: <%= item.getQuantidade() %></p>
                                                        <p class="preco-unitario">Preço unitário: R$ <%= String.format("%.2f", item.getPrecoUnitario()) %></p>
                                                    </div>
                                                </div>
                                                <p class="preco-total">R$ <%= String.format("%.2f", item.getPrecoUnitario() * item.getQuantidade()) %></p>
                                            </div>
                                        <% } %>
                                        <div class="pedido-total">
                                            <span>Total do Pedido:</span>
                                            <span class="valor-total">R$ <%= String.format("%.2f", pedido.getTotal()) %></span>
                                        </div>
                                    <% } %>
                                </div>
                            </div>
                        </div>
                        <%
                    }
                } else {
                    %>
                    <div class="alert alert-warning">
                        Pedido não encontrado.
                        <a href="javascript:history.back()">Voltar</a>
                    </div>
                    <%
                }
            %>
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

        .pedido-header-nav {
            display: flex;
            align-items: center;
            gap: 20px;
            margin-bottom: 20px;
        }

        .btn-back {
            text-decoration: none;
            color: #666;
            font-weight: 500;
            transition: color 0.3s;
        }

        .btn-back:hover {
            color: #333;
        }

        .pedido-card {
            background: white;
            border-radius: 8px;
            padding: 25px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }

        .pedido-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 25px;
        }

        .pedido-info-principal p {
            margin: 8px 0;
            color: #666;
        }

        .status {
            display: inline-block;
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 0.85em;
            font-weight: 600;
        }

        .status.pendente {
            background: #fff3cd;
            color: #856404;
        }

        .status.concluido {
            background: #d4edda;
            color: #155724;
        }

        .itens-pedido {
            border-top: 1px solid #eee;
            padding-top: 20px;
        }

        .itens-lista {
            margin-top: 15px;
        }

        .item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 15px 0;
            border-bottom: 1px solid #f5f5f5;
        }

        .item:last-child {
            border-bottom: none;
        }

        .item-info {
            display: flex;
            gap: 15px;
            align-items: center;
            flex: 1;
        }

        .item-thumb {
            width: 60px;
            height: 60px;
            object-fit: cover;
            border-radius: 4px;
        }

        .item-details h5 {
            margin: 0 0 5px 0;
            color: #333;
        }

        .item-details p {
            margin: 3px 0;
            color: #666;
        }

        .preco-total {
            font-weight: bold;
            color: #28a745;
            font-size: 1.1em;
            min-width: 100px;
            text-align: right;
        }

        .pedido-total {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-top: 20px;
            padding-top: 20px;
            border-top: 2px solid #eee;
            font-weight: bold;
        }

        .valor-total {
            font-size: 1.2em;
            color: #28a745;
        }

        .btn-concluir {
            background: #28a745;
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 4px;
            cursor: pointer;
            font-weight: 600;
            transition: background 0.3s;
        }

        .btn-concluir:hover {
            background: #218838;
        }

        .alert {
            padding: 15px;
            border-radius: 4px;
            margin-bottom: 20px;
        }

        .alert-warning {
            background: #fff3cd;
            border: 1px solid #ffeeba;
            color: #856404;
        }

        .alert-danger {
            background: #f8d7da;
            border: 1px solid #f5c6cb;
            color: #721c24;
        }

        .alert a {
            color: inherit;
            text-decoration: underline;
            margin-left: 10px;
        }
    </style>
</body>
</html>
