package br.com.littlemarket.servlet;

import br.com.littlemarket.dao.ProdutoDao;
import br.com.littlemarket.model.Produto;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/alterar-produto")
public class AlterProdutoServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String idProdutoStr = request.getParameter("idProduto");
        String nome = request.getParameter("nome");
        String descricao = request.getParameter("descricao");
        double preco = Double.parseDouble(request.getParameter("preco"));
        int estoque = Integer.parseInt(request.getParameter("estoque"));
        String imagemUrl = request.getParameter("imagem_url");

        Produto produto = new Produto(Integer.parseInt(idProdutoStr), nome, descricao, preco, estoque, imagemUrl);
        ProdutoDao produtoDao = new ProdutoDao();
        boolean sucesso = produtoDao.alterProduto(produto);

        if (sucesso) {
            response.sendRedirect("html/gerenciar.jsp");
        } else {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Erro ao alterar o produto.");
        }
    }
}