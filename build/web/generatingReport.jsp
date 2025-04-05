<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="controller.ManagerDashboardUtil"%>
<html>
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
<%String generatedReportID = "R001"; %>
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
    <form method="post" action="generatingReport.jsp" class="mb-4">
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
                <input type="date" name="startDate" id="startDateInput" class="form-control" readonly>
            </div>
            <div class="mb-3">
                <label for="endDateInput" class="form-label">End Date:</label>
                <input type="date" name="endDate" id="endDateInput" class="form-control" required
                       max="<%= java.time.LocalDate.now() %>">
            </div>
            <button type="submit" class="btn btn-primary">Generate Report</button>
            <button type="reset" class="btn btn-secondary">Reset</button>
        </fieldset>
    </form>

    <%
        String reportType = request.getParameter("reportType");
        String endDate = request.getParameter("endDate");
        String startDate = null;
        String reportTypeLabel = null;
        boolean dataExists = false;
        StringBuilder chartDataLabels = new StringBuilder();
        StringBuilder chartDataSales = new StringBuilder();
        double totalSalesSum = 0;

        if (endDate != null && reportType != null) {
            java.util.Date endDateParsed = java.sql.Date.valueOf(endDate);
            java.util.Calendar calendar = java.util.Calendar.getInstance();
            calendar.setTime(endDateParsed);

            switch (reportType) {
                case "day":
                    reportTypeLabel = "Daily Report";
                    startDate = endDate; 
                    break;
                case "month":
                    reportTypeLabel = "Monthly Report";
                    calendar.add(java.util.Calendar.MONTH, -1);
                    startDate = new java.sql.Date(calendar.getTimeInMillis()).toString();
                    break;
                case "year":
                    reportTypeLabel = "Yearly Report";
                    calendar.add(java.util.Calendar.YEAR, -1);
                    startDate = new java.sql.Date(calendar.getTimeInMillis()).toString();
                    break;
            }
            
            String query = "SELECT i.item_id, i.name AS product_name, i.price AS price_per_unit, " +
                    "SUM(od.quantity) AS total_quantity_sold, " +
                    "SUM(od.quantity * i.price) AS total_sales " +
                    "FROM item i " +
                    "JOIN orderdetails od ON i.item_id = od.item_id " +
                    "JOIN orders o ON od.order_id = o.order_id " +
                    "WHERE o.created_date BETWEEN ? AND DATE_ADD(?, INTERVAL 1 DAY) " +
                    "GROUP BY i.item_id, i.name, i.price " +
                    "ORDER BY i.item_id";
            String query1 = "SELECT report_id FROM report ORDER BY report_id DESC LIMIT 1";

            try (Connection conn = ManagerDashboardUtil.getConnection()) {
                PreparedStatement stmt = conn.prepareStatement(query);
                stmt.setString(1, startDate);
                stmt.setString(2, endDate);
                PreparedStatement stmt1 = conn.prepareStatement(query1);
                
                ResultSet rs1 = stmt1.executeQuery();
                
                if (rs1.next()) {
                    String lastReportID = rs1.getString("report_id"); 
                    int lastNumber = Integer.parseInt(lastReportID.substring(1)); // Extract number part
                    int newNumber = lastNumber + 1; 

                    generatedReportID = String.format("R%03d", newNumber);
                }
                ResultSet rs = stmt.executeQuery();
                int no = 1;
    %>
    <div id="printSection" class="print_table">
    <h4 class="text-center text-info">
        Type of Report: <%= reportTypeLabel %> | Date: <%= startDate %> to <%= endDate %>
    </h4>  
	  
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
                while (rs.next()) {
                    dataExists = true;
                    chartDataLabels.append("'").append(rs.getString("product_name")).append("',");
                    chartDataSales.append(rs.getDouble("total_sales")).append(",");
                    double totalSales = rs.getDouble("total_sales");
                    totalSalesSum += totalSales;
            %>
            <tr>
                <td><%= no++ %></td>
                <td><%= rs.getString("item_id") %></td>
                <td><%= rs.getString("product_name") %></td>
                <td><%= String.format("%.2f", rs.getDouble("price_per_unit")) %></td>
                <td><%= rs.getInt("total_quantity_sold") %></td>
                <td><%= String.format("%.2f", totalSales) %></td>
            </tr>
            <%
                }
             if (dataExists) { 
             %>
             	<tr>
             		<td colspan="4"></td>
             		<td>Total (RM)</td>
             		<td><%=totalSalesSum %></td>
            <% 
             }
                if (!dataExists) {
            %>
            <tr>
                <td colspan="6" class="text-center text-warning">No data available for the selected date range.</td>
            </tr>
            <%
                }
            } catch (SQLException e) {
                out.println("<p class='text-danger'>Error: " + e.getMessage() + "</p>");
            }
            
            
        } else {
            %>
            <h4 class="text-center text-info">Type of Report: None</h4>
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
                    <tr>
                        <td colspan="6" class="text-center text-warning">No data available. Please select a report type and date range.</td>
                    </tr>
                </tbody>
            </table>
        <%
        }
            %>
        </tbody>
    </table>
    </div>

	<!-- Save Report Modal -->
	<div class="modal fade" id="saveReportModal" tabindex="-1" aria-labelledby="saveReportModalLabel" aria-hidden="true">
	    <div class="modal-dialog">
	        <div class="modal-content">
	            <div class="modal-header">
	                <h5 class="modal-title text-primary" id="saveReportModalLabel">Save Report</h5>
	                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
	            </div>
	            <div class="modal-body">
	                <form id="saveReportForm">
	                    <div class="mb-3">
						    <label for="reportID" class="form-label">Report ID</label>
						    <input type="text" class="form-control" id="reportID" name="reportID" value="<%= generatedReportID %>" readonly>
						</div>
	                    <div class="mb-3">
	                        <label for="reportDate" class="form-label">Report Date</label>
	                        <input type="date" class="form-control" id="reportDate" name="reportDate" required readonly>
	                    </div>
	                    <div class="mb-3">
			                <label for="reportType" class="form-label">Report Type:</label>
			                <select name="reportType" id="modalReportType" class="form-select">
							    <option value="day">Daily Report</option>
							    <option value="month">Monthly Report</option>
							    <option value="year">Yearly Report</option>
							</select>
			            </div>
	                    <div class="mb-3">
	                        <label for="totalSales" class="form-label">Total Sales (RM)</label>
	                        <textarea type="text" id="totalSalesDisplay" class="form-control fw-bold text-primary" readonly><%=totalSalesSum %></textarea>
	                    </div>
	                    <div class="mb-3">
	                        <label for="description" class="form-label">Description</label>
	                        <textarea class="form-control" id="description" readonly><%= reportTypeLabel %> From <%= startDate %> to <%= endDate %></textarea>                  
	                    </div>
	                </form>
	            </div>
	            <div class="modal-footer">
	                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
	                <button type="submit" id="confirmSaveReportBtn" class="btn btn-success">Save Report</button>
	            </div>
	        </div>
	    </div>
	</div>

	<% if (dataExists) { %>
	<div id="printSection" class="print_chart">
	    <div class="mt-5">
	        <canvas id="salesChart"></canvas>
	    </div>
	</div>
	    <div class="text-center mt-3">
	        <button id="saveReportBtn" class="btn btn-success" data-bs-toggle="modal" data-bs-target="#saveReportModal">
			    Save Report
			</button>
			<button onclick="printReport()" class="btn btn-danger">Print Report</button>
	    </div>
	    
	    <script>
	        const ctx = document.getElementById('salesChart').getContext('2d');
	        new Chart(ctx, {
	            type: 'bar',
	            data: {
	                labels: [<%= chartDataLabels.toString().replaceAll(",$", "") %>],
	                datasets: [{
	                    label: 'Total Sales',
	                    data: [<%= chartDataSales.toString().replaceAll(",$", "") %>],
	                    backgroundColor: 'rgba(75, 192, 192, 0.6)',
	                    borderColor: 'rgba(75, 192, 192, 1)',
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
	    </script>
    <% } %>
    
    <a href="managerDashboard.jsp" class="btn btn-secondary mt-4">Back to Dashboard</a>
    
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
            const reportType = document.getElementById("modalReportType").value.trim();
            const totalSales = document.getElementById("totalSalesDisplay").value.trim();
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

    </script>
</body>
</html>
