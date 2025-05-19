<%@ page import="br.com.littlemarket.dao.ProdutoDao" %>
<%@ page import="br.com.littlemarket.model.Produto" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <title>Gerenciar Pedidos</title>
    <link rel="stylesheet" href="../css/gerenciar.css">
</head>
<body>
<header>
    <div class="logo-container">
        <img src="../img/INDEX/logo-pequena.png" alt="Logo Little Market" class="logo-img">
        <div class="logo-text">Little Market</div>
    </div>
    <nav>
        <a href="produto.jsp">Produtos</a>
        <a href="adicionarProduto.html">Adicionar Produto</a>
        <a href="../html/gerenciar.html">Gerenciar Estoque</a>
    </nav>
</header>
<main>
    <h1>Verificar Pedidos</h1>
    <table>
        <thead>
        <tr>
            <th>Id</th>
            <th>Id do Usuario</th>
            <th>Total do Pedido</th>
            <th>Quantidade de Itens</th>
            <th>Ações</th>
        </tr>
        </thead>
        <tbody>
        <%
            ProdutoDao produtoDao = new ProdutoDao();
            List<Produto> produtos = produtoDao.getAllProdutos();
            for (Produto produto : produtos) { %> <%--alterar pra pedido--%>
        <tr>
            <td><%= produto.getId() %> <%--id pedido--%>
            </td>
            <td><%= produto.getNome() %> <%--id do usuario--%>
            </td>
            <td>R$ <%= produto.getPreco() %> <%--total do pedido--%>
            </td>
            <td><%= produto.getEstoque() %> <%--total de itens no pedido--%>
            </td>
            <td>
                <button class="editar">Verificar Pedido</button>
            </td>
        </tr>
        <% } %>
        </tbody>
    </table>
</main>

<footer>
    &copy; 2024 Little Market - Todos os direitos reservados.
</footer>

</body>
</html>
