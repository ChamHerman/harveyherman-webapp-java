<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <!-- Default Head -->
        <jsp:include page="head.jsp" />
        <title>Password Recovery - HarveyHerman</title>
        <!-- Bootstrap CSS -->
        <link href="<%=request.getContextPath()%>/assets/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">
        <link href="<%=request.getContextPath()%>/assets/css/tiny-slider.css" rel="stylesheet">
        <link href="<%=request.getContextPath()%>/assets/css/style.css" rel="stylesheet">
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
            .back-login a {
                color: #3b5d50;
                text-decoration: none;
                font-weight: 600;
                transition: all 0.3s ease;
                display: inline-block;
                margin-bottom: 15px;
            }

            .back-login a:hover {
                color: #f9bf29;
                text-decoration: underline;
            }
        </style>
    </head>
    <body class="bg-light">
        <!-- Header -->
        <jsp:include page="header.jsp" />

        <div class="container">
            <div class="password-recovery-container">
                <h2 class="form-title">Password Recovery</h2>

                <% if (request.getAttribute("errorMessage") != null) {%>
                <div class="alert alert-danger">
                    <%= request.getAttribute("errorMessage")%>
                </div>
                <% }%>

                <form action="<%= request.getContextPath()%>/user/VerifyChallengeServlet" method="post" autocomplete="off">
                    <div class="form-group">
                        <label for="identifier">Username or Email</label>
                        <input type="text" class="form-control" id="identifier" name="identifier" autocomplete="off" required>
                    </div>

                    <div class="form-group">
                        <label for="challengeQuestion">Your Security Question</label>
                        <select class="form-control" id="challengeQuestion" name="challengeQuestion" autocomplete="off" required>
                            <option value="">Select your security question</option>
                            <option value="What is your favourite colors?">What is your favorite colors?</option>
                            <option value="What is your nickname?">What is your nickname?</option>
                            <option value="Which animal do you like?">Which animal do you like?</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label for="answer">Your Answer</label>
                        <input type="text" class="form-control" id="answer" name="answer" autocomplete="off" required>
                    </div>

                    <div class="d-grid gap-2">
                        <button type="submit" class="btn btn-primary">Verify Identity</button>
                    </div>

                    <div class="mt-3 text-center back-login">
                        <a href="login.jsp">Back to Login</a>
                    </div>
                </form>
            </div>
        </div>


    </body>
    <!-- Footer -->
    <jsp:include page="footer.jsp" />

    <script src="<%=request.getContextPath()%>/assets/js/bootstrap.bundle.min.js"></script>
</html>