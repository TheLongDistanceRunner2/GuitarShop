<%-- 
    Document   : orders
    Created on : 1 cze 2021, 19:17:08
    Author     : Marcin
--%>

<%@page import="java.util.ArrayList"%>
<%@page import="com.mycompany.guitarshop.Order"%>
<%@page import="com.mycompany.guitarshop.ConnectionToSQLite3"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Orders</title>
        
        <link rel="stylesheet" href="../css/style1.css">
    </head>
    <body>
        <button class="menuButton" onclick="mainPage()" type="button">
            Main page</button>
        &nbsp;
        <button class="menuButton" onclick="administrationPanel()" type="button">
            Administration panel</button>
        &nbsp;
        
        <%!
            boolean flag = false;
            ConnectionToSQLite3 connectionToSQLite3 = new ConnectionToSQLite3();
            ArrayList<Order> listOrders = new ArrayList<>();
        %>   
        
        <%
            Cookie _cookie = null;
            Cookie[] _cookies = null;
            
            // Get an array of Cookies associated with the this domain
            _cookies = request.getCookies();

            if(_cookies != null) {
                for (int i = 0; i < _cookies.length; i++) {
                    _cookie = _cookies[i];
                  
                    // if logged in:
                    if (_cookie.getName().equals("login")) {
                        // set flag:
                        flag = true;
                        
                        // show log out button:
                        %>
                        <form method="POST" action="products.jsp">
                            <button class="menuButton" onclick="products()" type="button">
                                Products</button>
                            &nbsp;
                            <button class="menuButton" onclick="chart()" type="button">
                                Chart</button>
                            &nbsp;
                            <input class="menuButton" name="logOutButton" id="logOutButton" type="submit" value="Log out!"/>
                            &nbsp;
                        </form>
                        &nbsp;
                        <%
                    
                        // and print hello message:
                        %>
                        <%
                        out.print("<div align=\"right\" style=\"font: 24px helvetica italic; font-style: italic;\"><font color=\"white\" >Hello " + _cookie.getValue()+ "! &nbsp&nbsp&nbsp </font></div>");                       
                    }
                }
            }
        %>    
        
                <script>
            function mainPage() {
                window.location = "../index.html";
            }
            
            function products() {
                window.location = "products.jsp";
            }
            
            function chart() {
                window.location = "chart.jsp";
            }

            function logIn() {
                window.location = "jsp/logIn.jsp";
            }
            
            function contact() {
                window.location = "jsp/contact.jsp";
            }
            
            function administrationPanel() {
                window.location = "administrationPanel.jsp";
            }
            
            function orders() {
                window.location = "orders.jsp";
            }
            
        </script>
        
        <h1 class="h1">All orders:</h1>
        
        <%
            connectionToSQLite3.getConnection();
            String query = "select * from Orders order by ClientName desc, OrderID asc";
            this.listOrders = connectionToSQLite3.getAllOrders(query);
            
            for (int i = 0; i < this.listOrders.size(); i++) {
                out.print(this.listOrders.get(i).getID() + " " 
                                + this.listOrders.get(i).getOrderID() + " "
                                + this.listOrders.get(i).getClientName() + " "
                                + this.listOrders.get(i).getItemID() + "        ");
            }
            
        %>    
        
    </body>
</html>
