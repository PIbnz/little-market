<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="br.com.littlemarket.dao.ProdutoDao"%>
<%@ page import="br.com.littlemarket.model.Produto"%>
<%@ page import="java.util.List"%>
<%@ page import="br.com.littlemarket.model.User"%>

<%
    User user = (User) session.getAttribute("user");
    if (user == null || user.getPermissionLevel() != 2) {
        response.sendRedirect("../html/login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gerenciar Estoque - Little Market</title>
    <link rel="stylesheet" href="../css/dono.css">
</head>
<body>
    <header>
        <div class="logo-container">
            <img src="../img/INDEX/logo-pequena.png" alt="Logo Little Market" class="logo-img" />
            <div class="logo-text">Little Market</div>
        </div>

        <nav>
            <a href="verPedidosAdm.jsp">Pedidos</a>
            <a href="gerenciar.jsp">Estoque</a>
            <a href="adicionarProduto.html">Adicionar Produto</a>
            <a href="adicionarFuncionario.jsp">Adicionar Funcionário</a>
        </nav>

        <div class="user-menu">
            <span>Painel do Dono</span>
            <a href="login.jsp?logout=true">Sair</a>
        </div>
    </header>

    <main>
        <h1>Gerenciar Estoque</h1>
        <table>
            <tr>
                <th>Id</th>
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

            <tr>
                <td><%= produto.getId() %>
                </td>
                <td><%= produto.getNome() %>
                </td>
                <td>R$ <%= produto.getPreco() %>
                </td>
                <td><%= produto.getDescricao() %>
                </td>
                <td><%= produto.getEstoque() %>
                </td>
                <td>
                    <form action="<%= request.getContextPath() %>/html/editarProduto.jsp" method="get" style="display: inline;">
                        <input type="hidden" id="idProduto" name="idProduto" value="<%= produto.getId() %>">
                        <button class="alterar" type="submit">Alterar</button>
                    </form>
                    <form action="<%= request.getContextPath() %>/delete-produto" method="post" style="display: inline;" onsubmit="exclusao();">
                        <input type="hidden" id="idProduto" name="idProduto" value="<%= produto.getId() %>">
                        <button class="excluir" type="submit">Deletar</button>
                    </form>
                </td>
            </tr>
            <% } %>
        </table>
        <a href="adicionarProduto.html" class="botao-adicionar">Adicionar Novo Produto</a>
    </main>

    <footer>
        &copy; 2024 Little Market - Todos os direitos reservados.
    </footer>
    <script>
        function exclusao() {
            alert("Produto excluído com sucesso!");
        }
    </script>
</body>
</html>
