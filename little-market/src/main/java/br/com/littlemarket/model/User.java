package br.com.littlemarket.model;

public class User {

    private int id;
    private String name;
    private String email;
    private String password; 
    private int permissionLevel; // 0 = user, 1 = admin

    public User(String name, String email, String password) {
        this(name, email, password, 0);
    }

    public User(String name, String email, String password, int permissionLevel) {
        this.name = name;
        this.email = email;
        this.password = password;
        this.permissionLevel = permissionLevel;
    }

    // Getters
    public int getId() {
        return id;
    }

    public String getName() {
        return name;
    }

    public String getEmail() {
        return email;
    }

    public String getPassword() {
        return password;
    }

    public int getPermissionLevel() {
        return permissionLevel;
    }

    // Setters
    public void setId(int id) {
        this.id = id;
    }

    public void setName(String name) {
        this.name = name;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public void setPermissionLevel(int permissionLevel) {
        this.permissionLevel = permissionLevel;
    }

}
