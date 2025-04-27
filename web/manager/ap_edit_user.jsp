<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="javax.naming.InitialContext" %>
<%@ page import="model.UserData" %>
<%@ page import="model.UserDataDAO" %>
<%@ page import="model.UserLogin" %>
<%@ page import="model.UserLoginDAO" %>

<%
    UserDataDAO userDataDAO = null;
    UserLoginDAO userLoginDAO = null;
    try {
        InitialContext context = new InitialContext();
        userDataDAO = (UserDataDAO) context.lookup("java:global/HarveyHerman/UserDataDAO");
        userLoginDAO = (UserLoginDAO) context.lookup("java:global/HarveyHerman/UserLoginDAO");
    } catch (Exception e) {
        e.printStackTrace();
    }

    UserData userData = null;
    UserLogin userLogin = null;
    String userId = request.getParameter("userId");

    if (userId != null) {
        userData = userDataDAO.findByUserId(userId);
        userLogin = userLoginDAO.findByUserId(userId);
    }

    // Format date to yyyy-MM-dd for input field
    String birthDateStr = "";
    if (userData != null && userData.getBirthDate() != null) {
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
        birthDateStr = dateFormat.format(userData.getBirthDate());
    }

    // Define security questions
    String[] securityQuestions = {
        "What is your favorite color?",
        "What is your nickname?",
        "Which animal do you like?"
    };
%>

