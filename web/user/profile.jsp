<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.UserData" %>
<%@ page import="java.text.SimpleDateFormat" %>
<jsp:useBean id="loggedInUser" class="model.UserData" scope="session" />
<!DOCTYPE html>
<html lang="en">
    <head>
        <!-- Default Head -->
        <jsp:include page="head.jsp" />
        <title>User Profile - HarveyHerman</title>

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
                            <h2 class="profile-title">User Profile</h2>

                            <% if (loggedInUser != null) { 
                                SimpleDateFormat dateFormat = new SimpleDateFormat("dd MMMM yyyy");
                                String birthDateStr = loggedInUser.getBirthDate() != null ? dateFormat.format(loggedInUser.getBirthDate()) : "Not provided";
                            %>
                            <div class="profile-info">
                                <div class="profile-details">
                                    <div class="profile-item">
                                        <label>Full Name</label>
                                        <div class="detail-value">${loggedInUser.fullname}</div>
                                    </div>

                                    <div class="profile-item">
                                        <label>Email</label>
                                        <div class="detail-value">${loggedInUser.email}</div>
                                    </div>

                                    <div class="profile-item">
                                        <label>Contact Number</label>
                                        <div class="detail-value"><%= loggedInUser.getContactNumber() != null ? loggedInUser.getContactNumber() : "Not provided"%></div>
                                    </div>

                                    <div class="profile-item">
                                        <label>Address</label>
                                        <div class="detail-value"><%= loggedInUser.getAddress() != null ? loggedInUser.getAddress() : "Not provided"%></div>
                                    </div>

                                    <div class="profile-item">
                                        <label>Birth Date</label>
                                        <div class="detail-value"><%= birthDateStr%></div>
                                    </div>

                                    <div class="profile-item">
                                        <label>Account Created</label>
                                        <div class="detail-value"><%= loggedInUser.getCreatedDate() != null ? dateFormat.format(loggedInUser.getCreatedDate()) : "Not available"%></div>
                                    </div>
                                </div>
                            </div>

                            <div class="profile-actions">
                                <a href="editProfile.jsp" class="btn btn-primary">Edit Profile</a>
                                <a href="changePassword.jsp" class="btn btn-secondary">Change Password</a>
                                <button type="button" class="btn btn-danger" data-bs-toggle="modal" data-bs-target="#deleteAccountModal">
                                    Delete Account
                                </button>
                            </div>

                            <div class="modal fade" id="deleteAccountModal" tabindex="-1" aria-labelledby="deleteAccountModalLabel" aria-hidden="true">
                                <div class="modal-dialog">
                                    <div class="modal-content">
                                        <div class="modal-header">
                                            <h5 class="modal-title" id="deleteAccountModalLabel">Confirm Account Deletion</h5>
                                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                        </div>
                                        <div class="modal-body">
                                            <p>Are you sure you want to delete your account? This action cannot be undone.</p>
                                            <p>Please enter your password to confirm deletion:</p>

                                            <form action="<%=request.getContextPath()%>/user/UserDeleteAccountServlet" method="post" id="deleteAccountForm">
                                                <div class="mb-3 password-field-container">
                                                    <label for="confirmPassword" class="form-label">Password</label>
                                                    <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" required>
                                                    <span class="password-toggle-icon" id="toggleDeletePassword">
                                                        <i class="fas fa-eye"></i>
                                                    </span>
                                                </div>
                                                <% if (request.getParameter("error") != null) { %>
                                                <div class="alert alert-danger">
                                                    Incorrect password. Account deletion canceled.
                                                </div>
                                                <% } %>
                                            </form>
                                        </div>
                                        <div class="modal-footer">
                                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                                            <button type="submit" form="deleteAccountForm" class="btn btn-danger">Delete My Account</button>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <% } else { %>
                            <div class="profile-error">
                                <p>You are not logged in. Please <a href="login.jsp">login</a> to view your profile.</p>
                            </div>
                            <% }%>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </body>
    <!-- Notification Popup -->
    <%
        Boolean profileUpdateSuccess = (Boolean) request.getAttribute("profileUpdateSuccess");
        Boolean changePasswordSuccess = (Boolean) request.getAttribute("changePasswordSuccess");
        if (profileUpdateSuccess != null && profileUpdateSuccess) {
    %>
    <div id="notification-popup">
        <i class="fa fa-check-circle me-2" style="color:#ffd700;"></i>Profile updated successfully!
    </div>
    <%
        } else if (changePasswordSuccess != null && changePasswordSuccess) {
    %>
    <div id="notification-popup">
        <i class="fa fa-check-circle me-2" style="color:#ffd700;"></i>Password changed successfully!
    </div>
    <%
        }
    %>
    <jsp:include page="footer.jsp" />

    <script>
        document.addEventListener('DOMContentLoaded', function () {
            const toggleDeletePassword = document.querySelector('#toggleDeletePassword');
            const confirmPassword = document.querySelector('#confirmPassword');

            if (toggleDeletePassword && confirmPassword) {
                toggleDeletePassword.addEventListener('click', function () {
                    // Toggle the type attribute
                    const type = confirmPassword.getAttribute('type') === 'password' ? 'text' : 'password';
                    confirmPassword.setAttribute('type', type);

                    // Toggle the eye / eye slash icon
                    const icon = this.querySelector('i');
                    if (icon) {
                        icon.classList.toggle('fa-eye');
                        icon.classList.toggle('fa-eye-slash');
                    }
                });
            }

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