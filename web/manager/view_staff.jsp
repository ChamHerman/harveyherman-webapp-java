<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="model.UserData"%>
<%@page import="model.UserDataDAO"%>
<%@page import="model.UserLogin"%>
<%@page import="model.UserLoginDAO"%>
<%@page import="javax.naming.InitialContext"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>View Staff Details</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
    <style>
        .profile-header {
            background-color: #f8f9fa;
            padding: 20px;
            border-radius: 5px;
            margin-bottom: 20px;
        }
        .profile-img {
            width: 150px;
            height: 150px;
            border-radius: 50%;
            object-fit: cover;
            border: 5px solid #fff;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }
        .info-card {
            margin-bottom: 20px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }
        .info-card .card-header {
            font-weight: bold;
            background-color: #f8f9fa;
        }
        .label {
            font-weight: bold;
            color: #6c757d;
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
        
        // Get user ID from request
        String userId = request.getParameter("id");
        if (userId == null || userId.trim().isEmpty()) {
            session.setAttribute("errorMessage", "Invalid user ID provided");
            response.sendRedirect(request.getContextPath() + "/manager/staff_management.jsp");
            return;
        }
        
        // Get user data
        UserDataDAO userDataDAO = null;
        UserLoginDAO userLoginDAO = null;
        UserData userData = null;
        UserLogin userLogin = null;
        
        try {
            InitialContext ic = new InitialContext();
            userDataDAO = (UserDataDAO) ic.lookup("java:global/SP_CA2_WebApplication/UserDataDAO");
            userLoginDAO = (UserLoginDAO) ic.lookup("java:global/SP_CA2_WebApplication/UserLoginDAO");
            
            userData = userDataDAO.findByUserId(userId);
            userLogin = userLoginDAO.findByUserId(userId);
            
            if (userData == null) {
                session.setAttribute("errorMessage", "User not found");
                response.sendRedirect(request.getContextPath() + "/manager/staff_management.jsp");
                return;
            }
        } catch (Exception e) {
            out.println("Error: " + e.getMessage());
        }
        
        // Format for dates
        SimpleDateFormat dateFormat = new SimpleDateFormat("dd MMM yyyy");
        SimpleDateFormat dateTimeFormat = new SimpleDateFormat("dd MMM yyyy HH:mm:ss");
    %>
    
    <div class="container-fluid">
        <div class="row">
            <!-- Sidebar -->
            <nav id="sidebar" class="col-md-3 col-lg-2 d-md-block bg-dark sidebar collapse">
                <div class="position-sticky pt-3">
                    <ul class="nav flex-column">
                        <li class="nav-item">
                            <a class="nav-link active text-white" href="<%=request.getContextPath()%>/manager/staff_management.jsp">
                                <i class="bi bi-people me-2"></i>
                                Staff Management
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link text-white" href="#">
                                <i class="bi bi-house me-2"></i>
                                Dashboard
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link text-white" href="#">
                                <i class="bi bi-file-earmark-text me-2"></i>
                                Reports
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link text-white" href="#">
                                <i class="bi bi-gear me-2"></i>
                                Settings
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link text-white" href="<%=request.getContextPath()%>/UserLogoutServlet">
                                <i class="bi bi-box-arrow-right me-2"></i>
                                Logout
                            </a>
                        </li>
                    </ul>
                </div>
            </nav>
            
            <!-- Main content -->
            <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4">
                <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                    <h1 class="h2">Staff Details</h1>
                    <div class="btn-toolbar mb-2 mb-md-0">
                        <a href="<%=request.getContextPath()%>/manager/staff_management.jsp" class="btn btn-outline-secondary me-2">
                            <i class="bi bi-arrow-left me-2"></i>Back to Staff List
                        </a>
                        <a href="<%=request.getContextPath()%>/manager/edit_staff.jsp?id=<%= userData.getUserId() %>" class="btn btn-warning me-2">
                            <i class="bi bi-pencil-square me-2"></i>Edit Staff
                        </a>
                        <button type="button" class="btn btn-danger" id="deleteStaffBtn">
                            <i class="bi bi-trash me-2"></i>Delete Staff
                        </button>
                    </div>
                </div>
                
                <div class="profile-header row">
                    <div class="col-md-3 text-center">
                        <img src="<%=request.getContextPath()%>/images/profile-placeholder.jpg" class="profile-img" alt="Profile Image">
                    </div>
                    <div class="col-md-9">
                        <h2><%= userData.getFullName() %></h2>
                        <p class="lead mb-2">
                            <%= userData.getPosition() != null ? userData.getPosition() : "Position Not Specified" %> | 
                            <%= userData.getDepartment() != null ? userData.getDepartment() : "Department Not Specified" %>
                        </p>
                        <p>
                            <span class="badge <%= userData.isActive() ? "bg-success" : "bg-danger" %>">
                                <%= userData.isActive() ? "Active" : "Inactive" %>
                            </span>
                        </p>
                        <div class="d-flex mt-3">
                            <div class="me-4">
                                <p><i class="bi bi-envelope me-2"></i><%= userData.getEmail() %></p>
                            </div>
                            <div class="me-4">
                                <p><i class="bi bi-telephone me-2"></i><%= userData.getContactNumber() != null ? userData.getContactNumber() : "Not provided" %></p>
                            </div>
                        </div>
                    </div>
                </div>
                
                <div class="row">
                    <!-- Personal Information -->
                    <div class="col-md-6">
                        <div class="card info-card">
                            <div class="card-header">
                                <i class="bi bi-person me-2"></i>Personal Information
                            </div>
                            <div class="card-body">
                                <div class="row mb-3">
                                    <div class="col-md-4 label">Full Name</div>
                                    <div class="col-md-8"><%= userData.getFullName() %></div>
                                </div>
                                <div class="row mb-3">
                                    <div class="col-md-4 label">Email</div>
                                    <div class="col-md-8"><%= userData.getEmail() %></div>
                                </div>
                                <div class="row mb-3">
                                    <div class="col-md-4 label">Contact Number</div>
                                    <div class="col-md-8"><%= userData.getContactNumber() != null ? userData.getContactNumber() : "Not provided" %></div>
                                </div>
                                <div class="row mb-3">
                                    <div class="col-md-4 label">Date of Birth</div>
                                    <div class="col-md-8"><%= userData.getDateOfBirth() != null ? dateFormat.format(userData.getDateOfBirth()) : "Not provided" %></div>
                                </div>
                                <div class="row mb-3">
                                    <div class="col-md-4 label">Gender</div>
                                    <div class="col-md-8"><%= userData.getGender() != null ? userData.getGender() : "Not specified" %></div>
                                </div>
                                <div class="row mb-3">
                                    <div class="col-md-4 label">Address</div>
                                    <div class="col-md-8"><%= userData.getAddress() != null ? userData.getAddress() : "Not provided" %></div>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Employment Information -->
                    <div class="col-md-6">
                        <div class="card info-card">
                            <div class="card-header">
                                <i class="bi bi-briefcase me-2"></i>Employment Information
                            </div>
                            <div class="card-body">
                                <div class="row mb-3">
                                    <div class="col-md-4 label">Employee ID</div>
                                    <div class="col-md-8"><%= userData.getUserId() %></div>
                                </div>
                                <div class="row mb-3">
                                    <div class="col-md-4 label">Department</div>
                                    <div class="col-md-8"><%= userData.getDepartment() != null ? userData.getDepartment() : "Not specified" %></div>
                                </div>
                                <div class="row mb-3">
                                    <div class="col-md-4 label">Position</div>
                                    <div class="col-md-8"><%= userData.getPosition() != null ? userData.getPosition() : "Not specified" %></div>
                                </div>
                                <div class="row mb-3">
                                    <div class="col-md-4 label">Date Joined</div>
                                    <div class="col-md-8"><%= userData.getDateJoined() != null ? dateFormat.format(userData.getDateJoined()) : "Not provided" %></div>
                                </div>
                                <div class="row mb-3">
                                    <div class="col-md-4 label">Status</div>
                                    <div class="col-md-8">
                                        <span class="badge <%= userData.isActive() ? "bg-success" : "bg-danger" %>">
                                            <%= userData.isActive() ? "Active" : "Inactive" %>
                                        </span>
                                    </div>
                                </div>
                                <div class="row mb-3">
                                    <div class="col-md-4 label">Salary</div>
                                    <div class="col-md-8">$<%= userData.getSalary() != null ? String.format("%.2f", userData.getSalary()) : "Not specified" %></div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                
                <!-- Account Information -->
                <div class="row mt-4">
                    <div class="col-md-12">
                        <div class="card info-card">
                            <div class="card-header">
                                <i class="bi bi-shield-lock me-2"></i>Account Information
                            </div>
                            <div class="card-body">
                                <div class="row mb-3">
                                    <div class="col-md-2 label">Username</div>
                                    <div class="col-md-4"><%= userLogin != null ? userLogin.getUsername() : "Not available" %></div>
                                    <div class="col-md-2 label">Last Login</div>
                                    <div class="col-md-4"><%= userLogin != null && userLogin.getLastLogin() != null ? dateTimeFormat.format(userLogin.getLastLogin()) : "Never logged in" %></div>
                                </div>
                                <div class="row mb-3">
                                    <div class="col-md-2 label">Account Created</div>
                                    <div class="col-md-4"><%= userData.getCreatedDate() != null ? dateTimeFormat.format(userData.getCreatedDate()) : "Not available" %></div>
                                    <div class="col-md-2 label">Last Updated</div>
                                    <div class="col-md-4"><%= userData.getUpdatedDate() != null ? dateTimeFormat.format(userData.getUpdatedDate()) : "Not updated" %></div>
                                </div>
                                <div class="row mb-3">
                                    <div class="col-md-2 label">Role</div>
                                    <div class="col-md-4"><%= userLogin != null ? userLogin.getRole() : "Not specified" %></div>
                                    <div class="col-md-2 label">Security Question</div>
                                    <div class="col-md-4"><%= userLogin != null ? userLogin.getChallengeQuestion() : "Not set" %></div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </main>
        </div>
    </div>
    
    <!-- Delete Confirmation Modal -->
    <div class="modal fade" id="deleteConfirmModal" tabindex="-1" aria-labelledby="deleteConfirmModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="deleteConfirmModalLabel">Confirm Delete</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    Are you sure you want to delete this staff member? This action cannot be undone.
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="button" class="btn btn-danger" id="confirmDeleteBtn">Delete</button>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Bootstrap JS and dependencies -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    
    <!-- JavaScript for handling delete -->
    <script>
        // Set up delete confirmation
        document.addEventListener('DOMContentLoaded', function() {
            const deleteBtn = document.getElementById('deleteStaffBtn');
            const confirmDeleteBtn = document.getElementById('confirmDeleteBtn');
            
            if (deleteBtn) {
                deleteBtn.addEventListener('click', function() {
                    // Show the confirmation modal
                    var deleteModal = new bootstrap.Modal(document.getElementById('deleteConfirmModal'));
                    deleteModal.show();
                });
            }
            
            if (confirmDeleteBtn) {
                confirmDeleteBtn.addEventListener('click', function() {
                    // Get the userId from the URL or data attribute
                    const userId = '<%= request.getParameter("id") %>';
                    
                    // Redirect to delete servlet
                    window.location.href = '<%= request.getContextPath() %>/manager/DeleteStaffServlet?id=' + userId;
                });
            }
        });
    </script>
</body>
</html> 