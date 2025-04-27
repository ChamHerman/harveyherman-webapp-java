<!-- For Manager -->
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html>
    <%List<Object[]> topSales = (List<Object[]>) request.getAttribute("topSales");%>
    <head>
        <jsp:include page="/user/head.jsp" />
        <title>Top 10 Sales</title>
        <!-- Bootstrap CSS -->
        <link href="<%= request.getContextPath()%>/assets/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">
        <link href="<%= request.getContextPath()%>/assets/css/style.css" rel="stylesheet">
        <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
        <!-- Custom CSS -->
        <link rel="stylesheet" href="<%= request.getContextPath()%>/assets/css/ap_index.css">
        <link rel="stylesheet" href="<%= request.getContextPath()%>/assets/css/ap_layout.css">
    </head>
    <body class="container mt-4">
        <div class="layout-wrapper">
            <!-- Side Bar -->
            <%@ include file="ap_sidebar.jsp" %>
            <div class="main-content">
                <h2 class="text-center text-primary">Top 10 Sales Report</h2>
                <p class="text-center">Select a date range to view the top 10 best-selling products.</p>

                <!-- Date Selection Form -->
                <form method="post" action="<%=request.getContextPath()%>/manager/TopSalesServlet" class="mb-4">
                    <fieldset class="border p-3">
                        <legend>View Sales by Date</legend>

                        <% if (request.getAttribute("errorReportSaleFormDate") != null) {%>
                        <p class="text-danger"><%= request.getAttribute("errorReportSaleFormDate")%></p>
                        <% }%>

                        <div class="mb-3">
                            <label for="startDateInput" class="form-label">Start Date:</label>
                            <input type="date" name="startDate" id="startDateInput" class="form-control"
                                   value="<%= request.getAttribute("selectedStartDate") != null ? request.getAttribute("selectedStartDate") : ""%>">
                        </div>

                        <div class="mb-3">
                            <label for="endDateInput" class="form-label">End Date:</label>
                            <input type="date" name="endDate" id="endDateInput" class="form-control"
                                   value="<%= request.getAttribute("selectedEndDate") != null ? request.getAttribute("selectedEndDate") : ""%>">
                        </div>

                        <button type="submit" class="btn btn-primary">Generate Report</button>
                        <button type="reset" class="btn btn-secondary">Reset</button>
                    </fieldset>
                </form>

                <!-- Sales Report Table -->
                <table class="table table-striped table-bordered">
                    <thead class="table-dark">
                        <tr>
                            <th>No</th>
                            <th>Item ID</th>
                            <th>Item Name</th>
                            <th>Total Quantity Sold</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            //List<Object[]> topSales = (List<Object[]>) request.getAttribute("topSales");
                            if (topSales != null && !topSales.isEmpty()) {
                                for (Object[] row : topSales) {
                        %>
                        <tr>
                            <td><%= row[0]%></td>
                            <td><%= row[1]%></td>
                            <td><%= row[2]%></td>
                            <td><%= row[3]%></td>
                        </tr>
                        <%}
                        } else { %>
                        <tr>
                            <td colspan="4" class="text-center text-danger">No sales data found for the selected dates.</td>
                        </tr>
                        <%
                            }
                        %>
                    </tbody>
                </table>
                <%
                    StringBuilder chartData = new StringBuilder("[");
                    if (topSales != null && !topSales.isEmpty()) {
                        for (int i = 0; i < topSales.size(); i++) {
                            Object[] row = topSales.get(i);
                            chartData.append("{ name: '").append(row[2]).append("', quantity: ").append(row[3]).append(" }");
                            if (i < topSales.size() - 1) {
                                chartData.append(",");
                            }
                        }
                    }
                    chartData.append("]");
                %>
                <%if (topSales != null && !topSales.isEmpty()) {%>
                <div class="mt-5">
                    <h4 class="text-center">Top 10 Items Chart</h4>
                    <div class="d-flex justify-content-center">
                        <canvas id="salesChart" width="800" height="400"></canvas>
                    </div>
                </div>
                <%}%>

                <a href="ap_index.jsp" class="btn btn-secondary">Back to Dashboard</a>


            </div>
        </div>
    </body>
    <!-- JavaScript Import -->
    <script src="<%= request.getContextPath()%>/assets/js/bootstrap.bundle.min.js"></script>
    <script>
        document.querySelector("form").addEventListener("submit", function (event) {
            let startDate = document.getElementById("startDateInput").value;
            let endDate = document.getElementById("endDateInput").value;
            
            // Create Date objects for proper comparison
            let today = new Date();
            today.setHours(0, 0, 0, 0); // Reset time part to ensure date-only comparison
            
            let startDateObj = new Date(startDate);
            startDateObj.setHours(0, 0, 0, 0);
            
            let endDateObj = new Date(endDate);
            endDateObj.setHours(0, 0, 0, 0);

            if (!startDate || !endDate) {
                alert("Please select both start and end dates.");
                event.preventDefault();
                return;
            }

            // Compare dates using getTime() for more reliable comparison
            if (startDateObj.getTime() > today.getTime()) {
                alert("Start date cannot be in the future.");
                event.preventDefault();
                return;
            }

            if (endDateObj.getTime() < startDateObj.getTime()) {
                alert("End date cannot be before the start date.");
                event.preventDefault();
                return;
            }

            if (endDateObj.getTime() > today.getTime()) {
                alert("End date cannot be in the future.");
                event.preventDefault();
                return;
            }
        });

        let topSalesData = <%= chartData.toString()%>;

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
</html>
