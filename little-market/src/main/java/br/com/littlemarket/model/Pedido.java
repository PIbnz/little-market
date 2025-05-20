package br.com.littlemarket.model;

import java.util.Date;
import java.util.List;

public class Pedido {
    private int id;
    private int userId;
    private Date dataPedido;
    private String status;
    private List<ItemPedido> itens;

    public Pedido() {
    }

    public Pedido(int id, int userId, Date dataPedido, String status, List<ItemPedido> itens) {
        this.id = id;
        this.userId = userId;
        this.dataPedido = dataPedido;
        this.status = status;
        this.itens = itens;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public Date getDataPedido() {
        return dataPedido;
    }

    public void setDataPedido(Date dataPedido) {
        this.dataPedido = dataPedido;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public List<ItemPedido> getItens() {
        return itens;
    }

    public void setItens(List<ItemPedido> itens) {
        this.itens = itens;
    }

    public double getTotal() {
        if (itens == null) return 0.0;
        return itens.stream()
                   .mapToDouble(item -> item.getQuantidade() * item.getPrecoUnitario())
                   .sum();
    }

    public String getData() {
        if (dataPedido == null) return "";
        return dataPedido.toString();
    }
}