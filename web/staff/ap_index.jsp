<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="javax.naming.NamingException"%>
<%@ page import="javax.naming.InitialContext"%>
<%@ page import="model.ManagerDashboardDAO" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
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
        <jsp:include page="/user/head.jsp" />
        <title>Staff Dashboard - HarveyHerman</title>
        <!-- Bootstrap CSS -->
        <link href="<%=request.getContextPath()%>/assets/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">
        <link href="<%=request.getContextPath()%>/assets/css/style.css" rel="stylesheet">

        <!-- Custom CSS -->
        <link rel="stylesheet" href="<%=request.getContextPath()%>/assets/css/ap_index.css">
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
        <!-- Side Bar -->
        <%@ include file="ap_sidebar.jsp" %>
        <div class="main-content">
            <div class="dashboard-title">Staff Dashboard</div>
            <div class="dashboard-desc">Welcome to the Staff Dashboard. Use the options below to manage and view sales reports.</div>

            <div class="dashboard-summary">
                <div class="summary-box">
                    <div class="summary-label">Total Sales</div>
                    <div class="summary-value" data-bs-toggle="tooltip" data-bs-placement="bottom"
                        accesskey="" title="The total amount of products sold by the company">
                        RM <%= totalSales%>
                    </div>
                </div>
                <div class="summary-box">
                    <div class="summary-label">Products Sold</div>
                    <div class="summary-value" data-bs-toggle="tooltip" data-bs-placement="bottom"
                        accesskey="" title="Products purchased since the company was founded">
                        <%= productSold%>
                    </div>
                </div>
                <div class="summary-box">
                    <div class="summary-label">Active Customers</div>
                    <div class="summary-value" data-bs-toggle="tooltip" data-bs-placement="bottom"
                           accesskey="" title="Customers who purchased our products in the past month">
                        <%= activeUsers%>
                    </div>
                </div>
            </div>

            <div class="dashboard-section">
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
                        <h5 class="fw-bold mb-2 text-center" style="text-decoration: underline;" data-bs-toggle="tooltip" data-bs-placement="top"
                           accesskey="" title="Top 10 best-selling products in the past month">
                            Top 10 Products Chart
                        </h5>
                        <canvas id="salesChart" style="max-width: 400px; max-height: 300px;"></canvas>
                    </div>
                    <%}%>
                </div>
            </div>
        </div>
    </body>

    <!-- Scripts -->
    <script src="<%=request.getContextPath()%>/assets/js/bootstrap.bundle.min.js"></script>
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
</html>
