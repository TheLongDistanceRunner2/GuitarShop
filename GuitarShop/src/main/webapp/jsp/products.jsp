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
        <h1 class="h1">Our offer:</h1>
    </body>
    
    <%! 
        ArrayList<Product> productsList = new ArrayList();
        String imageSource = "";        
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
            
                    // wyświetlamy wyświetlamy zawartość listy produktów:
            for (int i = 0; i < productsList.size(); i++) {
                %>
                <div class="div4"> 
                     <% out.print(productsList.get(i).getName()); %>
                     <br><br>
                     <% String path = imageSource.concat(productsList.get(i).getPicture()); 
                        //out.println(path);
                     %>
                     <img src="<%= path %>" width="500" height="300">

                     <br><br>
                     <% out.print(productsList.get(i).getPrice() + " zł"); %> 
                     
                </div> 
                <%
            }
        }
    %>    
    
</html>
