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
        <h1 class="h1">Your chart:</h1>
        
        <%!
            String imageSource = "../images/"; 
        %>    
        
        <%
            double sumCost = 0;
            
            // print cookies with selected items to buy:
            Cookie[] cookies = request.getCookies();
            ArrayList<String> selectedItems = new ArrayList<>();
            ArrayList<Product> fromDatabase = new ArrayList();
            
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
                    
                    // print all items in added to chart:
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
                                <div class="divChart">
                                    <% out.print(currentProduct.getName()); %>
                                    <br><br>
                                    <% String path = imageSource.concat(currentProduct.getPicture()); 
                                       //out.println(path);
                                    %>
                                    <img src="<%=path%>" width="200" height="100">
                                    &nbsp;
                                    <% out.print(currentProduct.getPrice() + " zł"); %> 
                                </div>
                                <%  
                                
                                // add cost to sum of costs:
                                sumCost += currentProduct.getPrice();
                            }
                        }
                    }
                }
            }

            %>
            <div class="divCostSum">
                <% out.println("<h2 class=\"h2_2\" align=\"center\"><font color=\"black\">" + "Sum of all items\n: " 
                        + sumCost + " zł" + "</font></h2>"); %>
            </div> 
  

    </body>
</html>
