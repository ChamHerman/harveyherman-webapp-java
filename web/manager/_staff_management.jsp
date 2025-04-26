<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="model.UserData"%>
<%@page import="model.UserDataDAO"%>
<%@page import="javax.naming.InitialContext"%>
<!DOCTYPE html>
<html>
    <head>
        <jsp:include page="/user/head.jsp" />
        <title>Staff Management - Manager</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
        <style>
            .table-hover tbody tr:hover {
                background-color: rgba(0, 123, 255, 0.1);
                cursor: pointer;
            }
            .action-icons i {
                margin-right: 10px;
                cursor: pointer;
            }
            .action-icons i:hover {
                color: #0d6efd;
            }
        </style>
    </head>
    <body>
        <%
            // Check if user is logged in and is a manager
            String role = (String) session.getAttribute("role");
            if (role == null || !role.equals("manager")) {
                response.sendRedirect(request.getContextPath() + "/staff/ap_login.jsp");
                return;
            }
            
            // Get the context and DAOs
            InitialContext ic = new InitialContext();
            StaffDataDAO staffDataDAO = (StaffDataDAO) ic.lookup("java:global/VGlobalMarketplace/StaffDataDAO");
            StaffLoginDAO staffLoginDAO = (StaffLoginDAO) ic.lookup("java:global/VGlobalMarketplace/StaffLoginDAO");
            
            // Get search parameters
            String searchTerm = request.getParameter("searchTerm");
            String searchBy = request.getParameter("searchBy");
            String filterStatus = request.getParameter("filterStatus");
            
            // Get the message parameter
            String message = request.getParameter("message");
            
            // Default to all staff if no search parameters
            List<StaffData> staffList;
            
            if (searchTerm != null && !searchTerm.trim().isEmpty() && searchBy != null) {
                // Perform search based on criteria
                if (searchBy.equals("id")) {
                    StaffData staff = staffDataDAO.findByStaffId(searchTerm);
                    staffList = new java.util.ArrayList<>();
                    if (staff != null) {
                        staffList.add(staff);
                    }
                } else if (searchBy.equals("name")) {
                    staffList = staffDataDAO.findByFullnameLike(searchTerm);
                } else if (searchBy.equals("email")) {
                    staffList = staffDataDAO.findByEmailLike(searchTerm);
                } else {
                    staffList = staffDataDAO.findAllStaff();
                }
            } else {
                staffList = staffDataDAO.findAllStaff();
            }
            
            // Filter by status if specified
            if (filterStatus != null && !filterStatus.equals("all")) {
                List<StaffData> filteredList = new java.util.ArrayList<>();
                for (StaffData staff : staffList) {
                    if (filterStatus.equals(staff.getDbstatus())) {
                        filteredList.add(staff);
                    }
                }
                staffList = filteredList;
            }
            
            SimpleDateFormat dateFormat = new SimpleDateFormat("dd-MM-yyyy");
        %>
        
        <div class="container mt-4">
            <h1>Staff Management</h1>
            
            <!-- Message display -->
            <% if (message != null && !message.isEmpty()) { %>
                <div class="message-container">
                    <% if (message.startsWith("MESSAGE:")) { %>
                        <div class="alert alert-success" role="alert">
                            <%= message.substring("MESSAGE:".length()).trim() %>
                        </div>
                    <% } else if (message.startsWith("ERROR:")) { %>
                        <div class="alert alert-danger" role="alert">
                            <%= message.substring("ERROR:".length()).trim() %>
                        </div>
                    <% } %>
                </div>
            <% } %>
            
            <!-- Search and filter container -->
            <div class="search-container">
                <form method="GET" action="staff_management.jsp" class="row g-3">
                    <div class="col-md-4">
                        <input type="text" name="searchTerm" class="form-control" placeholder="Search..." value="<%= searchTerm != null ? searchTerm : "" %>">
                    </div>
                    <div class="col-md-3">
                        <select name="searchBy" class="form-select">
                            <option value="id" <%= searchBy != null && searchBy.equals("id") ? "selected" : "" %>>Staff ID</option>
                            <option value="name" <%= searchBy != null && searchBy.equals("name") ? "selected" : "" %>>Name</option>
                            <option value="email" <%= searchBy != null && searchBy.equals("email") ? "selected" : "" %>>Email</option>
                        </select>
                    </div>
                    <div class="col-md-3">
                        <select name="filterStatus" class="form-select">
                            <option value="all" <%= filterStatus == null || filterStatus.equals("all") ? "selected" : "" %>>All Status</option>
                            <option value="active" <%= filterStatus != null && filterStatus.equals("active") ? "selected" : "" %>>Active</option>
                            <option value="inactive" <%= filterStatus != null && filterStatus.equals("inactive") ? "selected" : "" %>>Inactive</option>
                        </select>
                    </div>
                    <div class="col-md-2">
                        <button type="submit" class="btn btn-primary w-100">Search</button>
                    </div>
                </form>
            </div>
            
            <div class="d-flex justify-content-end mb-3">
                <a href="add_staff.jsp" class="btn btn-success">
                    <i class="fas fa-plus"></i> Add Staff
                </a>
            </div>
            
            <!-- Staff table -->
            <div class="staff-table">
                <table class="table table-striped table-hover">
                    <thead>
                        <tr>
                            <th>Staff ID</th>
                            <th>Name</th>
                            <th>Email</th>
                            <th>Contact</th>
                            <th>Position</th>
                            <th>Role</th>
                            <th>Status</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if (staffList.isEmpty()) { %>
                            <tr>
                                <td colspan="8" class="text-center">No staff members found</td>
                            </tr>
                        <% } else { %>
                            <% for (StaffData staff : staffList) {
                                // Get the staff login to display role
                                StaffLogin login = staffLoginDAO.findByStaffId(staff.getStaffId());
                                String staffRole = login != null ? login.getRole() : "N/A";
                            %>
                                <tr>
                                    <td><%= staff.getStaffId() %></td>
                                    <td><%= staff.getFullname() %></td>
                                    <td><%= staff.getEmail() %></td>
                                    <td><%= staff.getContactNumber() %></td>
                                    <td><%= staff.getPosition() %></td>
                                    <td><%= staffRole %></td>
                                    <td class="<%= staff.getDbstatus().equals("active") ? "status-active" : "status-inactive" %>">
                                        <%= staff.getDbstatus() %>
                                    </td>
                                    <td class="action-buttons">
                                        <a href="ap_viewStaff.jsp?staffId=<%= staff.getStaffId() %>" class="btn btn-sm btn-info">
                                            <i class="fas fa-eye"></i>
                                        </a>
                                        <a href="edit_staff.jsp?staffId=<%= staff.getStaffId() %>" class="btn btn-sm btn-warning">
                                            <i class="fas fa-edit"></i>
                                        </a>
                                        <button type="button" class="btn btn-sm btn-danger" 
                                                onclick="confirmDelete('<%= staff.getStaffId() %>', '<%= staff.getFullname() %>')">
                                            <i class="fas fa-trash"></i>
                                        </button>
                                    </td>
                                </tr>
                            <% } %>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
        
        <!-- Delete Confirmation Modal -->
        <div class="modal fade" id="deleteModal" tabindex="-1" aria-labelledby="deleteModalLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="deleteModalLabel">Confirm Deletion</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <p id="deleteConfirmText">Are you sure you want to delete this staff member?</p>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <form id="deleteForm" method="POST" action="../manager/DeleteStaffServlet">
                            <input type="hidden" id="staffIdToDelete" name="staffId" value="">
                            <button type="submit" class="btn btn-danger">Delete</button>
                        </form>
                    </div>
                </div>
            </div>
        </div>
        
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
        <script>
            function confirmDelete(staffId, staffName) {
                document.getElementById('staffIdToDelete').value = staffId;
                document.getElementById('deleteConfirmText').innerText = 
                    `Are you sure you want to delete staff member ${staffName} (${staffId})?`;
                
                // Show the modal using Bootstrap's modal API
                var myModal = new bootstrap.Modal(document.getElementById('deleteModal'));
                myModal.show();
            }
            
            // Check for messages and set timeout to clear them
            document.addEventListener('DOMContentLoaded', function() {
                const alerts = document.querySelectorAll('.alert');
                if (alerts.length > 0) {
                    setTimeout(function() {
                        alerts.forEach(alert => {
                            alert.style.transition = 'opacity 1s';
                            alert.style.opacity = '0';
                            setTimeout(() => alert.remove(), 1000);
                        });
                    }, 5000);
                }
            });
        </script>
    </body>
</html> 