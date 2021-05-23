<%-- 
    Document   : chart
    Created on : 14 maj 2021, 20:55:41
    Author     : Marcin
--%>

<%@page import="com.mycompany.guitarshop.Product"%>
<%@page import="com.mycompany.guitarshop.ConnectionToSQLite3"%>
<%@page import="java.util.ArrayList"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Chart</title>
        
        <link rel="stylesheet" href="../css/style1.css">
    </head>
    <body>
        <button class="menuButton" onclick="products()" type="button">
            Products</button>
        &nbsp;
        <button class="menuButton" onclick="mainPage()" type="button">
            Main page</button>
        &nbsp;


        
        <h1 class="h1">Your chart:</h1>
        
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
                window.location = "jsp/administrationPanel.jsp";
            }
            
        </script>
        
        
        <%!
            String imageSource = "../images/"; 
        %>    
        
        <%
            double sumCost = 0;
            
            // print cookies with selected items to buy:
            Cookie[] cookies = request.getCookies();
            ArrayList<String> selectedItems = new ArrayList<>();
            ArrayList<Product> fromDatabase = new ArrayList();
            
            
            
        //==================================================================
            
            // if cookies is not empty:
            if (cookies != null) {
                for (int i = 0; i < cookies.length; i++) {
                    // if the cookie starts with "addItem" prefix:
                    if(cookies[i].getName().startsWith("addItem")) {
                        // add it to ArrayList of selected items to show later:
                        selectedItems.add(cookies[i].getValue());
                        //out.println("<h2 class=\"h2_2\" align=\"center\">" + cookies[i].getValue() + "</h2>");
                    }
                }
                
                // get data from database by id:
                ConnectionToSQLite3 connection = new ConnectionToSQLite3();

                if(connection.getConnection() == null) {       
                    out.println("<h2 align=\"center\"><font color=\"red\">Cannot open database!</font></h2>");
                }
                else {
                    //out.println("connected to database");
                    // connect:
                    connection.getConnection();

                    String query = "select * from Products";
                    // execute query:
                    connection.selectFromDatabase(query);
                    // catch result:
                    fromDatabase = connection.getProductsList();
                    
                    //============================================================
                    // catch response from clear chart button:
                    String clearChartButton = request.getParameter("clearChartButton");

                    if(clearChartButton != null) {
                        for (int i = 0; i < selectedItems.size(); i++) {
                            // remove item:
                            selectedItems.remove(i);
                            
                            for (int j = 0; j < cookies.length; j++) {
                                // if found cookie with name addItem:
                                if(cookies[j].getName().startsWith("addItem")) {
                                    // remove this cookie:
                                    // so get it first:
                                    Cookie cookie = cookies[j];
                                    
                                    // then set its' time of existing to 0:
                                    cookie.setMaxAge(0);
                                    // and finally add it to response header:
                                    response.addCookie(cookie);
                                }
                            }
                        }
                        
                        selectedItems.clear();
                    }

                    
                    // ==========================================================
                    // print all items added to chart:
                    for (int i = 0; i < selectedItems.size(); i++) {
                        int currentID = Integer.valueOf(selectedItems.get(i));
                        
                        // iterate over ArrayList of all products:
                        for (int j = 0; j < fromDatabase.size(); j++) {
                            Product currentProduct = fromDatabase.get(j);
                            
                            // if ID of item in chart equals to ID of product
                            // from ArrayList received from database:
                            if(currentProduct.getID() == currentID) {
                                // print it:
                                %>
                                <form method="POST" action="chart.jsp">  
                                    <div class="divChart">
                                        <% out.print(currentProduct.getName()); %>
                                        <br><br>
                                        <% String path = imageSource.concat(currentProduct.getPicture()); 
                                           //out.println(path);
                                        %>
                                        <img src="<%=path%>" width="200" height="100">
                                        &nbsp;
                                        <% out.print(currentProduct.getPrice() + " zł"); %>
                                        <br><br> 
                                    </div>   
                                </form>
                                <%  
                                
                                // add cost to sum of costs:
                                sumCost += currentProduct.getPrice();
                            }
                        }
                    }






                    %>
                    <form method="POST" action="chart.jsp">
                        <input class="clearChartButton" type="submit" id="clearChartButton" name="clearChartButton" value="Clear chart!"/> 
                    </form>    
                    <%
                }
            }
            %>
            
            
            <div class="divCostSum">
                <% out.println("<h2 class=\"h2_2\" align=\"center\"><font color=\"black\">" + "Sum of all items\n: " 
                        + sumCost + " zł" + "</font></h2>"); %>
            </div> 
  
            
    </body>
</html>
