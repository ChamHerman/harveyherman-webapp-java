<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<div class="sidebar">
	<h3 class="text-center">HarveyHerman</h3>
	<div class="text-center my-3">
		<button id="theme-toggle" class="btn btn-outline-primary">🌙</button>
	</div>
	<ul class="nav flex-column">
		<li class="nav-item"><a class="nav-link" href="<%= request.getContextPath()%>/manager/ap_index.jsp" id="dashboard-link">Dashboard</a></li>
                <li class="nav-item"><a class="nav-link" href="<%= request.getContextPath()%>/manager/ap_user.jsp" id="user-management-link">User Management</a></li>
		<li class="nav-item"><a class="nav-link" href="<%= request.getContextPath()%>/manager/ap_item.jsp" id="item-management-link">Item
				Management</a></li>
		<li class="nav-item"><a class="nav-link" href="#" data-bs-toggle="collapse"
			data-bs-target="#ordersMenu" aria-expanded="false"> Order ▾ </a>
			<ul class="collapse list-unstyled ps-3" id="ordersMenu" data-bs-parent=".sidebar">
				<li><a class="nav-link" href="aporderlist.jsp" id="order-list-link">Order List</a></li>
				<li><a class="nav-link" href="aporderhistory.jsp" id="order-history-link">Order History</a></li>
			</ul></li>
		<li class="nav-item"><a class="nav-link" href="#" id="manage-reviews-link">Manage Reviews</a></li>
	</ul>
</div>
<script>
	$(document).ready(function() {
		$(".menu-toggle").click(function() {
			$(".sidebar").toggleClass("active");
		});
	});
</script>
