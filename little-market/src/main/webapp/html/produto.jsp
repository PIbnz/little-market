<%@ page import="br.com.littlemarket.dao.ProdutoDao" %>
<%@ page import="br.com.littlemarket.model.Produto" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Produtos - Little Market</title>
    <link rel="stylesheet" href="../css/produto.css">
</head>
<body>
    <header>
        <div class="logo">
            <img src="../img/INDEX/logo-pequena.png" alt="Logo Little Market">
        </div>
        <nav>
            <a href="#">Alimento</a>
            <a href="#">Higiene</a>
            <a href="#">Limpeza</a>
        </nav>
        <br>
        <div class="conta">
            <a href="Conta.jsp">Minha Conta</a>
        </div>
    </header>

    <main>
        <%
            ProdutoDao produtoDao = new ProdutoDao();
            List<Produto> produtos = produtoDao.getAllProdutos();
        %>
        <section class="hero">
            <h1>Produtos</h1>
            <p>Confira nossas ofertas em alimentos, higiene e limpeza.</p>
        </section>

        <section class="products">
            <%
                for (Produto produto : produtos) { %>
            <div class="product-card">
                <img src="<%= produto.getImagemUrl() %>" alt="Imagem do Produto">
                <h3><%= produto.getNome() %></h3>
                <p class="preco">R$ <%= produto.getPreco() %></p>
                <br>
                <a href="resumo.html" class="button">Ver Resumo</a>
            </div>
            <% } %>
        </section>
    </main>

    <footer>
        &copy; 2024 Little Market - Todos os direitos reservados.
    </footer>

</body>
</html>
