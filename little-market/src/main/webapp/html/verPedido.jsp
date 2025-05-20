<%@ page import="br.com.littlemarket.model.User" %>
<%@ page import="br.com.littlemarket.model.Pedido" %>
<%@ page import="br.com.littlemarket.dao.PedidoDao" %>
<%@ page import="java.util.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Meus Pedidos - Little Market</title>
    <link rel="stylesheet" href="../css/usuario.css">
</head>
<body>
    <header>
        <div class="logo-container">
            <img src="../img/INDEX/logo-pequena.png" alt="Logo Little Market" class="logo-img">
            <div class="logo-text">Little Market</div>
        </div>
        <nav>
            <a href="usuario.html">Home</a>
            <a href="produto.jsp">Produtos</a>
        </nav>
    </header>

    <main>
        <h2>Meus Pedidos</h2>

        <div class="painel">
            <%
                User user = (User) session.getAttribute("user");
                if (user != null) {
                    PedidoDao pedidoDao = new PedidoDao();
                    List<Pedido> pedidos = pedidoDao.getPedidosByUserId(user.getId());
                    
                    if (pedidos.isEmpty()) {
            %>
                        <div class="card">
                            <p>Você ainda não fez nenhum pedido.</p>
                        </div>
            <%
                    } else {
                        for (Pedido pedido : pedidos) {
            %>
                            <div class="card">
                                <h3>Pedido #<%= pedido.getId() %></h3>
                                <div class="pedido-detalhes">
                                    <p><strong>Data:</strong> <%= pedido.getData() %></p>
                                    <p><strong>Status:</strong> <%= pedido.getStatus() %></p>
                                    <p><strong>Total:</strong> R$ <%= String.format("%.2f", pedido.getTotal()) %></p>
                                    
                                    <%-- Aqui você pode adicionar mais detalhes do pedido se necessário --%>
                                    <div class="itens-pedido">
                                        <h4>Itens do Pedido:</h4>
                                        <%
                                            List<ItemCarrinho> itens = pedidoDao.getItensPedido(pedido.getId());
                                            for (ItemCarrinho item : itens) {
                                        %>
                                            <div class="item">
                                                <p><%= item.getProdutoNome() %> - <%= item.getQuantidade() %> unidade(s)</p>
                                                <p>R$ <%= String.format("%.2f", item.getTotal()) %></p>
                                            </div>
                                        <% } %>
                                    </div>
                                </div>
                            </div>
            <%
                        }
                    }
                } else {
            %>
                    <div class="card">
                        <p>Por favor, faça login para ver seus pedidos.</p>
                    </div>
            <%
                }
            %>
        </div>

        <div class="actions">
            <a href="usuario.html" class="card">🏠 Voltar para Home</a>
            <a href="pedido.jsp" class="card">🛒 Fazer Novo Pedido</a>
            <a href="Conta.jsp" class="card">👤 Dados da Conta</a>
        </div>
    </main>

    <footer>
        &copy; 2024 Little Market - Todos os direitos reservados.
    </footer>
</body>
</html>
