<%@ page import="java.util.List" %>
<%@ page import="com.harveyherman.model.UserData" %>
<%@ page import="com.harveyherman.dao.CustomerDAO" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>View Items</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</head>
<body class="container mt-4">
    <h2 class="text-center text-primary">View Customers</h2>
    <p class="text-center">Below is a list of all Customer they register account.</p>

    <%
        CustomerDAO CustomerDAO = new CustomerDAO();
        List<UserData> cus = CustomerDAO.getAllCustomer();
        
        if (cus == null || cus.isEmpty()) {
    %>
   		 <p class="error">Don't have any Customer.</p>
    <%
        } else {
    %>
    <table class="table table-striped table-bordered">
        <thead class="table-dark">
            <tr>
                <th>User ID</th>
                <th>Name</th>
                <th>Email</th>
                <th>Contact Number</th>
                <th>Address</th>
                <th>Birth Date</th>
                <th>Created Date</th>
            </tr>
        </thead>
        <tbody>
            <%
            	if (cus != null && !cus.isEmpty()) {
                for (UserData us : cus) {
            %>
            <tr>
                <td><%= us.getUserId() %></td>
                <td><%= us.getFullName()%></td>
                <td><%= us.getEmail() %></td>
                <td><%= us.getContactNumber() %></td>
                <td><%= us.getAddress() %></td>
                <td><%= us.getBirthDate() %></td>
                <td><%= us.getCreatedDate() %></td>
            </tr>
            <%
                    }
                } else {
            %>
            <tr>
                <td colspan="8" class="text-center text-danger">Don't have any Customer.</td>
            </tr>
            <%
        }
    %>
        </tbody>
    </table>
    <%
        }
    %>

    <!-- Back to Dashboard Button -->
    <a href="managerDashboard.jsp" class="btn btn-secondary">Back to Dashboard</a>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
