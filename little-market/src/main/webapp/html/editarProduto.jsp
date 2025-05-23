<%@ page import="br.com.littlemarket.dao.ProdutoDao" %>
<%@ page import="br.com.littlemarket.model.Produto" %>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Editar Produto - Little Market</title>
  <link rel="stylesheet" href="../css/adicionar.css" />
</head>
<body>

<header>
  <div class="logo-container">
    <img src="../img/INDEX/logo-pequena.png" alt="Logo da empresa Little Market" class="logo-img" />
    <div class="logo-text">Little Market</div>
  </div>

  <nav>
    <a href="produto.jsp">Home</a>
  </nav>

  <div class="user-menu">
    <span>Admin</span>
    <a href="../html/login.html">Sair</a>
  </div>
</header>
<%
  String idProdutoStr = request.getParameter("idProduto");
  Produto produto = null;
  if (idProdutoStr != null) {
    try {
      int idProduto = Integer.parseInt(idProdutoStr);
      ProdutoDao produtoDao = new ProdutoDao();
      produto = produtoDao.getProdutoById(idProduto);
    } catch (Exception e) {
    }
  }
%>
<main>
  <h1>Editar Produto</h1>
  <form class="formulario" action="<%= request.getContextPath() %>/alterar-produto" method="post" onsubmit="mostrarPopup()">
    <input type="hidden" name="idProduto" value="<%= produto != null ? produto.getId() : "" %>" />
    <input type="text" placeholder="Nome do Produto" name="nome" id="nome" required value="<%= produto != null ? produto.getNome() : "" %>" />
    <input type="number" placeholder="Preço" step="0.01" name="preco" id="preco" required value="<%= produto != null ? produto.getPreco() : "" %>" />
    <input type="number" placeholder="Estoque" step="1" name="estoque" id="estoque" required value="<%= produto != null ? produto.getEstoque() : "" %>" />
    <input type="text" placeholder="URL da Imagem" name="imagem_url" id="imagem_url" required value="<%= produto != null ? produto.getImagemUrl() : "" %>" />
    <textarea placeholder="Descrição do Produto" rows="4" id="descricao" name="descricao"><%= produto != null ? produto.getDescricao() : "" %></textarea>
    <button type="submit">Editar produto</button>
  </form>
</main>

<footer>
  &copy; 2024 Little Market - Todos os direitos reservados.
</footer>

<script>
  function mostrarPopup() {
    alert("Produto editado com sucesso!");
  }
</script>
</body>
</html>