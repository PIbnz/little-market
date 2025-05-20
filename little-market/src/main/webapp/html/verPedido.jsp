<%@ page import="br.com.littlemarket.model.User" %>
<%@ page import="br.com.littlemarket.model.Pedido" %>
<%@ page import="br.com.littlemarket.model.ItemPedido" %>
<%@ page import="br.com.littlemarket.dao.PedidoDao" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Meus Pedidos - Little Market</title>
    <link rel="stylesheet" href="../css/usuario.css">
</head>
<body>
    <jsp:include page="../jsp/navbar.jsp" />

    <main>
        <div class="container">
            <h2>Meus Pedidos</h2>
            
            <%
                User user = (User) session.getAttribute("user");
                PedidoDao pedidoDao = new PedidoDao();
                List<Pedido> pedidos = new ArrayList<>();
                
                if (user != null) {
                    try {
                        pedidos = pedidoDao.getPedidosByUserId(user.getId());
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                }
            %>

            <% if (user == null) { %>
                <div class="alert alert-warning">
                    Você precisa estar logado para ver seus pedidos.
                    <a href="../html/login.html">Fazer login</a>
                </div>
            <% } else if (pedidos.isEmpty()) { %>
                <div class="alert alert-info">
                    Você ainda não tem pedidos.
                    <a href="../html/pedido.jsp">Fazer um pedido</a>
                </div>
            <% } else { %>
                <div class="pedidos-lista">
                    <% for (Pedido pedido : pedidos) { %>
                        <div class="pedido-card">
                            <div class="pedido-header">
                                <h3>Pedido #<%= pedido.getId() %></h3>
                                <span class="status <%= pedido.getStatus().toLowerCase() %>">
                                    <%= pedido.getStatus() %>
                                </span>
                            </div>
                            <div class="pedido-info">
                                <p><strong>Data:</strong> <%= pedido.getData() %></p>
                                <p><strong>Total:</strong> R$ <%= String.format("%.2f", pedido.getTotal()) %></p>
                            </div>
                            <div class="itens-pedido">
                                <h4>Itens do Pedido:</h4>
                                <% if (pedido.getItens() != null) { %>
                                    <% for (ItemPedido item : pedido.getItens()) { %>
                                        <div class="item">
                                            <p><%= item.getProdutoId() %> - <%= item.getQuantidade() %> unidade(s)</p>
                                            <p class="preco">R$ <%= String.format("%.2f", item.getPrecoUnitario() * item.getQuantidade()) %></p>
                                        </div>
                                    <% } %>
                                <% } %>
                            </div>
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

        .pedidos-lista {
            display: grid;
            gap: 20px;
            margin-top: 20px;
        }

        .pedido-card {
            background: white;
            border-radius: 8px;
            padding: 20px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }

        .pedido-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 15px;
        }

        .pedido-header h3 {
            margin: 0;
            color: #333;
        }

        .status {
            padding: 5px 10px;
            border-radius: 15px;
            font-size: 0.9em;
            font-weight: bold;
        }

        .status.pendente {
            background: #fff3cd;
            color: #856404;
        }

        .status.finalizado {
            background: #d4edda;
            color: #155724;
        }

        .pedido-info {
            margin-bottom: 15px;
        }

        .pedido-info p {
            margin: 5px 0;
            color: #666;
        }

        .itens-pedido {
            border-top: 1px solid #eee;
            padding-top: 15px;
        }

        .itens-pedido h4 {
            margin: 0 0 10px 0;
            color: #333;
        }

        .item {
            display: flex;
            justify-content: space-between;
            padding: 8px 0;
            border-bottom: 1px solid #f5f5f5;
        }

        .item:last-child {
            border-bottom: none;
        }

        .item p {
            margin: 0;
            color: #666;
        }

        .item .preco {
            font-weight: bold;
            color: #28a745;
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

        .alert-info {
            background: #d1ecf1;
            border: 1px solid #bee5eb;
            color: #0c5460;
        }

        .alert a {
            color: inherit;
            text-decoration: underline;
        }
    </style>
</body>
</html>
