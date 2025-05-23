package br.com.littlemarket.dao;

import br.com.littlemarket.model.ItemCarrinho;
import br.com.littlemarket.model.ItemPedido;
import br.com.littlemarket.model.Pedido;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PedidoDao {
    private static final String DB_URL = "jdbc:h2:~/test";
    private static final String DB_USER = "sa";
    private static final String DB_PASSWORD = "sa";

    public int criarPedido(int userId) throws SQLException {
        // Primeiro, verifica se o usuário existe
        if (!verificarUsuarioExiste(userId)) {
            throw new SQLException("Usuário não encontrado com ID: " + userId);
        }

        String sql = "INSERT INTO tbpedidos (user_id, status, data_pedido) VALUES (?, 'pendente', CURRENT_TIMESTAMP)";

        try (Connection connection = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
             PreparedStatement ps = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setInt(1, userId);
            int affectedRows = ps.executeUpdate();

            if (affectedRows == 0) {
                throw new SQLException("Falha ao criar pedido, nenhuma linha afetada.");
            }

            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    int pedidoId = rs.getInt(1);
                    System.out.println("Pedido criado com sucesso. ID: " + pedidoId);
                    return pedidoId;
                } else {
                    throw new SQLException("Falha ao criar pedido, nenhum ID gerado.");
                }
            }
        } catch (SQLException e) {
            System.out.println("Erro ao criar pedido: " + e.getMessage());
            throw e;
        }
    }

    private boolean verificarUsuarioExiste(int userId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM tbuser WHERE id = ?";
        
        try (Connection connection = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
             PreparedStatement ps = connection.prepareStatement(sql)) {
            
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        }
        return false;
    }

    public void createItemPedido(Connection connection, ItemPedido itemPedido) throws SQLException {
        String sql = "INSERT INTO tbitens_pedido (pedido_id, produto_id, quantidade, preco_unitario) VALUES (?, ?, ?, ?)";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, itemPedido.getPedidoId());
            ps.setInt(2, itemPedido.getProdutoId());
            ps.setInt(3, itemPedido.getQuantidade());
            ps.setDouble(4, itemPedido.getPrecoUnitario());
            
            int affectedRows = ps.executeUpdate();
            if (affectedRows == 0) {
                throw new SQLException("Falha ao adicionar item ao pedido.");
            }
        }
    }

    public void finalizarPedido(int pedidoId, List<ItemCarrinho> itens) throws SQLException {
        Connection connection = null;
        try {
            connection = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
            connection.setAutoCommit(false); // Inicia transação

            try {
                // Primeiro, verifica se o pedido existe
                if (!verificarPedidoExiste(connection, pedidoId)) {
                    throw new SQLException("Pedido não encontrado com ID: " + pedidoId);
                }

                // Converte itens do carrinho para ItemPedido e salva
                for (ItemCarrinho item : itens) {
                    ItemPedido itemPedido = new ItemPedido();
                    itemPedido.setPedidoId(pedidoId);
                    itemPedido.setProdutoId(item.getProdutoId());
                    itemPedido.setQuantidade(item.getQuantidade());
                    itemPedido.setPrecoUnitario(item.getPrecoUnitario());

                    createItemPedido(connection, itemPedido);
                    System.out.println("Item adicionado ao pedido: " + itemPedido);
                }

                // Mantém status como 'pendente' até ser concluído pelo administrador.

                connection.commit();
                System.out.println("Pedido finalizado com sucesso. ID: " + pedidoId);
            } catch (SQLException e) {
                if (connection != null) {
                    connection.rollback();
                }
                System.out.println("Erro ao finalizar pedido: " + e.getMessage());
                throw e;
            }
        } finally {
            if (connection != null) {
                try {
                    connection.close();
                } catch (SQLException e) {
                    System.out.println("Erro ao fechar conexão: " + e.getMessage());
                }
            }
        }
    }

    private boolean verificarPedidoExiste(Connection connection, int pedidoId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM tbpedidos WHERE id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, pedidoId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        }
        return false;
    }

    public List<Pedido> getPedidosByUserId(int userId) throws SQLException {
        List<Pedido> pedidos = new ArrayList<>();
        String sql = "SELECT * FROM tbpedidos WHERE user_id = ? ORDER BY data_pedido DESC";

        try (Connection connection = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
             PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Pedido pedido = new Pedido();
                pedido.setId(rs.getInt("id"));
                pedido.setUserId(rs.getInt("user_id"));
                pedido.setDataPedido(rs.getTimestamp("data_pedido"));
                pedido.setStatus(rs.getString("status"));
                
                // Converte ItemCarrinho para ItemPedido
                List<ItemCarrinho> itensCarrinho = getItensPedido(pedido.getId());
                List<ItemPedido> itensPedido = new ArrayList<>();
                
                for (ItemCarrinho item : itensCarrinho) {
                    ItemPedido itemPedido = new ItemPedido();
                    itemPedido.setPedidoId(pedido.getId());
                    itemPedido.setProdutoId(item.getProdutoId());
                    itemPedido.setQuantidade(item.getQuantidade());
                    itemPedido.setPrecoUnitario(item.getPrecoUnitario());
                    itensPedido.add(itemPedido);
                }
                
                pedido.setItens(itensPedido);
                pedidos.add(pedido);
            }
        }
        return pedidos;
    }

    public List<ItemCarrinho> getItensPedido(int pedidoId) throws SQLException {
        List<ItemCarrinho> itens = new ArrayList<>();
        String sql = "SELECT ip.*, p.nome as produto_nome, p.imagem_url " +
                    "FROM tbitens_pedido ip " +
                    "JOIN tbprodutos p ON ip.produto_id = p.id " +
                    "WHERE ip.pedido_id = ?";

        try (Connection connection = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
             PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setInt(1, pedidoId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                ItemCarrinho item = new ItemCarrinho(
                    rs.getInt("produto_id"),
                    rs.getString("produto_nome"),
                    rs.getInt("quantidade"),
                    rs.getDouble("preco_unitario"),
                    rs.getString("imagem_url")
                );
                itens.add(item);
            }
        }
        return itens;
    }

    // Atualiza status genérico
    public boolean atualizarStatus(int pedidoId, String novoStatus) throws SQLException {
        String sql = "UPDATE tbpedidos SET status = ? WHERE id = ?";
        try (Connection connection = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
             PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, novoStatus);
            ps.setInt(2, pedidoId);
            return ps.executeUpdate() > 0;
        }
    }

    public List<Pedido> getAllPedidos() throws SQLException {
        List<Pedido> pedidos = new ArrayList<>();
        String sql = "SELECT * FROM tbpedidos ORDER BY data_pedido DESC";

        try (Connection connection = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
             PreparedStatement ps = connection.prepareStatement(sql)) {

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Pedido pedido = new Pedido();
                pedido.setId(rs.getInt("id"));
                pedido.setUserId(rs.getInt("user_id"));
                pedido.setDataPedido(rs.getTimestamp("data_pedido"));
                pedido.setStatus(rs.getString("status"));

                List<ItemCarrinho> itensCarrinho = getItensPedido(pedido.getId());
                List<ItemPedido> itensPedido = new ArrayList<>();
                for (ItemCarrinho item : itensCarrinho) {
                    ItemPedido ip = new ItemPedido();
                    ip.setPedidoId(pedido.getId());
                    ip.setProdutoId(item.getProdutoId());
                    ip.setQuantidade(item.getQuantidade());
                    ip.setPrecoUnitario(item.getPrecoUnitario());
                    itensPedido.add(ip);
                }
                pedido.setItens(itensPedido);
                pedidos.add(pedido);
            }
        }
        return pedidos;
    }

    public void atualizarItensPedido(int pedidoId, List<ItemCarrinho> itens) throws SQLException {
        Connection connection = null;
        try {
            connection = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
            connection.setAutoCommit(false);

            // Remove itens antigos
            String deleteSql = "DELETE FROM tbitens_pedido WHERE pedido_id = ?";
            try (PreparedStatement ps = connection.prepareStatement(deleteSql)) {
                ps.setInt(1, pedidoId);
                ps.executeUpdate();
            }

            // Insere novos itens
            for (ItemCarrinho item : itens) {
                ItemPedido itemPedido = new ItemPedido();
                itemPedido.setPedidoId(pedidoId);
                itemPedido.setProdutoId(item.getProdutoId());
                itemPedido.setQuantidade(item.getQuantidade());
                itemPedido.setPrecoUnitario(item.getPrecoUnitario());
                createItemPedido(connection, itemPedido);
            }

            connection.commit();
        } catch (SQLException e) {
            if (connection != null) connection.rollback();
            throw e;
        } finally {
            if (connection != null) connection.close();
        }
    }
}

