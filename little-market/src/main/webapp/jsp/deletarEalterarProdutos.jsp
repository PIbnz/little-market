<!DOCTYPE html>
<html>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<head>
  <meta charset="UTF-8">
  <title>Meus Pedidos - Little Market</title>
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
            <th></th>
            <th>Id</th>
            <th>Nome</th>
            <th>Preço</th>
            <th>Descrição</th>
            <th>Estoque</th>
        </tr>
        <c:forEach var="produto" items="${produtos}">
            <tr>
                <td></td>
                <td>${produto.id}</td>
                <td>${produto.name}</td>
                <td>${produto.preco}</td>
                <td>${produto.descricao}</td>
                <td>${produto.estoque}</td>
                <img src=${produto.imagem_url} alt="">
                <form action="/delete-produto" method="post">
                    <input type="hidden" id="id" name="id" value="${produto.id}">
                    <button type="submit">Deletar</button>
                </form>
                <form action="/alterar-produto" method="post">
                    <input type="hidden" id="id" name="id" value="${produto.id}">
                    <button type="submit">Alterar</button>
                </form>
            </tr>
        </c:forEach>
    </table>
  </div>
</body>
</html>
