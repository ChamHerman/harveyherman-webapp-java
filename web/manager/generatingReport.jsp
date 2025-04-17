
<%@page import="javax.naming.NamingException"%>
<%@page import="javax.naming.InitialContext"%>
<%@page import="java.util.List"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="model.Report" %>
<%@ page import="model.ReportDAO" %>

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
        String selectedEndDate = (request.getAttribute("selectedEndDateR") != null)
            ? request.getAttribute("selectedEndDateR").toString()
            : "";
        String selectedStartDate = (request.getAttribute("selectedStartDateR")!=null)
            ? request.getAttribute("selectedStartDateR").toString()
            : "";
        double totalSalesAmount=0.0;
    %>
<head>
    <title>Generate Sales Report</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
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
		        page-break-before: always; /* Move chart to new page */
		    }
		    table {
		        width: 100%;
		        border-collapse: collapse;
		    }
		 	.print_table{
		 		margin-top:100px;
		 	}
		 	.print_chart{
		 		margin-top:1000px;
		 	}
        }
    </style>
</head>

<body class="container mt-4">
    <h2 class="text-center text-primary">Generate Sales Report</h2>
    <p class="text-center">Select a report type and an end date to generate the report. The start date will be auto-calculated.</p>
    
    <!-- print pdf -->
    <div id="printSection" class="d-none text-center">
        <img src="logo.png" alt="Company Logo" style="height: 80px; margin-right: 10px;">
        <h2 style="display: inline-block; vertical-align: middle;">HARVEY HERMAN</h2>
        <hr>
    </div>

    <!-- Form -->
    <form method="post" action="GeneratingReportServlet" class="mb-4">
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
    <%if(reportSales!=null){%>
        <h4 class="text-center text-info">
            Type of Report: <%= reportTypeR %> | Date: <%=selectedStartDate  %> to <%= selectedEndDate %>
        </h4>  
    <%}%>
              
    <table class="table table-striped table-bordered">
        <thead class="table-dark">
            <tr>
                <th>No</th>
                <th>Item ID</th>
                <th>Product Name</th>
                <th>Price Per Unit</th>
                <th>Total Quantity Sold</th>
                <th>Total Sales (RM)</th>
            </tr>
        </thead>
        <tbody>
            <% 
                if(reportSales !=null && !reportSales.isEmpty()){
                    for(Object[] row : reportSales){
                    if (row[5] != null) {
                        totalSalesAmount += ((Number) row[5]).doubleValue();
                    }
            %>
                    <tr>
                        <td><%= row[0] %></td>
                        <td><%= row[1] %></td>
                        <td><%= row[2] %></td>
                        <td><%= row[3] %></td>
                        <td><%= row[4] %></td>
                        <td><%= row[5] %></td>
                    </tr>
                <%} %>
                    <tr>
                        <td colspan="4"></td>
                        <td>Total (RM)</td>
                        <td><%=totalSalesAmount %></td>
                    </tr>

                <%} else { %>
                <tr>
                    <td colspan="6" class="text-center text-danger">No sales data found for the selected dates.</td>
                </tr>
            <%
                }
            %>
        </tbody>
    </table>
</div>
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
    
    <% if (reportSales!=null) { %>
    <div id="printSection" class="print_table">
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
	    
	    <script>
                document.addEventListener("DOMContentLoaded", function () {
                    const ctx = document.getElementById('salesChart').getContext('2d');
                    new Chart(ctx, {
                        type: 'bar',
                        data: {
                            labels: [<%= chartDataLabels.toString() %>],
                            datasets: [{
                                label: 'Total Sales (RM)',
                                data: [<%= chartDataSales.toString() %>],
                                backgroundColor: 'rgba(75, 192, 192, 0.6)',
                                borderColor: 'rgba(75, 192, 192, 1)',
                                borderWidth: 1
                            }]
                        },
                    options: {
                        responsive: true,
                    scales: {
                        y: { beginAtZero: true }
                        }
                    }
                });
            });
        </script>

    <% } %>
    <a href="managerDashboard.jsp" class="btn btn-secondary mt-4">Back to Dashboard</a>
    
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
				<input type="text" class="form-control" id="reportID" name="reportID" value="<%= nextID %>" readonly>
                            </div>
	                    <div class="mb-3">
	                        <label for="reportDate" class="form-label">Report Date</label>
	                        <input type="date" class="form-control" id="reportDate" name="reportDate" required readonly>
	                    </div>
	                    <div class="mb-3">
			        <label for="reportType" class="form-label">Report Type:</label>
			        <input type="text" class="form-control" id="reportType" name="reportType" value="<%= reportTypeR %>" readonly>        
	                    <div class="mb-3">
	                        <label for="totalSales" class="form-label">Total Sales (RM)</label>
	                        <input type="text" class="form-control" id="totalSalesDisplay" name="totalSalesDisplay" value="<%=totalSalesAmount%>" readonly>
	                    </div>
	                    <div class="mb-3">
	                        <label for="description" class="form-label">Description</label>
	                        <input type="text" class="form-control" id="description" name="description" value="<%= reportTypeR %> From <%= selectedStartDate %> to <%= selectedEndDate %>" readonly>                  
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
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
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
            const today = new Date();
            const selectedDate = new Date(endDateElement.value);

            if (selectedDate > today) {
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
                headers: { "Content-Type": "application/x-www-form-urlencoded" },
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
</body>
</html>