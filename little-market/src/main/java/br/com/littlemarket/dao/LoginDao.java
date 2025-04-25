package br.com.littlemarket.dao;

import br.com.littlemarket.User;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class LoginDao {

    public User login(String email, String password) {
        String sql = "SELECT * FROM tbusers WHERE LOWER(email) = LOWER(?) AND password = ?";
        try {
            Connection connection = DriverManager.getConnection("jdbc:h2:~/test", "sa", "sa");
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, email);
            ps.setString(2, password);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                String name = rs.getString("username");
                String userEmail = rs.getString("email");
                String userPassword = rs.getString("password");
                int userType = rs.getInt("user_type");
                connection.close();
                return new User(name, userEmail, userPassword, userType);
            }
            connection.close();
        } catch (Exception e) {
            System.out.println("Login error: " + e.getMessage());
        }
        return null;
    }
}
