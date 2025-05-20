<%@ page import="br.com.littlemarket.model.User" %>
<%@ page import="br.com.littlemarket.model.Produto" %>
<%@ page import="br.com.littlemarket.dao.ProdutoDao" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Produtos - Little Market</title>
    <link rel="stylesheet" href="../css/usuario.css">
    <style>
        .produtos-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 2rem;
            padding: 2rem 0;
        }

        .produto-card {
            background: white;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            overflow: hidden;
            transition: transform 0.3s ease;
        }

        .produto-card:hover {
            transform: translateY(-5px);
        }

        .produto-imagem {
            width: 100%;
            height: 250px;
            overflow: hidden;
        }

        .produto-imagem img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .produto-info {
            padding: 1.5rem;
        }

        .produto-info h3 {
            margin: 0 0 1rem 0;
            color: #333;
            font-size: 1.4rem;
        }

        .preco {
            font-size: 1.5rem;
            color: #28a745;
            font-weight: bold;
            margin: 0.5rem 0;
        }

        .descricao {
            color: #666;
            margin: 1rem 0;
            line-height: 1.5;
        }

        .container {
            max-width: 1400px;
            margin: 0 auto;
            padding: 0 2rem;
        }

        h2 {
            text-align: center;
            margin: 2rem 0;
            color: #333;
            font-size: 2rem;
        }
    </style>
</head>
<body>
    <jsp:include page="../jsp/navbar.jsp" />

    <main>
        <div class="container">
            <h2>Nossos Produtos</h2>
            
            <div class="produtos-grid">
                <%
                    ProdutoDao produtoDao = new ProdutoDao();
                    List<Produto> produtos = produtoDao.getAllProdutos();
                    
                    for (Produto produto : produtos) {
                %>
                    <div class="produto-card">
                        <div class="produto-imagem">
                            <img src="<%= produto.getImagemUrl() %>" alt="<%= produto.getNome() %>">
                        </div>
                        <div class="produto-info">
                            <h3><%= produto.getNome() %></h3>
                            <p class="preco">R$ <%= String.format("%.2f", produto.getPreco()) %></p>
                            <p class="descricao"><%= produto.getDescricao() %></p>
                        </div>
                    </div>
                <% } %>
            </div>
        </div>
    </main>

    <footer>
        &copy; 2024 Little Market - Todos os direitos reservados.
    </footer>
</body>
</html>
