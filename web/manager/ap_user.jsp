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
    <meta charset="UTF-8">
    <title>Customer Management - Manager</title>
    <link href="<%= request.getContextPath()%>/assets/css/bootstrap.min.css" rel="stylesheet">
    <link href="<%= request.getContextPath()%>/assets/css/ap_index.css" rel="stylesheet">
    <link href="<%= request.getContextPath()%>/assets/css/ap_item.css" rel="stylesheet">
    <link href="<%= request.getContextPath()%>/assets/css/ap_user.css" rel="stylesheet">
</head>
<body>
<%@ include file="ap_sidebar.jsp" %>
<div class="main-content flex-grow-1">
    <%@ include file="/staff/ap_item_navbar.jsp" %>
    <div class="container">

        <%
            UserDataDAO userDataDAO = null;
            try {
                InitialContext context = new InitialContext();
                userDataDAO = (UserDataDAO) context.lookup("java:global/HarveyHerman/UserDataDAO");
            } catch (NamingException ne) {
                ne.printStackTrace();
            }
            List<UserData> allUsers = userDataDAO.findAll();

            // Filtering, sorting, pagination logic (similar to ap_item.jsp)
            String paramSearch = request.getParameter("search");
            if (paramSearch == null) paramSearch = "";

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
                    if (u1.getCreatedDate() == null || u2.getCreatedDate() == null) return 0;
                    return u2.getCreatedDate().compareTo(u1.getCreatedDate());
                }
            });

            // Pagination
            int rowCount = 15;
            String paramRows = request.getParameter("rows");
            if (paramRows != null) {
                try { rowCount = Integer.parseInt(paramRows); } catch (Exception e) {}
            }
            int currentPage = 1;
            String paramPage = request.getParameter("page");
            if (paramPage != null) {
                try { currentPage = Integer.parseInt(paramPage); } catch (Exception e) {}
            }
            int totalUsers = filteredUsers.size();
            int totalPages = (int) Math.ceil((double) totalUsers / rowCount);
            if (currentPage < 1) currentPage = 1;
            if (currentPage > totalPages && totalPages > 0) currentPage = totalPages;
            int startIdx = (currentPage - 1) * rowCount;
            int endIdx = Math.min(startIdx + rowCount, totalUsers);
            List<UserData> limitedUsers = (startIdx < endIdx) ? filteredUsers.subList(startIdx, endIdx) : new ArrayList<UserData>();
        %>

        <!-- Dashboard Overview -->
        <div class="dashboard-summary">
            <div class="summary-box fs-6">Total Users: <%= allUsers.size() %></div>
        </div>

        <!-- Filter/Search -->
        <form method="GET" action="ap_customer.jsp">
            <div class="filter-section row mb-3">
                <div class="col-md-6">
                    <label>Search:</label>
                    <div class="input-group">
                        <input type="text" name="search" class="form-control" value="<%= paramSearch %>" placeholder="Search by name or email...">
                        <button class="btn btn-outline-secondary" type="submit">Search</button>
                    </div>
                </div>
                <div class="col-md-3">
                    <label>Show Rows:</label>
                    <select name="rows" class="form-select" onchange="this.form.submit()">
                        <option value="15" <%= rowCount==15 ? "selected" : "" %>>15</option>
                        <option value="30" <%= rowCount==30 ? "selected" : "" %>>30</option>
                        <option value="50" <%= rowCount==50 ? "selected" : "" %>>50</option>
                    </select>
                </div>
                <div class="col-md-3 d-flex align-items-end">
                    <button type="button" class="btn btn-primary w-100" data-bs-toggle="modal" data-bs-target="#addCustomerModal">Add Customer</button>
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
            <tbody>
                <% if (limitedUsers.isEmpty()) { %>
                <tr>
                    <td colspan="7" class="text-center">No users found.</td>
                </tr>
                <% } else {
                    int i = 1 + (currentPage-1)*rowCount;
                    for (UserData user : limitedUsers) { %>
                <tr>
                    <td><%= i++ %></td>
                    <td><%= user.getUserId() %></td>
                    <td><%= user.getFullname() %></td>
                    <td><%= user.getEmail() %></td>
                    <td><%= user.getContactNumber() %></td>
                    <td><%= user.getCreatedDate() != null ? user.getCreatedDate() : "" %></td>
                    <td>
                        <button class="btn btn-edit btn-sm" onclick="editCustomer('<%= user.getUserId() %>')">Edit</button>
                        <button class="btn btn-view btn-sm" onclick="viewCustomer('<%= user.getUserId() %>')">View</button>
                        <button class="btn btn-delete btn-sm" onclick="deleteCustomer('<%= user.getUserId() %>')">Delete</button>
                    </td>
                </tr>
                <% } } %>
            </tbody>
        </table>

        <!-- Pagination -->
        <% if (totalPages > 1) { %>
        <div class="d-flex justify-content-end align-items-center mt-3">
            <nav>
                <ul class="pagination mb-0">
                    <li class="page-item <%= (currentPage == 1) ? "disabled" : "" %>">
                        <a class="page-link" href="ap_customer.jsp?page=<%= currentPage - 1 %>">&laquo; Prev</a>
                    </li>
                    <% for (int p = 1; p <= totalPages; p++) { %>
                    <li class="page-item <%= (p == currentPage) ? "active" : "" %>">
                        <a class="page-link" href="ap_customer.jsp?page=<%= p %>"><%= p %></a>
                    </li>
                    <% } %>
                    <li class="page-item <%= (currentPage == totalPages) ? "disabled" : "" %>">
                        <a class="page-link" href="ap_customer.jsp?page=<%= currentPage + 1 %>">Next &raquo;</a>
                    </li>
                </ul>
            </nav>
        </div>
        <% } %>

        <!-- Modals for Add, Edit, View, Delete (structure similar to ap_item.jsp, but for user fields) -->
        <%-- AddCustomerModal, EditCustomerModal, ViewCustomerModal, DeleteCustomerModal --%>
        <%-- You can copy the modal HTML from ap_item.jsp and adjust fields for UserData --%>

    </div>
</div>
<script src="<%= request.getContextPath()%>/assets/js/bootstrap.bundle.min.js"></script>
<script src="<%= request.getContextPath()%>/assets/js/ap_customer.js"></script>
</body>
</html>