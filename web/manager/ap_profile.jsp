<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.StaffData" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <jsp:include page="/user/head.jsp" />
        <title>Profile - Manager</title>
        <!-- Bootstrap CSS -->
        <link href="<%= request.getContextPath()%>/assets/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">
        <link href="<%= request.getContextPath()%>/assets/css/style.css" rel="stylesheet">
        <!-- Custom CSS -->
        <link href="<%= request.getContextPath()%>/assets/css/ap_index.css" rel="stylesheet">
        <link rel="stylesheet" href="<%= request.getContextPath()%>/assets/css/ap_profile.css">
    </head>
    <body>
        <!-- Side Bar -->
        <%@ include file="ap_sidebar.jsp" %>

        <!-- Main Content -->
        <div class="main-content">
            <div class="container">
                <div class="profile-card">
                    <h2 class="profile-title">Profile</h2>
                    <%
                        String successParam = request.getParameter("success");
                        if (successParam != null) {
                            if (successParam.equalsIgnoreCase("password")) {
                    %>
                    <div class="alert alert-success">
                        Password changed successfully!
                    </div>
                    <% } else if (successParam.equalsIgnoreCase("edit")) { %>
                    <div class="alert alert-success">
                        Profile edited successfully!
                    </div>
                    <% }
                        } %>

                    <%
                        StaffData staff = (StaffData) session.getAttribute("loggedInManager");
                        if (staff != null) {
                    %>
                    <div class="profile-info">
                        <div class="profile-item">
                            <label>Full Name</label>
                            <div class="detail-value"><%= staff.getFullname()%></div>
                        </div>
                        <div class="profile-item">
                            <label>Email</label>
                            <div class="detail-value"><%= staff.getEmail()%></div>
                        </div>
                        <div class="profile-item">
                            <label>Contact Number</label>
                            <div class="detail-value"><%= staff.getContactNumber() != null ? staff.getContactNumber() : "Not provided"%></div>
                        </div>
                        <div class="profile-item">
                            <label>Address</label>
                            <div class="detail-value"><%= staff.getAddress() != null ? staff.getAddress() : "Not provided"%></div>
                        </div>
                        <div class="profile-item">
                            <label>Position</label>
                            <div class="detail-value"><%= staff.getPosition()%></div>
                        </div>
                        <div class="profile-item">
                            <label>Gender</label>
                            <div class="detail-value"><%= staff.getGender()%></div>
                        </div>
                    </div>
                    <div class="profile-actions">
                        <a href="<%= request.getContextPath()%>/manager/ap_editProfile.jsp" class="btn btn-primary">Edit Profile</a>
                        <a href="<%= request.getContextPath()%>/manager/ap_changePassword.jsp" class="btn btn-outline-secondary">Change Password</a>
                        <a href="<%= request.getContextPath()%>/manager/StaffLogoutServlet" class="btn btn-danger">Logout</a>
                    </div>
                    <% } else {%>
                    <div class="alert alert-danger">
                        You are not logged in. Please <a href="<%= request.getContextPath()%>/staff/ap_login.jsp">login</a> to view your profile.
                    </div>
                    <% }%>
                </div>
            </div>
        </div>

        <script src="<%= request.getContextPath()%>/assets/js/bootstrap.bundle.min.js"></script>
    </body>
</html>