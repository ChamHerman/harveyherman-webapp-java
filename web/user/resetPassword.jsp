<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>Reset Password</title>
        <!-- Bootstrap CSS -->
        <link href="<%=request.getContextPath()%>/assets/css/bootstrap.min.css" rel="stylesheet">
        <link href="<%=request.getContextPath()%>/assets/css/style.css" rel="stylesheet">
        <link href="<%=request.getContextPath()%>/assets/css/resetPassword.css" rel="stylesheet">

    </head>
    <body class="bg-light">
        <div class="container">
            <div class="password-reset-container">
                <h2 class="form-title">Reset Password</h2>

                <% if (request.getAttribute("errorMessage") != null) {%>
                <div class="alert alert-danger">
                    <%= request.getAttribute("errorMessage")%>
                </div>
                <% } %>

                <%
                    // Check if user is verified
                    String loginId = (String) session.getAttribute("resetPasswordLoginId");
                    if (loginId == null) {
                        response.sendRedirect(request.getContextPath() + "/user/challengeQuestion.jsp");
                        return;
                    }
                %>

                <form action="<%= request.getContextPath()%>/user/ResetPasswordServlet" method="post" id="resetPasswordForm">
                    <div class="form-group password-field-container">
                        <label for="newPassword">New Password</label>
                        <input type="password" class="form-control" id="newPassword" name="newPassword" required minlength="6">
                        <i class="password-toggle-icon fas fa-eye" id="toggleNewPassword"></i>
                    </div>

                    <div class="form-group password-field-container">
                        <label for="confirmPassword">Confirm New Password</label>
                        <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" required minlength="6">
                        <i class="password-toggle-icon fas fa-eye" id="toggleConfirmPassword"></i>
                    </div>

                    <div id="passwordError" class="text-danger mb-3" style="display: none;">
                        Passwords do not match.
                    </div>

                    <div class="d-grid gap-2">
                        <button type="submit" class="btn btn-primary">Reset Password</button>
                    </div>

                    <div class="mt-3 text-center">
                        <a href="login.jsp">Back to Login</a>
                    </div>
                </form>
            </div>
        </div>

        <script src="<%=request.getContextPath()%>/assets/js/bootstrap.bundle.min.js"></script>
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
            setupPasswordToggle('toggleNewPassword', 'newPassword');
            setupPasswordToggle('toggleConfirmPassword', 'confirmPassword');

            // Client-side password validation
            document.getElementById('resetPasswordForm').addEventListener('submit', function (event) {
                var newPassword = document.getElementById('newPassword').value;
                var confirmPassword = document.getElementById('confirmPassword').value;
                var errorDiv = document.getElementById('passwordError');

                if (newPassword !== confirmPassword) {
                    errorDiv.style.display = 'block';
                    event.preventDefault();
                } else {
                    errorDiv.style.display = 'none';
                }
            });
        </script>
    </body>
</html>