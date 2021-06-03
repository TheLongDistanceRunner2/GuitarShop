<%-- 
    Document   : administrationPanel
    Created on : 30 maj 2021, 19:47:24
    Author     : Marcin
--%>

<%@page import="java.sql.Connection"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="com.mycompany.guitarshop.ConnectionToSQLite3"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Administration panel</title>
        
        <link rel="stylesheet" href="../css/style1.css">
    </head>
    <body>
        <button class="menuButton" onclick="mainPage()" type="button">
            Main page</button>
        &nbsp;
        <button class="menuButton" onclick="orders()" type="button">
            Orders</button>
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

            // if not logged in:
            if (flag == false) {
                // show log in button:
                %>
                <form method="POST" action="products.jsp">
                    <input class="menuButton" name="logInButton" id="logInButton" type="submit" value="Log in" onclick="logIn()" />
                    &nbsp;
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
                                Cookie tmpCookie = cookies2[j];
                                
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
            }

            // if login button pressed:
            String logInButton = request.getParameter("logInButton");

            if (logInButton != null) {
                // redirect to login page:
                String redirectURL = "login.jsp";
                response.sendRedirect(redirectURL);
            }

        %>    

        
        <h1 class="h1">Welcome Administrator!</h1>
        


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
        
        <br><br>
        <div class="divAdminHeader" style="margin-left: 700px">
            <input class="addToChartButton" type="button" onclick="orders()" value="See all orders"/>
        </div>
        
        <br><br>
        <div class="divAdminHeader" style="margin-left: 700px">
            <h2 class="h2_5">Here you can add new items to database: </h2>
        </div>
        
        <div class="divAdmin" style="margin-left: 700px">
            <form method="POST" action="administrationPanel.jsp">
                <label>Id:</label>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <input id="id" name="id" type="number" value="1"/>
                <br>
                <label>Name:</label>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input id="name" name="name" type="text"/>
                <br>
                <label>Price:</label>&nbsp;&nbsp;&nbsp;&nbsp;<input id="price" name="price" type="number" value="1200"/> zł
                <br>
                <label>Picture:</label>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input id="picture" name="picture" type="text"/>
                <br>
                <br>
                <input class="addToChartButton" type="submit" id="addToDatabase" name="addToDatabase" value="Add to database!"/> 
            </form>
        </div>    
        
        <%
            String id = request.getParameter("id");
            String name = request.getParameter("name");
            String price = request.getParameter("price");
            String picture = request.getParameter("picture");
            
            // if button add to database pressed:
            if (id != null && name != null && price != null && picture != null) {
                // get products form database:
                ConnectionToSQLite3 connection = new ConnectionToSQLite3();

                if(connection.getConnection() == null) {       
                    out.println("<h2 align=\"center\"><font color=\"red\">Cannot open database!</font></h2>");
                }
                else {
                    //out.println("connected to database");
                    // connect:
                    int numRowsInserted = 0;
                    Connection conn = connection.getConnection();

                    String sql = "insert into Products (ID, Name, Price, Picture) values (?,?,?,?)";
                    
                    PreparedStatement pstmt = conn.prepareStatement(sql);
                    pstmt.setInt(1, Integer.valueOf(id));
                    pstmt.setString(2, name);
                    pstmt.setDouble(3, Double.valueOf(price));
                    pstmt.setString(4, picture);
                    // execute query:
                    pstmt.executeUpdate();
                   
                    %>
                    <div class="divAdminMessage" style="margin-left: 650px">
                        <% out.println("<h2  class=\"h2_4\" align=\"center\"><font color=\"green\">" + "Added successfully!" + "</font></h2>"); %>
                    </div>
                    <%
                }
            }
            else {
                %>
                <div class="divAdminMessage" style="margin-left: 650px">
                    <% out.println("<h2  class=\"h2_4\" align=\"center\"><font color=\"red\">" + "You haven't entered the all values!" + "</font></h2>"); %>
                </div>
                <%
            }


        %>    
        
        
        <br><br>
        <div class="divAdminHeader" style="margin-left: 700px">
            <h2 class="h2_5">Here you can create new account: </h2>
        </div>
        
        <div class="divAdmin" style="margin-left: 700px">
            <form method="POST" action="administrationPanel.jsp">
                <label>Id:</label>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <input id="idUser" name="idUser" type="number" value="1"/>
                <br>
                <label>Login:</label>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input id="loginUser" name="loginUser" type="text"/>
                <br>
                <label>Password:</label>&nbsp;<input id="passwordUser" name="passwordUser" type="password"/>
                <br><br><br>
                <input class="addToChartButton" type="submit" id="createUser" name="createUser" value="Create User!"/>
            </form>
        </div>
        
        <%
            String idNewUser = request.getParameter("idUser");
            String loginNewUser = request.getParameter("loginUser");
            String passwordNewUser = request.getParameter("passwordUser");
            
            // if button add to database pressed:
            if (idNewUser != null && loginNewUser != null && passwordNewUser != null) {
                // get products form database:
                ConnectionToSQLite3 connection = new ConnectionToSQLite3();

                if(connection.getConnection() == null) {       
                    out.println("<h2 align=\"center\"><font color=\"red\">Cannot open database!</font></h2>");
                }
                else {
                    //out.println("connected to database");
                    // connect:
                    int numRowsInserted = 0;
                    Connection conn = connection.getConnection();

                    String sql = "insert into Login (ID, Login, Password) values (?,?,?)";
                    
                    PreparedStatement pstmt = conn.prepareStatement(sql);
                    pstmt.setInt(1, Integer.valueOf(idNewUser));
                    pstmt.setString(2, loginNewUser);
                    pstmt.setString(3, passwordNewUser);
                    // execute query:
                    pstmt.executeUpdate();
                   
                    %>
                    <div class="divAdminMessage" style="margin-left: 650px">
                        <% out.println("<h2  class=\"h2_4\" align=\"center\"><font color=\"green\">" + "Added successfully!" + "</font></h2>"); %>
                    </div>
                    <%
                }
            }
            else {
                %>
                <div class="divAdminMessage" style="margin-left: 650px">
                    <% out.println("<h2  class=\"h2_4\" align=\"center\"><font color=\"red\">" + "You haven't entered the all values!" + "</font></h2>"); %>
                </div>
                <%
            }


        %>   
        
        
    </body>
</html>
