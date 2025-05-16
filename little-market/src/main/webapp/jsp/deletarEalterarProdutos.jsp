<%@ page import="br.com.littlemarket.dao.ProdutoDao" %>
<%@ page import="br.com.littlemarket.model.Produto" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html lang="pt-BR">
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
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
<div>
    <h1>Produtos</h1>
    <table>
        <tr>
            <th>Id</th>
            <th>Imagem</th>
            <th>Nome</th>
            <th>Preço</th>
            <th>Descrição</th>
            <th>Estoque</th>
            <th>Ações</th>
        </tr>
        <%
            ProdutoDao produtoDao = new ProdutoDao();
            List<Produto> produtos = produtoDao.getAllProdutos();
            for (Produto produto : produtos) { %>
        <script>
            function exclusao() {
                alert("Produto excluído com sucesso!");
            }
        </script>
        <tr>
            <td><%= produto.getId() %>
            </td>
            <td><img src=<%= produto.getImagemUrl()%> alt=""></td>
            <td><%= produto.getNome() %>
            </td>
            <td>R$ <%= produto.getPreco() %>
            </td>
            <td><%= produto.getDescricao() %>
            </td>
            <td><%= produto.getEstoque() %>
            </td>
            <td>
                <form action="/alterar-produto" method="post" style="display: inline;">
                    <input type="hidden" id="idProduto" name="idProduto" value="<%= produto.getId() %>">
                    <button class="alterar" type="submit">Alterar</button>
                </form>
                <form action="/delete-produto" method="post" style="display: inline;" onsubmit="exclusao();">
                    <input type="hidden" id="idProduto" name="idProduto" value="<%= produto.getId() %>">
                    <button class="excluir" type="submit">Deletar</button>
                </form>
            </td>
        </tr>
        <% } %>
    </table>
</div>


<footer>
    &copy; 2024 Little Market - Todos os direitos reservados.
</footer>

</body>
</html>
