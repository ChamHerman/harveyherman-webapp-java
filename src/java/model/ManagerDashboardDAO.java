package model;

import model.Orders;
import controller.ManagerDashboardUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class ManagerDashboardDAO {
	private static final String SELECT_TOTAL_SALES = "SELECT SUM(total_amount) AS total_sales FROM Orders";
	private static final String SELECT_TOTAL_PRODUCT_SOLD="SELECT SUM(quantity) AS product_sold FROM Orderdetails";
	private static final String SELECT_ACTIVE_USER="SELECT COUNT(DISTINCT o.user_id) AS active_users\r\n"
												+ "FROM Orders o\r\n"
												+ "WHERE o.created_date >= DATE_SUB(CURDATE(), INTERVAL 14 DAY)";
	
    public static double getTotalSales() {
        List<Orders> order = new ArrayList<>();
        
        try (Connection conn = ManagerDashboardUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(SELECT_TOTAL_SALES);
             ResultSet rs = ps.executeQuery()) {
        	
            if (rs.next()) {
                return rs.getDouble("total_sales");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0.0;
    }

    public static int getProductSold() {
        try (Connection conn = ManagerDashboardUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(SELECT_TOTAL_PRODUCT_SOLD);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt("product_sold");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public static int getActiveUser() {
        try (Connection conn = ManagerDashboardUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(SELECT_ACTIVE_USER);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt("active_users");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }
    
}
