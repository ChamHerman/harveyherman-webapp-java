<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="model.StaffDataDAO" %>
<%@ page import="model.StaffData" %>
<%@ page import="model.StaffLoginDAO" %>
<%@ page import="model.StaffLogin" %>
<%@ page import="javax.naming.InitialContext" %>
<%@ page import="javax.naming.NamingException" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Staff Management - Manager</title>
        <link href="<%= request.getContextPath()%>/assets/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">
        <link href="<%= request.getContextPath()%>/assets/css/style.css" rel="stylesheet">
        <link href="<%= request.getContextPath()%>/assets/css/ap_index.css" rel="stylesheet">
        <link href="<%= request.getContextPath()%>/assets/css/ap_staff.css" rel="stylesheet">
    </head>
    <body>
        <%@ include file="ap_sidebar.jsp" %>
        <div class="main-content flex-grow-1">
            <div class="container">

                <%            
                    StaffDataDAO staffDataDAO = null;
                    try {
                        InitialContext context = new InitialContext();
                        staffDataDAO = (StaffDataDAO) context.lookup("java:global/HarveyHerman/StaffDataDAO");
                    } catch (NamingException ne) {
                        ne.printStackTrace();
                    }
                    List<StaffData> allStaff = staffDataDAO.findAllStaff();

                    String paramSearch = request.getParameter("search");
                    if (paramSearch == null) {
                        paramSearch = "";
                    }

                    // Filter by name or email
                    List<StaffData> filteredStaff = new ArrayList<StaffData>();
                    for (StaffData staff : allStaff) {
                        if (staff.getFullname() != null && staff.getFullname().toLowerCase().contains(paramSearch.toLowerCase())) {
                            filteredStaff.add(staff);
                        } else if (staff.getEmail() != null && staff.getEmail().toLowerCase().contains(paramSearch.toLowerCase())) {
                            filteredStaff.add(staff);
                        }
                    }

                    // Sort by createdDate desc by default
                    Collections.sort(filteredStaff, new Comparator<StaffData>() {
                        public int compare(StaffData s1, StaffData s2) {
                            if (s1.getCreatedDate() == null || s2.getCreatedDate() == null) {
                                return 0;
                            }
                            return s2.getCreatedDate().compareTo(s1.getCreatedDate());
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
                    int totalStaff = filteredStaff.size();
                    int totalPages = (int) Math.ceil((double) totalStaff / rowCount);
                    if (currentPage < 1) {
                        currentPage = 1;
                    }
                    if (currentPage > totalPages && totalPages > 0) {
                        currentPage = totalPages;
                    }
                    int startIdx = (currentPage - 1) * rowCount;
                    int endIdx = Math.min(startIdx + rowCount, totalStaff);
                    List<StaffData> limitedStaff = (startIdx < endIdx) ? filteredStaff.subList(startIdx, endIdx) : new ArrayList<StaffData>();
                %>

                <!-- Dashboard Overview -->
                <div class="dashboard-summary">
                    <div class="summary-box fs-6">Total Staff: <%= allStaff.size()%></div>
                </div>

                <!-- Filter/Search -->
                <form method="GET" action="ap_staff.jsp">
                    <div class="filter-section row mb-3">
                        <div class="col-md-6">
                            <label>Search:</label>
                            <div class="input-group">
                                <input type="text" id="searchInput" name="search" class="form-control" value="<%= paramSearch%>" placeholder="Search by name or email...">
                                <button class="btn btn-outline-secondary" id="clearSearch" type="button">Clear</button>
                                <button class="btn btn-outline-secondary" type="submit">Search</button>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <label>Show Rows:</label>
                            <select name="rows" class="form-select" onchange="this.form.submit()">
                                <option value="15" <%= rowCount == 15 ? "selected" : ""%>>15</option>
                                <option value="30" <%= rowCount == 30 ? "selected" : ""%>>30</option>
                                <option value="50" <%= rowCount == 50 ? "selected" : ""%>>50</option>
                            </select>
                        </div>
                        <div class="col-md-3 d-flex align-items-end">
                            <button type="button" id="addStaffBtn" class="btn btn-primary w-100">Add Staff</button>
                        </div>
                    </div>
                </form>

                <!-- Staff Table -->
                <table class="item-table">
                    <thead>
                        <tr>
                            <th>No</th>
                            <th>Staff ID</th>
                            <th>Full Name</th>
                            <th>Email</th>
                            <th>Contact</th>
                            <th>Position</th>
                            <th>Created Date</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody id="itemTableBody">
                        <% if (limitedStaff.isEmpty()) { %>
                        <tr>
                            <td colspan="8" class="text-center">No staff found.</td>
                        </tr>
                        <% } else {
                            int i = 1 + (currentPage - 1) * rowCount;
                            for (StaffData staff : limitedStaff) {%>
                        <tr>
                            <td><%= i++%></td>
                            <td><%= staff.getStaffId()%></td>
                            <td><%= staff.getFullname()%></td>
                            <td><%= staff.getEmail()%></td>
                            <td><%= staff.getContactNumber() != null ? staff.getContactNumber() : ""%></td>
                            <td><%= staff.getPosition()%></td>
                            <td><%= staff.getCreatedDate() != null ? staff.getCreatedDate() : ""%></td>
                            <td>
                                <button class="btn btn-edit btn-sm" onclick="editStaff('<%= staff.getStaffId()%>')">Edit</button>
                                <button class="btn btn-view btn-sm" onclick="viewStaff('<%= staff.getStaffId()%>')">View</button>
                                <button class="btn btn-delete btn-sm" onclick="deleteStaff('<%= staff.getStaffId()%>')">Delete</button>
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
                                <a class="page-link" href="ap_staff.jsp?page=<%= currentPage - 1%>&search=<%= paramSearch%>&rows=<%= rowCount%>">&laquo; Prev</a>
                            </li>
                            <% for (int p = 1; p <= totalPages; p++) {%>
                            <li class="page-item <%= (p == currentPage) ? "active" : ""%>">
                                <a class="page-link" href="ap_staff.jsp?page=<%= p%>&search=<%= paramSearch%>&rows=<%= rowCount%>"><%= p%></a>
                            </li>
                            <% }%>
                            <li class="page-item <%= (currentPage == totalPages) ? "disabled" : ""%>">
                                <a class="page-link" href="ap_staff.jsp?page=<%= currentPage + 1%>&search=<%= paramSearch%>&rows=<%= rowCount%>">Next &raquo;</a>
                            </li>
                        </ul>
                    </nav>
                </div>
                <% }%>

            </div>
        </div>
        
        <!-- View Staff Modal -->
        <div class="modal fade" id="viewStaffModal" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog modal-lg">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">Staff Details</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <div class="container">
                            <h4 class="mb-4 text-center">Staff Information</h4>
                            <div class="row mb-2">
                                <div class="col-sm-4 text-end fw-bold">Staff ID:</div>
                                <div class="col-sm-8" id="viewStaffId"></div>
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
                                <div class="col-sm-4 text-end fw-bold">Position:</div>
                                <div class="col-sm-8" id="viewPosition"></div>
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
                                <div class="col-sm-4 text-end fw-bold">Password:</div>
                                <div class="col-sm-8" id="viewPassword"></div>
                            </div>
                            <div class="row mb-2">
                                <div class="col-sm-4 text-end fw-bold">Role:</div>
                                <div class="col-sm-8" id="viewRole"></div>
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
        <div class="modal fade" id="staffResultMessageModal" tabindex="-1" aria-labelledby="staffResultMessageModalLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="staffResultMessageModalLabel">System Message</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <div id="staffResultMessage" class="item-result-message"></div>
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
        
        <!-- Delete Staff Confirmation Modal -->
        <div class="modal fade" id="deleteStaffModal" tabindex="-1" aria-labelledby="deleteStaffModalLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="deleteStaffModalLabel">Confirm Deletion</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <p>Are you sure you want to delete this staff member? This action cannot be undone.</p>
                        <form id="deleteStaffForm" method="post" action="<%= request.getContextPath() %>/manager/DeleteStaffServlet">
                            <input type="hidden" id="deleteStaffId" name="staffId" value="">
                        </form>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" form="deleteStaffForm" class="btn btn-danger">Delete</button>
                    </div>
                </div>
            </div>
        </div>
        
        <script>
            var contextPath = '<%= request.getContextPath() %>';
        </script>
        <script src="<%= request.getContextPath()%>/assets/js/bootstrap.bundle.min.js"></script>
        <script src="<%= request.getContextPath()%>/assets/js/ap_staff.js"></script>
    </body>
</html> 