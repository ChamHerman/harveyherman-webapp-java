<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <!-- Default Head -->
        <jsp:include page="head.jsp" />
        <title>Login - HarveyHerman</title>

        <!-- Bootstrap CSS -->
        <link href="<%=request.getContextPath()%>/assets/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">
        <link href="<%=request.getContextPath()%>/assets/css/tiny-slider.css" rel="stylesheet">
        <link href="<%=request.getContextPath()%>/assets/css/style.css" rel="stylesheet">
        <!-- Custom CSS -->
        <link href="<%=request.getContextPath()%>/assets/css/login.css" rel="stylesheet">
    </head>

    <body>
        <!-- Header -->
        <jsp:include page="header.jsp" />

        <div class="login-section">
            <div class="container">
                <div class="row justify-content-center">
                    <div class="col-md-6">
                        <div class="login-card">
                            <h2 class="login-title">Login</h2>

                            <form class="login-form" action="<%= request.getContextPath()%>/user/UserLoginServlet" method="post" autocomplete="off">
                                <% if (session.getAttribute("loginError") != null) {
                                        session.removeAttribute("loginError"); %>
                                <div class="login-error">
                                    <h5>Invalid username/email or wrong password!</h5>
                                </div>
                                <% }%>

                                <div class="form-group">
                                    <input type="text" class="form-control" name="usernameOrEmail" placeholder="Username or Email" autocomplete="off" required>
                                </div>

                                <div class="form-group password-field-container">
                                    <input type="password" class="form-control" id="password" name="password" placeholder="Password" autocomplete="off" required>
                                    <i class="password-toggle-icon fas fa-eye" id="togglePassword"></i>
                                </div>

                                <div class="form-group">
                                    <button type="submit" class="btn btn-primary">Login</button>
                                </div>
                            </form>

                            <div class="login-links">
                                <h3>Don't have an account?</h3>
                                <a href="register.jsp">Register for a new account</a>

                                <h3>Forgot your password?</h3>
                                <a href="challengeQuestion.jsp">Reset password</a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>


    </body>
    <!-- Notification Popup -->
    <%
        Boolean resetPasswordSuccess = (Boolean) session.getAttribute("resetPasswordSuccess");
        Boolean registerSuccess = (Boolean) session.getAttribute("registerSuccess");
        Boolean deleteSuccess = (Boolean) session.getAttribute("deleteSuccess");

        if (resetPasswordSuccess != null && resetPasswordSuccess) {
    %>
    <div id="notification-popup">
        <i class="fa fa-check-circle me-2" style="color:#ffd700;"></i>Password reset successfully!
    </div>
    <%
            session.removeAttribute("registerSuccess");
        }

        if (registerSuccess != null && resetPasswordSuccess) {
    %>
    <div id="notification-popup">
        <i class="fa fa-check-circle me-2" style="color:#ffd700;"></i>Registered successfully!
    </div>
    <%
            session.removeAttribute("registerSuccess");
        }

        if (deleteSuccess != null && deleteSuccess) {
    %>
    <div id="notification-popup">
        <i class="fa fa-check-circle me-2" style="color:#ffd700;"></i>Account deleted successfully!
    </div>
    <%
            session.removeAttribute("deleteSuccess");
        }
    %>
    <!-- Footer -->
    <jsp:include page="footer.jsp" />

    <script>
        // Password toggle functionality
        const togglePassword = document.querySelector('#togglePassword');
        const password = document.querySelector('#password');

        togglePassword.addEventListener('click', function () {
            // Toggle the type attribute
            const type = password.getAttribute('type') === 'password' ? 'text' : 'password';
            password.setAttribute('type', type);

            // Toggle the eye / eye slash icon
            this.classList.toggle('fa-eye');
            this.classList.toggle('fa-eye-slash');
        });

        document.addEventListener('DOMContentLoaded', function () {
            var popup = document.getElementById('notification-popup');
            if (popup) {
                // Slide in
                setTimeout(function () {
                    popup.classList.add('show');
                }, 100); // slight delay for transition

                // Slide out after 3 seconds
                setTimeout(function () {
                    popup.classList.remove('show');
                    popup.classList.add('hide');
                }, 3100);

                // Remove from DOM after animation
                setTimeout(function () {
                    if (popup.parentNode) {
                        popup.parentNode.removeChild(popup);
                    }
                }, 3700);
            }
        });
    </script>

    <script src="<%=request.getContextPath()%>/assets/js/bootstrap.bundle.min.js"></script>
    <script src="<%=request.getContextPath()%>/assets/js/tiny-slider.js"></script>
    <script src="<%=request.getContextPath()%>/assets/js/custom.js"></script>
</html>