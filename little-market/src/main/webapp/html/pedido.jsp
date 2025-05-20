<%@ page import="br.com.littlemarket.model.User" %>
<%@ page import="br.com.littlemarket.model.Produto" %>
<%@ page import="br.com.littlemarket.model.ItemCarrinho" %>
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
    <jsp:include page="../jsp/navbar.jsp" />

    <%
        User user = (User) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect("../html/login.jsp");
            return;
        }

        ProdutoDao produtoDao = new ProdutoDao();
        PedidoDao pedidoDao = new PedidoDao();
        List<ItemCarrinho> carrinho = (List<ItemCarrinho>) session.getAttribute("carrinho");
        if (carrinho == null) {
            carrinho = new ArrayList<>();
            session.setAttribute("carrinho", carrinho);
        }

        // Adicionar produto ao carrinho
        String addProduto = request.getParameter("addProduto");
        if (addProduto != null) {
            try {
                int produtoId = Integer.parseInt(request.getParameter("produtoId"));
                int quantidade = Integer.parseInt(request.getParameter("quantidade"));
                
                Produto produto = produtoDao.getProdutoById(produtoId);
                if (produto != null) {
                    boolean itemExiste = false;
                    for (ItemCarrinho item : carrinho) {
                        if (item.getProdutoId() == produtoId) {
                            item.setQuantidade(item.getQuantidade() + quantidade);
                            itemExiste = true;
                            break;
                        }
                    }
                    
                    if (!itemExiste) {
                        ItemCarrinho novoItem = new ItemCarrinho(
                            produtoId,
                            produto.getNome(),
                            quantidade,
                            produto.getPreco()
                        );
                        carrinho.add(novoItem);
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        // Remover item do carrinho
        String removeItem = request.getParameter("removeItem");
        if (removeItem != null) {
            try {
                int produtoId = Integer.parseInt(removeItem);
                carrinho.removeIf(item -> item.getProdutoId() == produtoId);
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        // Finalizar pedido
        String finalizar = request.getParameter("finalizar");
        if (finalizar != null && !carrinho.isEmpty()) {
            try {
                int pedidoId = pedidoDao.criarPedido(user.getId());
                if (pedidoId > 0) {
                    pedidoDao.finalizarPedido(pedidoId, carrinho);
                    carrinho.clear();
                    response.sendRedirect("verPedido.jsp");
                    return;
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        List<Produto> produtos = produtoDao.getAllProdutos();
    %>

    <main>
        <div class="container">
            <h2>Novo Pedido</h2>
            
            <div class="pedido-container">
                <div class="form-section">
                    <h3>Adicionar Produto</h3>
                    <form method="post" class="add-produto-form">
                        <div class="form-group">
                            <label for="produtoId">Produto:</label>
                            <select name="produtoId" id="produtoId" required>
                                <option value="">Selecione um produto</option>
                                <% for (Produto produto : produtos) { %>
                                    <option value="<%= produto.getId() %>">
                                        <%= produto.getNome() %> - R$ <%= String.format("%.2f", produto.getPreco()) %>
                                    </option>
                                <% } %>
                            </select>
                        </div>
                        
                        <div class="form-group">
                            <label for="quantidade">Quantidade:</label>
                            <input type="number" name="quantidade" id="quantidade" min="1" value="1" required>
                        </div>
                        
                        <button type="submit" name="addProduto" class="btn btn-primary">Adicionar ao Carrinho</button>
                    </form>
                </div>

                <div class="carrinho-section">
                    <h3>Carrinho</h3>
                    <% if (carrinho.isEmpty()) { %>
                        <p class="empty-cart">Seu carrinho está vazio</p>
                    <% } else { %>
                        <div class="carrinho-items">
                            <% for (ItemCarrinho item : carrinho) { %>
                                <div class="carrinho-item">
                                    <div class="item-info">
                                        <h4><%= item.getProdutoNome() %></h4>
                                        <p>Quantidade: <%= item.getQuantidade() %></p>
                                        <p>Preço unitário: R$ <%= String.format("%.2f", item.getPrecoUnitario()) %></p>
                                        <p class="item-total">Total: R$ <%= String.format("%.2f", item.getQuantidade() * item.getPrecoUnitario()) %></p>
                                    </div>
                                    <form method="post" class="remove-form">
                                        <input type="hidden" name="removeItem" value="<%= item.getProdutoId() %>">
                                        <button type="submit" class="btn btn-danger">Remover</button>
                                    </form>
                                </div>
                            <% } %>
                            
                            <div class="carrinho-total">
                                <h4>Total do Pedido:</h4>
                                <p class="total-value">
                                    R$ <%= String.format("%.2f", carrinho.stream()
                                        .mapToDouble(item -> item.getQuantidade() * item.getPrecoUnitario())
                                        .sum()) %>
                                </p>
                            </div>
                            
                            <form method="post" class="finalizar-form">
                                <button type="submit" name="finalizar" class="btn btn-success">Finalizar Pedido</button>
                            </form>
                        </div>
                    <% } %>
                </div>
            </div>
        </div>
    </main>

    <footer>
        &copy; 2024 Little Market - Todos os direitos reservados.
    </footer>
</body>
</html>
