package br.com.littlemarket.dao;

import br.com.littlemarket.model.Produto;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
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
            System.out.println("Product created successfully!");

            connection.close();
        } catch (Exception e) {
            System.out.println("Error creating product: " + e.getMessage());
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
            System.out.println("Error fetching products: " + e.getMessage());
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
}
