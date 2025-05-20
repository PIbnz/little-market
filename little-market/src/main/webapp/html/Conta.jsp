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
</head>
<body>
    <jsp:include page="../jsp/navbar.jsp" />

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

    <main>
        <div class="container">
            <h2>Minha Conta</h2>
            
            <% if (user == null) { %>
                <div class="alert alert-warning">
                    Você precisa estar logado para ver sua conta.
                    <a href="../html/login.html">Fazer login</a>
                </div>
            <% } else { %>
                <div class="conta-container">
                    <div class="info-section">
                        <h3>Informações Pessoais</h3>
                        <div class="info-card">
                            <p><strong>Nome:</strong> <%= user.getName() %></p>
                            <p><strong>Email:</strong> <%= user.getEmail() %></p>
                            <p><strong>CPF:</strong> <%= user.getCpf() %></p>
                            <p><strong>Telefone:</strong> <%= user.getTelefone() %></p>
                            <p><strong>Endereço:</strong> <%= user.getEndereco() %></p>
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