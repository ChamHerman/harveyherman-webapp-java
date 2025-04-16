<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Admin Dashboard - HarveyHerman</title>
<!-- Bootstrap CSS -->
<link href="<%=request.getContextPath()%>/assets/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css"
	rel="stylesheet">
<link href="<%=request.getContextPath()%>/assets/css/style.css" rel="stylesheet">

<!-- Custom CSS -->
<link rel="stylesheet" href="<%=request.getContextPath()%>/assets/css/ap_index.css">

</head>
<body>
	<%@ include file="ap_sidebar.jsp"%>

	<div class="content">
		<h2>Admin Dashboard</h2>
		<div class="row">
			<div class="col-lg-3 col-md-6 col-sm-12">
				<div class="card card-blue">
					<h4>In-Store Sales</h4>
					<p>$5,345.43</p>
				</div>
			</div>
			<div class="col-lg-3 col-md-6 col-sm-12">
				<div class="card card-green">
					<h4>Website Sales</h4>
					<p>$674,347.12</p>
				</div>
			</div>
			<div class="col-lg-3 col-md-6 col-sm-12">
				<div class="card card-yellow">
					<h4>Discounts</h4>
					<p>$14,235.12</p>
				</div>
			</div>
			<div class="col-lg-3 col-md-6 col-sm-12">
				<div class="card card-red">
					<h4>Affiliates</h4>
					<p>$8,345.23</p>
				</div>
			</div>
		</div>
	</div>
</body>

<!-- Scripts -->
<script src="<%=request.getContextPath()%>/assets/js/bootstrap.bundle.min.js"></script>
<script src="<%=request.getContextPath()%>/assets/js/ap_index.js"></script>
</html>
