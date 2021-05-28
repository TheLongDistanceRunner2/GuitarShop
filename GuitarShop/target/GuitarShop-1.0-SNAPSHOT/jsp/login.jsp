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
        <%!
            ArrayList<Login> loginList = new ArrayList();
        %>    
        
        <%
            Cookie _cookie = null;
            Cookie[] _cookies = null;
            boolean flag = false;

            // Get an array of Cookies associated with the this domain
            _cookies = request.getCookies();

            if(_cookies != null) {
                for (int i = 0; i < _cookies.length; i++) {
                    _cookie = _cookies[i];
                  
                    // if logged in:
                    if (_cookie.getName().equals("login")) {
                        // set flag:
                        flag = true;
                        
                        // show buttons:
                        %>
                        <form method="POST" action="products.jsp">
                            <button class="menuButton" onclick="chart()" type="button">
                                Chart</button>
                            &nbsp;
                            <button class="menuButton" onclick="products()" type="button">
                                Products</button>
                            &nbsp;
                            <button class="menuButton" onclick="mainPage()" type="button">
                                Main page</button>
                            &nbsp;
                            <input class="menuButton" name="logOutButton" id="logOutButton" type="submit" value="Log out!"/>
                            &nbsp;
                              
                            <%
                                // and print hello message:
                                out.print("<div align=\"right\" style=\"font: 24px helvetica italic; font-style: italic;\"><font color=\"white\"><br>Hello " + _cookie.getValue()+ "! &nbsp&nbsp&nbsp </font></div>");
                            %>
                        </form>
                        
                        <br><br><br><br><br><br>
                        <%
                            // show message:
                            out.println("<div align=\"center\" style=\"font: 32px helvetica italic; font-style: italic;\"><font color=\"white\">You are already logged in, " + _cookie.getValue() + " ;-)");
                        %>
                        <%
                    }
                }
            } 

            // if not logged in:
            if (flag == false) {
                // show buttons:
                %>
                <button class="menuButton" onclick="products()" type="button">
                    Products</button>
                &nbsp;
                <button class="menuButton" onclick="mainPage()" type="button">
                    Main page</button>
                &nbsp;
                
                <br><br><br>
                <h1 class="h1">Log in into our shop:</h1>
                
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
            }


            // if button log off pressed:
            String logOffButton = request.getParameter("logOutButton");

            if (logOffButton != null) {
                // add cookie in the response header:
                Cookie cookie2 = null;
                Cookie[] cookies2 = null;

                // Get an array of Cookies associated with the this domain
                cookies2 = request.getCookies();

                if(cookies2 != null) {
                    // search for cookie login:
                    for (int i = 0; i < cookies2.length; i++) {
                        // if found cookie:
                        if (cookies2[i].getName().equals("login")) {
                            // delete it:
                            cookie2 = cookies2[i];
                            cookie2.setMaxAge(0);
                            response.addCookie(cookie2);

                            // delete all cookies with added products to chart:
                            for (int j = 0; j < cookies2.length; j++) {
                                Cookie tmpCookie = cookies2[i];
                                
                                // if found such cookie:
                                if (tmpCookie.getName().contains("addItem")) {
                                    // delete it:
                                    tmpCookie.setMaxAge(0);
                                    response.addCookie(tmpCookie);
                                }
                            }

                            // redirect to main page:
                            String redirectURL = "../index.html";
                            response.sendRedirect(redirectURL);
                        }
                    }       
                }
                else {
                    out.print("aaasd");
                }
            }

            // if login button pressed:
            String logInButton = request.getParameter("logInButton");

            if (logInButton != null) {
                // redirect to login page:
                String redirectURL = "login.jsp";
                response.sendRedirect(redirectURL);
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
                window.location = "logIn.jsp";
            }
            
            function contact() {
                window.location = "jsp/contact.jsp";
            }
            
            function administrationPanel() {
                window.location = "jsp/administrationPanel.jsp";
            }
            
        </script>
        
       
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
