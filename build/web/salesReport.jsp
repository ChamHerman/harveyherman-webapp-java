<%-- 
    Document   : salesReport
    Created on : Apr 6, 2025, 9:44:40 PM
    Author     : User
--%>

<%@ page import="java.util.List" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Top 10 Sales Report</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>
<body class="container mt-4">
    <h2 class="text-center text-primary">Top 10 Sales Report</h2>
    <p class="text-center">Select a date range to view the top 10 best-selling products.</p>

    <!-- Date Selection Form -->
    <form method="post" action="topSales" class="mb-4">
        <fieldset class="border p-3">
            <legend>View Sales by Date</legend>

            <% if (request.getAttribute("errorReportSaleFormDate") != null) { %>
                <p class="text-danger"><%= request.getAttribute("errorReportSaleFormDate") %></p>
            <% } %>

            <div class="mb-3">
                <label for="startDateInput" class="form-label">Start Date:</label>
                <input type="date" name="startDate" id="startDateInput" class="form-control"
                       value="<%= request.getAttribute("selectedStartDate") != null ? request.getAttribute("selectedStartDate") : "" %>">
            </div>

            <div class="mb-3">
                <label for="endDateInput" class="form-label">End Date:</label>
                <input type="date" name="endDate" id="endDateInput" class="form-control"
                       value="<%= request.getAttribute("selectedEndDate") != null ? request.getAttribute("selectedEndDate") : "" %>">
            </div>

            <button type="submit" class="btn btn-primary">Generate Report</button>
            <button type="reset" class="btn btn-secondary">Reset</button>
        </fieldset>
    </form>

    <!-- Report Table -->
    <table class="table table-striped table-bordered">
    <thead class="table-dark">
        <tr>
            <th>No</th>
            <th>Item ID</th>
            <th>Product Name</th>
            <th>Total Quantity Sold</th>
        </tr>
    </thead>
    <tbody>
        <%
            List<Object[]> topSales = (List<Object[]>) request.getAttribute("topSales");
            if (topSales != null && !topSales.isEmpty()) {
                for (Object[] row : topSales) {
        %>
            <tr>
                <td><%= row[0] %></td>
                <td><%= row[1] %></td>
                <td><%= row[2] %></td>
                <td><%= row[3] %></td>
            </tr>
        <%} } else { %>
            <tr>
                <td colspan="4" class="text-center text-danger">No sales data found for the selected dates.</td>
            </tr>
        <%
            }
        %>
    </tbody>
</table>
	<% if(topSales !=null && !topSales.isEmpty()){%>
        	<div class="mt-4">
		        <h4 class="text-center text-secondary">Sales Performance Chart</h4>
		        <canvas id="salesChart"></canvas>
		    </div>
     <% }%>

    <a href="managerDashboard.jsp" class="btn btn-secondary">Back to Dashboard</a>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
    document.querySelector("form").addEventListener("submit", function (event) {
        let startDate = document.getElementById("startDateInput").value;
        let endDate = document.getElementById("endDateInput").value;
        let today = new Date().toISOString().split("T")[0]; // Get today's date in YYYY-MM-DD format

        if (!startDate || !endDate) {
            alert("Please select both start and end dates.");
            event.preventDefault();
            return;
        }
        
        if (startDate > today) {
            alert("Start date cannot be in the future.");
            event.preventDefault();
        }

        if (endDate < startDate) {
            alert("End date cannot be before the start date.");
            event.preventDefault();
            return;
        }

        if (endDate > today) {
            alert("End date cannot be in the future.");
            event.preventDefault();
        }
    });
    
    let topSalesData = <%= (topSales != null) ? "[" + topSales.stream()
            .map(row -> "{ name: '" + row[2] + "', quantity: " + row[3] + " }")
            .reduce((a, b) -> a + "," + b).orElse("") + "]" : "[]" %>;

        if (topSalesData.length > 0) {
            let labels = topSalesData.map(item => item.name);
            let data = topSalesData.map(item => item.quantity);

            let ctx = document.getElementById("salesChart").getContext("2d");
            new Chart(ctx, {
                type: 'bar',
                data: {
                    labels: labels,
                    datasets: [{
                        label: "Total Quantity Sold",
                        data: data,
                        backgroundColor: "rgba(54, 162, 235, 0.6)",
                        borderColor: "rgba(54, 162, 235, 1)",
                        borderWidth: 1
                    }]
                },
                options: {
                    responsive: true,
                    scales: {
                        y: {
                            beginAtZero: true
                        }
                    }
                }
            });
        }
</script>
</body>
</html>
