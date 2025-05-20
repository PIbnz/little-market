<%@ page import="br.com.littlemarket.model.User" %>
<%
    User user = (User) session.getAttribute("user");
%>
<header>
    <div class="logo-container">
        <img src="../img/INDEX/logo-pequena.png" alt="Logo Little Market" class="logo-img">
        <div class="logo-text">Little Market</div>
    </div>
    <nav>
        <a href="../html/usuario.html">Home</a>
        <a href="../html/pedido.jsp">Novo Pedido</a>
        <a href="../html/verPedido.jsp">Meus Pedidos</a>
        <a href="../html/Conta.jsp">Minha Conta</a>
        <a href="../html/produto.jsp">Produtos</a>
    </nav>
    <div class="user-menu">
        <% if (user != null) { %>
            <span>Olá, <%= user.getName() %></span>
            <a href="../html/login.html">Sair</a>
        <% } else { %>
            <a href="../html/login.html">Login</a>
        <% } %>
    </div>
</header> 