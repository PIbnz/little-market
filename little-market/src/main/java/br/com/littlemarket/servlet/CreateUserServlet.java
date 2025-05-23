package br.com.littlemarket.servlet;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import br.com.littlemarket.model.User;
import br.com.littlemarket.dao.UserDao;

import java.io.IOException;


@WebServlet("/create-user")
public class CreateUserServlet extends HttpServlet{

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        String username = request.getParameter("username") != null ? request.getParameter("username") : request.getParameter("nome");
        String userPassword = request.getParameter("password") != null ? request.getParameter("password") : request.getParameter("senha");
        String userEmail = request.getParameter("email");

        int permissionLevel = 1;
        try {
            permissionLevel = Integer.parseInt(request.getParameter("permissionLevel"));
        } catch (Exception ignored) {}

        User user = new User(username, userEmail, userPassword, permissionLevel);
        UserDao userDao = new UserDao();

        userDao.createUser(user);

        response.setContentType("text/html");
        response.setCharacterEncoding("UTF-8");

        response.getWriter().println("<script type='text/javascript'>");
        response.getWriter().println("alert('Usuário cadastrado com sucesso!');");
        User current = (User) request.getSession().getAttribute("user");
        if (current != null && current.getPermissionLevel() == 2) {
            response.getWriter().println("window.location.href = 'html/dono.html';");
        } else {
            response.getWriter().println("window.location.href = 'html/login.jsp';");
        }
        response.getWriter().println("</script>");

    }
}
