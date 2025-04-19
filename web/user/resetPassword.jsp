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
    <style>
        .password-reset-container {
            max-width: 500px;
            margin: 80px auto;
            padding: 30px;
            background-color: #fff;
            border-radius: 20px;
            box-shadow: 0 5px 30px rgba(0, 0, 0, 0.05);
        }
        .form-title {
            color: #3b5d50;
            font-weight: 700;
            margin-bottom: 30px;
            text-align: center;
        }
        .form-group {
            margin-bottom: 20px;
        }
        label {
            color: #3b5d50;
            font-weight: 600;
            font-size: 14px;
            margin-bottom: 8px;
        }
        .form-control {
            height: 50px;
            border-radius: 10px;
            padding: 10px 15px;
            border: 1px solid #dce5e4;
        }
        .form-control:focus {
            border-color: #3b5d50;
            box-shadow: 0 0 0 0.2rem rgba(59, 93, 80, 0.15);
        }
        .error-message {
            color: #dc3545;
            margin-top: 20px;
        }
        .btn-primary {
            background-color: #3b5d50;
            border-color: #3b5d50;
            padding: 12px 20px;
            font-weight: 600;
            border-radius: 30px;
        }
        .btn-primary:hover {
            background-color: #2f4a40;
            border-color: #2f4a40;
        }
    </style>
</head>
<body class="bg-light">
    <div class="container">
        <div class="password-reset-container">
            <h2 class="form-title">Reset Password</h2>
            
            <% if(request.getAttribute("errorMessage") != null) { %>
                <div class="alert alert-danger">
                    <%= request.getAttribute("errorMessage") %>
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
            
            <form action="<%= request.getContextPath() %>/user/ResetPasswordServlet" method="post" id="resetPasswordForm">
                <div class="form-group">
                    <label for="newPassword">New Password</label>
                    <input type="password" class="form-control" id="newPassword" name="newPassword" 
                           required minlength="6">
                </div>
                
                <div class="form-group">
                    <label for="confirmPassword">Confirm New Password</label>
                    <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" 
                           required minlength="6">
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
        // Client-side password validation
        document.getElementById('resetPasswordForm').addEventListener('submit', function(event) {
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