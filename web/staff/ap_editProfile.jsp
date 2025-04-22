<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.StaffData" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Edit Profile - Staff</title>
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
                    <%
                        StaffData staff = (StaffData) session.getAttribute("loggedInStaff");
                        if (staff != null) {
                    %>
                    <form action="<%= request.getContextPath()%>/staff/EditStaffServlet" method="post">
                        <div class="form-group">
                            <label for="fullname">Full Name</label>
                            <input type="text" class="form-control" id="fullname" name="fullname" value="<%= staff.getFullname() %>" required autocomplete="off">
                        </div>
                        <div class="form-group">
                            <label for="email">Email</label>
                            <input type="email" class="form-control" id="email" name="email" value="<%= staff.getEmail() %>" required autocomplete="off">
                        </div>
                        <div class="form-group">
                            <label for="contactNumber">Contact Number</label>
                            <input type="text" class="form-control" id="contactNumber" name="contactNumber" value="<%= staff.getContactNumber() != null ? staff.getContactNumber() : "" %>" autocomplete="off">
                        </div>
                        <div class="form-group">
                            <label for="address">Address</label>
                            <textarea class="form-control" id="address" name="address" rows="3" autocomplete="off"><%= staff.getAddress() != null ? staff.getAddress() : "" %></textarea>
                        </div>
                        <div class="form-group">
                            <label for="position">Position</label>
                            <input type="text" class="form-control" id="position" name="position" value="<%= staff.getPosition() %>" readonly>
                        </div>
                        <div class="form-group">
                            <label for="gender">Gender</label>
                            <select class="form-control" id="gender" name="gender" autocomplete="off">
                                <option value="Male" <%= "Male".equals(staff.getGender()) ? "selected" : "" %>>Male</option>
                                <option value="Female" <%= "Female".equals(staff.getGender()) ? "selected" : "" %>>Female</option>
                                <option value="Other" <%= "Other".equals(staff.getGender()) ? "selected" : "" %>>Other</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <button type="submit" class="btn btn-primary">Save Changes</button>
                            <a href="<%= request.getContextPath()%>/staff/ap_profile.jsp" class="btn btn-outline-secondary">Cancel</a>
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
    </body>
</html>