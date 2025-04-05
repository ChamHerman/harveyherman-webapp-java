<%@ page import="java.util.List" %>
<%@ page import="com.harveyherman.model.Item" %>
<%@ page import="com.harveyherman.dao.ItemDAO" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>View Items</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</head>
<body class="container mt-4">
    <h2 class="text-center text-primary">View Items</h2>
    <p class="text-center">Below is a list of all items in the inventory.</p>

    <%
        ItemDAO ItemDAO = new ItemDAO();
        List<Item> item = ItemDAO.getAllItem();
        
        if (item == null || item.isEmpty()) {
    %>
   		 <p class="error">No items available.</p>
    <%
        } else {
    %>
    <table class="table table-striped table-bordered">
        <thead class="table-dark">
            <tr>
                <th>Item ID</th>
                <th>Name</th>
                <th>Description</th>
                <th>Price</th>
                <th>Stock Quantity</th>
                <th>Category</th>
                <th>Item Image</th>
                <th>Created Date</th>
                <th>Updated Date</th>
            </tr>
        </thead>
        <tbody>
            <%
            	if (item != null && !item.isEmpty()) {
                for (Item it : item) {
            %>
            <tr>
                <td><%= it.getItemId() %></td>
                <td><%= it.getName() %></td>
                <td><%= it.getDescription() %></td>
                <td><%= String.format("%.2f", it.getPrice()) %></td>
                <td><%= it.getStockQuantity() %></td>
                <td><%= it.getCategory() %></td>
                <td><% if (it.getImageUrl() != null && !it.getImageUrl().isEmpty()) { %>
                            <img src="<%= it.getImageUrl() %>" alt="Image" width="50">
                        <% } else { %>
                            N/A
                        <% } %>
                </td>
                <td><%= it.getCreatedDate() %></td>
                <td><%= it.getUpdatedDate() %></td>
            </tr>
            <%
                    }
                } else {
            %>
            <tr>
                <td colspan="8" class="text-center text-danger">No items available.</td>
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
