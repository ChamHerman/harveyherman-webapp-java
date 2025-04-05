package controller;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class ManagerDashboardUtil {
    private static final String URL = "jdbc:mysql://localhost:3306/harveyhermandb?serverTimezone=UTC";
    private static final String USER = "root";
    private static final String PASSWORD = "root";

    public static Connection getConnection() throws SQLException {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new RuntimeException("MySQL JDBC Driver not found", e);
        }
        return DriverManager.getConnection( URL, USER, PASSWORD);
    }
}
