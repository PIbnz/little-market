<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="br.com.littlemarket.model.User"%>

<%
    User user = (User) session.getAttribute("user");
    if (user == null || user.getPermissionLevel() != 2) {
        response.sendRedirect("../html/login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Adicionar Funcionário - Little Market</title>
    <link rel="stylesheet" href="../css/dono.css">
</head>
<body>
    <header>
        <div class="logo-container">
            <img src="../img/INDEX/logo-pequena.png" alt="Logo Little Market" class="logo-img" />
            <div class="logo-text">Little Market</div>
        </div>

        <nav>
            <a href="verPedidosAdm.jsp">Pedidos</a>
            <a href="gerenciar.jsp">Estoque</a>
            <a href="adicionarProduto.html">Adicionar Produto</a>
            <a href="adicionarFuncionario.jsp">Adicionar Funcionário</a>
        </nav>

        <div class="user-menu">
            <span>Painel do Dono</span>
            <a href="login.jsp?logout=true">Sair</a>
        </div>
    </header>

    <main>
        <div class="container">
            <h2>Novo Funcionário</h2>
            <form method="post" action="<%= request.getContextPath() %>/create-user" class="cadastro-form">
                <input type="hidden" name="permissionLevel" value="2">
                <div class="form-group">
                    <label for="nome">Nome:</label>
                    <input type="text" id="nome" name="nome" required>
                </div>
                <div class="form-group">
                    <label for="email">Email:</label>
                    <input type="email" id="email" name="email" required>
                </div>
                <div class="form-group">
                    <label for="senha">Senha:</label>
                    <input type="password" id="senha" name="senha" required>
                </div>
                <button type="submit" class="btn btn-primary">Cadastrar Funcionário</button>
            </form>
        </div>
    </main>
</body>
</html> 