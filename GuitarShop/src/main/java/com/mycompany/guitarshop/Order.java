/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.mycompany.guitarshop;

/**
 *
 * @author Marcin
 */
public class Order {
    private int ID;
    private int OrderID;
    private String ClientName;
    private int ItemID;

    public Order(int ID, int OrderID, String ClientName, int ItemID) {
        this.ID = ID;
        this.OrderID = OrderID;
        this.ClientName = ClientName;
        this.ItemID = ItemID;
    }

    public int getID() {
        return ID;
    }

    public void setID(int ID) {
        this.ID = ID;
    }

    public int getOrderID() {
        return OrderID;
    }

    public void setOrderID(int OrderID) {
        this.OrderID = OrderID;
    }

    public int getItemID() {
        return ItemID;
    }

    public void setItemID(int ItemID) {
        this.ItemID = ItemID;
    }

    public String getClientName() {
        return ClientName;
    }

    public void setClientName(String ClientName) {
        this.ClientName = ClientName;
    }
    
}
