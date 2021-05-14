<%-- 
    Document   : chart
    Created on : 14 maj 2021, 20:55:41
    Author     : Marcin
--%>

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
        <h1 class="h1">Your chart:</h1>
        
        <%
            // print cookies with selected items to buy:
            Cookie[] cookies = request.getCookies();
            ArrayList<String> selectedItems = new ArrayList<>();
            
            // if cookies is not empty:
            if (cookies != null) {
                for (int i = 0; i < cookies.length; i++) {
                    // if the cookie starts with "addItem" prefix:
                    if(cookies[i].getName().startsWith("addItem")) {
                        // add it to ArrayList of selected items to show later:
                        selectedItems.add(cookies[i].getValue());
                        out.println("<h2 class=\"h2_2\" align=\"center\">" + cookies[i].getValue() + "</h2>");
                    }
                }
            }


        %>    
        
        
        
    </body>
</html>
