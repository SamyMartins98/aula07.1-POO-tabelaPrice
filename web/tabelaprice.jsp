<%-- 
    Document   : index
    Created on : 28/03/2021, 16:13:23
    Author     : samantamartins
--%>

<%@page import="java.text.DecimalFormat"%>
<%@page import="javax.swing.JOptionPane"%>
<%@page import="java.text.NumberFormat"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Aula 07.1</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.0-beta3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="css/styles.css" rel="stylesheet">
    </head>
    <body>
        <%@include file="WEB-INF/components/header.jspf"%>
        <br>
        <h1 class="card-title">Tabela Price</h1>
        <hr>
        <div class="container">

            <form>
                <div class="container">
                    <div class="card text-center"> 
                        <div class="card-body">
                            <div class="row">
                                <div class="col-3">
                                    <label for="valorDoEmprestimo">Empréstimo (R$)</label>
                                    <input class="form-control" type="number" min="0" name="valorDoEmprestimo"  id="valorDoEmprestimo"/>
                                </div>
                                <div class="col-3">
                                    <label for="valorDeEntrada">Entrada (R$)</label>
                                    <input class="form-control" type="number" min="0" name="valorDeEntrada"  id="valorDeEntrada" />
                                </div>
                                <div class="col-2">
                                    <label for="taxaDeJuros">Taxa de Juros (%)</label>
                                    <input class="form-control" id="taxaDeJuros" type="number" min="0" name="taxaDeJuros" />
                                </div>
                                <div class="col-2">
                                    <label for="numeroDePeriodos">Nº de período (Meses)</label>
                                    <input class="form-control" id="numeroDePeriodos" type="number" min="0" name="numeroDePeriodos" />
                                </div>
                                <div class="col-2">
                                    <button type="submit" class="btn btn-primary" name="calcular">Calcular</button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </form>
            <%
                DecimalFormat df = new DecimalFormat("###,###.00");
                double parcela = 0, juros = 0, saldoDevedor = 0, amortizacao = 0, totalParcelas = 0, totalJuros = 0, totalAmortizado = 0;
                if (request.getParameter("calcular") != null) {
                    if ((request.getParameter("valorDoEmprestimo") != "" && request.getParameter("valorDoEmprestimo") != null)
                            || (request.getParameter("valorDeEntrada") != "" && request.getParameter("valorDeEntrada") != null)
                            || (request.getParameter("taxaDeJuros") != "" && request.getParameter("taxaDeJuros") != null)
                            || (request.getParameter("numeroDePeriodos") != "" && request.getParameter("numeroDePeriodos") != null)) {
                        try {

                            float valorDoEmprestimo = Float.parseFloat(request.getParameter("valorDoEmprestimo"));
                            float valorDeEntrada = Float.parseFloat(request.getParameter("valorDeEntrada"));
                            float taxaDeJuros = Float.parseFloat(request.getParameter("taxaDeJuros"));
                            int numeroDePeriodos = Integer.parseInt(request.getParameter("numeroDePeriodos"));
                            saldoDevedor = (valorDoEmprestimo - valorDeEntrada);
                            parcela = (saldoDevedor * (((Math.pow((1 + (taxaDeJuros / 100)), numeroDePeriodos)) * (taxaDeJuros / 100)) / 
                                    ((Math.pow((1 + (taxaDeJuros / 100)), numeroDePeriodos)) - 1)));
                            if ((valorDoEmprestimo >= 1) && (valorDeEntrada >= 0) && (taxaDeJuros >= 1) && (numeroDePeriodos >= 1)) {
            %>
            <%try {%>
            <div class="container">
                <hr>
                <table class="table table-dark table-striped">
                    <thead>
                        <tr>
                            <th> Vezes </th>
                            <th> Prestação </th>
                            <th> Juros </th>
                            <th> Amortização </th>
                            <th> Saldo Devedor </th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td>0</td>
                            <td> - </td>
                            <td> - </td>
                            <td> - </td>
                            <td>R$ <%= df.format(saldoDevedor)%></td>                             
                        </tr>
                        <%
                            for (int i = 1; i <= numeroDePeriodos; i++) {
                                juros = (saldoDevedor * (taxaDeJuros / 100));
                                amortizacao = parcela - juros;
                                saldoDevedor = saldoDevedor - amortizacao;
                                totalParcelas = totalParcelas + parcela;
                                totalJuros = totalJuros + juros;
                                totalAmortizado = totalAmortizado + amortizacao;
                                if (saldoDevedor < 0) {
                                    saldoDevedor = 0;
                                }
                        %>
                        <tr>
                            <td><%= i%></td>
                            <td>R$ <%= df.format(parcela)%></td>
                            <td>R$ <%= df.format(juros)%></td>
                            <td>R$ <%= df.format(amortizacao)%></td>
                            <td>R$ <%= df.format(saldoDevedor)%></td>
                        </tr>
                        <%}
                        %>
                        <tr>
                            <td><%="TOTAL"%></td>
                            <td>R$ <%= df.format(totalParcelas)%></td>
                            <td>R$ <%= df.format(totalJuros)%></td>
                            <td>R$ <%= df.format(totalAmortizado)%></td>
                            <td >  -  </td>
                        </tr>

                    </tbody>
                </table>
                <div class="container">
                    <div class="card text-center"> 
                        <div class="card-body">
                            <div class="row">
                                <div class="col-3">
                                    <label for="valorDoEmprestimo">Empréstimo R$:</label><label><%=valorDoEmprestimo%></label>
                                </div>
                                <div class="col-3">
                                    <label for="valorDoEmprestimo">Entrada R$:</label><label><%=valorDeEntrada%></label>
                                </div>
                                <div class="col-3">
                                    <label for="valorDoEmprestimo">Juros R$:</label><label><%=taxaDeJuros%></label>
                                </div>
                                <div class="col-3">
                                    <label for="valorDoEmprestimo">Meses R$:</label><label><%=numeroDePeriodos%></label>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <%
            } catch (NumberFormatException e) {%>
            <br>
            <div class="container" style="color:#d70000">
                <div class="card text-center" style="color:#d70000"> 
                    <div class="card-body">
                        <h5 class="card-title">Escolha inválida!</h5>
                    </div>
                </div>
            </div>
            <%}
            }
                } catch (NumberFormatException e) {%>
                <br>
                <div class="container" style="color:#d70000">
                    <div class="card text-center" style="color:#d70000"> 
                        <div class="card-body">
                            <h5 class="card-title">Escolha inválida!</h5>
                        </div>
                    </div>
                </div>
            <%
                } 
            }else {%>
            <br>
            <div class="container" style="color:#d70000">
                <div class="card text-center" style="color:#d70000"> 
                    <div class="card-body">
                        <h5 class="card-title">Escolha inválida!</h5>
                    </div>
                </div>
            </div>
            <%}
                }
            %> 
        </div>
        <br/>
        <%@include file="WEB-INF/components/footer.jspf"%>
    </body>
</html>