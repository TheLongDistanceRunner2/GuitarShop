<%-- 
    Document   : login
    Created on : 24 maj 2021, 22:48:41
    Author     : Marcin
--%>

<%@page import="java.util.ArrayList"%>
<%@page import="com.mycompany.guitarshop.Login"%>
<%@page import="com.mycompany.guitarshop.ConnectionToSQLite3"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Login</title>
        
        <link rel="stylesheet" href="../css/style1.css">
    </head>
    <body>
        <button class="menuButton" onclick="products()" type="button">
            Products</button>
        &nbsp;
        <button class="menuButton" onclick="mainPage()" type="button">
            Main page</button>
        &nbsp;

        <h1 class="h1">Log in into our shop:</h1>
        
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
                window.location = "logIn.jsp";
            }
            
            function contact() {
                window.location = "jsp/contact.jsp";
            }
            
            function administrationPanel() {
                window.location = "jsp/administrationPanel.jsp";
            }
            
        </script>
        
        <%!
            ArrayList<Login> loginList = new ArrayList();
        %>    
        
        
        
        
        
        <br><br><br>
        <form id="login" method="post">
            <div align="center">
                <div class="div1"> Login:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type="text" id="login" name="login"/> </div> 
                <br/>
                <div class="div1"> Password:&nbsp;<input type="password" id="password" name="password"/> </div>  
                <br/>
                <br/>
                <button class="addToChartButton" name="enter" type="submit">Log in!</button>
            </div> 
        </form>   
        
        
        
        
        <%
            String login = ""; 
            login = request.getParameter("login");
            String password = "";
            password = request.getParameter("password");
            
            // when entered values:
            if (login != null && password != null) {
                // get products form database:
                ConnectionToSQLite3 connection = new ConnectionToSQLite3();

                if(connection.getConnection() == null) {       
                    out.println("<h2 align=\"center\"><font color=\"red\">Cannot open database!</font></h2>");
                }
                else {
                    // connect:
                    connection.getConnection();

                    String query = "select * from Login";
                    // execute query:
                    connection.selectLoginFromDatabase(query);
                    // catch result:
                    loginList = connection.getLoginList();

                    for (int i = 0; i < loginList.size(); i++) {
                        // if login and password are correct:
                        if(loginList.get(i).getLogin().equals(login) && loginList.get(i).getPassword().equals(password)) {
                            // add cookie in the response header:
                            Cookie logIn = new Cookie("login", login);
                            response.addCookie(logIn);

                            // redirect to Products page:
                            String redirectURL = "products.jsp";
                            response.sendRedirect(redirectURL);
                        }

                        // if not found such login and password:
                        if(i == loginList.size() - 1) {
                            out.println("<h2 align=\"center\"><font color=\"red\">Wrong login or password! Try again!</font></h2>");
                        }
                    }
                }            
            }
        %>
        
        
        
    </body>
</html>
