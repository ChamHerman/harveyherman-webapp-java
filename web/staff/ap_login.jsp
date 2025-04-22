<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <title>Admin Portal - HarveyHerman</title>
        <!-- Bootstrap CSS -->
        <link href="<%=request.getContextPath()%>/assets/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">
        <link href="<%=request.getContextPath()%>/assets/css/style.css" rel="stylesheet">
        <!-- Custom CSS -->
        <link href="<%=request.getContextPath()%>/assets/css/ap_login.css" rel="stylesheet">
    </head>
    <body>
        <div class="login-container">
            <div class="login-header">
                <h2>Admin Portal</h2>
            </div>

            <div class="login-body">
                <div class="login-logo">
                    <img src="<%=request.getContextPath()%>/assets/images/logo.png" alt="HarveyHerman Logo">
                </div>

                <% if (request.getParameter("error") != null) { %>
                <div class="alert alert-danger">
                    Invalid username or password. Please try again.
                </div>
                <% }%>

                <form action="<%=request.getContextPath()%>/staff/StaffLoginServlet" method="post">
                    <div class="form-group">
                        <label for="username">Username</label>
                        <input type="text" class="form-control" id="username" name="username" required>
                    </div>

                    <div class="form-group password-field-container">
                        <label for="password">Password</label>
                        <input type="password" class="form-control" id="password" name="password" required>
                        <span class="password-toggle-icon" id="togglePassword">
                            <i class="fas fa-eye"></i>
                        </span>
                    </div>

                    <button type="submit" class="btn-login">Login</button>
                </form>
            </div>

            <div class="login-footer">
                <p>&copy; 2023 HarveyHerman. All rights reserved.</p>
            </div>
        </div>

        <!-- Scripts -->
        <script>
            // Password toggle functionality
            document.addEventListener('DOMContentLoaded', function () {
                const togglePassword = document.querySelector('#togglePassword');
                const password = document.querySelector('#password');

                if (togglePassword && password) {
                    togglePassword.addEventListener('click', function () {
                        // Toggle the type attribute
                        const type = password.getAttribute('type') === 'password' ? 'text' : 'password';
                        password.setAttribute('type', type);

                        // Toggle the eye / eye slash icon
                        const icon = this.querySelector('i');
                        if (icon) {
                            icon.classList.toggle('fa-eye');
                            icon.classList.toggle('fa-eye-slash');
                        }
                    });
                }
            });
        </script>

        <script src="<%=request.getContextPath()%>/assets/js/bootstrap.bundle.min.js"></script>
    </body>
</html>