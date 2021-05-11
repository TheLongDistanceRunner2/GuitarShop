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
    %>    
            
    <%
        // pobieramy produkty z bazy:
        
        ConnectionToSQLite3 connection = new ConnectionToSybase();
        
        if(connection.getConnection() == null) {       
            out.println("<h2 align=\"center\"><font color=\"red\">NIE UDAŁO SIĘ POŁĄCZYĆ Z BAZĄ DANYCH!</font></h2>");
        }
        else {
            out.println("POŁĄCZONO Z BAZĄ DANYCH");
            // ustanawiamy połączenie:
            connection.getConnection();

            String query = "select * from Products";

            // wykonujemy zapytanie:
            connection.selectFromDatabase(query);

            // odbieramy wynik:
            productsList = connection.getProductsList();
        }
    %>    
</html>
