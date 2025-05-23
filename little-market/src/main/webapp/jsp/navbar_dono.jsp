<%@ page import="br.com.littlemarket.model.User" %>
<%
    User user = (User) session.getAttribute("user");
%>
<header>
    <div class="logo-container">
        <img src="../img/INDEX/logo-pequena.png" alt="Logo da empresa Little Market" class="logo-img" />
        <div class="logo-text">Little Market</div>
    </div>

    <nav>
        <a href="produto.jsp">Home</a>
    </nav>

    <div class="user-menu">
        <span>Admin</span>
        <a href="../html/login.html">Sair</a>
    </div>
</header> 