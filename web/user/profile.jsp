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
                                        <div class="detail-value"><%= user.getFullName()%></div>
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