<%@ page import="br.com.littlemarket.dao.ProdutoDao" %>
<%@ page import="br.com.littlemarket.model.Produto" %>
<%@ page import="java.util.List" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <title>Administrar Produtos - Little Market</title>
    <link rel="stylesheet" type="text/css" href="../css/JSP.css">
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
        <h1>Produtos</h1>
        <table>
            <thead>
                <tr>
                    <th>Id</th>
                    <th>Imagem</th>
                    <th>Nome</th>
                    <th>Preço</th>
                    <th>Descrição</th>
                    <th>Estoque</th>
                    <th>Ações</th>
                </tr>
            </thead>
            <tbody>
                <%
                    ProdutoDao produtoDao = new ProdutoDao();
                    List<Produto> produtos = produtoDao.getAllProdutos();
                    for (Produto produto : produtos) {
                %>
                <tr>
                    <td><%= produto.getId() %></td>
                    <td><img src="<%= produto.getImagemUrl() %>" alt="Imagem do produto"></td>
                    <td><%= produto.getNome() %></td>
                    <td>R$ <%= produto.getPreco() %></td>
                    <td><%= produto.getDescricao() %></td>
                    <td><%= produto.getEstoque() %></td>
                    <td>
                        <form action="/alterar-produto" method="post" class="inline-form">
                            <input type="hidden" name="idProduto" value="<%= produto.getId() %>">
                            <button class="alterar" type="submit">Alterar</button>
                        </form>
                        <form action="/delete-produto" method="post" class="inline-form" onsubmit="return confirm('Tem certeza que deseja excluir este produto?');">
                            <input type="hidden" name="idProduto" value="<%= produto.getId() %>">
                            <button class="excluir" type="submit">Deletar</button>
                        </form>
                    </td>
                </tr>
                <% } %>
            </tbody>
        </table>
    </section>
</main>

<footer>
    <p>&copy; 2024 Little Market - Todos os direitos reservados.</p>
</footer>

</body>
</html>

