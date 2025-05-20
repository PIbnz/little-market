package br.com.littlemarket.dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;

import br.com.littlemarket.model.User;

public class UserDao {
    
    public void createUser(User user) {
    
        String sql = "INSERT INTO tbuser (username, email, password, user_type) VALUES (?, ?, ?, ?)";
        try {

            Connection connection = DriverManager.getConnection("jdbc:h2:~/test", "sa","sa");

            System.out.println("success in database connection");

            PreparedStatement preparedStatement = connection.prepareStatement(sql);

            preparedStatement.setString(1, user.getName());
            preparedStatement.setString(2, user.getEmail());
            preparedStatement.setString(3, user.getPassword());
            preparedStatement.setInt(4, user.getPermissionLevel());
            preparedStatement.execute();

            System.out.println("success in creating user");

            connection.close();

        } catch (Exception e) {

            System.out.println("fail in database connection");

        }

     }

    public User getUserById(int id) {
        String sql = "SELECT * FROM tbuser WHERE id = ?";
        try (Connection connection = DriverManager.getConnection("jdbc:h2:~/test", "sa","sa");
             PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (java.sql.ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    User user = new User(rs.getString("username"), rs.getString("email"), rs.getString("password"), rs.getInt("user_type"));
                    user.setId(rs.getInt("id"));
                    return user;
                }
            }
        } catch (Exception e) {
            System.out.println("Erro ao buscar usuário: " + e.getMessage());
        }
        return null;
    }

}

