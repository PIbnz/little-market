<%@ page import="br.com.littlemarket.model.User" %>
<%@ page import="br.com.littlemarket.model.Produto" %>
<%@ page import="br.com.littlemarket.dao.ProdutoDao" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Produtos - Little Market</title>
    <link rel="stylesheet" href="../css/usuario.css">
</head>
<body>
    <jsp:include page="../jsp/navbar.jsp" />

    <main>
        <div class="container">
            <h2>Nossos Produtos</h2>
            
            <div class="categorias">
                <h3>Categorias</h3>
                <div class="categoria-links">
                    <a href="#">Todos</a>
                </div>
            </div>

            <div class="produtos-grid">
                <%
                    ProdutoDao produtoDao = new ProdutoDao();
                    List<Produto> produtos = produtoDao.getAllProdutos();
                    
                    for (Produto produto : produtos) {
                %>
                    <div class="produto-card">
                        <div class="produto-imagem">
                            <img src="<%= produto.getImagemUrl() %>" alt="<%= produto.getNome() %>">
                        </div>
                        <div class="produto-info">
                            <h3><%= produto.getNome() %></h3>
                            <p class="preco">R$ <%= String.format("%.2f", produto.getPreco()) %></p>
                            <p class="descricao"><%= produto.getDescricao() %></p>
                            <form action="pedido.jsp" method="post">
                                <input type="hidden" name="produtoId" value="<%= produto.getId() %>">
                                <input type="number" name="quantidade" value="1" min="1" class="quantidade-input">
                                <button type="submit" name="addProduto" class="btn btn-primary">Adicionar ao Carrinho</button>
                            </form>
                        </div>
                    </div>
                <% } %>
            </div>
        </div>
    </main>

    <footer>
        &copy; 2024 Little Market - Todos os direitos reservados.
    </footer>
</body>
</html>
