<%-- 
    Document   : managerDashboard
    Created on : Apr 6, 2025, 9:43:38 PM
    Author     : User
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%--<%@ page import="model.ManagerDashboardDAO" %>--%>
<%@ page import="java.util.List" %>
<html>
<head>
    <title>Manager Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="container mt-4">
    <h1 class="text-center text-primary">Manager Dashboard</h1>
    <p class="text-center">Welcome to the Manager Dashboard. Use the options below to manage and view sales reports.</p>
    <%--
    	List<Orders> order = 
    --%>

    <!-- Dashboard Buttons -->
    <div class="row text-center">
        <div class="col-md-4 mb-3">
            <a href="salesReport.jsp" class="btn btn-primary btn-lg w-100">View Top 10 Sales</a>
        </div>
        <div class="col-md-4 mb-3">
            <a href="generatingReport.jsp" class="btn btn-primary btn-lg w-100">Generate Sales Report</a>
        </div>
        <div class="col-md-4 mb-3">
            <a href="viewItem.jsp" class="btn btn-primary btn-lg w-100">View Item Information</a>
        </div>
        <div class="col-md-4 mb-3">
            <a href="viewCustomerInfor.jsp" class="btn btn-primary btn-lg w-100">View Customer Information</a>
        </div>
        <div class="col-md-4 mb-3">
            <a href="viewStaffInfor.jsp" class="btn btn-primary btn-lg w-100">View Staff Information</a>
        </div>
    </div>

    <!-- Quick Stats Section -->
    <div class="row mt-4">
        <div class="col-md-4 text-center">
            <div class="card">
                <div class="card-body">
                    <h5 class="card-title">Total Sales</h5>
                    <p class="card-text text-success fs-4">RM <%= ManagerDashboardDAO.getTotalSales() %></p>
                </div>
            </div>
        </div>
        <div class="col-md-4 text-center">
            <div class="card">
                <div class="card-body">
                    <h5 class="card-title">Products Sold</h5>
                    <p class="card-text text-success fs-4"><%=ManagerDashboardDAO.getProductSold() %></p>
                </div>
            </div>
        </div>
        <div class="col-md-4 text-center">
            <div class="card">
                <div class="card-body">
                    <h5 class="card-title">Active Customers</h5>
                    <p class="card-text text-success fs-4"><%=ManagerDashboardDAO.getActiveUser() %></p>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
