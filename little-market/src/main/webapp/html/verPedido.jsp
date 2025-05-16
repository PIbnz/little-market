<%@ page import="br.com.littlemarket.model.User" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
  <meta charset="UTF-8">
  <title>Meus Pedidos - Little Market</title>
  <link rel="stylesheet" href="../css/verPedidos.css">
</head>
<body>
  <header>
    <div class="logo-container">
      <img src="../img/INDEX/logo-pequena.png" alt="Logo Little Market" class="logo-img">
      <div class="logo-text">Little Market</div>
    </div>
    <nav>
      <a href="../html/usuario.html">Home</a>
      <a href="../html/produto.html">Produtos</a>
    </nav>
  </header>

  <main>
    <%
      User user = (User) session.getAttribute("user");
      if (user != null) {
    %>
    <h2>Seus Pedidos</h2>
    <table class="tabela">
      <thead>
        <tr>
          <th>#</th>
          <th>Data</th>
          <th>Itens</th>
          <th>Status</th>
        </tr>
      </thead>
      <tbody>
        <tr>
          <td><%= user.getName() %></td> <%-- mudar para o id do pedido qd estiver pornto o dao--%>
          <td><%= user.getName() %></td>
          <td><%= user.getName() %></td>
          <td><%= user.getName() %></td>
        </tr>
        <tr>
            <%
            }
        %>
      </tbody>
    </table>
  </main>

  <footer>
    &copy; 2024 Little Market - Todos os direitos reservados.
</footer>

</body>
</html>
