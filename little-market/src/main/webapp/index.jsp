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
  <title>Little Market</title>
  <link rel="stylesheet" href="css/index.css">
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

  <header>
    <div class="logo-area">
      <img src="img/INDEX/logo-pequena.png" alt="Logo Little Market">
    </div>
  </header>

  <nav>
    <a href="index.html">Home</a>
    <a href="html/produto.jsp">Produtos</a>
    <a href="html/login.html">Login</a>
  </nav>

  <div class="aviso">
    Frete <strong>GRÁTIS</strong> para pedidos acima de <strong>R$200</strong>
  </div>

  <section class="hero">
    <h1>SAL <br><span style="color: var(--highlight-color);">MEDIDA</span></h1>
    <p><strong>30%</strong> de desconto em bacalhaus salgados selecionados</p>
    <img src="img/INDEX/bacalhau.png" alt="Bacalhau" style="max-width: 300px; margin-top: 20px;">
  </section>


<body>


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

</body>
</html>
