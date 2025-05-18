package br.com.littlemarket.dao;

import br.com.littlemarket.model.ItemPedido;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;

public class ItemPedidoDao {
    public void createItemPedido(ItemPedido itemPedido) {
        String sql = "INSERT INTO tbitempedido (pedido_id, produto_id, quantidade, preco_unitario) VALUES (?, ?, ?, ?)";
        try {
            Connection connection = DriverManager.getConnection("jdbc:h2:~/test", "sa", "sa");
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, itemPedido.getPedidoId());
            ps.setInt(2, itemPedido.getProdutoId());
            ps.setInt(3, itemPedido.getQuantidade());
            ps.setDouble(4, itemPedido.getPrecoUnitario());
            ps.executeUpdate();
            connection.close();
        } catch (Exception e) {
            System.out.println("Error creating ItemPedido: " + e.getMessage());
        }
    }
}
