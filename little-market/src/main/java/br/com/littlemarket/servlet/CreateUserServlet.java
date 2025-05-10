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

        String username = request.getParameter("nome");
        String userPassword = request.getParameter("senha");
        String userEmail = request.getParameter("email");

        User user = new User(username, userEmail, userPassword);
        UserDao userDao = new UserDao();

        userDao.createUser(user);

        response.setContentType("text/html");
        response.setCharacterEncoding("UTF-8");

        response.getWriter().println("<script type='text/javascript'>");
        response.getWriter().println("alert('Usuário cadastrado com sucesso! Siga para o login.');");
        response.getWriter().println("window.location.href = '/html/login.html';");
        response.getWriter().println("</script>");

    }
}
