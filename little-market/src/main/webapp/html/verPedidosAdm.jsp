<%@ page import="br.com.littlemarket.dao.PedidoDao" %>
<%@ page import="br.com.littlemarket.model.Pedido" %>
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
        <a href="dono.html">Painel</a>
        <a href="adicionarProduto.html">Adicionar Produto</a>
        <a href="gerenciar.jsp">Gerenciar Estoque</a>
        <a href="login.jsp?logout=true">Sair</a>
    </nav>
</header>
<main>
    <h1>Pedidos Recebidos</h1>
    <%
        PedidoDao pedidoDao = new PedidoDao();
        // Concluir pedido se parâmetro presente
        String concluir = request.getParameter("concluirId");
        if (concluir != null) {
            try {
                int pid = Integer.parseInt(concluir);
                pedidoDao.atualizarStatus(pid, "concluido");
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        List<Pedido> lista = null;
        try {
            lista = pedidoDao.getAllPedidos();
        } catch (Exception e) {
            e.printStackTrace();
        }
    %>
    <table>
        <thead>
        <tr>
            <th>ID</th>
            <th>Cliente</th>
            <th>Data</th>
            <th>Total</th>
            <th>Status</th>
            <th>Ações</th>
        </tr>
        </thead>
        <tbody>
        <% if (lista != null) {
               for (Pedido p : lista) { %>
            <tr>
                <td><%= p.getId() %></td>
                <td><%= p.getUserId() %></td>
                <td><%= p.getData() %></td>
                <td>R$ <%= String.format("%.2f", p.getTotal()) %></td>
                <td><%= p.getStatus() %></td>
                <td>
                    <% if (!"concluido".equalsIgnoreCase(p.getStatus())) { %>
                        <form method="post">
                            <input type="hidden" name="concluirId" value="<%= p.getId() %>">
                            <button type="submit">Marcar Pronto</button>
                        </form>
                    <% } else { %>
                        -
                    <% } %>
                </td>
            </tr>
        <% } } %>
        </tbody>
    </table>
</main>

<footer>
    &copy; 2024 Little Market - Todos os direitos reservados.
</footer>
</body>
</html>
