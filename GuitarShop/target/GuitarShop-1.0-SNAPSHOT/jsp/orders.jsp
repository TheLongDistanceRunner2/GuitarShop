<%-- 
    Document   : orders
    Created on : 1 cze 2021, 19:17:08
    Author     : Marcin
--%>

<%@page import="com.mycompany.guitarshop.Product"%>
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
        
        <%! 
            ArrayList<Product> productsList = new ArrayList();
            String imageSource = "";     
        %>    
        
        <%
            connectionToSQLite3.getConnection();
            String query = "select * from Orders order by ClientName desc, OrderID asc";
            this.listOrders = connectionToSQLite3.getAllOrders(query);
            String previousName = "";
            int previousOrder = 0;
            
            // get products form database:
            ConnectionToSQLite3 connection = new ConnectionToSQLite3();

            if(connection.getConnection() == null) {       
                out.println("<h2 align=\"center\"><font color=\"red\">Cannot open database!</font></h2>");
            }
            else {
                //out.println("connected to database");
                // connect:
                connection.getConnection();

                String _query = "select * from Products";
                // execute query:
                connection.selectFromDatabase(_query);
                // catch result:
                productsList = connection.getProductsList();

                imageSource = "../images/";

                %>
                <div class="divAdminOrders" style="margin-left: 500px">
                <%    
                for (int i = 0; i < this.listOrders.size(); i++) {
                    String tmpName = this.listOrders.get(i).getClientName();
                    int tmpOrderID = this.listOrders.get(i).getOrderID();
                    int itemID = this.listOrders.get(i).getItemID();
                    
                    String productName = "";
                    String productImage = "";
                    double price = 0.0;
                    String category = "";

                    // find item in database by its id:
                    for (int j = 0; j < this.productsList.size(); j++) {
                        Product tmpProduct = this.productsList.get(j);
                        
                        // if found this item:
                        if (tmpProduct.getID() == itemID) {
                            productName = tmpProduct.getName();
                            productImage = imageSource.concat(tmpProduct.getPicture());
                            price = tmpProduct.getPrice();
                            category = tmpProduct.getCategory();
                        }
                    }

                    if (i == 0) {
                        previousName = tmpName;
                        previousOrder = tmpOrderID;
                        out.println("<br><br>");
                        out.println("<h2 class=\"h2_7\">User: " + tmpName + "</h2>");
                        out.println("<br><br>");
                        out.println("<h2 class=\"h2_8\">Order number " + tmpOrderID + ":" + "</h2>");
                    }

                    // if it's still the same person:
                    if (previousName.equals(tmpName)) {
                        out.println("<br><br>");

                        // if it's still the same Order:
                        if (previousOrder == tmpOrderID) {
                            out.println("<img src=\"" + productImage + "\" width=\"400\" height=\"300\"/>");
                            out.println("<h2 class=\"h2_9\"> " + productName + "</h2>");
                            out.println("<h2 class=\"h2_9\"> " + price + " zł" + "</h2>"); 
                            out.println("<h2 class=\"h2_9\"> " + category + "</h2>");      
                        }
                        // if it's a new Order:
                        else {
                            out.println("<h2 class=\"h2_8\">Order number " + tmpOrderID + ":" + "</h2>");
                            out.println("<br><br>");
                            out.println("<img src=\"" + productImage + "\" width=\"400\" height=\"300\"/>");
                            out.println("<h2 class=\"h2_9\"> " + productName + "</h2>");
                            out.println("<h2 class=\"h2_9\"> " + price + " zł" + "</h2>"); 
                            out.println("<h2 class=\"h2_9\"> " + category + "</h2>");
                            previousOrder = tmpOrderID;
                        }  
                    }
                    // if it's a new person:
                    else {
                        out.println("<br><br>");
                        out.println("<br><br>");
                        out.println("<h2 class=\"h2_7\">User: " + tmpName + "</h2>");
                        out.println("<br><br>");
                        out.println("<h2 class=\"h2_8\">Order number " + tmpOrderID + ":" + "</h2>");
                        out.println("<br><br>");
                        out.println("<img src=\"" + productImage + "\" width=\"400\" height=\"300\"/>");
                        out.println("<h2 class=\"h2_9\"> " + productName + "</h2>");
                        out.println("<h2 class=\"h2_9\"> " + price + " zł" + "</h2>"); 
                        out.println("<h2 class=\"h2_9\"> " + category + "</h2>"); 
                        previousName = tmpName;
                        previousOrder = tmpOrderID;
                    }
                }
                %>
                </div>
            <%
            }
        %>
            
            
        
    </body>
</html>
