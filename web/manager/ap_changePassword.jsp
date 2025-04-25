<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.StaffData" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Change Password - Staff</title>
        <!-- Bootstrap CSS -->
        <link href="<%= request.getContextPath()%>/assets/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">
        <link href="<%= request.getContextPath()%>/assets/css/style.css" rel="stylesheet">
        <!-- Custom CSS -->
        <link href="<%= request.getContextPath()%>/assets/css/ap_index.css" rel="stylesheet">
        <link rel="stylesheet" href="<%= request.getContextPath()%>/assets/css/ap_profile.css">
    </head>
    <body>
        <!-- Side Bar -->
        <%@ include file="ap_sidebar.jsp" %>
        
        <!-- Main Content -->
        <div class="main-content">
            <div class="container">
                <div class="profile-card">
                    <h2 class="profile-title">Change Password</h2>
                    <%
                        StaffData staff = (StaffData) session.getAttribute("loggedInManager");
                        if (staff != null) {
                    %>
                    
                    <% if (request.getParameter("error") != null) { %>
                    <div class="alert alert-danger">
                        <%= request.getParameter("error") %>
                    </div>
                    <% } %>

                    <% if (request.getParameter("success") != null) { %>
                    <div class="alert alert-success">
                        Password changed successfully!
                    </div>
                    <% } %>

                    <form action="<%= request.getContextPath()%>/manager/StaffChangePasswordServlet" method="post" autocomplete="off">
                        <div class="form-group password-field-container">
                            <label for="currentPassword">Current Password</label>
                            <input type="password" class="form-control" id="currentPassword" name="currentPassword" required autocomplete="off">
                            <i class="password-toggle-icon fas fa-eye" id="toggleCurrentPassword"></i>
                        </div>

                        <div class="form-group password-field-container">
                            <label for="newPassword">New Password</label>
                            <input type="password" class="form-control" id="newPassword" name="newPassword" required minlength="6" autocomplete="off">
                            <i class="password-toggle-icon fas fa-eye" id="toggleNewPassword"></i>
                            <div class="form-text text-muted">Password must be at least 6 characters long.</div>
                        </div>

                        <div class="form-group password-field-container">
                            <label for="confirmNewPassword">Confirm New Password</label>
                            <input type="password" class="form-control" id="confirmNewPassword" name="confirmNewPassword" required autocomplete="off">
                            <i class="password-toggle-icon fas fa-eye" id="toggleConfirmPassword"></i>
                        </div>

                        <div class="form-group">
                            <button type="submit" class="btn btn-primary">Change Password</button>
                            <a href="<%= request.getContextPath()%>/manager/ap_profile.jsp" class="btn btn-outline-secondary">Cancel</a>
                        </div>
                    </form>
                    <% } else { %>
                    <div class="alert alert-danger">
                        You are not logged in. Please <a href="<%= request.getContextPath()%>/staff/ap_login.jsp">login</a> to change your password.
                    </div>
                    <% } %>
                </div>
            </div>
        </div>
        
        <script src="<%= request.getContextPath()%>/assets/js/bootstrap.bundle.min.js"></script>
        
        <script>
            // Password toggle functionality
            function setupPasswordToggle(toggleId, passwordId) {
                const toggle = document.getElementById(toggleId);
                const password = document.getElementById(passwordId);

                toggle.addEventListener('click', function () {
                    // Toggle the type attribute
                    const type = password.getAttribute('type') === 'password' ? 'text' : 'password';
                    password.setAttribute('type', type);

                    // Toggle the eye / eye slash icon
                    this.classList.toggle('fa-eye');
                    this.classList.toggle('fa-eye-slash');
                });
            }

            // Setup all password toggles
            setupPasswordToggle('toggleCurrentPassword', 'currentPassword');
            setupPasswordToggle('toggleNewPassword', 'newPassword');
            setupPasswordToggle('toggleConfirmPassword', 'confirmNewPassword');

            // Client-side validation to check if passwords match
            document.querySelector('form').addEventListener('submit', function (event) {
                const newPassword = document.getElementById('newPassword').value;
                const confirmNewPassword = document.getElementById('confirmNewPassword').value;

                if (newPassword !== confirmNewPassword) {
                    event.preventDefault();
                    alert('New password and confirmation do not match!');
                }
            });
        </script>
    </body>
</html>