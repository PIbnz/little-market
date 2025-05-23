<%@ page import="br.com.littlemarket.dao.PedidoDao" %>
<%@ page import="br.com.littlemarket.model.Pedido" %>
<%@ page import="br.com.littlemarket.model.ItemPedido" %>
<%@ page import="java.util.List" %>
<%@ page import="br.com.littlemarket.dao.UserDao" %>
<%@ page import="br.com.littlemarket.model.User" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <title>Gerenciar Pedidos</title>
    <link rel="stylesheet" href="../css/gerenciar.css">
</head>
<body>
    <%
        // Verificar se o usuário está logado e é admin
        User user = (User) session.getAttribute("user");
        if (user == null || user.getPermissionLevel() != 2) {
            response.sendRedirect("../html/login.jsp");
            return;
        }
    %>
    <jsp:include page="../jsp/navbar_dono.jsp" />
<main>
    <h1>Pedidos Recebidos</h1>
    <%
        PedidoDao pedidoDao = new PedidoDao();
        UserDao udao = new UserDao();
        
        // Concluir pedido se parâmetro presente
        String concluir = request.getParameter("concluirId");
        if (concluir != null) {
            try {
                int pid = Integer.parseInt(concluir);
                pedidoDao.atualizarStatus(pid, "concluido");
                response.sendRedirect(request.getContextPath() + "/html/verPedidosAdm.jsp?success=true");
                return;
            } catch (Exception e) {
                e.printStackTrace();
                %>
                <div class="alert alert-danger">
                    Erro ao concluir pedido: <%= e.getMessage() %>
                </div>
                <%
            }
        }

        // Mensagem de sucesso
        String success = request.getParameter("success");
        if ("true".equals(success)) {
            %>
            <div class="alert alert-success">
                Pedido concluído com sucesso!
            </div>
            <%
        }

        List<Pedido> lista = null;
        try {
            lista = pedidoDao.getAllPedidos();
        } catch (Exception e) {
            e.printStackTrace();
            %>
            <div class="alert alert-danger">
                Erro ao carregar pedidos: <%= e.getMessage() %>
            </div>
            <%
        }
    %>
    <div class="table-container">
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
            <% if (lista != null && !lista.isEmpty()) {
                   for (Pedido p : lista) { %>
                <tr>
                    <td><%= p.getId() %></td>
                    <td><%= udao.getUserById(p.getUserId()) != null ? udao.getUserById(p.getUserId()).getName() : "Cliente #" + p.getUserId() %></td>
                    <td><%= p.getData() %></td>
                    <td>R$ <%= String.format("%.2f", p.getTotal()) %></td>
                    <td>
                        <span class="status-badge <%= p.getStatus().toLowerCase() %>">
                            <%= p.getStatus() %>
                        </span>
                    </td>
                    <td class="actions">
                        <a href="<%= request.getContextPath() %>/html/verPedido.jsp?id=<%= p.getId() %>" class="btn-view">
                            Ver Detalhes
                        </a>
                        <% if (!"concluido".equalsIgnoreCase(p.getStatus())) { %>
                            <form method="post" action="<%= request.getContextPath() %>/html/verPedidosAdm.jsp" 
                                  onsubmit="return confirm('Tem certeza que deseja concluir este pedido?');">
                                <input type="hidden" name="concluirId" value="<%= p.getId() %>">
                                <button type="submit" class="btn-concluir">Concluir</button>
                            </form>
                        <% } %>
                    </td>
                </tr>
            <% } } else { %>
                <tr>
                    <td colspan="6" class="no-orders">Nenhum pedido encontrado</td>
                </tr>
            <% } %>
            </tbody>
        </table>
    </div>
</main>

<footer>
    &copy; 2024 Little Market - Todos os direitos reservados.
</footer>
<style>
    .table-container {
        margin: 20px 0;
        background: white;
        border-radius: 8px;
        box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        overflow: hidden;
    }

    table {
        width: 100%;
        border-collapse: collapse;
        margin: 0;
    }

    th, td {
        padding: 12px 15px;
        text-align: left;
        border-bottom: 1px solid #eee;
    }

    th {
        background-color: #f8f9fa;
        font-weight: 600;
        color: #333;
    }

    tr:hover {
        background-color: #f8f9fa;
    }

    .status-badge {
        display: inline-block;
        padding: 6px 12px;
        border-radius: 20px;
        font-size: 0.85em;
        font-weight: 600;
    }

    .status-badge.pendente {
        background-color: #fff3cd;
        color: #856404;
    }

    .status-badge.concluido {
        background-color: #d4edda;
        color: #155724;
    }

    .actions {
        display: flex;
        gap: 8px;
        align-items: center;
    }

    .btn-concluir {
        background: var(--primary-color, #28a745);
        color: #fff;
        border: none;
        padding: 6px 12px;
        border-radius: 4px;
        cursor: pointer;
        font-weight: 600;
        transition: background 0.3s ease;
    }

    .btn-concluir:hover {
        background: var(--secondary-color, #218838);
    }

    .btn-view {
        background: #007bff;
        color: #fff;
        text-decoration: none;
        padding: 6px 12px;
        border-radius: 4px;
        font-size: 0.9em;
        transition: background 0.3s ease;
    }

    .btn-view:hover {
        background: #0056b3;
    }

    .alert {
        padding: 12px 20px;
        margin: 20px 0;
        border-radius: 4px;
        font-weight: 500;
    }

    .alert-success {
        background-color: #d4edda;
        color: #155724;
        border: 1px solid #c3e6cb;
    }

    .alert-danger {
        background-color: #f8d7da;
        color: #721c24;
        border: 1px solid #f5c6cb;
    }

    .no-orders {
        text-align: center;
        color: #666;
        padding: 20px;
    }
</style>
</body>
</html>
