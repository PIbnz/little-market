package br.com.littlemarket.dao;

import br.com.littlemarket.model.ItemCarrinho;
import br.com.littlemarket.model.ItemPedido;

import java.sql.*;
import java.util.List;

public class PedidoDao {
    private static final String DB_URL = "jdbc:h2:~/test";
    private static final String DB_USER = "sa";
    private static final String DB_PASSWORD = "sa";

    public int criarPedido(int userId) throws SQLException {
        String sql = "INSERT INTO tbpedidos (user_id, status) VALUES (?, 'pendente')";

        try (Connection connection = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
             PreparedStatement ps = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setInt(1, userId);
            ps.executeUpdate();

            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            System.out.println("Error creating Pedido: " + e.getMessage());
            throw e;
        }
        return -1;
    }

    public void createItemPedido(ItemPedido itemPedido) throws SQLException {
        String sql = "INSERT INTO tbitens_pedido (pedido_id, produto_id, quantidade, preco_unitario) VALUES (?, ?, ?, ?)";

        try (Connection connection = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
             PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setInt(1, itemPedido.getPedidoId());
            ps.setInt(2, itemPedido.getProdutoId());
            ps.setInt(3, itemPedido.getQuantidade());
            ps.setDouble(4, itemPedido.getPrecoUnitario());
            ps.executeUpdate();
        } catch (SQLException e) {
            System.out.println("Error creating ItemPedido: " + e.getMessage());
            throw e;
        }
    }

    public void finalizarPedido(int pedidoId, List<ItemCarrinho> itens) throws SQLException {
        try (Connection connection = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD)) {
            connection.setAutoCommit(false); // Inicia transação

            try {
                // Converte itens do carrinho para ItemPedido e salva
                for (ItemCarrinho item : itens) {
                    ItemPedido itemPedido = new ItemPedido();
                    itemPedido.setPedidoId(pedidoId);
                    itemPedido.setProdutoId(item.getProdutoId());
                    itemPedido.setQuantidade(item.getQuantidade());
                    itemPedido.setPrecoUnitario(item.getPrecoUnitario());

                    createItemPedido(itemPedido);
                }
                connection.commit();
            } catch (SQLException e) {
                connection.rollback();
                throw e;
            }
        }
    }
}

