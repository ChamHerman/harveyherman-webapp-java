<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.StaffData" %>
<jsp:useBean id="loggedInManager" class="model.StaffData" scope="session" />
<!DOCTYPE html>
<html lang="en">
    <head>
        <jsp:include page="/user/head.jsp" />
        <title>Edit Profile - Manager</title>
        <!-- Bootstrap CSS -->
        <link href="<%= request.getContextPath()%>/assets/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">
        <link href="<%= request.getContextPath()%>/assets/css/style.css" rel="stylesheet">
        <!-- Custom CSS -->
        <link href="<%= request.getContextPath()%>/assets/css/ap_index.css" rel="stylesheet">
        <link href="<%= request.getContextPath()%>/assets/css/ap_profile.css" rel="stylesheet">
    </head>
    <body>
        <!-- Side Bar -->
        <%@ include file="ap_sidebar.jsp" %>
        
        <!-- Main Content -->
        <div class="main-content">
            <div class="container">
                <div class="profile-card">
                    <h2 class="profile-title">Edit Profile</h2>
                    <% if (request.getParameter("error") != null) { %>
                    <div class="alert alert-danger">
                        <%= request.getAttribute("error")%>
                    </div>
                    <% } %>
                    
                    <%
                        if (loggedInManager != null) {
                    %>
                    <form action="<%= request.getContextPath()%>/manager/EditStaffServlet" method="post" autocomplete="off">
                        <div class="form-group">
                            <label for="fullname">Full Name</label>
                            <input type="text" class="form-control" id="fullname" name="fullname" value="<%= loggedInManager.getFullname() %>" required autocomplete="off">
                        </div>
                        <div class="form-group">
                            <label for="email">Email</label>
                            <input type="email" class="form-control" id="email" name="email" value="<%= loggedInManager.getEmail() %>" required autocomplete="off">
                        </div>
                        <div class="form-group">
                            <label for="contactNumber">Contact Number</label>
                            <input type="text" class="form-control" id="contactNumber" name="contactNumber" value="<%= loggedInManager.getContactNumber() != null ? loggedInManager.getContactNumber() : "" %>" autocomplete="off">
                        </div>
                        <div class="form-group">
                            <label for="address">Address</label>
                            <textarea class="form-control" id="address" name="address" rows="3" autocomplete="off"><%= loggedInManager.getAddress() != null ? loggedInManager.getAddress() : "" %></textarea>
                        </div>
                        <div class="form-group">
                            <label for="position">Position</label>
                            <input type="text" class="form-control" id="position" name="position" value="<%= loggedInManager.getPosition() %>" readonly autocomplete="off">
                        </div>
                        <div class="form-group">
                            <label for="gender">Gender</label>
                            <select class="form-control" id="gender" name="gender" autocomplete="off">
                                <option value="Male" <%= "Male".equals(loggedInManager.getGender()) ? "selected" : "" %>>Male</option>
                                <option value="Female" <%= "Female".equals(loggedInManager.getGender()) ? "selected" : "" %>>Female</option>
                                <option value="Other" <%= "Other".equals(loggedInManager.getGender()) ? "selected" : "" %>>Other</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <button type="submit" class="btn btn-primary">Save Changes</button>
                            <a href="<%= request.getContextPath()%>/manager/ap_profile.jsp" class="btn btn-outline-secondary">Cancel</a>
                        </div>
                    </form>
                    <% } else { %>
                    <div class="alert alert-danger">
                        You are not logged in. Please <a href="<%= request.getContextPath()%>/staff/ap_login.jsp">login</a> to edit your profile.
                    </div>
                    <% } %>
                </div>
            </div>
        </div>
        
        <script src="<%= request.getContextPath()%>/assets/js/bootstrap.bundle.min.js"></script>
        <script src="<%=request.getContextPath()%>/assets/js/validateForm.js"></script>
    </body>
</html>