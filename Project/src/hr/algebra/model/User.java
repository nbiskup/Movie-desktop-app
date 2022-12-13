/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package hr.algebra.model;

/**
 *
 * @author Nikola
 */
public class User {
    
     private int id;
    private String username;
    private String password;
    private int userType;

    public User(int id, String username, String password) {
        this(username, password);
        this.id = id;

    }

    public User(String username, String password) {
        this.username = username;
        this.password = password;
    }

    public User(int id, String username, String password, int userType) {
        this.id = id;
        this.username = username;
        this.password = password;
        this.userType = userType;
    }

    public int getUserType() {
        return userType;
    }

    public void setUserType(int userType) {
        this.userType = userType;
    }

    
    
    public void setId(int id) {
        this.id = id;
    }

    
    public int getId() {
        return id;
    }

    
    public String getUsername() {
        return username;
    }

    public String getPassword() {
        return password;
    }
    
}
