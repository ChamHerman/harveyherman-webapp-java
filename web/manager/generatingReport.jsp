<!-- For Manager -->
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="javax.naming.NamingException"%>
<%@ page import="javax.naming.InitialContext"%>
<%@ page import="java.util.List"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="model.Report" %>
<%@ page import="model.ReportDAO" %>
<!DOCTYPE html>
<html>
    <%
        ReportDAO reportDAO = null;
        try {
            InitialContext context = new InitialContext();
            reportDAO = (ReportDAO) context.lookup("java:global/HarveyHerman/ReportDAO");
        } catch (NamingException ne) {
            ne.printStackTrace();
        }
        String nextID = reportDAO.getNextReportId();
        List<Object[]> reportSales = (List<Object[]>) request.getAttribute("reportSales");
        String reportTypeR = (String) request.getAttribute("reportType");
        Object promoObj = request.getAttribute("promoAmount");
        double promoAmount = (promoObj != null) ? (double) promoObj : 0.0;
        //double promoAmount=0.0;
        String selectedEndDate = (request.getAttribute("selectedEndDateR") != null)
                ? request.getAttribute("selectedEndDateR").toString()
                : "";
        String selectedStartDate = (request.getAttribute("selectedStartDateR") != null)
                ? request.getAttribute("selectedStartDateR").toString()
                : "";
        double totalSalesAmount = 0.0;
        double promoBetweenTotal = 0.0;
        double totalRevenue =0.0;
        String contextPath = request.getContextPath();
    %>
    <head>
        <jsp:include page="/user/head.jsp" />
        <title>Generate Sales Report - Manager</title>
        <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
        <!-- Bootstrap CSS -->
        <link href="<%= request.getContextPath()%>/assets/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">
        <link href="<%= request.getContextPath()%>/assets/css/style.css" rel="stylesheet">
        <!-- Custom CSS -->
        <link rel="stylesheet" href="<%= request.getContextPath()%>/assets/css/ap_index.css">
        <link rel="stylesheet" href="<%= request.getContextPath()%>/assets/css/ap_layout.css">

        <style>
            @media print {
                body * {
                    visibility: hidden;
                }
                #printSection, #printSection * {
                    visibility: visible;
                }
                #printSection {
                    position: absolute;
                    left: 0;
                    top: 0;
                    width: 100%;
                }

                .chart-container {
                    page-break-before: always; 
                }
                table {
                    width: 100%;
                    border-collapse: collapse;
                }
                .print_table{
                    margin-top:100px;
                }
                .print_chart {
                    page-break-before: always ;
                    margin-top: 0 ;
                    margin-left: -135px;
                    width: 100% ;
                    height: 400px ;
                    background: white;
                }
            }
        </style>
    </head>

    <body class="container mt-4">
        <div class="layout-wrapper">
            <!-- Side Bar -->
            <%@ include file="ap_sidebar.jsp" %>
            <div class="main-content">
                <h2 class="text-center text-primary">Generate Sales Report</h2>
                <p class="text-center">Select a report type and an end date to generate the report. The start date will be auto-calculated.</p>
                <%            String successMessage = (String) request.getAttribute("successMessage");
                    String errorMessage = (String) request.getAttribute("errorMessage");
                %>

                <% if (successMessage != null) {%>
                <div class="alert alert-success"><%= successMessage%></div>
                <% } %>

                <% if (errorMessage != null) {%>
                <div class="alert alert-danger"><%= errorMessage%></div>
                <% }%>
                <!-- print pdf -->
                <div id="printSection" class="d-none text-center">
                    <img src="<%=request.getContextPath()%>/assets/images/favicon.png" alt="Company Logo" style="height: 100px; width: auto; margin-right: 20px; padding-bottom: 20px;">
                    <h2 style="display: inline-block; vertical-align: middle;"><%=companyName%></h2>
                    <hr>
                </div>

                <!-- Form -->
                <form method="post" action="<%=request.getContextPath()%>/manager/GeneratingReportServlet" class="mb-4">
                    <fieldset class="border p-3">
                        <legend>Select Report Type</legend>
                        <div class="mb-3">
                            <label for="reportType" class="form-label">Report Type:</label>
                            <select name="reportType" id="reportType" class="form-select">
                                <option value="day">Daily Report</option>
                                <option value="month">Monthly Report</option>
                                <option value="year">Yearly Report</option>
                            </select>
                        </div>
                        <div class="mb-3">
                            <label for="startDateInput" class="form-label">Start Date:</label>
                            <input type="date" name="startDateR" id="startDateInput" class="form-control" readonly><%--readonly,required--%>
                        </div>
                        <div class="mb-3">
                            <label for="endDateInput" class="form-label">End Date:</label>
                            <input type="date" name="endDateR" id="endDateInput" class="form-control" required>
                        </div>
                        <button type="submit" class="btn btn-primary">Generate Report</button>
                        <button type="reset" class="btn btn-secondary">Reset</button>
                    </fieldset>
                </form>

                <div id="printSection" class="print_table">
                    <%if (reportSales != null) {%>
                    <h4 class="text-center text-info" style="width: 100%; margin: 0.5rem 0 2rem 0; font-size: 20px; color: black !important;"><%= reportTypeR%> Report | From <%=selectedStartDate%> to <%= selectedEndDate%></h4>  
                    <%}%>

                    <table class="table table-striped table-bordered" style="width: 100%;">
                        <thead class="table-dark">
                            <tr>
                                <th>No</th>
                                <th>Item ID</th>
                                <th>Item Name</th>
                                <th>Price Per Unit</th>
                                <th>Quantity Sold</th>
                                <th>Sales (RM)</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                if (reportSales != null && !reportSales.isEmpty()) {
                                    for (Object[] row : reportSales) {
                                        if (row[5] != null) {
                                            totalSalesAmount += ((Number) row[5]).doubleValue();
                                        }
                            %>
                            <tr>
                                <td><%= row[0]%></td>
                                <td><%= row[1]%></td>
                                <td><%= row[2]%></td>
                                <td><%= row[3]%></td>
                                <td><%= row[4]%></td>
                                <td><%= row[5]%></td>
                            </tr>
                            <%}%>
                            <% 
                                promoBetweenTotal=totalSalesAmount-promoAmount;
                                totalRevenue=totalSalesAmount-promoBetweenTotal;
                            %>
                            <tr>
                                <td colspan="4"></td>
                                <td>Total (RM)</td>
                                <td><%=String.format("%.2f", totalSalesAmount)%></td>
                            </tr>
                            <tr>
                                <td colspan="4"></td>
                                <td>Promotion (RM)</td>
                                <td><%=String.format("%.2f", promoBetweenTotal)%></td>                            </tr>
                            </tr>
                            <tr>
                                <td colspan="4"></td>
                                <td>Total Revenue (RM)</td>
                                <td><%=String.format("%.2f", totalRevenue)%></td>                            </tr>
                            </tr>
                            <%
                                } else { %>
                            <tr>
                                <td colspan="6" class="text-center text-danger">No sales data found for the selected dates.</td>
                            </tr>
                            <%
                                }
                            %>
                        </tbody>
                    </table>
                
                <%
                    StringBuilder chartDataLabels = new StringBuilder();
                    StringBuilder chartDataSales = new StringBuilder();
                    if (reportSales != null && !reportSales.isEmpty()) {
                        for (int i = 0; i < reportSales.size(); i++) {
                            Object[] row = reportSales.get(i);
                            chartDataLabels.append("'").append(row[2]).append("'");
                            chartDataSales.append(row[5]);
                            if (i < reportSales.size() - 1) {
                                chartDataLabels.append(",");
                                chartDataSales.append(",");
                            }
                        }
                    }
                %>

                <% if (reportSales != null) {%>
                
                    <div id="chartSection" class="print_chart">
                        <div class="chart-container mt-5">
                            <canvas id="salesChart"></canvas>
                        </div>
                    </div>
                </div>
                <div class="text-center mt-3">
                    <button id="saveReportBtn" class="btn btn-success" data-bs-toggle="modal" data-bs-target="#saveReportModal">Save Report</button>
                    <button onclick="printReport()" class="btn btn-danger">Print Report</button>
                </div>



                <% }%>
                <a href="ap_index.jsp" class="btn btn-secondary mt-4">Back to Dashboard</a>

                <div class="modal fade" id="saveReportModal" tabindex="-1" aria-labelledby="saveReportModalLabel" aria-hidden="true">
                    <div class="modal-dialog">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h5 class="modal-title text-primary" id="saveReportModalLabel">Save Report</h5>
                                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                            </div>
                            <div class="modal-body">
                                <form id="saveReportForm" action="AddReportServlet" method="post">
                                    <div class="mb-3">
                                        <label for="reportID" class="form-label">Report ID</label>
                                        <input type="text" class="form-control" id="reportID" name="reportID" value="<%= nextID%>" readonly>
                                    </div>
                                    <div class="mb-3">
                                        <label for="reportDate" class="form-label">Report Date</label>
                                        <input type="date" class="form-control" id="reportDate" name="reportDate" required readonly>
                                    </div>
                                    <div class="mb-3">
                                        <label for="reportType" class="form-label">Report Type:</label>
                                        <input type="text" class="form-control" id="reportType" name="reportType" value="<%= reportTypeR%>" readonly>        
                                        <div class="mb-3">
                                            <label for="totalSales" class="form-label">Total Sales (RM)</label>
                                            <input type="text" class="form-control" id="totalSalesDisplay" name="totalSalesDisplay" value="<%=String.format("%.2f", totalRevenue)%>" readonly>
                                        </div>
                                        <div class="mb-3">
                                            <label for="description" class="form-label">Description</label>
                                            <input type="text" class="form-control" id="description" name="description" value="<%= reportTypeR%> From <%= selectedStartDate%> to <%= selectedEndDate%>" readonly>                  
                                        </div>
                                </form>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                                <button type="button" id="confirmSaveReportBtn" class="btn btn-success">Save Report</button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
