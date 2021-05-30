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
        <button class="menuButton" onclick="mainPage()" type="button">
            Main page</button>
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
                            <%
                            // if the admin is logged in:
                            if (_cookie.getValue().equals("admin")) {
                                // show button of administration panel:
                                %>
                                <button class="menuButton" onclick="administrationPanel()" type="button">
                                    Administration panel</button>
                                &nbsp;
                                <%
                            }
                            %>
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
            else {
                out.println("asddasd");
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
                window.location = "administrationPanel.jsp";
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
            boolean flag2 = false;
            
            // catch response from buttons:
            for (int i = 0; i < productsList.size(); i++) {
                String name = "addItem" + i;
                String currentButton = request.getParameter(name);
                
                // exact button:
                if(currentButton != null) {
                    Cookie cookie4 = null;
                    Cookie[] cookies4 = request.getCookies();;
                
                    // if the user is logged in:
                    for (int j = 0; j < cookies4.length; j++) {
                        cookie4 = cookies4[j];

                        // if found such cookie:
                        if (cookie4.getName().equals("login")) {
                            flag2 = true;
                        
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
                    
                    if (flag2 == false) {
                        // show communicate:
                        out.println("<br><br>");
                        out.println("<h2 class=\"h2_4\" align=\"center\">" + "You have to be logged to add product!" + "</h2>");
                        out.println("<br><br>");
                    }  
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
