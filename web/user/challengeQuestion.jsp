<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Password Recovery</title>
    <!-- Bootstrap CSS -->
    <link href="<%=request.getContextPath()%>/assets/css/bootstrap.min.css" rel="stylesheet">
    <link href="<%=request.getContextPath()%>/assets/css/style.css" rel="stylesheet">
    <style>
        .password-recovery-container {
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
        <div class="password-recovery-container">
            <h2 class="form-title">Password Recovery</h2>
            
            <% if(request.getAttribute("errorMessage") != null) { %>
                <div class="alert alert-danger">
                    <%= request.getAttribute("errorMessage") %>
                </div>
            <% } %>
            
            <form action="<%= request.getContextPath() %>/user/VerifyChallengeServlet" method="post">
                <div class="form-group">
                    <label for="identifier">Username or Email</label>
                    <input type="text" class="form-control" id="identifier" name="identifier" required>
                </div>
                
                <div class="form-group">
                    <label for="challengeQuestion">Your Security Question</label>
                    <select class="form-control" id="challengeQuestion" name="challengeQuestion" required>
                        <option value="">Select your security question</option>
                        <option value="What is your favourite colors?">What is your favorite colors?</option>
                        <option value="What is your nickname?">What is your nickname?</option>
                        <option value="Which animal do you like?">Which animal do you like?</option>
                    </select>
                </div>
                
                <div class="form-group">
                    <label for="answer">Your Answer</label>
                    <input type="text" class="form-control" id="answer" name="answer" required>
                </div>
                
                <div class="d-grid gap-2">
                    <button type="submit" class="btn btn-primary">Verify Identity</button>
                </div>
                
                <div class="mt-3 text-center">
                    <a href="login.jsp">Back to Login</a>
                </div>
            </form>
        </div>
    </div>
    
    <script src="<%=request.getContextPath()%>/assets/js/bootstrap.bundle.min.js"></script>
</body>
</html>