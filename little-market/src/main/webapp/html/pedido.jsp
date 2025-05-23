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
    <style>
        .pedido-container {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 2rem;
            margin-top: 2rem;
        }

        .form-section, .carrinho-section {
            background: white;
            padding: 2rem;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }

        .form-group {
            margin-bottom: 1.5rem;
        }

        .form-group label {
            display: block;
            margin-bottom: 0.5rem;
            font-weight: bold;
            color: #333;
        }

        .form-group select, .form-group input {
            width: 100%;
            padding: 0.8rem;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 1rem;
        }

        .carrinho-items {
            margin-top: 1rem;
        }

        .carrinho-item {
            display: grid;
            grid-template-columns: auto 1fr auto;
            gap: 1rem;
            padding: 1rem;
            border-bottom: 1px solid #eee;
            align-items: center;
        }

        .carrinho-item:last-child {
            border-bottom: none;
        }

        .item-imagem {
            width: 80px;
            height: 80px;
            object-fit: cover;
            border-radius: 4px;
        }

        .item-info {
            display: flex;
            flex-direction: column;
            gap: 0.5rem;
        }

        .item-info h4 {
            margin: 0;
            color: #333;
        }

        .item-info p {
            margin: 0;
            color: #666;
        }

        .item-total {
            font-weight: bold;
            color: #28a745;
        }

        .remove-form {
            margin: 0;
        }

        .btn-danger {
            background: #dc3545;
            color: white;
            border: none;
            padding: 0.5rem 1rem;
            border-radius: 4px;
            cursor: pointer;
            transition: background 0.3s;
        }

        .btn-danger:hover {
            background: #c82333;
        }

        .carrinho-total {
            margin-top: 2rem;
            padding-top: 1rem;
            border-top: 2px solid #eee;
        }

        .total-value {
            font-size: 1.5rem;
            font-weight: bold;
            color: #28a745;
        }

        .finalizar-form {
            margin-top: 1rem;
        }

        .btn-success {
            background: #28a745;
            color: white;
            border: none;
            padding: 1rem 2rem;
            border-radius: 4px;
            cursor: pointer;
            width: 100%;
            font-size: 1.1rem;
            transition: background 0.3s;
        }

        .btn-success:hover {
            background: #218838;
        }

        .empty-cart {
            text-align: center;
            color: #666;
            padding: 2rem;
        }

        .quantidade-input {
            width: 80px;
            padding: 0.5rem;
            border: 1px solid #ddd;
            border-radius: 4px;
            margin-right: 1rem;
        }

        .btn-primary {
            background: #007bff;
            color: white;
            border: none;
            padding: 0.8rem 1.5rem;
            border-radius: 4px;
            cursor: pointer;
            transition: background 0.3s;
        }

        .btn-primary:hover {
            background: #0056b3;
        }
    </style>
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

        // --- Suporte para edição de pedido -----
        String editarPedidoIdParam = request.getParameter("editarPedidoId");
        if (editarPedidoIdParam != null) {
            // Usuário solicitou editar um pedido existente
            try {
                int editPedidoId = Integer.parseInt(editarPedidoIdParam);
                // Carrega itens do pedido na sessão (carrinho)
                List<ItemCarrinho> carrinho = pedidoDao.getItensPedido(editPedidoId);
                session.setAttribute("carrinho", carrinho);
                session.setAttribute("editandoPedidoId", editPedidoId);
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        List<ItemCarrinho> carrinho = (List<ItemCarrinho>) session.getAttribute("carrinho");
        if (carrinho == null) {
            carrinho = new ArrayList<ItemCarrinho>();
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
                            produto.getPreco(),
                            produto.getImagemUrl()
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
                for (Iterator<ItemCarrinho> iterator = carrinho.iterator(); iterator.hasNext();) {
                    ItemCarrinho item = iterator.next();
                    if (item.getProdutoId() == produtoId) {
                        iterator.remove();
                        break;
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        // Finalizar pedido
        String finalizar = request.getParameter("finalizar");
        if (finalizar != null && !carrinho.isEmpty()) {
            try {
                if (user.getId() <= 0) {
                    session.setAttribute("erro", "Erro: ID do usuário inválido. Por favor, faça login novamente.");
                    response.sendRedirect("login.jsp");
                    return;
                }

                // Verifica se estamos editando pedido existente
                Integer editandoPedidoId = (Integer) session.getAttribute("editandoPedidoId");
                int pedidoId;
                if (editandoPedidoId != null) {
                    pedidoId = editandoPedidoId;
                    // Atualiza itens
                    pedidoDao.atualizarItensPedido(pedidoId, carrinho);
                    session.removeAttribute("editandoPedidoId");
                    session.setAttribute("mensagem", "Pedido atualizado com sucesso!");
                } else {
                    // Novo pedido
                    pedidoId = pedidoDao.criarPedido(user.getId());
                    if (pedidoId > 0) {
                        pedidoDao.finalizarPedido(pedidoId, carrinho);
                        session.setAttribute("mensagem", "Pedido criado com sucesso!");
                    } else {
                        session.setAttribute("erro", "Erro ao criar pedido. Tente novamente.");
                    }
                }

                carrinho.clear();
                response.sendRedirect("verPedido.jsp?id=" + pedidoId);
                return;
            } catch (SQLException e) {
                e.printStackTrace();
                String mensagemErro = "Erro ao finalizar pedido: ";
                if (e.getMessage().contains("Usuário não encontrado")) {
                    mensagemErro += "Usuário não encontrado. Por favor, faça login novamente.";
                    session.setAttribute("erro", mensagemErro);
                    response.sendRedirect("login.jsp");
                } else {
                    mensagemErro += e.getMessage();
                    session.setAttribute("erro", mensagemErro);
                }
            }
        }

        // Exibir mensagens de erro ou sucesso
        String mensagem = (String) session.getAttribute("mensagem");
        String erro = (String) session.getAttribute("erro");
        if (mensagem != null) {
            session.removeAttribute("mensagem");
        }
        if (erro != null) {
            session.removeAttribute("erro");
        }

        List<Produto> produtos = produtoDao.getAllProdutos();
    %>

    <main>
        <div class="container">
            <h2>Novo Pedido</h2>
            
            <% if (mensagem != null) { %>
                <div class="alert alert-success">
                    <%= mensagem %>
                </div>
            <% } %>
            
            <% if (erro != null) { %>
                <div class="alert alert-danger">
                    <%= erro %>
                </div>
            <% } %>

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
                                    <img src="<%= item.getImagem() %>" alt="<%= item.getProdutoNome() %>" class="item-imagem">
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
                                    R$ <%= String.format("%.2f", calcularTotal(carrinho)) %>
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

<%!
    private double calcularTotal(List<ItemCarrinho> carrinho) {
        double total = 0.0;
        for (ItemCarrinho item : carrinho) {
            total += item.getQuantidade() * item.getPrecoUnitario();
        }
        return total;
    }
%>
