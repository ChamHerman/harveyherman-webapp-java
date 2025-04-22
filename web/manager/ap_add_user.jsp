<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Add User - Manager</title>
        <link href="<%= request.getContextPath()%>/assets/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">
        <link href="<%= request.getContextPath()%>/assets/css/style.css" rel="stylesheet">
        <link href="<%= request.getContextPath()%>/assets/css/ap_index.css" rel="stylesheet">
        <link href="<%= request.getContextPath()%>/assets/css/ap_user.css" rel="stylesheet">
        <style>
            .form-label {
                color: #000000;
            }
            .card-header {
                color: #b5e7a0;
                background-color: #1a1a1a;
            }
        </style>
    </head>
    <body>
        <%@ include file="ap_sidebar.jsp" %>
        <div class="main-content flex-grow-1">
            <div class="container mt-4">
                <h2>Add New User</h2>
                
                <div class="card">
                    <div class="card-header">
                        <h5>User Information</h5>
                    </div>
                    <div class="card-body">
                        <form id="addUserForm" method="post" action="<%= request.getContextPath() %>/manager/AddUsersServlet" onsubmit="return validateAddUserForm()">
                            <!-- Personal Information Section -->
                            <h4 class="mb-3">Personal Information</h4>
                            
                            <div class="row mb-3">
                                <div class="col-md-6">
                                    <label for="fullname" class="form-label">Full Name <span class="text-danger">*</span></label>
                                    <input type="text" class="form-control" id="fullname" name="fullname" required>
                                </div>
                                <div class="col-md-6">
                                    <label for="email" class="form-label">Email <span class="text-danger">*</span></label>
                                    <input type="email" class="form-control" id="email" name="email" required>
                                </div>
                            </div>
                            
                            <div class="row mb-3">
                                <div class="col-md-6">
                                    <label for="contactNumber" class="form-label">Contact Number <span class="text-danger">*</span></label>
                                    <input type="text" class="form-control" id="contactNumber" name="contactNumber" required>
                                </div>
                                <div class="col-md-6">
                                    <label for="birthDate" class="form-label">Birth Date</label>
                                    <input type="date" class="form-control" id="birthDate" name="birthDate">
                                </div>
                            </div>
                            
                            <div class="row mb-3">
                                <div class="col-md-6">
                                    <label for="gender" class="form-label">Gender <span class="text-danger">*</span></label>
                                    <select class="form-select" id="gender" name="gender" required>
                                        <option value="">Select gender...</option>
                                        <option value="Male">Male</option>
                                        <option value="Female">Female</option>
                                        <option value="Other">Other</option>
                                    </select>
                                </div>
                            </div>
                            
                            <div class="mb-3">
                                <label for="address" class="form-label">Address</label>
                                <textarea class="form-control" id="address" name="address" rows="2"></textarea>
                            </div>
                            
                            <!-- Account Information Section -->
                            <h4 class="mb-3 mt-4">Account Information</h4>
                            <div class="alert alert-info">
                                <i class="fas fa-info-circle"></i> Default password will be set to "password"
                            </div>
                            
                            <div class="row mb-3">
                                <div class="col-md-6">
                                    <label for="username" class="form-label">Username <span class="text-danger">*</span></label>
                                    <input type="text" class="form-control" id="username" name="username" required minlength="3" maxlength="20" pattern="^[a-zA-Z0-9_-]{3,20}$">
                                    <div class="form-text">Username must be 3-20 characters and can only contain letters, numbers, underscores, and hyphens.</div>
                                </div>
                            </div>
                            
                            <div class="row mb-3">
                                <div class="col-md-6">
                                    <label for="securityQuestion" class="form-label">Security Question <span class="text-danger">*</span></label>
                                    <select class="form-select" id="securityQuestion" name="securityQuestion" required>
                                        <option value="">Select security question...</option>
                                        <option value="What is your favorite color?">What is your favorite color?</option>
                                        <option value="What is your nickname?">What is your nickname?</option>
                                        <option value="Which animal do you like?">Which animal do you like?</option>
                                    </select>
                                </div>
                                <div class="col-md-6">
                                    <label for="securityAnswer" class="form-label">Security Answer <span class="text-danger">*</span></label>
                                    <input type="text" class="form-control" id="securityAnswer" name="securityAnswer" required>
                                </div>
                            </div>
                            
                            <div class="mt-4">
                                <button type="submit" class="btn btn-primary">Create User</button>
                                <a href="<%= request.getContextPath() %>/manager/ap_user.jsp" class="btn btn-secondary ms-2">Cancel</a>
                            </div>
                        </form>
                    </div>
                </div>
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
        
        <script>
            var contextPath = '<%= request.getContextPath() %>';
            
            // Form validation function
            function validateAddUserForm() {
                // Get form fields
                const fullname = document.getElementById('fullname').value.trim();
                const email = document.getElementById('email').value.trim();
                const contactNumber = document.getElementById('contactNumber').value.trim();
                const username = document.getElementById('username').value.trim();
                const securityQuestion = document.getElementById('securityQuestion').value.trim();
                const securityAnswer = document.getElementById('securityAnswer').value.trim();
                const gender = document.getElementById('gender').value.trim();
                
                // Basic validation
                if (fullname.length === 0) {
                    alert('Full name is required.');
                    return false;
                }
                
                if (fullname.length > 255) {
                    alert('Full name must be less than 255 characters.');
                    return false;
                }
                
                if (email.length === 0) {
                    alert('Email is required.');
                    return false;
                }
                
                if (email.length > 255) {
                    alert('Email must be less than 255 characters.');
                    return false;
                }
                
                // Simple email validation
                const emailPattern = /^[A-Za-z0-9+_.-]+@(.+)$/;
                if (!emailPattern.test(email)) {
                    alert('Please enter a valid email address.');
                    return false;
                }
                
                if (contactNumber.length === 0) {
                    alert('Contact number is required.');
                    return false;
                }
                
                if (contactNumber.length > 255) {
                    alert('Contact number must be less than 255 characters.');
                    return false;
                }
                
                if (username.length === 0) {
                    alert('Username is required.');
                    return false;
                }
                
                if (username.length < 3 || username.length > 20) {
                    alert('Username must be between 3 and 20 characters.');
                    return false;
                }
                
                // Username format validation
                const usernamePattern = /^[a-zA-Z0-9_-]{3,20}$/;
                if (!usernamePattern.test(username)) {
                    alert('Username can only contain letters, numbers, underscores, and hyphens.');
                    return false;
                }
                
                if (securityQuestion.length === 0) {
                    alert('Please select a security question.');
                    return false;
                }
                
                if (securityAnswer.length === 0) {
                    alert('Security answer is required.');
                    return false;
                }
                
                if (securityAnswer.length > 255) {
                    alert('Security answer must be less than 255 characters.');
                    return false;
                }
                
                if (gender.length === 0) {
                    alert('Please select a gender.');
                    return false;
                }
                
                // Show loading modal
                const loadingModal = new bootstrap.Modal(document.getElementById('loadingModal'));
                loadingModal.show();
                
                return true;
            }
        </script>
        <script src="<%= request.getContextPath()%>/assets/js/bootstrap.bundle.min.js"></script>
        <script src="<%= request.getContextPath()%>/assets/js/ap_user.js"></script>
    </body>
</html> 