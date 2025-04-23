<!-- For Manager -->
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
        <!-- Bootstrap CSS -->
        <link href="<%= request.getContextPath()%>/assets/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">
        <link href="<%= request.getContextPath()%>/assets/css/style.css" rel="stylesheet">
        <!-- Custom CSS -->
        <link rel="stylesheet" href="<%= request.getContextPath()%>/assets/css/ap_index.css">
        <link rel="stylesheet" href="<%= request.getContextPath()%>/assets/css/ap_layout.css">
    </head>
    <body class="container mt-4">
        <div class="layout-wrapper">
            <!-- Side Bar -->
            <%@ include file="ap_sidebar.jsp" %>
            <div class="main-content">
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
                        <%                    if (report != null && !report.isEmpty()) {
                                for (Report re : report) {
                        %>

                        <tr>
                            <td><%= re.getReportId()%></td>
                            <td><%= re.getReportType()%></td>
                            <td><%= re.getReportDate()%></td>
                            <td><%= re.getTotalSales()%></td>
                            <td><%= re.getDescription()%></td>
                        </tr>
                        <%
                            }
                        } else {
                        %>
                        <tr><td colspan="5" class="text-center text-danger">No Reports available.</td></tr>
                        <% }%>

                    </tbody>
                </table>
                <a href="ap_index.jsp" class="btn btn-secondary">Back to Dashboard</a>
            </div>
        </div>
    </body>
    <!-- JavaScript Import -->
    <script src="<%= request.getContextPath()%>/assets/js/bootstrap.bundle.min.js"></script>

</html>