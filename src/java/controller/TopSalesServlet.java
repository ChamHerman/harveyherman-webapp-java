package controller;

import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/topSales")
public class TopSalesServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String startDate = request.getParameter("startDate");
        String endDate = request.getParameter("endDate");
        
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");

            Connection conn = ManagerDashboardUtil.getConnection();
        } catch (ClassNotFoundException e) {
            System.out.println("MySQL JDBC Driver not found. Add MySQL Connector/J to your project.");
            e.printStackTrace();
        } catch (SQLException e) {
            System.out.println("Database connection failed: " + e.getMessage());
            e.printStackTrace();
        }

        
        if (startDate == null || endDate == null || startDate.isEmpty() || endDate.isEmpty()) {
            request.setAttribute("error", "Please enter both start and end dates.");
            request.getRequestDispatcher("salesReport.jsp").forward(request, response);
            return;
        }

        List<Object[]> topSales = new ArrayList<>();

        String sql = "SELECT " +
                     "    RANK() OVER (ORDER BY SUM(od.quantity) DESC) AS No, " +
                     "    i.item_id, " +
                     "    i.name AS item_name, " +
                     "    SUM(od.quantity) AS total_quantity_sold " +
                     "FROM orderdetails od " +
                     "JOIN orders o ON od.order_id = o.order_id " +
                     "JOIN item i ON od.item_id = i.item_id " +
                     "WHERE o.created_date BETWEEN ? AND ? " +
                     "GROUP BY i.item_id, i.name " +
                     "ORDER BY total_quantity_sold DESC " +
                     "LIMIT 10";

        try (Connection conn = ManagerDashboardUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, startDate);
            stmt.setString(2, endDate);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    topSales.add(new Object[]{
                        rs.getInt("No"),
                        rs.getString("item_id"),
                        rs.getString("item_name"),
                        rs.getInt("total_quantity_sold")
                    });
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Database error: " + e.getMessage());
        }

        request.setAttribute("topSales", topSales);
        request.getRequestDispatcher("salesReport.jsp").forward(request, response);
    }
}
