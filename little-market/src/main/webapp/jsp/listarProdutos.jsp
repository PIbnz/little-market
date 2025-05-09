<%@ page import="br.com.littlemarket.dao.ProdutoDao" %>
<%@ page import="br.com.littlemarket.model.Produto" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Ver Produtos</title>
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

<h2>Lista de Produtos</h2>

<%
    ProdutoDao produtoDao = new ProdutoDao();
    List<Produto> produtos = produtoDao.getAllProdutos();
%>

<table>
    <tr>
        <th>ID</th>
        <th>Nome</th>
        <th>Preço</th>
        <th>Estoque</th>
        <th>Imagem URL</th>
        <th>Descrição</th>
    </tr>
    <%
        for (Produto produto : produtos) { %>
    <tr>
        <td><%= produto.getId() %>
        </td>
        <td><%= produto.getNome() %>
        </td>
        <td><%= produto.getPreco() %>
        </td>
        <td><%= produto.getEstoque() %>
        </td>
        <td><img src="<%= produto.getImagemUrl() %>" alt="Imagem do Produto" width="100"></td>
        <td><%= produto.getDescricao() %>
        </td>
    </tr>
    <% } %>
</table>
</body>
</html>
