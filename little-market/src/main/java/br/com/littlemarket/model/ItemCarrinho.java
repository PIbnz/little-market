package br.com.littlemarket.model;

public class ItemCarrinho extends ItemPedido {
    private String produtoNome;

    public ItemCarrinho(int produtoId, String produtoNome, int quantidade, double precoUnitario) {
        super(0, 0, produtoId, quantidade, precoUnitario); // id e pedidoId serão 0 até o pedido ser finalizado
        this.produtoNome = produtoNome;
    }

    public String getProdutoNome() {
        return produtoNome;
    }

    public void setProdutoNome(String produtoNome) {
        this.produtoNome = produtoNome;
    }

    @Override
    public String toString() {
        return "ItemCarrinho{" +
                "produtoId=" + getProdutoId() +
                ", produtoNome='" + produtoNome + '\'' +
                ", quantidade=" + getQuantidade() +
                ", precoUnitario=" + getPrecoUnitario() +
                '}';
    }
}