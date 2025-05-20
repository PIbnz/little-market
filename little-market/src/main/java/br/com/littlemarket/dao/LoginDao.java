package br.com.littlemarket.dao;

import br.com.littlemarket.model.User;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class LoginDao {

    public User login(String email, String password) {
        String sql = "SELECT * FROM tbuser WHERE LOWER(email) = LOWER(?) AND password = ?";
        try {
            Connection connection = DriverManager.getConnection("jdbc:h2:~/test", "sa", "sa");
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, email);
            ps.setString(2, password);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                int id = rs.getInt("id");
                String name = rs.getString("username");
                String userEmail = rs.getString("email");
                String userPassword = rs.getString("password");
                int userType = rs.getInt("user_type");

                User user = new User(name, userEmail, userPassword, userType);
                user.setId(id);

                connection.close();
                return user;
            }
            connection.close();
        } catch (Exception e) {
            System.out.println("Login error: " + e.getMessage());
        }
        return null;
    }
}
