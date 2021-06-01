<%-- 
    Document   : orders
    Created on : 1 cze 2021, 19:17:08
    Author     : Marcin
--%>

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
        
        
        
    </body>
</html>
