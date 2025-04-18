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
        <title>Edit Profile - HarveyHerman</title>
    </head>

    <body>
        <jsp:include page="header.jsp" />

        <div class="profile-section">
            <div class="container">
                <div class="row justify-content-center">
                    <div class="col-md-8">
                        <div class="profile-card">
                            <h2 class="profile-title">Edit Profile</h2>

                            <%
                                UserData user = (UserData) session.getAttribute("loggedInUser");
                                if (user != null) {
                                    SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
                                    String birthDateStr = user.getBirthDate() != null ? dateFormat.format(user.getBirthDate()) : "";
                            %>
                            <% if (request.getAttribute("updateMessage") != null) {%>
                            <div class="alert alert-success text-center mb-4">
                                <%= request.getAttribute("updateMessage")%>
                            </div>
                            <% }%>

                            <form action="<%=request.getContextPath()%>/user/EditUserServlet" method="post" class="profile-edit-form">
                                <input type="hidden" name="userId" value="<%= user.getUserId()%>">

                                <div class="profile-info">
                                    <div class="profile-details">
                                        <div class="profile-item">
                                            <label for="fullName">Full Name</label>
                                            <input type="text" id="fullName" name="fullName" class="form-control" value="<%= user.getFullname()%>" required>
                                        </div>

                                        <div class="profile-item">
                                            <label for="email">Email</label>
                                            <input type="email" id="email" name="email" class="form-control" value="<%= user.getEmail()%>" required>
                                        </div>

                                        <div class="profile-item">
                                            <label for="contactNumber">Contact Number</label>
                                            <input type="tel" id="contactNumber" name="contactNumber" class="form-control" value="<%= user.getContactNumber() != null ? user.getContactNumber() : ""%>">
                                        </div>

                                        <div class="profile-item">
                                            <label for="address">Address</label>
                                            <textarea id="address" name="address" class="form-control" rows="3"><%= user.getAddress() != null ? user.getAddress() : ""%></textarea>
                                        </div>

                                        <div class="profile-item">
                                            <label for="birthDate">Birth Date</label>
                                            <input type="date" id="birthDate" name="birthDate" class="form-control" value="<%= birthDateStr%>">
                                        </div>
                                    </div>
                                </div>

                                <form action="<%=request.getContextPath()%>/user/EditUserServlet" method="post" class="profile-edit-form">
                                    <div class="profile-actions">
                                        <button type="submit" class="btn btn-primary">Save Changes</button>
                                        <a href="profile.jsp" class="btn btn-secondary">Discard Changes</a>
                                    </div>
                                </form>
                            </form>

                            <% } else { %>
                            <div class="profile-error">
                                <p>You are not logged in. Please <a href="login.jsp">login</a> to edit your profile.</p>
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