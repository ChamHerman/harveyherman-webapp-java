<%-- 
    Document   : saveReport
    Created on : Apr 6, 2025, 9:45:08 PM
    Author     : User
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>

<%
    String reportID = request.getParameter("reportID");
    String reportDate = request.getParameter("reportDate");
    String reportType = request.getParameter("reportType");  // Correctly get the selected report type
    String totalSales = request.getParameter("totalSales");
    String description = request.getParameter("description");
    
    if(reportType.equals("day")){
    	reportType="Daily Sales";
    }
    if(reportType.equals("month")){
    	reportType="Monthly Sales";
    }
    if(reportType.equals("year")){
    	reportType="Yearly Sales";
    }

    try (Connection conn = ManagerDashboardUtil.getConnection()) {
        String query = "INSERT INTO report (report_id, report_date, report_type, total_sales, description) VALUES (?, ?, ?, ?, ?)";
        PreparedStatement stmt = conn.prepareStatement(query);
        
        stmt.setString(1, reportID);
        stmt.setString(2, reportDate);
        stmt.setString(3, reportType);  // Ensure correct report type is inserted
        stmt.setDouble(4, Double.parseDouble(totalSales));
        stmt.setString(5, description);

        int rowsInserted = stmt.executeUpdate();
        if (rowsInserted > 0) {
            out.println("Report saved successfully!");
        } else {
            out.println("Error: Report was not saved.");
        }
    } catch (SQLException e) {
        out.println("Error: " + e.getMessage());
    }
%>

