<%-- 
    Document   : products
    Created on : 11 maj 2021, 18:48:05
    Author     : Marcin
--%>

<%@page import="com.mycompany.guitarshop.ConnectionToSQLite3"%>
<%@page import="com.mycompany.guitarshop.Product"%>
<%@ page import="java.sql.*" %>
<%@ page import="org.sqlite.*" %>
<%@page import="java.util.ArrayList"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Products</title>
        
        <link rel="stylesheet" href="../css/style1.css">
    </head>
    <body>
        <button class="menuButton" onclick="chart()" type="button">
            Chart</button>
        &nbsp;
        <button class="menuButton" onclick="mainPage()" type="button">
            Main page</button>
        &nbsp;

        
        <h1 class="h1">Our offer:</h1>


        
        <script>
            function mainPage() {
                window.location = "../index.html";
            }
            
            function products() {
                window.location = "jsp/products.jsp";
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
        ArrayList<Product> productsList = new ArrayList();
        String imageSource = "";
        int addedItemNumber = 0;        
    %>    
            
    <%
        // get products form database:
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
            productsList = connection.getProductsList();
            
            imageSource = "../images/";
            
        //==================================================================

        // catch response from buttons:
        for (int i = 0; i < productsList.size(); i++) {
            String name = "addItem" + i;
            String currentButton = request.getParameter(name);

            // exact button:
            if(currentButton != null) {
                Cookie[] cookies = request.getCookies();
            
          
                // add cookie indicating that this item has been added to chart:
                String cookieName = "addItem" + addedItemNumber;
                // get id, because cookie cannont contain space mark!
                String selectedProduct = String.valueOf(productsList.get(i).getID());

                Cookie addedItem = new Cookie(cookieName, selectedProduct);

                // Add cookie in the response header.
                response.addCookie(addedItem);

                // icrement value of adedItemNumber (in order to no to have a duplicate cookie):
                addedItemNumber++;

                // show communicate:
                out.println("<br><br>");
                out.println("<h2 class=\"h2_2\" align=\"center\">" + "Product added to chart!" + "</h2>");
                out.println("<br><br>");
            }
        }
    %>
            
            <form method="POST" action="products.jsp">       
            <%
                // wyświetlamy wyświetlamy zawartość listy produktów:
                for (int i = 0; i < productsList.size(); i++) {
                    String buttonName = "addItem" + i;
                    %>
                    <div class="div4"> 
                         <% out.print(productsList.get(i).getName()); %>
                         <br><br>
                         <% String path = imageSource.concat(productsList.get(i).getPicture()); 
                            //out.println(path);
                         %>
                         <img src="<%=path%>" width="500" height="300">

                         <br><br>
                         <% out.print(productsList.get(i).getPrice() + " zł"); %> 

                         <br><br>
                         <input class="addToChartButton" type="submit" id="<%=buttonName%>" name="<%=buttonName%>" value="Add to chart!"/> 
                    </div> 
                    <%
                }
            %>
            </form>
            <%
        }
    %>    
    </body>
</html>
