<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="pt-BR">
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

  <main>
    <section>
      <h1>Pedidos</h1>
      <table>
        <thead>
          <tr>
            <th>Id</th>
            <th>Produto</th>
            <th>Usuário</th>
            <th>Quantidade</th>
            <th>Data do Pedido</th>
            <th>Status</th>
            <th>Ações</th>
          </tr>
        </thead>
        <tbody>
          <c:forEach var="pedido" items="${pedidos}">
            <tr>
              <td>${pedido.id}</td>
              <td>${pedido.produto_id}</td>
              <td>${pedido.user_id}</td>
              <td>${pedido.quantidade}</td>
              <td>${pedido.data_pedido}</td>
              <td>${pedido.status}</td>
              <td>
                <form action="/delete-pedido" method="post" class="inline-form">
                  <input type="hidden" name="id" value="${pedido.id}">
                  <button type="submit" class="excluir">Deletar</button>
                </form>
                <form action="/alterar-pedido" method="post" class="inline-form">
                  <input type="hidden" name="id" value="${pedido.id}">
                  <button type="submit" class="alterar">Alterar</button>
                </form>
              </td>
            </tr>
          </c:forEach>
        </tbody>
      </table>
    </section>
  </main>

  <footer>
    <p>&copy; 2024 Little Market - Todos os direitos reservados.</p>
  </footer>

</body>
</html>
