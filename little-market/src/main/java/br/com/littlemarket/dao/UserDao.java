package br.com.littlemarket.dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;

import br.com.littlemarket.model.User;

public class UserDao {
    
    public void createUser(User user) {
    
        String sql = "INSERT INTO tbuser (username, email, password) VALUES (?, ?, ?)";
        try {

            Connection connection = DriverManager.getConnection("jdbc:h2:~/test", "sa","sa");

            System.out.println("success in database connection");

            PreparedStatement preparedStatement = connection.prepareStatement(sql);

            preparedStatement.setString(1, user.getName());
            preparedStatement.setString(2, user.getEmail());
            preparedStatement.setString(3, user.getPassword());
            preparedStatement.execute();

            System.out.println("success in creating user");

            connection.close();

        } catch (Exception e) {

            System.out.println("fail in database connection");

        }

     }

    }

