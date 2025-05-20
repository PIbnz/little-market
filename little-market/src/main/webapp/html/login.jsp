<%@ page import="br.com.littlemarket.model.User" %>
<%@ page import="br.com.littlemarket.dao.LoginDao" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - Little Market</title>
    <link rel="stylesheet" href="../css/usuario.css">
</head>
<body>
    <jsp:include page="../jsp/navbar.jsp" />

    <%
        // Processa o logout
        String logout = request.getParameter("logout");
        if (logout != null && logout.equals("true")) {
            session.invalidate();
            response.sendRedirect("login.jsp");
            return;
        }

        // Verifica se já está logado
        User user = (User) session.getAttribute("user");
        if (user != null) {
            response.sendRedirect("usuario.html");
            return;
        }

        // Processa o login
        String email = request.getParameter("email");
        String senha = request.getParameter("senha");
        String error = null;

        if (email != null && senha != null) {
            try {
                LoginDao loginDao = new LoginDao();
                User loggedUser = loginDao.login(email, senha);
                
                if (loggedUser != null) {
                    // Salva o usuário na sessão
                    session.setAttribute("user", loggedUser);
                    response.sendRedirect("usuario.html");
                    return;
                } else {
                    error = "Email ou senha inválidos";
                }
            } catch (Exception e) {
                error = "Erro ao fazer login: " + e.getMessage();
                e.printStackTrace();
            }
        }
    %>

    <main>
        <div class="container">
            <div class="login-container">
                <h2>Login</h2>
                
                <% if (error != null) { %>
                    <div class="alert alert-danger">
                        <%= error %>
                    </div>
                <% } %>

                <form method="post" class="login-form">
                    <div class="form-group">
                        <label for="email">Email:</label>
                        <input type="email" id="email" name="email" required>
                    </div>

                    <div class="form-group">
                        <label for="senha">Senha:</label>
                        <input type="password" id="senha" name="senha" required>
                    </div>

                    <button type="submit" class="btn btn-primary">Entrar</button>
                </form>

                <div class="login-links">
                    <p>Não tem uma conta? <a href="cadastro.jsp">Cadastre-se</a></p>
                </div>
            </div>
        </div>
    </main>

    <footer>
        &copy; 2024 Little Market - Todos os direitos reservados.
    </footer>
</body>
</html> 