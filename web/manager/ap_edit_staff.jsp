<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.StaffData" %>
<%@ page import="model.StaffDataDAO" %>
<%@ page import="model.StaffLogin" %>
<%@ page import="model.StaffLoginDAO" %>
<%@ page import="javax.naming.InitialContext" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Edit Staff - Manager</title>
        <link href="<%= request.getContextPath()%>/assets/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">
        <link href="<%= request.getContextPath()%>/assets/css/style.css" rel="stylesheet">
        <link href="<%= request.getContextPath()%>/assets/css/ap_index.css" rel="stylesheet">
        <link href="<%= request.getContextPath()%>/assets/css/ap_staff.css" rel="stylesheet">
        <style>
            .card {
                margin-bottom: 20px;
                border-radius: 10px;
                box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.1);
            }
            .card-header {
                background-color: #4e73df;
                color: white;
                font-weight: bold;
                border-radius: 10px 10px 0 0;
            }
            .form-label {
                color: #000000 !important;
                font-weight: 600;
            }
            .form-label.required:after {
                content: ' *';
                color: red;
            }
            .btn-primary {
                background-color: #4e73df;
                border-color: #4e73df;
            }
            .btn-primary:hover {
                background-color: #2e59d9;
                border-color: #2e59d9;
            }
            .btn-secondary {
                background-color: #858796;
                border-color: #858796;
            }
            .btn-secondary:hover {
                background-color: #717384;
                border-color: #717384;
            }
        </style>
    </head>
    <body>
        <%@ include file="ap_sidebar.jsp" %>
        
        <%
            // Get staff ID from request
            String staffId = request.getParameter("staffId");
            if (staffId == null || staffId.trim().isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/manager/ap_staff.jsp");
                return;
            }
            
            // Get DAOs
            StaffDataDAO staffDataDAO = null;
            StaffLoginDAO staffLoginDAO = null;
            StaffData newStaffData = null;
            StaffLogin staffLogin = null;
            
            try {
                InitialContext context = new InitialContext();
                staffDataDAO = (StaffDataDAO) context.lookup("java:global/HarveyHerman/StaffDataDAO");
                staffLoginDAO = (StaffLoginDAO) context.lookup("java:global/HarveyHerman/StaffLoginDAO");
                
                // Get staff data
                newStaffData = staffDataDAO.findByStaffId(staffId);
                if (newStaffData == null) {
                    response.sendRedirect(request.getContextPath() + "/manager/ap_staff.jsp?message=" + 
                        java.net.URLEncoder.encode("ERROR: Staff not found", "UTF-8"));
                    return;
                }
                
                // Get staff login
                staffLogin = staffLoginDAO.findByStaffId(staffId);
                if (staffLogin == null) {
                    response.sendRedirect(request.getContextPath() + "/manager/ap_staff.jsp?message=" + 
                        java.net.URLEncoder.encode("ERROR: Staff login not found", "UTF-8"));
                    return;
                }
            } catch (Exception e) {
                e.printStackTrace();
                response.sendRedirect(request.getContextPath() + "/manager/ap_staff.jsp?message=" + 
                    java.net.URLEncoder.encode("ERROR: Failed to initialize DAOs", "UTF-8"));
                return;
            }
        %>
        
        <div class="main-content flex-grow-1">
            <div class="container">
                <h2 class="mt-4 mb-4">Edit Staff</h2>
                
                <form id="editStaffForm" action="<%= request.getContextPath()%>/manager/EditStaffsServlet" method="post">
                    <input type="hidden" name="staffId" value="<%= newStaffData.getStaffId() %>">
                    
                    <div class="card">
                        <div class="card-header">
                            <h5 class="mb-0">Personal Information</h5>
                        </div>
                        <div class="card-body">
                            <div class="row mb-3">
                                <div class="col-md-6">
                                    <label for="fullname" class="form-label required">Full Name</label>
                                    <input type="text" class="form-control" id="fullname" name="fullname" 
                                           value="<%= newStaffData.getFullname() %>" required>
                                </div>
                                <div class="col-md-6">
                                    <label for="email" class="form-label required">Email</label>
                                    <input type="email" class="form-control" id="email" name="email" 
                                           value="<%= newStaffData.getEmail() %>" required>
                                </div>
                            </div>
                            
                            <div class="row mb-3">
                                <div class="col-md-6">
                                    <label for="contactNumber" class="form-label required">Contact Number</label>
                                    <input type="text" class="form-control" id="contactNumber" name="contactNumber" 
                                           value="<%= newStaffData.getContactNumber() != null ? newStaffData.getContactNumber() : "" %>" required>
                                </div>
                                <div class="col-md-6">
                                    <label for="gender" class="form-label required">Gender</label>
                                    <select class="form-select" id="gender" name="gender" required>
                                        <option value="">Select Gender</option>
                                        <option value="Male" <%= "Male".equals(newStaffData.getGender()) ? "selected" : "" %>>Male</option>
                                        <option value="Female" <%= "Female".equals(newStaffData.getGender()) ? "selected" : "" %>>Female</option>
                                        <option value="Other" <%= "Other".equals(newStaffData.getGender()) ? "selected" : "" %>>Other</option>
                                    </select>
                                </div>
                            </div>
                            
                            <div class="row mb-3">
                                <div class="col-md-12">
                                    <label for="address" class="form-label">Address</label>
                                    <textarea class="form-control" id="address" name="address" rows="3"><%= newStaffData.getAddress() != null ? newStaffData.getAddress() : "" %></textarea>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <div class="card">
                        <div class="card-header">
                            <h5 class="mb-0">Employment Information</h5>
                        </div>
                        <div class="card-body">
                            <div class="row mb-3">
                                <div class="col-md-12">
                                    <label for="position" class="form-label required">Position</label>
                                    <input type="text" class="form-control" id="position" name="position" 
                                           value="<%= newStaffData.getPosition() %>" required>
                                </div>
                            </div>
                            
                            <div class="row mb-3">
                                <div class="col-md-6">
                                    <label for="dbstatus" class="form-label required">Status</label>
                                    <select class="form-select" id="dbstatus" name="dbstatus" required>
                                        <option value="active" <%= "active".equals(newStaffData.getDbstatus()) ? "selected" : "" %>>Active</option>
                                        <option value="inactive" <%= "inactive".equals(newStaffData.getDbstatus()) ? "selected" : "" %>>Inactive</option>
                                    </select>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <div class="card">
                        <div class="card-header">
                            <h5 class="mb-0">Account Information</h5>
                        </div>
                        <div class="card-body">
                            <div class="row mb-3">
                                <div class="col-md-6">
                                    <label for="username" class="form-label required">Username</label>
                                    <input type="text" class="form-control" id="username" name="username" 
                                           value="<%= staffLogin.getUsername() %>" required>
                                </div>
                                <div class="col-md-6">
                                    <label for="role" class="form-label required">Role</label>
                                    <select class="form-select" id="role" name="role" required>
                                        <option value="staff" <%= "staff".equals(staffLogin.getRole()) ? "selected" : "" %>>Staff</option>
                                        <option value="manager" <%= "manager".equals(staffLogin.getRole()) ? "selected" : "" %>>Manager</option>
                                    </select>
                                </div>
                            </div>
                            
                            <div class="row mb-3">
                                <div class="col-md-6">
                                    <label for="password" class="form-label">Password</label>
                                    <div class="input-group">
                                        <input type="password" class="form-control" id="password" name="password" 
                                            value="<%= staffLogin.getPassword() %>">
                                        <button class="btn btn-outline-secondary" type="button" id="togglePassword">
                                            <i class="fas fa-eye"></i>
                                        </button>
                                    </div>
                                    <div class="form-text">Leave unchanged to keep the current password.</div>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <div class="d-flex justify-content-end mt-3 mb-5">
                        <a href="ap_staff.jsp" class="btn btn-secondary me-2">Cancel</a>
                        <button type="submit" class="btn btn-primary">Save Changes</button>
                    </div>
                </form>
            </div>
        </div>
        
        <!-- Loading Modal -->
        <div class="modal fade" id="loadingModal" tabindex="-1" data-bs-backdrop="static" data-bs-keyboard="false" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content">
                    <div class="modal-body text-center p-4">
                        <div class="spinner-border text-primary" role="status">
                            <span class="visually-hidden">Loading...</span>
                        </div>
                        <h5 class="mt-3">Processing...</h5>
                    </div>
                </div>
            </div>
        </div>
        
        <script src="<%= request.getContextPath()%>/assets/js/bootstrap.bundle.min.js"></script>
        <script>
            document.addEventListener('DOMContentLoaded', function() {
                // Toggle password visibility
                const togglePassword = document.getElementById('togglePassword');
                const password = document.getElementById('password');
                
                if (togglePassword && password) {
                    togglePassword.addEventListener('click', function() {
                        const type = password.getAttribute('type') === 'password' ? 'text' : 'password';
                        password.setAttribute('type', type);
                        this.querySelector('i').classList.toggle('fa-eye');
                        this.querySelector('i').classList.toggle('fa-eye-slash');
                    });
                }
                
                // Show loading modal on form submission
                const form = document.getElementById('editStaffForm');
                if (form) {
                    form.addEventListener('submit', function(e) {
                        const loadingModal = new bootstrap.Modal(document.getElementById('loadingModal'));
                        loadingModal.show();
                    });
                }
            });
        </script>
    </body>
</html> 