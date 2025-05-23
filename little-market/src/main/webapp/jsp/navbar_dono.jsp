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
        <a href="../html/dono.html">Painel</a>
        <a href="../html/verPedidosAdm.jsp">Pedidos</a>
        <a href="../html/gerenciar.jsp">Estoque</a>
        <a href="../html/adicionarProduto.html">Adicionar Produto</a>
        <a href="../html/adicionarFuncionario.jsp">Adicionar Funcionário</a>
    </nav>
    <div class="user-menu">
        <% if (user != null) { %>
            <span>Ola, <%= user.getName() %> (Dono)</span>
            <a href="../html/login.jsp?logout=true">Sair</a>
        <% } else { %>
            <a href="../html/login.jsp">Login</a>
        <% } %>
    </div>
</header> 