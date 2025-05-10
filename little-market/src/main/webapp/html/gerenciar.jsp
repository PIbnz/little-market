<%@ page import="br.com.littlemarket.dao.ProdutoDao" %>
<%@ page import="br.com.littlemarket.model.Produto" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <title>Gerenciar Estoque</title>
    <link rel="stylesheet" href="../css/gerenciar.css">
</head>
<body>
    <header>
        <div class="logo-container">
            <img src="../img/INDEX/logo-pequena.png" alt="Logo Little Market" class="logo-img">
            <div class="logo-text">Little Market</div>
          </div>
        <nav>
            <a href="../html/produto.html">Produtos</a>
            <a href="adicionarProduto.html">Adicionar Produto</a>
            <a href="../html/gerenciar.html">Gerenciar Estoque</a>
        </nav>
    </header>
    <main>
        <h1>Gerenciar Estoque</h1>
        <table>
            <thead>
                <tr>
                    <th>Id</th>
                    <th>Produto</th>
                    <th>Preço</th>
                    <th>Quantidade</th>
                    <th>Ações</th>
                </tr>
            </thead>
            <tbody>
            <%
                ProdutoDao produtoDao = new ProdutoDao();
                List<Produto> produtos = produtoDao.getAllProdutos();
                for (Produto produto : produtos) { %>
                <tr>
                    <td><%= produto.getId() %>
                    </td>
                    <td><%= produto.getNome() %>
                    </td>
                    <td>R$ <%= produto.getPreco() %>
                    </td>
                    <td><%= produto.getEstoque() %>
                    </td>
                    <td>
                        <button class="editar">Editar</button>
                        <button class="excluir">Excluir</button>
                    </td>
                </tr>
            <% } %>
            </tbody>
        </table>
        <a href="adicionarProduto.html" class="botao-adicionar">Adicionar Novo Produto</a>
    </main>

</body>
</html>
