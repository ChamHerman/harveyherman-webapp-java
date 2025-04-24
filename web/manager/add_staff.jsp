<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="javax.naming.InitialContext"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Add Staff Member</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <style>
            .form-section {
                margin-bottom: 30px;
            }
            .form-label {
                font-weight: 500;
            }
            .required::after {
                content: " *";
                color: red;
            }
            .password-container {
                position: relative;
            }
            .toggle-password {
                position: absolute;
                right: 10px;
                top: 10px;
                cursor: pointer;
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
            
            // Get current date for the date fields
            SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
            String currentDate = dateFormat.format(new Date());
        %>
        
        <div class="container mt-4">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h1>Add New Staff Member</h1>
                <a href="staff_management.jsp" class="btn btn-secondary">
                    <i class="fas fa-arrow-left"></i> Back to Staff List
                </a>
            </div>
            
            <form id="addStaffForm" method="POST" action="../manager/AddStaffServlet" class="needs-validation" novalidate>
                <!-- Personal Information Section -->
                <div class="card mb-4">
                    <div class="card-header bg-primary text-white">
                        <h4>Personal Information</h4>
                    </div>
                    <div class="card-body">
                        <div class="row g-3">
                            <div class="col-md-6">
                                <label for="fullname" class="form-label required">Full Name</label>
                                <input type="text" class="form-control" id="fullname" name="fullname" required>
                                <div class="invalid-feedback">
                                    Please provide a full name.
                                </div>
                            </div>
                            <div class="col-md-6">
                                <label for="email" class="form-label required">Email</label>
                                <input type="email" class="form-control" id="email" name="email" required>
                                <div class="invalid-feedback">
                                    Please provide a valid email.
                                </div>
                            </div>
                            <div class="col-md-6">
                                <label for="contactNumber" class="form-label required">Contact Number</label>
                                <input type="tel" class="form-control" id="contactNumber" name="contactNumber" required>
                                <div class="invalid-feedback">
                                    Please provide a contact number.
                                </div>
                            </div>
                            <div class="col-md-6">
                                <label for="dateOfBirth" class="form-label">Date of Birth</label>
                                <input type="date" class="form-control" id="dateOfBirth" name="dateOfBirth" max="<%= currentDate %>">
                            </div>
                            <div class="col-md-12">
                                <label for="address" class="form-label">Address</label>
                                <textarea class="form-control" id="address" name="address" rows="2"></textarea>
                            </div>
                        </div>
                    </div>
                </div>
                
                <!-- Employment Information Section -->
                <div class="card mb-4">
                    <div class="card-header bg-primary text-white">
                        <h4>Employment Information</h4>
                    </div>
                    <div class="card-body">
                        <div class="row g-3">
                            <div class="col-md-6">
                                <label for="position" class="form-label required">Position</label>
                                <input type="text" class="form-control" id="position" name="position" required>
                                <div class="invalid-feedback">
                                    Please provide a position.
                                </div>
                            </div>
                            <div class="col-md-6">
                                <label for="department" class="form-label">Department</label>
                                <input type="text" class="form-control" id="department" name="department">
                            </div>
                            <div class="col-md-6">
                                <label for="dateJoined" class="form-label required">Date Joined</label>
                                <input type="date" class="form-control" id="dateJoined" name="dateJoined" required value="<%= currentDate %>">
                                <div class="invalid-feedback">
                                    Please provide a joining date.
                                </div>
                            </div>
                            <div class="col-md-6">
                                <label for="salary" class="form-label">Salary</label>
                                <div class="input-group">
                                    <span class="input-group-text">$</span>
                                    <input type="number" class="form-control" id="salary" name="salary" step="0.01" min="0">
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                
                <!-- Account Information Section -->
                <div class="card mb-4">
                    <div class="card-header bg-primary text-white">
                        <h4>Account Information</h4>
                    </div>
                    <div class="card-body">
                        <div class="row g-3">
                            <div class="col-md-6">
                                <label for="username" class="form-label required">Username</label>
                                <input type="text" class="form-control" id="username" name="username" required>
                                <div class="invalid-feedback">
                                    Please provide a username.
                                </div>
                            </div>
                            <div class="col-md-6">
                                <label for="role" class="form-label required">Role</label>
                                <select class="form-select" id="role" name="role" required>
                                    <option value="">Select Role</option>
                                    <option value="staff">Staff</option>
                                    <option value="manager">Manager</option>
                                </select>
                                <div class="invalid-feedback">
                                    Please select a role.
                                </div>
                            </div>
                            <div class="col-md-6">
                                <label for="password" class="form-label required">Password</label>
                                <div class="password-container">
                                    <input type="password" class="form-control" id="password" name="password" required 
                                           pattern="^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$">
                                    <i class="toggle-password fa fa-eye-slash" toggle="#password"></i>
                                    <div class="invalid-feedback">
                                        Password must be at least 8 characters with at least one uppercase letter, one lowercase letter, one number, and one special character.
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <label for="confirmPassword" class="form-label required">Confirm Password</label>
                                <div class="password-container">
                                    <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" required>
                                    <i class="toggle-password fa fa-eye-slash" toggle="#confirmPassword"></i>
                                    <div class="invalid-feedback">
                                        Passwords do not match.
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-12">
                                <div class="form-check">
                                    <input class="form-check-input" type="checkbox" id="active" name="active" checked>
                                    <label class="form-check-label" for="active">
                                        Active Account
                                    </label>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                
                <div class="d-grid gap-2 d-md-flex justify-content-md-end mb-4">
                    <button type="button" class="btn btn-secondary" onclick="resetForm()">Reset</button>
                    <button type="submit" class="btn btn-primary">Add Staff Member</button>
                </div>
            </form>
        </div>
        
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
        <script>
            // Form validation
            (() => {
                'use strict';
                
                const form = document.getElementById('addStaffForm');
                const password = document.getElementById('password');
                const confirmPassword = document.getElementById('confirmPassword');
                
                form.addEventListener('submit', event => {
                    if (!form.checkValidity()) {
                        event.preventDefault();
                        event.stopPropagation();
                    } else if (password.value !== confirmPassword.value) {
                        event.preventDefault();
                        event.stopPropagation();
                        confirmPassword.setCustomValidity('Passwords do not match.');
                    } else {
                        confirmPassword.setCustomValidity('');
                    }
                    
                    form.classList.add('was-validated');
                }, false);
                
                // Check password match on input
                confirmPassword.addEventListener('input', () => {
                    if (password.value !== confirmPassword.value) {
                        confirmPassword.setCustomValidity('Passwords do not match.');
                    } else {
                        confirmPassword.setCustomValidity('');
                    }
                });
            })();
            
            // Toggle password visibility
            document.querySelectorAll('.toggle-password').forEach(icon => {
                icon.addEventListener('click', function() {
                    const input = document.querySelector(this.getAttribute('toggle'));
                    if (input.type === 'password') {
                        input.type = 'text';
                        this.classList.remove('fa-eye-slash');
                        this.classList.add('fa-eye');
                    } else {
                        input.type = 'password';
                        this.classList.remove('fa-eye');
                        this.classList.add('fa-eye-slash');
                    }
                });
            });
            
            // Reset form
            function resetForm() {
                document.getElementById('addStaffForm').reset();
                document.getElementById('addStaffForm').classList.remove('was-validated');
            }
        </script>
    </body>
</html> 