<!-- For Manager -->
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List"%>
<%@ page import="model.Report"%>
<%@ page import="model.ReportDAO"%>
<%@ page import="java.util.Arrays"%>
<%@ page import="java.util.Set"%>
<%@ page import="java.util.HashSet"%>
<%@ page import="javax.naming.InitialContext" %>
<%@ page import="javax.naming.NamingException" %>
<!DOCTYPE html>
<html>
    <%
        //String searchQuery = request.getParameter("search");
        ReportDAO reportDAO = null;
        try {
            InitialContext context = new InitialContext();
            reportDAO = (ReportDAO) context.lookup("java:global/HarveyHerman/ReportDAO");
        } catch (NamingException ne) {
            ne.printStackTrace();
        }
        List<Report> report = reportDAO.getAllReports();//
    %>
    <head>
        <jsp:include page="/user/head.jsp" />
        <title>History Report</title>
        <!-- Bootstrap CSS -->
        <link href="<%= request.getContextPath()%>/assets/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">
        <link href="<%= request.getContextPath()%>/assets/css/style.css" rel="stylesheet">
        <!-- Custom CSS -->
        <link rel="stylesheet" href="<%= request.getContextPath()%>/assets/css/ap_index.css">
        <link rel="stylesheet" href="<%= request.getContextPath()%>/assets/css/ap_layout.css">
    </head>
    <body class="container mt-4">
        <div class="layout-wrapper">
            <!-- Side Bar -->
            <%@ include file="ap_sidebar.jsp" %>
            <div class="main-content">
                <h2 class="text-center text-primary">History Report</h2>
                <%                
                        String successMessage = (String) request.getAttribute("successMessage");
                        String errorMessage = (String) request.getAttribute("errorMessage");
                %>

                <% if (successMessage != null) {%>
                    <div class="alert alert-success"><%= successMessage%></div>
                <% } %>

                <% if (errorMessage != null) {%>
                    <div class="alert alert-danger"><%= errorMessage%></div>
                <% } %>
                <table class="table table-striped table-bordered">
                    <thead class="table-dark">
                        <tr>
                            <th>Report ID</th>
                            <th>Type Of Report</th>
                            <th>Created Date</th>
                            <th>Total Sales</th>
                            <th>Description</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%                    if (report != null && !report.isEmpty()) {
                                for (Report re : report) {
                        %>

                        <tr>
                            <td><%= re.getReportId()%></td>
                            <td><%= re.getReportType()%></td>
                            <td><%= re.getReportDate()%></td>
                            <td><%= re.getTotalSales()%></td>
                            <td><%= re.getDescription()%></td>
                        </tr>
                        <%
                            }
                        } else {
                        %>
                        <tr><td colspan="5" class="text-center text-danger">No reports available.</td></tr>
                        <% }%>

                    </tbody>
                </table>
                <div class="d-flex justify-content-center gap-3 mt-3">
                    <button type="button" class="btn btn-danger" data-bs-toggle="modal" data-bs-target="#deleteReportModal">
                        Delete Report
                    </button>
                    <a href="ap_index.jsp" class="btn btn-secondary">Back to Dashboard</a>
                </div>
            </div>
        </div>
        
        <!-- Delete Report Modal -->
        <div class="modal fade" id="deleteReportModal" tabindex="-1" aria-labelledby="deleteReportModalLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="deleteReportModalLabel">Delete Report</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <form action="DeleteReportServlet" method="post">
                            <div class="mb-3">
                                <label for="deleteReportId" class="form-label">Report ID</label>
                                <input type="text" class="form-control" id="deleteReportId" name="reportId" required>
                                <small class="text-danger" id="deleteError" style="display: none;">Report ID is required.</small>
                            </div>
                            <button type="submit" name="deleteReportBtn" id="deleteReportBtn" class="btn btn-danger w-100">Delete Report</button>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </body>
    <!-- JavaScript Import -->
    <script src="<%= request.getContextPath()%>/assets/js/bootstrap.bundle.min.js"></script>
    <script>
        document.addEventListener("DOMContentLoaded", function () {
            const deleteButton = document.querySelector("#deleteReportBtn");
            const deleteInput = document.querySelector("#deleteReportId");
            const deleteError = document.querySelector("#deleteError");

            function validateDelete() {
                if (deleteInput.value.trim() === "") {
                    deleteError.style.display = "block";
                    deleteButton.disabled = true;
                } else {
                    deleteError.style.display = "none";
                    deleteButton.disabled = false;
                }
            }

            deleteInput.addEventListener("input", validateDelete);
            validateDelete();
        });
    </script>
</html>