<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ page import="java.util.List"%>
<%@ page import="model.Item"%>
<%@ page import="model.ItemDAO"%>
<%@ page import="java.util.Arrays"%>
<%@ page import="java.util.Set"%>
<%@ page import="java.util.HashSet"%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
<title>Item - HarveyHerman</title>

<!-- Bootstrap CSS -->
<link href="assets/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css"
	rel="stylesheet">
<link href="assets/css/tiny-slider.css" rel="stylesheet">
<link href="assets/css/style.css" rel="stylesheet">
</head>
<body>

	<!-- Header -->
	<jsp:include page="header.jsp" />

	<!-- Start Hero Section -->
	<div class="hero">
		<div class="container">
			<div class="row justify-content-between">
				<div class="col-lg-5">
					<div class="intro-excerpt">
						<h1>Shop</h1>
					</div>
				</div>
				<div class="col-lg-7"></div>
			</div>
		</div>
	</div>
	<!-- End Hero Section -->

	<!-- Fetch Items and Categories from DAO -->
	<%
	String searchQuery = request.getParameter("search");
	String[] selectedCategories = request.getParameterValues("category");
	Set<String> selectedCategoriesSet = new HashSet<String>();
	if (selectedCategories != null) {
		selectedCategoriesSet.addAll(Arrays.asList(selectedCategories));
	}

	// Fetch categories
	List<String> categories = Arrays.asList("test", "Kitchen Appliances", "Cooking & Bakeware", "Refrigeration & Cooling",
			"Laundry & Cleaning", "Smart Home Devices", "Lighting & Electrical", "Heating & Air Conditioning",
			"Bathroom Essentials", "Home Entertainment", "Furniture & Décor");

	// Fetch items from DB
	ItemDAO itemDAO = new ItemDAO();
	List<Item> items = itemDAO.getFilteredItems(searchQuery, selectedCategories);
	%>

	<!-- Main Content -->
	<div class="untree_co-section product-section before-footer-section">
		<div class="container">
			<div class="row">

				<!-- Side Bar (Filter) -->
				<div class="col-md-3">
					<form action="item.jsp" method="POST">
						<div class="card p-3">
							<h5>Search</h5>
							<input type="text" name="search" class="form-control" placeholder="Search item..."
								value="<%=(searchQuery != null) ? searchQuery : ""%>">

							<h5 class="mt-3">Category</h5>
							<%
							for (String cat : categories) {
							%>
							<div class="form-check">
								<input class="form-check-input" type="checkbox" name="category" value="<%=cat%>"
									<%if (selectedCategoriesSet.contains(cat)) {%> checked <%}%> /> <label
									class="form-check-label"><%=cat%></label>
							</div>
							<%
							}
							%>

							<!-- Buttons: Apply Filter & Clear Filter -->
							<div class="d-flex gap-2 mt-3">
								<button type="submit" class="btn btn-primary flex-grow-1">Apply Filters</button>
								<a href="item.jsp" class="btn btn-secondary flex-grow-1">Clear Filters</a>
							</div>
						</div>
					</form>

				</div>

				<!-- Products Section -->
				<div class="col-md-9">
					<div class="row">
						<%
						if (items != null && !items.isEmpty()) {
						%>
						<%
						for (Item item : items) {
						%>
						<div class="col-12 col-md-4 col-lg-3 mb-5">
							<a class="product-item border rounded p-3 d-block text-center"
								href="#" onclick="postItemDetails('<%=item.getItemId()%>')"> <img
								src="<%=item.getImageUrl()%>" class="img-fluid product-thumbnail" alt="Product Image">
								<h3 class="product-title"><%=item.getName()%></h3> <strong class="product-price">RM
									<%=String.format("%.2f", item.getPrice())%></strong> <span class="icon-cross"> <img
									src="assets/images/cross.svg" class="img-fluid">
							</span>
							</a>

							<form id="itemForm" action="details" method="post" style="display: none;">
								<input type="hidden" name="itemId" id="itemId">
							</form>
						</div>
						<%
						}
						%>
						<%
						} else {
						%>
						<p>No items found.</p>
						<%
						}
						%>
					</div>
				</div>

			</div>
		</div>
	</div>

	<!-- Footer -->
	<jsp:include page="footer.jsp" />

	<!-- Scripts -->
	<script src="assets/js/bootstrap.bundle.min.js"></script>
	<script src="assets/js/tiny-slider.js"></script>
	<script src="assets/js/custom.js"></script>
	<script src="assets/js/itemDetails.js"></script>

</body>
</html>
