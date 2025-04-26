package br.com.littlemarket.servlet;

import br.com.littlemarket.dao.ProdutoDao;
import br.com.littlemarket.model.Produto;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/createProduto")
public class CreateProdutoServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String nome = request.getParameter("nome");
        String descricao = request.getParameter("descricao");
        double preco;
        int estoque;
        String imagemUrl = request.getParameter("imagem_url");

        try {
            preco = Double.parseDouble(request.getParameter("preco"));
            estoque = Integer.parseInt(request.getParameter("estoque"));
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid price format");
            return;
        }

        Produto produto = new Produto();
        produto.setNome(nome);
        produto.setDescricao(descricao);
        produto.setPreco(preco);
        produto.setEstoque(estoque);
        produto.setImagemUrl(imagemUrl);

        ProdutoDao produtoDao = new ProdutoDao();
        produtoDao.createProduto(produto);
        response.getWriter().println("Product created successfully!");

    }
}
