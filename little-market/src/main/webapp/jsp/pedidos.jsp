<%@ page import="br.com.littlemarket.model.User" %>
<%@ page import="br.com.littlemarket.model.Pedido" %>
<%@ page import="br.com.littlemarket.dao.PedidoDao" %>
<%@ page import="java.util.*" %>
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
    <header>
        <div class="logo-container">
            <img src="../img/INDEX/logo-pequena.png" alt="Logo Little Market" class="logo-img">
            <div class="logo-text">Little Market</div>
        </div>
        <nav>
            <a href="../html/usuario.html">Home</a>
            <a href="../html/produto.jsp">Produtos</a>
        </nav>
    </header>

    <main>
        <h2>Meus Pedidos</h2>
        
        <% if (request.getParameter("sucesso") != null) { %>
            <div class="alert alert-success">
                <strong>Sucesso!</strong> <%= request.getParameter("sucesso") %>
            </div>
        <% } %>

        <% if (request.getParameter("erro") != null) { %>
            <div class="alert alert-danger">
                <strong>Erro!</strong> <%= request.getParameter("erro") %>
            </div>
        <% } %>

        <div class="painel">
            <%
                User user = (User) session.getAttribute("user");
                if (user != null) {
                    PedidoDao pedidoDao = new PedidoDao();
                    List<Pedido> pedidos = pedidoDao.getPedidosByUserId(user.getId());
                    
                    if (pedidos.isEmpty()) {
            %>
                        <p>Você ainda não fez nenhum pedido.</p>
            <%
                    } else {
                        for (Pedido pedido : pedidos) {
            %>
                            <div class="card">
                                <h3>Pedido #<%= pedido.getId() %></h3>
                                <p>Data: <%= pedido.getData() %></p>
                                <p>Status: <%= pedido.getStatus() %></p>
                                <p>Total: R$ <%= String.format("%.2f", pedido.getTotal()) %></p>
                            </div>
            <%
                        }
                    }
                } else {
            %>
                    <p>Por favor, faça login para ver seus pedidos.</p>
            <%
                }
            %>
        </div>

        <div class="actions">
            <a href="../html/pedido.jsp" class="card">🛒 Fazer Novo Pedido</a>
            <a href="../html/usuario.html" class="card">🏠 Voltar para Home</a>
            <a href="../html/Conta.jsp" class="card">👤 Dados da Conta</a>
        </div>
    </main>

    <footer>
        &copy; 2024 Little Market - Todos os direitos reservados.
    </footer>
</body>
</html> 