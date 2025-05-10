package br.com.littlemarket.servlet;

import br.com.littlemarket.dao.ProdutoDao;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/delete-produto")
public class DeleteProdutoServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String idProdutoStr = request.getParameter("idProduto");
        int idProduto;

        try {
            idProduto = Integer.parseInt(idProdutoStr);
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID do produto inválido.");
            return;
        }

        ProdutoDao produtoDao = new ProdutoDao();
        boolean sucesso = produtoDao.deleteProduto(idProduto);

        if (sucesso) {
            response.sendRedirect("jsp/deletarEalterarProdutos.jsp");
        } else {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Erro ao deletar o produto.");
        }
    }
}
