<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.util.List"%>
<%@ page import="model.Report"%>
<%@ page import="model.ReportDAO"%>
<%@ page import="java.util.Arrays"%>
<%@ page import="java.util.Set"%>
<%@ page import="java.util.HashSet"%>
<%@ page import="javax.naming.InitialContext" %>
<%@ page import="javax.naming.NamingException" %>
<!DOCTYPE html>
<html>
    <%  
    //String searchQuery = request.getParameter("search");
        ReportDAO reportDAO = null;
        try {
            InitialContext context = new InitialContext();
            reportDAO = (ReportDAO) context.lookup("java:global/HarveyHerman/ReportDAO");
        } catch (NamingException ne) {
            ne.printStackTrace();
        }
        List<Report> report = reportDAO.getAllReports();//
%>
<head>
    <title>View History Report</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</head>
<body class="container mt-4">
    <h2 class="text-center text-primary">History Report</h2>
    <table class="table table-striped table-bordered">
            <thead class="table-dark">
	            <tr>
	                <th>Report ID</th>
	                <th>Type Of Report</th>
	                <th>Created Date</th>
	                <th>Total Sales</th>
                        <th>Description</th>
	            </tr>
            </thead>
            <tbody>
            <%  
            	if (report != null && !report.isEmpty()) {
                for (Report re : report) {
            %>
            
                <tr>
                    <td><%= re.getReportId() %></td>
                    <td><%= re.getReportType() %></td>
                    <td><%= re.getReportDate() %></td>
                    <td><%= re.getTotalSales() %></td>
                    <td><%= re.getDescription() %></td>
                </tr>
            <%
                }
            	} else {
            %>
            <tr><td colspan="5" class="text-center text-danger">No promotions available.</td></tr>
            <% } %>
            
        </tbody>
    </table>
    <a href="managerDashboard.jsp" class="btn btn-secondary">Back to Dashboard</a>
</body>
<html>