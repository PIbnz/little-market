package br.com.littlemarket.servlet;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import br.com.littlemarket.User;
import br.com.littlemarket.dao.UserAdminDao;

import java.io.IOException;


@WebServlet("/create-user-admin")
public class CreateUserAdminServlet extends HttpServlet{

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        String username = request.getParameter("nome");
        String userPassword = request.getParameter("senha");
        String userEmail = request.getParameter("email");
      

        User user = new User(username, userEmail, userPassword);
        new UserAdminDao().createUser(user);

        request.getRequestDispatcher("").forward(request, response);

    }
}
