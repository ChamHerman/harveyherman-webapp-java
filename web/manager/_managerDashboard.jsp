<%@page import="java.util.ArrayList"%>
<%@page import="javax.naming.NamingException"%>
<%@page import="javax.naming.InitialContext"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.ManagerDashboardDAO" %>
<%@ page import="java.util.List" %>
<html>
    <%
        ManagerDashboardDAO mdDAO = null;
        try {
            InitialContext context = new InitialContext();
            mdDAO = (ManagerDashboardDAO) context.lookup("java:global/HarveyHerman/ManagerDashboardDAO");
        } catch (NamingException ne) {
            ne.printStackTrace();
        }
        double totalSales = mdDAO.getTotalSales();
        int productSold = mdDAO.getProductSold();
        int activeUsers = mdDAO.getActiveUser();
        double reviewRating = 5;

        int cash = mdDAO.getPaymentMethodCash();
        int debit = mdDAO.getPaymentMethodDebit();
        int credit = mdDAO.getPaymentMethodCredit();
        int eWallet = mdDAO.getPaymentMethodE();
        List<Object[]> topSales = mdDAO.getTopSales();
        List<Object[]> todaySales = mdDAO.getTodaySales();
        List<Object[]> yesterdaySales = mdDAO.getYesterdaySales();
        double todayS = 0.0;
        double yesterdayS = 0.0;
        double equalS = 0.0;
        double avgS1 = 0.0;
        double avgS2 = 0.0;

        if (todaySales != null && !todaySales.isEmpty()) {
            for (Object[] row : todaySales) {
                if (row[4] != null) {
                    todayS += ((Number) row[4]).doubleValue();
                }
            }
        }

        if (yesterdaySales != null && !yesterdaySales.isEmpty()) {
            for (Object[] row : yesterdaySales) {
                if (row[4] != null) {
                    yesterdayS += ((Number) row[4]).doubleValue();
                }
            }
        }
        equalS = todayS - yesterdayS;
        if (todayS == 0.0) {
            todayS = todayS + 1.0;
        }
        if (yesterdayS == 0.0) {
            todayS = todayS + 1.0;
        }

        avgS1 = (todayS / yesterdayS) * 100;
        avgS2 = (yesterdayS / todayS) * 100;

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
    <head>
        <title>Manager Dashboard</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <style>
            canvas {
                max-width: 100%;
                height: auto;
            }

            #paymentMethodChart {
                max-width: 320px;
                max-height: 320px;
            }

            #salesChart {
                max-width: 400px;
                max-height: 300px;
            }
        </style>
    </head>
    <body class="container mt-4">
        <h1 class="text-center text-primary">Manager Dashboard</h1>
        <p class="text-center">Welcome to the Manager Dashboard. Use the options below to manage and view sales reports.</p>

        <div class="row text-center">
            <div class="col-md-3 mb-3">
                <a href="salesReport.jsp" class="btn btn-primary btn-lg w-100">View Top 10 Sales</a>
            </div>
            <div class="col-md-3 mb-3">
                <a href="generatingReport.jsp" class="btn btn-primary btn-lg w-100">Generate Sales Report</a>
            </div>
            <div class="col-md-3 mb-3">
                <a href="viewItem.jsp" class="btn btn-primary btn-lg w-100">View Item Information</a>
            </div>
            <div class="col-md-3 mb-3">
                <a href="viewCustomerInfor.jsp" class="btn btn-primary btn-lg w-100">View Customer Information</a>
            </div>
            <div class="col-md-3 mb-3">
                <a href="viewStaffInfor.jsp" class="btn btn-primary btn-lg w-100">View Staff Information</a>
            </div>
            <div class="col-md-3 mb-3">
                <a href="promotion.jsp" class="btn btn-primary btn-lg w-100">Manage Promotion</a>
            </div>
            <div class="col-md-3 mb-3">
                <a href="viewHistoryReport.jsp" class="btn btn-primary btn-lg w-100">View History Report</a>
            </div>
        </div>

        <!-- Quick Stats Section -->
        <div class="row row-cols-1 row-cols-md-5 g-3 mt-4 text-center">
            <div class="col">
                <div class="card">
                    <div class="card-body">
                        <h5 class="card-title">Total Sales</h5>
                        <p class="card-text text-success fs-4" data-bs-toggle="tooltip" data-bs-placement="bottom"
                           accesskey="" title="The total amount of products sold by the company">
                            RM <%= totalSales%></p>
                    </div>
                </div>
            </div>
            <div class="col">
                <div class="card">
                    <div class="card-body">
                        <h5 class="card-title">Products Sold</h5>
                        <p class="card-text text-success fs-4" data-bs-toggle="tooltip" data-bs-placement="bottom"
                           accesskey="" title="Products purchased since the company was founded">
                            <%= productSold%></p>
                    </div>
                </div>
            </div>
            <div class="col">
                <div class="card">
                    <div class="card-body">
                        <h5 class="card-title">Active Customers</h5>
                        <p class="card-text text-success fs-4" data-bs-toggle="tooltip" data-bs-placement="bottom"
                           accesskey="" title="Customers who purchased our products in the past month">
                            <%= activeUsers%></p>
                    </div>
                </div>
            </div>
            <div class="col">
                <div class="card">
                    <div class="card-body">
                        <h5 class="card-title">Average Review Rating</h5>
                        <p class="card-text text-success fs-4" data-bs-toggle="tooltip" data-bs-placement="bottom"
                           accesskey="" title="Customer reviews of the product">
                            <%= reviewRating%></p>
                    </div>
                </div>
            </div>
            <div class="col">
                <div class="card">
                    <div class="card-body">
                        <h5 class="card-title">Contrast</h5>
                        <%if (equalS < 0) {%>
                        <p class="card-text text-success fs-4" data-bs-toggle="tooltip" data-bs-placement="bottom"
                           accesskey="" title="Compare today's sales with yesterday's">
                            <small>Less than yesterday RM<%= equalS%> 
                                <span style="color: red;"> -<%= String.format("%.2f", avgS2)%>%</span></small>
                        </p>
                        <%} else if (equalS == 0) {%>
                        <p class="card-text text-success fs-4" data-bs-toggle="tooltip" data-bs-placement="bottom"
                           accesskey="" title="Compare today's sales with yesterday's">
                        <div style="color:'black';"><%= 0%>%</div>
                        </p>
                        <%} else if (equalS > 0) {%>
                        <p class="card-text text-success fs-4" data-bs-toggle="tooltip" data-bs-placement="bottom"
                           accesskey="" title="Compare today's sales with yesterday's">
                            <small>More than yesterday RM<%= equalS%>  
                                <span style="color: green;">+<%= String.format("%.2f", avgS1)%>%</span></small>
                        </p>
                        <%}%>
                    </div>
                </div>
            </div>
        </div>
        </br>
        </br>
        </br>

        <div class="row mt-5">
            <%if (cash != 0 || debit != 0 || credit != 0 || eWallet != 0) {%>
            <!-- Pie Chart -->
            <div class="col-md-6 mb-4 d-flex flex-column align-items-center">
                <h5 class="fw-bold mb-2 text-center" style="text-decoration: underline;">Payment Method Distribution</h5>
                <canvas id="paymentMethodChart" style="max-width: 320px; max-height: 320px;"></canvas>
            </div>
            <%}%>

            <%if (topSales != null) {%>
            <!-- Bar Chart -->
            <div class="col-md-6 mb-4 d-flex flex-column align-items-center">
                <h5 class="fw-bold mb-2 text-center" style="text-decoration: underline;">Top 10 Products Chart</h5>
                <canvas id="salesChart" style="max-width: 400px; max-height: 300px;"></canvas>
            </div>
            <%}%>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
        <script>
        var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
        var tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
            return new bootstrap.Tooltip(tooltipTriggerEl);
        });

        //display pie chart
        var cash = <%= cash%>; // Replace with dynamic data (e.g., the count of "cash" payments)
        var debitCard = <%= debit%>; // Replace with dynamic data (e.g., the count of "debit_card" payments)
        var creditCard = <%= credit%>; // Replace with dynamic data (e.g., the count of "credit_card" payments)
        var eWallet = <%= eWallet%>; // Replace with dynamic data (e.g., the count of "e_wallet" payments)

        // Total of all payment method counts
        var total = cash + debitCard + creditCard + eWallet;

        var ctx = document.getElementById('paymentMethodChart').getContext('2d');

        var chart = new Chart(ctx, {
            type: 'pie', // Pie chart type
            data: {
                labels: ['Cash', 'Debit Card', 'Credit Card', 'E-wallet'], // Labels for the chart
                datasets: [{
                        label: 'Payment Method Distribution',
                        data: [cash, debitCard, creditCard, eWallet], // Use dynamic data here
                        backgroundColor: ['#007bff', '#28a745', '#ffc107', '#dc3545'], // Slice colors
                    }]
            },
            options: {
                responsive: true,
                plugins: {
                    tooltip: {
                        callbacks: {
                            // Tooltip to display percentage
                            label: function (tooltipItem) {
                                // Calculate percentage for the tooltip
                                var percentage = Math.round((tooltipItem.raw / total) * 100);
                                return tooltipItem.label + ': ' + tooltipItem.raw + ' (' + percentage + '%)';
                            }
                        }
                    },
                    legend: {
                        position: 'bottom', // Position labels below the pie chart
                        labels: {
                            usePointStyle: true, // Makes the labels display as small colored dots
                            pointStyle: 'circle',
                            font: {
                                size: 14, // Adjust label font size
                            }
                        }
                    }
                }
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
    </body>
</html>
