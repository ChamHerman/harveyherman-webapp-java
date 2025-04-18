<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.UserData" %>
<%@ page import="java.text.SimpleDateFormat" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <meta name="author" content="HarveyHerman">
        <link rel="shortcut icon" href="favicon.png">

        <meta name="description" content="" />
        <meta name="keywords" content="bootstrap, bootstrap4" />

        <!-- Bootstrap CSS -->
        <link href="<%=request.getContextPath()%>/assets/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">
        <link href="<%=request.getContextPath()%>/assets/css/tiny-slider.css" rel="stylesheet">
        <link href="<%=request.getContextPath()%>/assets/css/style.css" rel="stylesheet">
        <link href="<%=request.getContextPath()%>/assets/css/profile.css" rel="stylesheet">
        <title>User Profile - HarveyHerman</title>
    </head>

    <body>
        <jsp:include page="header.jsp" />

        <div class="profile-section">
            <div class="container">
                <div class="row justify-content-center">
                    <div class="col-md-8">
                        <div class="profile-card">
                            <h2 class="profile-title">User Profile</h2>

                            <%
                                UserData user = (UserData) session.getAttribute("loggedInUser");
                                if (user != null) {
                                    SimpleDateFormat dateFormat = new SimpleDateFormat("dd MMMM yyyy");
                                    String birthDateStr = user.getBirthDate() != null ? dateFormat.format(user.getBirthDate()) : "Not provided";
                            %>
                            <div class="profile-info">
                                <div class="profile-details">
                                    <div class="profile-item">
                                        <label>Full Name</label>
                                        <div class="detail-value"><%= user.getFullname()%></div>
                                    </div>

                                    <div class="profile-item">
                                        <label>Email</label>
                                        <div class="detail-value"><%= user.getEmail()%></div>
                                    </div>

                                    <div class="profile-item">
                                        <label>Contact Number</label>
                                        <div class="detail-value"><%= user.getContactNumber() != null ? user.getContactNumber() : "Not provided"%></div>
                                    </div>

                                    <div class="profile-item">
                                        <label>Address</label>
                                        <div class="detail-value"><%= user.getAddress() != null ? user.getAddress() : "Not provided"%></div>
                                    </div>

                                    <div class="profile-item">
                                        <label>Birth Date</label>
                                        <div class="detail-value"><%= birthDateStr%></div>
                                    </div>

                                    <div class="profile-item">
                                        <label>Account Created</label>
                                        <div class="detail-value"><%= user.getCreatedDate() != null ? dateFormat.format(user.getCreatedDate()) : "Not available"%></div>
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
                                                <div class="mb-3">
                                                    <label for="confirmPassword" class="form-label">Password</label>
                                                    <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" required>
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

        <jsp:include page="footer.jsp" />

        <script src="<%=request.getContextPath()%>/assets/js/bootstrap.bundle.min.js"></script>
        <script src="<%=request.getContextPath()%>/assets/js/tiny-slider.js"></script>
        <script src="<%=request.getContextPath()%>/assets/js/custom.js"></script>
    </body>
</html>