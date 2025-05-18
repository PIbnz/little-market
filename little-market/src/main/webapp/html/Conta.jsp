<%@ page import="br.com.littlemarket.model.User" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <title>Minha Conta - Little Market</title>
    <link rel="stylesheet" href="../css/Conta.css">
</head>
<body>
<header>
    <div class="logo-container">
        <img src="../img/INDEX/logo-pequena.png" alt="Logo Little Market" class="logo-img">
        <div class="logo-text">Little Market</div>
    </div>
    <nav>
        <a href="produto.jsp">Alimentos</a>
        <a href="produto.jsp">Higiene</a>
        <a href="produto.jsp">Limpeza</a>
    </nav>
    <div class="user-menu">
        <%
            User user = (User) session.getAttribute("user");
            if (user != null) {
        %>
        <span>Olá, <%= user.getName() %></span>
        <a href="../html/login.html">Sair</a>
    </div>
</header>

<main>
    <section class="conta-box">
        <h2>Dados da Minha Conta</h2>

        <p><strong>Nome: </strong> <%= user.getName() %>
        </p>
        <p><strong>Email: </strong> <%= user.getEmail() %>
        </p>
        <%
            }
        %>
    </section>
</main>

<footer>
    &copy; 2024 Little Market - Todos os direitos reservados.
</footer>

</body>
</html>