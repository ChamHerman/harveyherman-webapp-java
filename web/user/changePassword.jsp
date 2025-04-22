<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <!-- Default Head -->
        <jsp:include page="head.jsp" />
        <title>Change Password - HarveyHerman</title>

        <!-- Bootstrap CSS -->
        <link href="<%=request.getContextPath()%>/assets/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">
        <link href="<%=request.getContextPath()%>/assets/css/tiny-slider.css" rel="stylesheet">
        <link href="<%=request.getContextPath()%>/assets/css/style.css" rel="stylesheet">
        <link href="<%=request.getContextPath()%>/assets/css/profile.css" rel="stylesheet">
    </head>

    <body>
        <jsp:include page="header.jsp" />

        <div class="profile-section">
            <div class="container">
                <div class="row justify-content-center">
                    <div class="col-md-8">
                        <div class="profile-card">
                            <h2 class="profile-title">Change Password</h2>

                            <% if (session.getAttribute("loggedInUser") != null) { %>

                            <% if (request.getParameter("error") != null) {%>
                            <div class="alert alert-danger">
                                <%= request.getParameter("error")%>
                            </div>
                            <% } %>

                            <% if (request.getParameter("success") != null) { %>
                            <div class="alert alert-success">
                                Password changed successfully!
                            </div>
                            <% }%>

                            <form action="<%=request.getContextPath()%>/user/ChangePasswordServlet" method="post">
                                <div class="mb-3 password-field-container">
                                    <label for="currentPassword" class="form-label">Current Password</label>
                                    <input type="password" class="form-control" id="currentPassword" name="currentPassword" required>
                                    <i class="password-toggle-icon fas fa-eye" id="toggleCurrentPassword"></i>
                                </div>

                                <div class="mb-3">
                                    <div class="password-field-container">
                                        <label for="newPassword" class="form-label">New Password</label>
                                        <input type="password" class="form-control" id="newPassword" name="newPassword" required minlength="6">

                                        <i class="password-toggle-icon fas fa-eye" id="toggleNewPassword"></i>
                                    </div>
                                    <div class="form-text">Password must be at least 6 characters long.</div>
                                </div>


                                <div class="mb-3 password-field-container">
                                    <label for="confirmNewPassword" class="form-label">Confirm New Password</label>
                                    <input type="password" class="form-control" id="confirmNewPassword" name="confirmNewPassword" required>
                                    <i class="password-toggle-icon fas fa-eye" id="toggleConfirmPassword"></i>
                                </div>

                                <div class="d-grid gap-2 d-md-flex justify-content-center">
                                    <a href="profile.jsp" class="btn btn-secondary me-md-2">Cancel</a>
                                    <button type="submit" class="btn btn-primary">Change Password</button>
                                </div>
                            </form>
                            <% } else { %>
                            <div class="profile-error">
                                <p>You are not logged in. Please <a href="login.jsp">login</a> to change your password.</p>
                            </div>
                            <% }%>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <jsp:include page="footer.jsp" />

        <script src="<%=request.getContextPath()%>/assets/js/bootstrap.bundle.min.js"></script>
        <script src="<%=request.getContextPath()%>/assets/js/tiny-slider.js"></script>
        <script src="<%=request.getContextPath()%>/assets/js/custom.js"></script>

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