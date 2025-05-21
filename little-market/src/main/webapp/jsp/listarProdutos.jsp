<%@ page import="br.com.littlemarket.dao.ProdutoDao" %>
<%@ page import="br.com.littlemarket.model.Produto" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <title>Ver Produtos - Little Market</title>
    <link rel="stylesheet" href="../css/JSP.css">
</head>
<body>

<header>
    <div class="logo-container">
        <img src="../img/INDEX/logo-pequena.png" alt="Logo Little Market" class="logo-img">
        <div class="logo-text">Little Market</div>
    </div>
    <nav>
        <a href="usuario.html">Home</a>
        <a href="produtos.html">Produtos</a>
    </nav>
</header>

<main>
    <section>
        <h1>Lista de Produtos</h1>

        <%
            ProdutoDao produtoDao = new ProdutoDao();
            List<Produto> produtos = produtoDao.getAllProdutos();
        %>

        <table>
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Nome</th>
                    <th>Preço</th>
                    <th>Estoque</th>
                    <th>Imagem</th>
                    <th>Descrição</th>
                </tr>
            </thead>
            <tbody>
                <%
                    for (Produto produto : produtos) {
                %>
                <tr>
                    <td><%= produto.getId() %></td>
                    <td><%= produto.getNome() %></td>
                    <td>R$ <%= produto.getPreco() %></td>
                    <td><%= produto.getEstoque() %></td>
                    <td>
                        <img src="<%= produto.getImagemUrl() %>" alt="Imagem do Produto" style="max-width: 150px; border-radius: 4px;">
                    </td>
                    <td><%= produto.getDescricao() %></td>
                </tr>
                <%
                    }
                %>
            </tbody>
        </table>
    </section>
</main>

<footer>
    <p>&copy; 2024 Little Market - Todos os direitos reservados.</p>
</footer>

</body>
</html>
