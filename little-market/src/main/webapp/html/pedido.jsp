<%@ page import="br.com.littlemarket.model.User" %>
<%@ page import="br.com.littlemarket.model.Produto" %>
<%@ page import="br.com.littlemarket.dao.ProdutoDao" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
  <meta charset="UTF-8">
  <title>Fazer Pedido - Little Market</title>
  <link rel="stylesheet" href="../css/pedido.css">
</head>
<body>
  <header>
    <div class="logo-container">
      <img src="../img/INDEX/logo-pequena.png" alt="Logo Little Market" class="logo-img">
      <div class="logo-text">Little Market</div>
    </div>
    <nav>
      <a href="../html/produto.html">Alimentos</a>
      <a href="../html/produto.html">Higiene</a>
      <a href="../html/produto.html">Limpeza</a>
    </nav>
    <div class="user-menu">
      <%
        User user = (User) session.getAttribute("user");
        if (user != null) {
      %>
      <span>Olá, <%= user.getName() %></span>
      <%}%>
      <a href="../html/login.html">Sair</a>
    </div>
  </header>

  <main>
    <%
      ProdutoDao produtoDao = new ProdutoDao();
      List<Produto> produtos = produtoDao.getAllProdutos();
    %>
    <div class="form-container">
      <h2>Fazer Novo Pedido</h2>
      <form class="pedido-form">
        <label for="produto">Produto</label>
        <input type="text" id="produto" name="produto" list="produtos-list" placeholder="Nome do produto">
        <datalist id="produtos-list">
          <% for (Produto produto : produtos) { %>
          <option value="<%= produto.getNome() %>">
              <% } %>
        </datalist>

        <label for="quantidade">Quantidade</label>
        <input type="number" id="quantidade" placeholder="1">

        <button type="submit">Adicionar ao Pedido</button>
      </form>
    </div>
  </main>
  <footer>
    &copy; 2024 Little Market - Todos os direitos reservados.
</footer>

</body>
</html>
