package br.com.littlemarket.dao;

import br.com.littlemarket.model.Produto;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ProdutoDao {

    public void createProduto(Produto produto){
        String sql = "INSERT INTO tbprodutos (nome, descricao, preco, estoque, imagem_url) VALUES (?, ?, ?, ?, ?)";
        try {
            Connection connection = DriverManager.getConnection("jdbc:h2:~/test", "sa", "sa");
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, produto.getNome());
            ps.setString(2, produto.getDescricao());
            ps.setDouble(3, produto.getPreco());
            ps.setInt(4, produto.getEstoque());
            ps.setString(5, produto.getImagemUrl())
            ;
            ps.executeUpdate();

            connection.close();
        } catch (Exception e) {
            System.out.println("Erro ao criar produto: " + e.getMessage());
        }
    }
    public List<Produto> getAllProdutos() {
        List<Produto> produtos = new ArrayList<>();
        String sql = "SELECT * FROM tbprodutos";
        try {
            Connection connection = DriverManager.getConnection("jdbc:h2:~/test", "sa", "sa");
            PreparedStatement ps = connection.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Produto produto = new Produto(
                        rs.getInt("id"),
                        rs.getString("nome"),
                        rs.getString("descricao"),
                        rs.getDouble("preco"),
                        rs.getInt("estoque"),
                        rs.getString("imagem_url")
                );
                produtos.add(produto);
            }
            connection.close();
        } catch (Exception e) {
            System.out.println("Erro ao listar produtos: " + e.getMessage());
        }
        return produtos;
    }
    public boolean deleteProduto(int idProduto) {
        String sql = "DELETE FROM tbprodutos WHERE id = ?";
        try {
            Connection connection = DriverManager.getConnection("jdbc:h2:~/test", "sa", "sa");
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, idProduto);
            int rowsAffected = ps.executeUpdate();
            connection.close();
            return rowsAffected > 0;
        } catch (Exception e) {
            System.out.println("Erro ao deletar produto: " + e.getMessage());
            return false;
        }
    }
    public boolean alterProduto (Produto produto) {
        String sql = "UPDATE tbprodutos SET nome = ?, descricao = ?, preco = ?, estoque = ?, imagem_url = ? WHERE id = ?";
        try {
            Connection connection = DriverManager.getConnection("jdbc:h2:~/test", "sa", "sa");
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, produto.getNome());
            ps.setString(2, produto.getDescricao());
            ps.setDouble(3, produto.getPreco());
            ps.setInt(4, produto.getEstoque());
            ps.setString(5, produto.getImagemUrl());
            ps.setInt(6, produto.getId());
            int rowsAffected = ps.executeUpdate();
            connection.close();
            return rowsAffected > 0;
        } catch (Exception e) {
            System.out.println("Erro ao alterar produto: " + e.getMessage());
            return false;
        }
    }

    public Produto getProdutoById(int produtoId) {
        String sql = "SELECT * FROM tbprodutos WHERE id = ?";
        try (Connection connection = DriverManager.getConnection("jdbc:h2:~/test", "sa", "sa");
             PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setInt(1, produtoId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new Produto(
                            rs.getInt("id"),
                            rs.getString("nome"),
                            rs.getString("descricao"),
                            rs.getDouble("preco"),
                            rs.getInt("estoque"),
                            rs.getString("imagem_url")
                    );
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null; // Retorna null se o produto não for encontrado
    }
}
