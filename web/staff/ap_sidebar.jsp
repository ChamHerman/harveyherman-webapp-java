<%@page import="javax.naming.NamingException"%>
<%@page import="javax.naming.InitialContext"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.StaffLoginDAO"%>
<%@ page import="model.StaffLogin"%>
<%@ page import="model.StaffData"%>
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
        <li class="nav-item"><a class="nav-link" href="<%= request.getContextPath()%>/staff/ap_index.jsp" id="dashboard-link">Dashboard</a></li>
        <li class="nav-item"><a class="nav-link" href="<%= request.getContextPath()%>/staff/ap_item.jsp" id="item-management-link">Item Management</a></li>
        <li class="nav-item"><a class="nav-link" href="<%= request.getContextPath()%>/staff/ap_order.jsp" id="order-management-link">Update Order Status</a></li>
        <li class="nav-item"><a class="nav-link" href="<%= request.getContextPath()%>/staff/ap_user.jsp" id="user-management-link">View User Records</a></li>
    </ul>
    <div class="sidebar-profile">
        <%
            StaffLoginDAO staffLoginDAO = null;
                try {
                    InitialContext context = new InitialContext();
                    staffLoginDAO = (StaffLoginDAO) context.lookup("java:global/HarveyHerman/StaffLoginDAO");
                } catch (NamingException ne) {
                    ne.printStackTrace();
                }
                
            StaffData staffData = (StaffData) session.getAttribute("loggedInStaff");

            if (staffData != null) {
                StaffLogin staffLogin = staffLoginDAO.findByStaffId(staffData.getStaffId());
                String username = staffLogin != null ? "Staff" : "Unknown";
        %>
        <a href="<%= request.getContextPath()%>/staff/ap_profile.jsp" class="btn btn-outline-primary w-100">
            <span class="fa fa-user"></span> <%= username%>
        </a>
        <% } else {%>
        <a href="<%= request.getContextPath()%>/staff/ap_profile.jsp" class="btn btn-outline-primary w-100">
            <span class="fa fa-user"></span> Not Logged In
        </a>
        <% }%>
    </div>
</div>
<script>
    document.addEventListener("DOMContentLoaded", function () {
        var path = window.location.pathname.split("/").pop().split("?")[0];
        var pageMap = {
            "ap_index.jsp": "dashboard-link",
            "ap_item.jsp": "item-management-link",
            "ap_order.jsp": "order-management-link",
            "ap_user.jsp": "user-management-link"
        };
        if (pageMap[path]) {
            document.getElementById(pageMap[path]).classList.add("active");
        }
    });
</script>