<!-- JavaScript Import -->
<script src="<%= request.getContextPath()%>/assets/js/bootstrap.bundle.min.js"></script>
<script>
                        document.addEventListener("DOMContentLoaded", function () {
                            const ctx = document.getElementById('salesChart').getContext('2d');
                            new Chart(ctx, {
                                type: 'bar',
                                data: {
                                    labels: [<%= chartDataLabels.toString()%>],
                                    datasets: [{
                                            label: 'Total Sales (RM)',
                                            data: [<%= chartDataSales.toString()%>],
                                            backgroundColor: 'rgba(75, 192, 192, 0.6)',
                                            borderColor: 'rgba(75, 192, 192, 1)',
                                            borderWidth: 1
                                        }]
                                },
                                options: {
                                    responsive: true,
                                    scales: {
                                        y: {beginAtZero: true}
                                    }
                                }
                            });
                        });
</script>
<script>
    const reportTypeElement = document.getElementById('reportType');
    const endDateElement = document.getElementById('endDateInput');
    const startDateElement = document.getElementById('startDateInput');

    function printReport() {
        const printSection = document.getElementById("printSection");
        printSection.classList.remove("d-none");
        window.print();
        printSection.classList.add("d-none");
    }

    function calculateStartDate() {
        const reportType = reportTypeElement.value;
        const endDate = new Date(endDateElement.value);

        if (isNaN(endDate.getTime())) {
            startDateElement.value = '';
            return;
        }

        let startDate = new Date(endDate);

        if (reportType === 'month') {
            startDate.setMonth(startDate.getMonth() - 1);
        } else if (reportType === 'year') {
            startDate.setFullYear(startDate.getFullYear() - 1);
        }

        startDateElement.value = startDate.toISOString().split('T')[0];
    }

    endDateElement.addEventListener('change', calculateStartDate);
    reportTypeElement.addEventListener('change', calculateStartDate);

    endDateElement.addEventListener('input', () => {
        // Get today's date in the local timezone
        const today = new Date();
        today.setHours(0, 0, 0, 0); // Reset time part to ensure date-only comparison
        
        // Parse the selected date
        const selectedDate = new Date(endDateElement.value);
        selectedDate.setHours(0, 0, 0, 0); // Reset time part to ensure date-only comparison
        
        // Compare dates using getTime() for more reliable comparison
        if (selectedDate.getTime() > today.getTime()) {
            alert("The end date cannot be a future date.");
            endDateElement.value = "";
        }
    });

    function calculateTotalSales() {
        let total = 0;
        document.querySelectorAll("table tbody tr").forEach(row => {
            const cells = row.getElementsByTagName("td");
            if (cells.length > 0) {
                const salesValue = parseFloat(cells[5].innerText);
                if (!isNaN(salesValue)) {
                    total += salesValue;
                }
            }
        });

        document.getElementById("totalSalesDisplay").value = total.toFixed(2);
    }

    document.addEventListener("DOMContentLoaded", calculateTotalSales);

    document.addEventListener("DOMContentLoaded", function () {
        const saveButton = document.getElementById("confirmSaveReportBtn");
        const form = document.getElementById("saveReportForm");
        const reportTypeInput = document.getElementById("reportType");
        const modalReportTypeInput = document.getElementById("modalReportType");
        const inputs = form.querySelectorAll("input, textarea, select");

        function setTodayDate() {
            const today = new Date().toISOString().split("T")[0];
            document.getElementById("reportDate").value = today;
        }

        function setReportType() {
            document.getElementById("modalReportType").value = document.getElementById("reportType").value;
        }

        function validateForm() {
            let isValid = true;
            inputs.forEach(input => {
                if (input.value.trim() === "") {
                    isValid = false;
                }
            });
            saveButton.disabled = !isValid;
        }

        document.getElementById("saveReportBtn").addEventListener("click", function () {
            setReportType();
            validateForm();
        });

        inputs.forEach(input => {
            input.addEventListener("input", validateForm);
        });

        setTodayDate();
        validateForm();
    });

    document.getElementById("confirmSaveReportBtn").addEventListener("click", function (event) {
        event.preventDefault();

        const reportID = document.getElementById("reportID").value.trim();
        const reportDate = document.getElementById("reportDate").value.trim();
        const reportType = document.getElementById("reportType").value.trim();
        const totalSales = document.getElementById("totalSalesAmount").value.trim();
        const description = document.getElementById("description").value.trim();

        const formData = new URLSearchParams();
        formData.append("reportID", reportID);
        formData.append("reportDate", reportDate);
        formData.append("reportType", reportType);
        formData.append("totalSales", totalSales);
        formData.append("description", description);

        fetch("saveReport.jsp", {
            method: "POST",
            headers: {"Content-Type": "application/x-www-form-urlencoded"},
            body: formData
        })
                .then(response => response.text())
                .then(result => {
                    console.log("Server Response:", result);
                    alert(result);
                })
                .catch(error => {
                    console.error("Fetch Error:", error);
                });
    });
    document.addEventListener("DOMContentLoaded", function () {
        const today = new Date().toISOString().split("T")[0];
        document.getElementById("reportDate").value = today;
    });

    document.getElementById("confirmSaveReportBtn").addEventListener("click", function () {
        document.getElementById("saveReportForm").submit();
    });

</script>
</html>