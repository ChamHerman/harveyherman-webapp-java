<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="model.UserDataDAO" %>
<%@ page import="model.UserData" %>
<%@ page import="model.UserLoginDAO" %>
<%@ page import="model.UserLogin" %>
<%@ page import="javax.naming.InitialContext" %>
<%@ page import="javax.naming.NamingException" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <jsp:include page="/user/head.jsp" />
        <title>User Management - Manager</title>
        <!-- Bootstrap CSS -->
        <link href="<%= request.getContextPath()%>/assets/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">
        <link href="<%= request.getContextPath()%>/assets/css/style.css" rel="stylesheet">
        <!-- Custom CSS -->
        <link href="<%= request.getContextPath()%>/assets/css/ap_index.css" rel="stylesheet">
        <link href="<%= request.getContextPath()%>/assets/css/ap_user.css" rel="stylesheet">
    </head>
    <body>
        <%@ include file="ap_sidebar.jsp" %>
        <div class="main-content flex-grow-1">
            <div class="container">

                <%            UserDataDAO userDataDAO = null;
                    try {
                        InitialContext context = new InitialContext();
                        userDataDAO = (UserDataDAO) context.lookup("java:global/HarveyHerman/UserDataDAO");
                    } catch (NamingException ne) {
                        ne.printStackTrace();
                    }
                    List<UserData> allUsers = userDataDAO.findAllUsers();

                    String paramSearch = request.getParameter("search");
                    if (paramSearch == null) {
                        paramSearch = "";
                    }

                    // Filter by name or email
                    List<UserData> filteredUsers = new ArrayList<UserData>();
                    for (UserData user : allUsers) {
                        if (user.getFullname() != null && user.getFullname().toLowerCase().contains(paramSearch.toLowerCase())) {
                            filteredUsers.add(user);
                        } else if (user.getEmail() != null && user.getEmail().toLowerCase().contains(paramSearch.toLowerCase())) {
                            filteredUsers.add(user);
                        }
                    }

                    // Sort by createdDate desc by default
                    Collections.sort(filteredUsers, new Comparator<UserData>() {
                        public int compare(UserData u1, UserData u2) {
                            if (u1.getCreatedDate() == null || u2.getCreatedDate() == null) {
                                return 0;
                            }
                            return u2.getCreatedDate().compareTo(u1.getCreatedDate());
                        }
                    });

                    // Pagination
                    int rowCount = 15;
                    String paramRows = request.getParameter("rows");
                    if (paramRows != null) {
                        try {
                            rowCount = Integer.parseInt(paramRows);
                        } catch (Exception e) {
                        }
                    }
                    int currentPage = 1;
                    String paramPage = request.getParameter("page");
                    if (paramPage != null) {
                        try {
                            currentPage = Integer.parseInt(paramPage);
                        } catch (Exception e) {
                        }
                    }
                    int totalUsers = filteredUsers.size();
                    int totalPages = (int) Math.ceil((double) totalUsers / rowCount);
                    if (currentPage < 1) {
                        currentPage = 1;
                    }
                    if (currentPage > totalPages && totalPages > 0) {
                        currentPage = totalPages;
                    }
                    int startIdx = (currentPage - 1) * rowCount;
                    int endIdx = Math.min(startIdx + rowCount, totalUsers);
                    List<UserData> limitedUsers = (startIdx < endIdx) ? filteredUsers.subList(startIdx, endIdx) : new ArrayList<UserData>();
                %>
                <h2 style="text-align: center; margin-bottom: 2rem;">User Management</h2>
                <!-- Dashboard Overview -->
                <div class="dashboard-summary">
                    <div class="summary-box fs-6">Total Users: <%= allUsers.size()%></div>
                </div>

                <!-- Filter/Search -->
                <form method="GET" action="ap_user.jsp" autocomplete="off">
                    <div class="filter-section row mb-3">
                        <div class="col-md-6">
                            <label>Search:</label>
                            <div class="input-group">
                                <input type="text" id="searchInput" name="search" class="form-control" value="<%= paramSearch%>" placeholder="Search by name or email..." autocomplete="off">
                                <button class="btn btn-outline-secondary" id="clearSearch" type="button">Clear</button>
                                <button class="btn btn-outline-secondary" type="submit">Search</button>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <label>Show Rows:</label>
                            <select name="rows" class="form-select" onchange="this.form.submit()" autocomplete="off">
                                <option value="15" <%= rowCount == 15 ? "selected" : ""%>>15</option>
                                <option value="30" <%= rowCount == 30 ? "selected" : ""%>>30</option>
                                <option value="50" <%= rowCount == 50 ? "selected" : ""%>>50</option>
                            </select>
                        </div>
                        <div class="col-md-3 d-flex align-items-end">
                            <button type="button" id="addUserBtn" class="btn btn-primary w-100">Add Customer</button>
                        </div>
                    </div>
                </form>

                <!-- User Table -->
                <table class="item-table">
                    <thead>
                        <tr>
                            <th>No</th>
                            <th>User ID</th>
                            <th>Full Name</th>
                            <th>Email</th>
                            <th>Contact</th>
                            <th>Created Date</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody id="itemTableBody">
                        <% if (limitedUsers.isEmpty()) { %>
                        <tr>
                            <td colspan="7" class="text-center">No users found.</td>
                        </tr>
                        <% } else {
                            int i = 1 + (currentPage - 1) * rowCount;
                            for (UserData user : limitedUsers) {%>
                        <tr>
                            <td><%= i++%></td>
                            <td><%= user.getUserId()%></td>
                            <td><%= user.getFullname()%></td>
                            <td><%= user.getEmail()%></td>
                            <td><%= user.getContactNumber()%></td>
                            <td><%= user.getCreatedDate() != null ? user.getCreatedDate() : ""%></td>
                            <td>
                                <button class="btn btn-edit btn-sm" onclick="editUser('<%= user.getUserId()%>')">Edit</button>
                                <button class="btn btn-view btn-sm" onclick="viewUser('<%= user.getUserId()%>')">View</button>
                                <button class="btn btn-delete btn-sm" onclick="deleteUser('<%= user.getUserId()%>')">Delete</button>
                            </td>
                        </tr>
                        <% }
                            } %>
                    </tbody>
                </table>

                <!-- Pagination -->
                <% if (totalPages > 1) {%>
                <div class="d-flex justify-content-end align-items-center mt-3">
                    <nav>
                        <ul class="pagination mb-0">
                            <li class="page-item <%= (currentPage == 1) ? "disabled" : ""%>">
                                <a class="page-link" href="ap_user.jsp?page=<%= currentPage - 1%>&search=<%= paramSearch%>&rows=<%= rowCount%>">&laquo; Prev</a>
                            </li>
                            <% for (int p = 1; p <= totalPages; p++) {%>
                            <li class="page-item <%= (p == currentPage) ? "active" : ""%>">
                                <a class="page-link" href="ap_user.jsp?page=<%= p%>&search=<%= paramSearch%>&rows=<%= rowCount%>"><%= p%></a>
                            </li>
                            <% }%>
                            <li class="page-item <%= (currentPage == totalPages) ? "disabled" : ""%>">
                                <a class="page-link" href="ap_user.jsp?page=<%= currentPage + 1%>&search=<%= paramSearch%>&rows=<%= rowCount%>">Next &raquo;</a>
                            </li>
                        </ul>
                    </nav>
                </div>
                <% }%>

            </div>
        </div>

        <!-- View User Modal -->
        <div class="modal fade" id="viewUserModal" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog modal-lg">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">User Details</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <div class="container">
                            <h4 class="mb-4 text-center">User Information</h4>
                            <div class="row mb-2">
                                <div class="col-sm-4 text-end fw-bold">User ID:</div>
                                <div class="col-sm-8" id="viewUserId"></div>
                            </div>
                            <div class="row mb-2">
                                <div class="col-sm-4 text-end fw-bold">Full Name:</div>
                                <div class="col-sm-8" id="viewFullName"></div>
                            </div>
                            <div class="row mb-2">
                                <div class="col-sm-4 text-end fw-bold">Email:</div>
                                <div class="col-sm-8" id="viewEmail"></div>
                            </div>
                            <div class="row mb-2">
                                <div class="col-sm-4 text-end fw-bold">Contact Number:</div>
                                <div class="col-sm-8" id="viewContactNumber"></div>
                            </div>
                            <div class="row mb-2">
                                <div class="col-sm-4 text-end fw-bold">Address:</div>
                                <div class="col-sm-8" id="viewAddress"></div>
                            </div>
                            <div class="row mb-2">
                                <div class="col-sm-4 text-end fw-bold">Birth Date:</div>
                                <div class="col-sm-8" id="viewBirthDate"></div>
                            </div>
                            <div class="row mb-2">
                                <div class="col-sm-4 text-end fw-bold">Gender:</div>
                                <div class="col-sm-8" id="viewGender"></div>
                            </div>
                            <div class="row mb-2">
                                <div class="col-sm-4 text-end fw-bold">Created Date:</div>
                                <div class="col-sm-8" id="viewCreatedDate"></div>
                            </div>

                            <h4 class="mb-4 mt-4 text-center">Login Information</h4>
                            <div class="row mb-2">
                                <div class="col-sm-4 text-end fw-bold">Login ID:</div>
                                <div class="col-sm-8" id="viewLoginId"></div>
                            </div>
                            <div class="row mb-2">
                                <div class="col-sm-4 text-end fw-bold">Username:</div>
                                <div class="col-sm-8" id="viewUsername"></div>
                            </div>
                            <div class="row mb-2">
                                <div class="col-sm-4 text-end fw-bold">Challenge Question:</div>
                                <div class="col-sm-8" id="viewChallengeQuestion"></div>
                            </div>
                            <div class="row mb-2">
                                <div class="col-sm-4 text-end fw-bold">Answer:</div>
                                <div class="col-sm-8" id="viewAnswer"></div>
                            </div>
                            <div class="row mb-2">
                                <div class="col-sm-4 text-end fw-bold">Last Login:</div>
                                <div class="col-sm-8" id="viewLastLogin"></div>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                    </div>
                </div>
            </div>
        </div>

        <!-- Result Message Modal -->
        <div class="modal fade" id="userResultMessageModal" tabindex="-1" aria-labelledby="userResultMessageModalLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="userResultMessageModalLabel">System Message</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <div id="userResultMessage" class="item-result-message"></div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
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

        <!-- Delete User Confirmation Modal -->
        <div class="modal fade" id="deleteUserModal" tabindex="-1" aria-labelledby="deleteUserModalLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="deleteUserModalLabel">Confirm Deletion</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <p>Are you sure you want to delete this user? This action cannot be undone.</p>
                        <form id="deleteUserForm" method="post" action="<%= request.getContextPath()%>/manager/DeleteUsersServlet" autocomplete="off">
                            <input type="hidden" id="deleteUserId" name="userId" value="" autocomplete="off">
                        </form>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" form="deleteUserForm" class="btn btn-danger">Delete</button>
                    </div>
                </div>
            </div>
        </div>

        <script>
            var contextPath = '<%= request.getContextPath()%>';
        </script>
        <script src="<%= request.getContextPath()%>/assets/js/bootstrap.bundle.min.js"></script>
        <script src="<%= request.getContextPath()%>/assets/js/ap_user.js"></script>
    </body>
</html>