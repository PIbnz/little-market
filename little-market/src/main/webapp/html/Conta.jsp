<%@ page import="br.com.littlemarket.model.User" %>
<%@ page import="br.com.littlemarket.model.Pedido" %>
<%@ page import="br.com.littlemarket.dao.PedidoDao" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Minha Conta - Little Market</title>
    <link rel="stylesheet" href="../css/usuario.css">
    <style>
        .conta-container {
            display: grid;
            grid-template-columns: 1fr 2fr;
            gap: 2rem;
        }
        .info-card, .pedidos-section {
            background:#fff;
            padding:1.5rem;
            border-radius:8px;
            box-shadow:0 2px 4px rgba(0,0,0,0.1);
        }
        .pedidos-lista {
            display:grid;
            gap:1rem;
            max-height:400px;
            overflow:auto;
        }
    </style>
</head>
<body>
    <jsp:include page="../jsp/navbar.jsp" />

    <%
        User user = (User) session.getAttribute("user");
        PedidoDao pedidoDao = new PedidoDao();
        List<Pedido> pedidos = new ArrayList<Pedido>();
        
        if (user != null) {
            try {
                pedidos = pedidoDao.getPedidosByUserId(user.getId());
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    %>

    <main>
        <div class="container">
            <h2>Minha Conta</h2>
            
            <% if (user == null) { %>
                <div class="alert alert-warning">
                    Você precisa estar logado para ver sua conta.
                    <a href="../html/login.jsp">Fazer login</a>
                </div>
            <% } else { %>
                <div class="conta-container">
                    <div class="info-section">
                        <h3>Informações Pessoais</h3>
                        <div class="info-card">
                            <p><strong>Nome:</strong> <%= user.getName() %></p>
                            <p><strong>Email:</strong> <%= user.getEmail() %></p>
                        </div>
                    </div>

                    <div class="pedidos-section">
                        <h3>Meus Últimos Pedidos</h3>
                        <% if (pedidos.isEmpty()) { %>
                            <div class="alert alert-info">
                                Você ainda não tem pedidos.
                                <a href="../html/pedido.jsp">Fazer um pedido</a>
                            </div>
                        <% } else { %>
                            <div class="pedidos-lista">
                                <% for (Pedido pedido : pedidos) { %>
                                    <div class="pedido-card">
                                        <div class="pedido-header">
                                            <h4>Pedido #<%= pedido.getId() %></h4>
                                            <span class="status <%= pedido.getStatus().toLowerCase() %>">
                                                <%= pedido.getStatus() %>
                                            </span>
                                        </div>
                                        <div class="pedido-info">
                                            <p><strong>Data:</strong> <%= pedido.getData() %></p>
                                            <p><strong>Total:</strong> R$ <%= String.format("%.2f", pedido.getTotal()) %></p>
                                        </div>
                                    </div>
                                <% } %>
                            </div>
                        <% } %>
                    </div>
                </div>
            <% } %>
        </div>
    </main>

    <footer>
        &copy; 2024 Little Market - Todos os direitos reservados.
    </footer>
</body>
</html>