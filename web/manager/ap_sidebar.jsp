<%@page import="model.StaffLogin"%>
<%@page import="model.StaffData"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String companyName = application.getInitParameter("companyName");
%>
<link rel="stylesheet" href="<%=request.getContextPath()%>/assets/css/ap_sidebar.css">
<div class="sidebar">
    <div class="sidebar-header">
        <div class="sidebar-avatar">
            <span class="fa fa-user-circle"></span>
        </div>
        <span class="sidebar-logo"><%= companyName%></span>
    </div>
    <ul class="nav flex-column">
        <li class="nav-item"><a class="nav-link" href="<%= request.getContextPath()%>/manager/ap_index.jsp" id="dashboard-link">Dashboard</a></li>
        <li class="nav-item"><a class="nav-link" href="<%= request.getContextPath()%>/manager/ap_item.jsp" id="item-management-link">Item Management</a></li>
        <li class="nav-item"><a class="nav-link" href="<%= request.getContextPath()%>/manager/ap_order.jsp" id="order-management-link">Order Management</a></li>
        <li class="nav-item"><a class="nav-link" href="<%= request.getContextPath()%>/manager/promotion.jsp" id="promotion-management-link">Promotion Management</a></li>
        <li class="nav-item"><a class="nav-link" href="<%= request.getContextPath()%>/manager/generatingReport.jsp" id="report-management-link">Report Management</a></li>
        <li class="nav-item"><a class="nav-link" href="<%= request.getContextPath()%>/manager/ap_staff.jsp" id="staff-management-link">Staff Management</a></li>
        <li class="nav-item"><a class="nav-link" href="<%= request.getContextPath()%>/manager/ap_user.jsp" id="user-management-link">User Management</a></li>
    </ul>
    <div class="sidebar-profile">
        <%
            StaffData staffData = (StaffData) session.getAttribute("loggedInManager");
            if (staffData != null) {
                StaffLogin staffLogin = staffData.getStaffLogin();
                String username = staffLogin != null ? staffLogin.getUsername() : "Unknown";
        %>
        <a href="<%= request.getContextPath()%>/manager/ap_profile.jsp" class="btn btn-outline-primary w-100">
            <span class="fa fa-user"></span> <%= username%>
        </a>
        <% } else {%>
        <a href="<%= request.getContextPath()%>/manager/ap_profile.jsp" class="btn btn-outline-primary w-100">
            <span class="fa fa-user"></span> Not Logged In
        </a>
        <% }%>
    </div>
</div>
<script>
    document.addEventListener("DOMContentLoaded", function () {
        // Get the current page filename from the URL and remove any query parameters.
        var path = window.location.pathname.split("/").pop().split("?")[0];

        // Map page names to their corresponding sidebar link IDs.
        var pageMap = {
            "ap_index.jsp": "dashboard-link",
            "ap_item.jsp": "item-management-link",
            "ap_order.jsp": "order-management-link",
            "promotion.jsp": "promotion-management-link",
            "generatingReport.jsp": "report-management-link",
            "ap_staff.jsp": "staff-management-link",
            "ap_user.jsp": "user-management-link"
        };

        // Highlight the active link if mapping exists.
        if (pageMap[path]) {
            document.getElementById(pageMap[path]).classList.add("active");
        }
    });
</script>
