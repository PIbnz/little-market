package br.com.littlemarket.model;

public class ItemCarrinho extends ItemPedido {
    private String produtoNome;
    private String imagem;

    public ItemCarrinho(int produtoId, String produtoNome, int quantidade, double precoUnitario, String imagem) {
        super(0, 0, produtoId, quantidade, precoUnitario); // id e pedidoId serão 0 até o pedido ser finalizado
        this.produtoNome = produtoNome;
        this.imagem = imagem;
    }

    public String getProdutoNome() {
        return produtoNome;
    }

    public void setProdutoNome(String produtoNome) {
        this.produtoNome = produtoNome;
    }

    public String getImagem() {
        return imagem;
    }

    public void setImagem(String imagem) {
        this.imagem = imagem;
    }

    @Override
    public String toString() {
        return "ItemCarrinho{" +
                "produtoId=" + getProdutoId() +
                ", produtoNome='" + produtoNome + '\'' +
                ", quantidade=" + getQuantidade() +
                ", precoUnitario=" + getPrecoUnitario() +
                ", imagem='" + imagem + '\'' +
                '}';
    }
}