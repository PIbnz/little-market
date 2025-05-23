<%@ page import="br.com.littlemarket.model.User" %>
<%
    User user = (User) session.getAttribute("user");
%>
<header>
    <div class="logo-container">
        <img src="../img/INDEX/logo-pequena.png" alt="Logo da empresa Little Market" class="logo-img" />
        <div class="logo-text">Little Market</div>
    </div>

    <nav style="background-color: #0e773b;">
        <a href="dono.html">Home</a>
        <a href="verPedidosAdm.jsp">Pedidos</a>
        <a href="gerenciar.jsp">Estoque</a>
        <a href="adicionarProduto.html">Adicionar Produto</a>
        <a href="adicionarFuncionario.jsp">Adicionar Funcionario</a>
    </nav>

    <div class="user-menu">
        <span>Painel do Dono</span>
        <a href="login.jsp?logout=true">Sair</a>
    </div>
</header> 