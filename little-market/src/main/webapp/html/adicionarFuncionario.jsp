<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <title>Adicionar Funcionário - Little Market</title>
    <link rel="stylesheet" href="../css/usuario.css">
</head>
<body>
    <jsp:include page="../jsp/navbar.jsp" />
    <main>
        <div class="container">
            <h2>Novo Funcionário</h2>
            <form method="post" action="../create-user" class="cadastro-form">
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