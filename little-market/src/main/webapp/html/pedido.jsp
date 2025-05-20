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
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Fazer Pedido - Little Market</title>
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
                Integer userId = (Integer) session.getAttribute("userId");

                if (userId != null) {
                    PedidoDao pedidoDao = new PedidoDao();
                    try {
                        int pedidoId = pedidoDao.criarPedido(userId);

                        if (pedidoId > 0) {
                            pedidoDao.finalizarPedido(pedidoId, carrinho);
                            carrinho.clear();
                            response.sendRedirect("../jsp/pedidos.jsp?sucesso=Pedido #" + pedidoId + " realizado com sucesso!");
                            return;
                        }
                    } catch (SQLException e) {
                        e.printStackTrace();
                        response.sendRedirect("../jsp/pedidos.jsp?erro=Erro ao finalizar pedido: " + e.getMessage());
                        return;
                    }
                }
                response.sendRedirect("../jsp/pedidos.jsp?erro=Erro ao finalizar pedido: Usuário não autenticado");
            }
        %>

        <h2>Fazer Novo Pedido</h2>

        <div class="painel">
            <div class="card">
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

            <div class="card">
                <h3>Seu Carrinho</h3>
                <% if (carrinho.isEmpty()) { %>
                    <p>Seu carrinho está vazio.</p>
                <% } else { %>
                    <%
                    double totalPedido = 0;
                    for (ItemCarrinho item : carrinho) {
                        totalPedido += item.getTotal();
                    %>
                        <div class="carrinho-item">
                            <p><strong><%= item.getProdutoNome() %></strong></p>
                            <p>Quantidade: <%= item.getQuantidade() %></p>
                            <p>Preço Unitário: R$ <%= String.format("%.2f", item.getPrecoUnitario()) %></p>
                            <p>Total: R$ <%= String.format("%.2f", item.getTotal()) %></p>
                            <form method="post" style="display:inline;">
                                <input type="hidden" name="produtoId" value="<%= item.getProdutoId() %>">
                                <button type="submit" name="remover">Remover</button>
                            </form>
                        </div>
                    <% } %>
                    <div class="total">
                        <p><strong>Total do Pedido: R$ <%= String.format("%.2f", totalPedido) %></strong></p>
                        <form method="post">
                            <button type="submit" name="finalizar">Finalizar Pedido</button>
                        </form>
                    </div>
                <% } %>
            </div>
        </div>

        <div class="actions">
            <a href="usuario.html" class="card">🏠 Voltar para Home</a>
            <a href="../jsp/pedidos.jsp" class="card">📦 Ver Meus Pedidos</a>
            <a href="Conta.jsp" class="card">👤 Dados da Conta</a>
        </div>
    </main>

    <footer>
        &copy; 2024 Little Market - Todos os direitos reservados.
    </footer>
</body>
</html>
