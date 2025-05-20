<%@ page import="br.com.littlemarket.model.User" %>
<%@ page import="br.com.littlemarket.model.Produto" %>
<%@page import="br.com.littlemarket.model.ItemCarrinho"%>
<%@ page import="br.com.littlemarket.dao.ProdutoDao" %>
<%@ page import="br.com.littlemarket.dao.PedidoDao" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
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
      <a href="produto.jsp">Alimentos</a>
      <a href="produto.jsp">Higiene</a>
      <a href="produto.jsp">Limpeza</a>
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

          // Recupera o carrinho da sessão
          List<ItemCarrinho> carrinho = (List<ItemCarrinho>) session.getAttribute("carrinho");

          // Se não existir, cria um novo
          if (carrinho == null) {
              carrinho = new ArrayList<ItemCarrinho>();
              session.setAttribute("carrinho", carrinho);
          }

          // Verifica se foi enviado um produto para adicionar
          if (request.getParameter("adicionar") != null) {
              int produtoId = Integer.parseInt(request.getParameter("produtoId"));
              int quantidade = Integer.parseInt(request.getParameter("quantidade"));

              // Busca o produto no banco
              Produto produto = produtoDao.getProdutoById(produtoId);

              // Verifica se o produto já está no carrinho
              boolean encontrado = false;
              for (ItemCarrinho item : carrinho) {
                  if (item.getProdutoId() == produtoId) {
                      item.setQuantidade(item.getQuantidade() + quantidade);
                      encontrado = true;
                      break;
                  }
              }

              // Se não encontrou, adiciona novo item
              if (!encontrado) {
                  carrinho.add(new ItemCarrinho(
                      produtoId,
                      produto.getNome(),
                      quantidade,
                      produto.getPreco()
                  ));
              }
          }

          // Verifica se foi solicitada a remoção de um item
          if (request.getParameter("remover") != null) {
              int produtoId = Integer.parseInt(request.getParameter("produtoId"));
              Iterator<ItemCarrinho> iterator = carrinho.iterator();
              while (iterator.hasNext()) {
                  ItemCarrinho item = iterator.next();
                  if (item.getProdutoId() == produtoId) {
                      iterator.remove();
                      break;
                  }
              }
          }

          // Verifica se foi solicitado finalizar o pedido
          if (request.getParameter("finalizar") != null && !carrinho.isEmpty()) {
              // Supondo que você tenha o ID do usuário logado
              Integer userId = (Integer) session.getAttribute("userId");

              if (userId != null) {
                  PedidoDao pedidoDao = new PedidoDao();
                  try {
                      // Cria o pedido e obtém o ID
                      int pedidoId = pedidoDao.criarPedido(userId);

                      if (pedidoId > 0) {
                          // Adiciona os itens do pedido
                          pedidoDao.finalizarPedido(pedidoId, carrinho);

                          // Limpa o carrinho
                          carrinho.clear();

                          // Redireciona com mensagem de sucesso
                          response.sendRedirect("pedidos.jsp?sucesso=Pedido #" + pedidoId + " realizado com sucesso!");
                          return;
                      }
                  } catch (SQLException e) {
                      e.printStackTrace();
                      response.sendRedirect("pedidos.jsp?erro=Erro ao finalizar pedido: " + e.getMessage());
                      return;
                  }
              }
              response.sendRedirect("pedidos.jsp?erro=Erro ao finalizar pedido: Usuário não autenticado");
          }
      %>

      <div class="form-container">
          <h2>Fazer Novo Pedido</h2>
          <form method="post" class="pedido-form">
              <label for="produto">Produto</label>
              <select id="produto" name="produtoId" required>
                  <option value="">Selecione um produto</option>
                  <% for (Produto produto : produtos) { %>
                  <option value="<%= produto.getId() %>"><%= produto.getNome() %> - R$ <%= produto.getPreco() %></option>
                  <% } %>
              </select>

              <label for="quantidade">Quantidade</label>
              <input type="number" id="quantidade" name="quantidade" min="1" value="1" required>

              <button type="submit" name="adicionar">Adicionar ao Carrinho</button>
          </form>
      </div>

      <!-- Seção do Carrinho -->
      <div class="carrinho-container">
          <h3>Seu Carrinho</h3>
          <% if (carrinho.isEmpty()) { %>
              <p>Seu carrinho está vazio.</p>
          <% } else { %>
              <table>
                  <thead>
                      <tr>
                          <th>Produto</th>
                          <th>Quantidade</th>
                          <th>Preço Unitário</th>
                          <th>Total</th>
                          <th>Ação</th>
                      </tr>
                  </thead>
                  <tbody>
                      <%
                      double totalPedido = 0;
                      for (ItemCarrinho item : carrinho) {
                          totalPedido += item.getTotal();
                      %>
                      <tr>
                          <td><%= item.getProdutoNome() %></td>
                          <td><%= item.getQuantidade() %></td>
                          <td>R$ <%= String.format("%.2f", item.getPrecoUnitario()) %></td>
                          <td>R$ <%= String.format("%.2f", item.getTotal()) %></td>
                          <td>
                              <form method="post" style="display:inline;">
                                  <input type="hidden" name="produtoId" value="<%= item.getProdutoId() %>">
                                  <button type="submit" name="remover">Remover</button>
                              </form>
                          </td>
                      </tr>
                      <% } %>
                  </tbody>
                  <tfoot>
                      <tr>
                          <td colspan="3"><strong>Total do Pedido:</strong></td>
                          <td><strong>R$ <%= String.format("%.2f", totalPedido) %></strong></td>
                          <td></td>
                      </tr>
                  </tfoot>
              </table>

              <form method="post">
                  <button type="submit" name="finalizar">Finalizar Pedido</button>
              </form>
              <%-- Exibe mensagens de sucesso/erro --%>
              <% if (request.getParameter("sucesso") != null) { %>
                  <div class="alert alert-success">
                      <strong>Sucesso!</strong> <%= request.getParameter("sucesso") %>
                  </div>
              <% } %>

              <% if (request.getParameter("erro") != null) { %>
                  <div class="alert alert-danger">
                      <strong>Erro!</strong> <%= request.getParameter("erro") %>
                  </div>
              <% } %>
          <% } %>
      </div>
  </main>
  <footer>
    &copy; 2024 Little Market - Todos os direitos reservados.
</footer>

</body>
</html>
