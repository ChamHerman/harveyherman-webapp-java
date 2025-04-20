<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<div class="sidebar">
	<h3 class="text-center">HarveyHerman</h3>
	<ul class="nav flex-column">
		<li class="nav-item"><a class="nav-link" href="<%= request.getContextPath()%>/manager/ap_index.jsp" id="dashboard-link">Dashboard</a></li>
		<li class="nav-item"><a class="nav-link" href="<%= request.getContextPath()%>/manager/ap_item.jsp" id="item-management-link">Item Management</a></li>
                <li class="nav-item"><a class="nav-link" href="<%= request.getContextPath()%>/manager/ap_order.jsp" id="order-management-link">Order Management</a></li>
                <li class="nav-item"><a class="nav-link" href="<%= request.getContextPath()%>/manager/promotion.jsp" id="promotion-management-link">Promotion Management</a></li>
                <li class="nav-item"><a class="nav-link" href="<%= request.getContextPath()%>/manager/generatingReport.jsp" id="report-management-link">Report Management</a></li>
                <li class="nav-item"><a class="nav-link" href="<%= request.getContextPath()%>/manager/ap_staff.jsp" id="staff-management-link">Staff Management</a></li>
	</ul>   <li class="nav-item"><a class="nav-link" href="<%= request.getContextPath()%>/manager/ap_user.jsp" id="user-management-link">User Management</a></li>
</div>
<script>
	$(document).ready(function() {
		$(".menu-toggle").click(function() {
			$(".sidebar").toggleClass("active");
		});
	});
</script>