<!DOCTYPE html>
<html lang="en">
    <head>
        <jsp:include page="/user/head.jsp" />
        <title>Edit User - Manager</title>
        <!-- Bootstrap CSS -->
        <link href="<%= request.getContextPath()%>/assets/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">
        <link href="<%= request.getContextPath()%>/assets/css/style.css" rel="stylesheet">
        <!-- Custom CSS -->
        <link href="<%= request.getContextPath()%>/assets/css/ap_index.css" rel="stylesheet">
        <link href="<%= request.getContextPath()%>/assets/css/ap_user.css" rel="stylesheet">
        <style>
            .form-label {
                color: #000000;
            }
        </style>
    </head>
    <body>
        <%@ include file="ap_sidebar.jsp" %>
        <div class="main-content flex-grow-1">
            <div class="container mt-4">
                <h2>Edit User</h2>

                <% if (userData == null) { %>
                <div class="alert alert-danger mt-4">User not found.</div>
                <% } else {%>

                <div class="card">
                    <div class="card-header">
                        <h5>Editing User: <%= userData.getFullname()%> (ID: <%= userData.getUserId()%>)</h5>
                    </div>
                    <div class="card-body">
                        <form id="editUserForm" method="post" action="<%= request.getContextPath()%>/manager/EditUsersServlet" autocomplete="off">
                            <input type="hidden" name="userId" value="<%= userData.getUserId()%>" autocomplete="off">

                            <!-- Personal Information Section -->
                            <h4 class="mb-3">Personal Information</h4>

                            <div class="row mb-3">
                                <div class="col-md-6">
                                    <label for="fullname" class="form-label">Full Name <span class="text-danger">*</span></label>
                                    <input type="text" class="form-control" id="fullname" name="fullname" value="<%= userData.getFullname()%>" required autocomplete="off">
                                </div>
                                <div class="col-md-6">
                                    <label for="email" class="form-label">Email <span class="text-danger">*</span></label>
                                    <input type="email" class="form-control" id="email" name="email" value="<%= userData.getEmail()%>" required autocomplete="off">
                                </div>
                            </div>

                            <div class="row mb-3">
                                <div class="col-md-6">
                                    <label for="contactNumber" class="form-label">Contact Number <span class="text-danger">*</span></label>
                                    <input type="text" class="form-control" id="contactNumber" name="contactNumber" value="<%= userData.getContactNumber()%>" required autocomplete="off">
                                </div>
                                <div class="col-md-6">
                                    <label for="birthDate" class="form-label">Birth Date</label>
                                    <input type="date" class="form-control" id="birthDate" name="birthDate" value="<%= birthDateStr%>" autocomplete="off">
                                </div>
                            </div>

                            <div class="row mb-3">
                                <div class="col-md-6">
                                    <label for="gender" class="form-label">Gender <span class="text-danger">*</span></label>
                                    <select class="form-select" id="gender" name="gender" required autocomplete="off">
                                        <option value="">Select gender...</option>
                                        <option value="Male" <%= "Male".equals(userData.getGender()) ? "selected" : ""%>>Male</option>
                                        <option value="Female" <%= "Female".equals(userData.getGender()) ? "selected" : ""%>>Female</option>
                                        <option value="Other" <%= "Other".equals(userData.getGender()) ? "selected" : ""%>>Other</option>
                                    </select>
                                </div>
                            </div>

                            <div class="mb-3">
                                <label for="address" class="form-label">Address</label>
                                <textarea class="form-control" id="address" name="address" rows="3" autocomplete="off"><%= userData.getAddress() != null ? userData.getAddress() : ""%></textarea>
                            </div>

                            <% if (userLogin != null) {%>
                            <!-- Account Information Section -->
                            <h4 class="mb-3 mt-4">Account Information</h4>

                            <div class="row mb-3">
                                <div class="col-md-6">
                                    <label class="form-label">Username</label>
                                    <input type="text" class="form-control" id="username" name="username" value="<%= userLogin.getUsername()%>" required autocomplete="off">
                                </div>
                                <div class="col-md-6">
                                    <label for="securityQuestion" class="form-label">Security Question</label>
                                    <select class="form-select" id="securityQuestion" name="securityQuestion" autocomplete="off">
                                        <option value="">Current: "<%= userLogin.getChallengeQuestion()%>"</option>
                                        <% for (String question : securityQuestions) {
                                                if (!question.equals(userLogin.getChallengeQuestion())) {%>
                                        <option value="<%= question%>"><%= question%></option>
                                        <% }
                                                }%>
                                    </select>
                                    <div class="form-text">Only change if you want to update the security question.</div>
                                </div>
                            </div>

                            <div class="row mb-3">
                                <div class="col-md-6">
                                    <label for="securityAnswer" class="form-label">Security Answer</label>
                                    <input type="text" class="form-control" id="securityAnswer" name="securityAnswer" 
                                           placeholder="Current: <%= userLogin.getAnswer()%>" autocomplete="off">
                                    <div class="form-text">Only fill if you want to update the security answer.</div>
                                </div>
                            </div>
                            <% }%>

                            <div class="d-flex justify-content-between mt-4">
                                <div>
                                    <button type="submit" class="btn btn-primary">Save Changes</button>
                                    <a href="<%= request.getContextPath()%>/manager/ap_user.jsp" class="btn btn-secondary ms-2">Cancel</a>
                                </div>
                                <% if (userLogin != null) { %>
                                <div>
                                    <button type="button" class="btn btn-warning" data-bs-toggle="modal" data-bs-target="#resetPasswordModal">
                                        Reset Password
                                    </button>
                                </div>
                                <% } %>
                            </div>
                        </form>
                    </div>
                </div>
                <% }%>
            </div>
        </div>

        <!-- Reset Password Confirmation Modal -->
        <div class="modal fade" id="resetPasswordModal" tabindex="-1" aria-labelledby="resetPasswordModalLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="resetPasswordModalLabel">Confirm Password Reset</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <p>Are you sure you want to reset this user's password to the default value "password"?</p>
                        <form id="resetPasswordForm" method="post" action="<%= request.getContextPath()%>/manager/EditUsersServlet">
                            <input type="hidden" name="userId" value="<%= userData != null ? userData.getUserId() : ""%>">
                            <input type="hidden" name="resetPassword" value="true">
                        </form>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" form="resetPasswordForm" class="btn btn-warning">Reset Password</button>
                    </div>
                </div>
            </div>
        </div>

        <!-- Loading Modal -->
        <div class="modal fade" id="loadingModal" tabindex="-1" data-bs-backdrop="static" data-bs-keyboard="false" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content">
                    <div class="modal-body text-center p-4">
                        <div class="spinner-border text-primary" role="status">
                            <span class="visually-hidden">Loading...</span>
                        </div>
                        <h5 class="mt-3">Processing...</h5>
                    </div>
                </div>
            </div>
        </div>

        <script src="<%= request.getContextPath()%>/assets/js/bootstrap.bundle.min.js"></script>
        <script src="<%= request.getContextPath()%>/assets/js/ap_user.js"></script>
        <script src="<%=request.getContextPath()%>/assets/js/validateForm.js"></script>
    </body>
</html> 