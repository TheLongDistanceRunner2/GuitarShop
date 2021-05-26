package com.mycompany.guitarshop;


import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;

/**
 *
 * @author Marcin
 */
public class ConnectionToSQLite3 {
    private String fileDestination;
    private Connection connection;
    // wynik zapytania:
    private ArrayList<Product> productsList;
    private ArrayList<Login> loginList;

    public ConnectionToSQLite3() {
        this.fileDestination = null;
        this.connection = null;
        this.productsList = new ArrayList<>();
        this.loginList = new ArrayList<>();
    }
    
    public String getFileDestination() {
        return fileDestination;
    }

    public ArrayList<Product> getProductsList() {
        return productsList;
    }

    public void setFileDestination(String fileDestination) {
        this.fileDestination = fileDestination;
    }

    public void setConnection(Connection connection) {
        this.connection = connection;
    }

    public void setProductsList(ArrayList<Product> productsList) {
        this.productsList = productsList;
    }

    public ArrayList<Login> getLoginList() {
        return loginList;
    }

    public void setLoginList(ArrayList<Login> loginList) {
        this.loginList = loginList;
    }
    
    public Connection getConnection() {
        try {  
            Class.forName("org.sqlite.JDBC");                                                                                                                                   //.db            
            connection = DriverManager.getConnection("jdbc:sqlite:G:\\INFORMATYKA\\MAGISTERSKIE\\SEMESTR_2\\PROGRAMOWANIE\\ZALICZENIE\\GuitarShop\\database\\databaseGuitarShop.sqlite3");

            if (connection != null) {
                System.out.println("Connected");
            }
            else {
                System.out.println("Connection failed");
            }
        }
        catch(Exception e) {
            System.out.println("==========================================");
            e.printStackTrace();
            System.out.println("==========================================");
        }
        
        return connection;
    }
    
    public void selectFromDatabase(String sql) throws SQLException {
        //step3 create the statement object  
        Statement stmt = connection.createStatement();  

        //step4 execute query  
        ResultSet result = stmt.executeQuery(sql);  
        // odbieramy dane i wpisujemy do listy wynikowej:
        while (result.next()) {
            this.productsList.add(new Product(Integer.valueOf(result.getString(1)), 
                                        result.getString(2), 
                                        Double.valueOf(result.getString(3)),
                                        result.getString(4)));
        }
        
        // zamykamy zapytanie i połączenie !!!
        result.close();
        stmt.close();
        this.connection.close();
    }

    public void selectLoginFromDatabase(String sql) throws SQLException {
        //step3 create the statement object  
        Statement stmt = connection.createStatement();  

        //step4 execute query  
        ResultSet result = stmt.executeQuery(sql);  
        // odbieramy dane i wpisujemy do listy wynikowej:
        while (result.next()) {
            this.loginList.add(new Login(Integer.valueOf(result.getString(1)), 
                                        result.getString(2), 
                                        result.getString(3)));
        }
        
        // zamykamy zapytanie i połączenie !!!
        result.close();
        stmt.close();
        this.connection.close();
    }
    
}
