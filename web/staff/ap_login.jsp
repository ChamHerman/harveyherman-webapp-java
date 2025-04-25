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
        <style>
            /* Override styles directly in the page */
            .password-toggle-icon {
                position: absolute;
                right: 16px;
                top: 50% !important;
                transform: translateY(-50%) !important;
            }
            
            /* Ensure the input has enough padding for the icon */
            #password {
                padding-right: 40px;
            }
        </style>
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

                <form action="<%=request.getContextPath()%>/staff/StaffLoginServlet" method="post" autocomplete="off">
                    <div class="form-group">
                        <label for="username">Username</label>
                        <input type="text" class="form-control" id="username" name="username" required autocomplete="off">
                    </div>

                    <div class="form-group">
                        <label for="password">Password</label>
                        <div style="position: relative;">
                            <input type="password" class="form-control" id="password" name="password" required autocomplete="off">
                            <div class="password-toggle-icon" id="togglePassword" style="position: absolute; right: 12px; top: 15px;">
                                <i class="fas fa-eye"></i>
                            </div>
                        </div>
                    </div>

                    <button type="submit" class="btn-login">LOGIN</button>
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