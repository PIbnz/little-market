package br.com.littlemarket.servlet;

import br.com.littlemarket.model.User;
import br.com.littlemarket.dao.LoginDao;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("email");
        String senha = request.getParameter("senha");

        User user = new LoginDao().login(email, senha);

        if (user != null) {
            HttpSession session = request.getSession();
            session.setAttribute("user", user);
            // Redireciona conforme o tipo de usuário
            if (user.getPermissionLevel() == 2) {
                // Dono ou funcionário
                response.sendRedirect("html/dono.html");
            } else {
                // Usuário comum (permissionLevel 1)
                response.sendRedirect("html/usuario.html");
            }
        } else {
            request.setAttribute("erro", "Login inválido");
            request.getRequestDispatcher("html/login.html").forward(request, response);
        }
    }
}
