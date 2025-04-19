<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<div class="sidebar">
	<h3 class="text-center">HarveyHerman</h3>
	<div class="text-center my-3">
		<button id="theme-toggle" class="btn btn-outline-primary">🌙</button>
	</div>
	<ul class="nav flex-column">
		<li class="nav-item"><a class="nav-link" href="<%= request.getContextPath()%>/staff/ap_index.jsp" id="dashboard-link">Dashboard</a></li>
		<li class="nav-item"><a class="nav-link" href="<%= request.getContextPath()%>/staff/ap_item.jsp" id="item-management-link">Item Management</a></li>
                <li class="nav-item"><a class="nav-link" href="<%= request.getContextPath()%>/staff/ap_user.jsp" id="user-management-link">User Management</a></li>
                <li class="nav-item"><a class="nav-link" href="<%= request.getContextPath()%>/staff/ap_order.jsp" id="order-management-link">Order Management</a></li>
        </ul>
</div>
<script>
	$(document).ready(function() {
		$(".menu-toggle").click(function() {
			$(".sidebar").toggleClass("active");
		});
	});
</script>
