<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="model.Item" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <jsp:include page="head.jsp" />
        <title>Shop - HarveyHerman</title>
        <link href="<%=request.getContextPath()%>/assets/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">
        <link href="<%=request.getContextPath()%>/assets/css/tiny-slider.css" rel="stylesheet">
        <link href="<%=request.getContextPath()%>/assets/css/style.css" rel="stylesheet">
        <link href="<%=request.getContextPath()%>/assets/css/item.css" rel="stylesheet">
    </head>
    <body>
        <jsp:include page="header.jsp" />
        <div class="shop-hero">
            <div class="container">
                <div class="row justify-content-between align-items-center">
                    <div class="col-lg-6">
                        <div class="intro-excerpt">
                            <h1>Shop</h1>
                            <div class="shop-hero-words">Discover the best products, filter by your needs, and enjoy a seamless shopping experience.</div>
                        </div>
                    </div>
                    <div class="col-lg-6 d-none d-lg-block position-relative">
                        <img src="<%=request.getContextPath()%>/assets/images/item-hero.svg" class="shop-hero-anim" alt="Shop Animation" />
                    </div>
                </div>
            </div>
        </div>
        <div class="container" style="margin-top: 1rem;">
            <div class="alert alert-info d-flex align-items-center justify-content-center p-3 rounded shadow-sm" style="background: linear-gradient(90deg, #d4f5e9 0%, #e8fbe6 100%); color: #22543d; font-size: 1.1rem; font-weight: 500; border: 1px solid #b7e4c7;">
                <i class="fa fa-truck me-2" style="font-size: 1.3em;"></i>
                Enjoy <span style="color:#38a169;font-weight:700;" class="mx-1">FREE delivery</span> on orders of <span style="color:#38a169;font-weight:700;" class="mx-1">RM1000</span> and above! For orders below RM1000, a delivery charge of <span style="color:#38a169;font-weight:700;" class="mx-1">RM25</span> applies.
            </div>
        </div>
        <div class="untree_co-section product-section before-footer-section">
            <div class="container">
                <div class="row">
                    <div class="col-md-3">
                        <form action="items" method="get">
                            <div class="card p-3 shop-sidebar-card">
                                <h5>Search</h5>
                                <input type="text" name="search" class="form-control" placeholder="Search item..."
                                       value="<%= request.getAttribute("search") != null ? request.getAttribute("search") : ""%>" autocomplete="off">
                                <h5 class="mt-3">Category</h5>
                                <% List<String> allCategories = (List<String>) request.getAttribute("allCategories"); %>
                                <% String[] selectedCategories = (String[]) request.getAttribute("categories"); %>
                                <% java.util.Set<String> selectedCategoriesSet = new java.util.HashSet<>(); %>
                                <% if (selectedCategories != null) {
                                        for (String c : selectedCategories) {
                                            selectedCategoriesSet.add(c);
                                        }
                                    } %>
                                <% if (allCategories != null) {
                                        for (String cat : allCategories) {%>
                                <div class="form-check">
                                    <input class="form-check-input" type="checkbox" name="category" value="<%=cat%>"
                                           <%= selectedCategoriesSet.contains(cat) ? "checked" : ""%> />
                                    <label class="form-check-label category-title"><%=cat%></label>
                                </div>
                                <% }
                                    }%>
                                <h5 class="mt-3">Stock</h5>
                                <select class="form-select" name="stock">
                                    <option value="All" <%= (request.getAttribute("stock") == null || "All".equals(request.getAttribute("stock"))) ? "selected" : ""%>>All</option>
                                    <option value="InStock" <%= "InStock".equals(request.getAttribute("stock")) ? "selected" : ""%>>In Stock</option>
                                    <option value="OutOfStock" <%= "OutOfStock".equals(request.getAttribute("stock")) ? "selected" : ""%>>Out of Stock</option>
                                </select>
                                <%
                                    // Get current min/max price from request or use defaults
                                    String minPriceStr = (String) request.getAttribute("minPrice");
                                    String maxPriceStr = (String) request.getAttribute("maxPrice");
                                    int minsSliderPrice = (minPriceStr != null && !minPriceStr.isEmpty()) ? Integer.parseInt(minPriceStr) : 0;
                                    int maxSliderPrice = (maxPriceStr != null && !maxPriceStr.isEmpty()) ? Integer.parseInt(maxPriceStr) : 1000000;
                                    int sliderMin = 0; // absolute min
                                    int sliderMax = 10000000; // absolute max
%>
                                <h5 class="mt-3">Price Range</h5>
                                <div class="mb-2 d-flex align-items-center gap-2">
                                    <input type="number" class="form-control" id="minPriceInput" name="minPrice"
                                           min="<%=sliderMin%>" max="<%=sliderMax%>" step="100" value="<%=minsSliderPrice%>" style="width: 7.5rem;">
                                    <span>&mdash;</span>
                                    <input type="number" class="form-control" id="maxPriceInput" name="maxPrice"
                                           min="<%=sliderMin%>" max="<%=sliderMax%>" step="100" value="<%=maxSliderPrice%>" style="width: 7.5rem;">
                                </div>
                                <div class="d-flex align-items-center gap-2">
                                    <input type="range" class="form-range" id="minPriceSlider"
                                           min="<%=sliderMin%>" max="<%=sliderMax%>" step="100" value="<%=minsSliderPrice%>">
                                    <input type="range" class="form-range" id="maxPriceSlider"
                                           min="<%=sliderMin%>" max="<%=sliderMax%>" step="100" value="<%=maxSliderPrice%>">
                                </div>
                                <h5 class="mt-3">Sort By</h5>
                                <div class="d-flex gap-2">
                                    <select class="form-select" name="sortBy" id="sortBy">
                                        <option value="createdDate" <%= (request.getAttribute("sortBy") == null || "createdDate".equals(request.getAttribute("sortBy"))) ? "selected" : ""%>>Date</option>
                                        <option value="name" <%= "name".equals(request.getAttribute("sortBy")) ? "selected" : ""%>>Name</option>
                                        <option value="price" <%= "price".equals(request.getAttribute("sortBy")) ? "selected" : ""%>>Price</option>
                                        <option value="topSelling" <%= "topSelling".equals(request.getAttribute("sortBy")) ? "selected" : ""%>>Top Selling</option>
                                    </select>
                                    <select class="form-select" name="sortOrder" id="sortOrder">
                                        <option value="asc" <%= (request.getAttribute("sortOrder") == null || "asc".equals(request.getAttribute("sortOrder"))) ? "selected" : ""%>>Asc</option>
                                        <option value="desc" <%= "desc".equals(request.getAttribute("sortOrder")) ? "selected" : ""%>>Desc</option>
                                    </select>
                                </div>
                                <div class="d-flex gap-2 mt-3">
                                    <button type="submit" class="btn btn-primary flex-grow-1">Apply Filters</button>
                                    <a href="items" class="btn btn-secondary flex-grow-1">Clear Filters</a>
                                </div>
                            </div>
                        </form>
                    </div>
                    <div class="col-md-9">
                        <div class="row">
                            <% List<Item> pagedItems = (List<Item>) request.getAttribute("pagedItems"); %>
                            <% if (pagedItems != null && !pagedItems.isEmpty()) { %>
                            <% for (Item item : pagedItems) {%>
                            <div class="col-12 col-md-6 col-lg-3 mb-5">
                                <a class="product-item border rounded p-3 d-block text-center"
                                   href="<%=request.getContextPath()%>/user/details?itemId=<%=item.getItemId()%>" style="text-decoration: none;">
                                    <img src="<%=request.getContextPath()%>/assets/<%=item.getImageUrl()%>" class="img-fluid product-thumbnail" alt="Product Image">
                                    <h3 class="product-title" style="text-decoration: none;"> <%=item.getName()%> </h3>
                                    <strong class="product-price">RM <%=String.format("%.2f", item.getPrice())%></strong>
                                    <% if (item.getStockQuantity() > 0) { %>
                                    <div class="mt-1"><span class="badge bg-success" style="font-size: 0.95em;">In Stock</span></div>
                                    <% } else { %>
                                    <div class="mt-1"><span class="badge bg-danger" style="font-size: 0.95em;">Out of Stock</span></div>
                                    <% }%>
                                    <span class="icon-cross">
                                        <img src="<%=request.getContextPath()%>/assets/images/cross.svg" class="img-fluid">
                                    </span>
                                </a>
                            </div>
                            <% } %>
                            <% } else { %>
                            <p class="text-center w-100">No items found.</p>
                            <% }%>
                        </div>
                    </div>
                    <div class="d-flex justify-content-center mt-4">
                        <%
                            StringBuilder queryString = new StringBuilder();
                            String search = (String) request.getAttribute("search");
                            String[] categories = (String[]) request.getAttribute("categories");
                            String stock = (String) request.getAttribute("stock");
                            String minPrice = (String) request.getAttribute("minPrice");
                            String maxPrice = (String) request.getAttribute("maxPrice");
                            String sortBy = (String) request.getAttribute("sortBy");
                            String sortOrder = (String) request.getAttribute("sortOrder");

                            if (search != null && !search.isEmpty()) {
                                queryString.append("&search=").append(java.net.URLEncoder.encode(search, "UTF-8"));
                            }
                            if (categories != null) {
                                for (String cat : categories) {
                                    queryString.append("&category=").append(java.net.URLEncoder.encode(cat, "UTF-8"));
                                }
                            }
                            if (stock != null && !stock.isEmpty()) {
                                queryString.append("&stock=").append(java.net.URLEncoder.encode(stock, "UTF-8"));
                            }
                            if (minPrice != null && !minPrice.isEmpty()) {
                                queryString.append("&minPrice=").append(java.net.URLEncoder.encode(minPrice, "UTF-8"));
                            }
                            if (maxPrice != null && !maxPrice.isEmpty()) {
                                queryString.append("&maxPrice=").append(java.net.URLEncoder.encode(maxPrice, "UTF-8"));
                            }
                            if (sortBy != null && !sortBy.isEmpty()) {
                                queryString.append("&sortBy=").append(java.net.URLEncoder.encode(sortBy, "UTF-8"));
                            }
                            if (sortOrder != null && !sortOrder.isEmpty()) {
                                queryString.append("&sortOrder=").append(java.net.URLEncoder.encode(sortOrder, "UTF-8"));
                            }
                        %>
                        <% Integer currentPage = (Integer) request.getAttribute("currentPage"); %>
                        <% Integer totalPages = (Integer) request.getAttribute("totalPages");%>

                    </div>
                    <div class="d-flex justify-content-end mt-4">
                        <nav>
                            <ul class="pagination">
                                <li class="page-item <%= (currentPage != null && currentPage == 1) ? "disabled" : ""%>">
                                    <a class="page-link" href="items?page=<%= (currentPage != null ? currentPage - 1 : 1)%><%= queryString.toString()%>">&laquo; Prev</a>
                                </li>
                                <% for (int i = 1; i <= (totalPages != null ? totalPages : 1); i++) {%>
                                <li class="page-item <%= (currentPage != null && i == currentPage) ? "active" : ""%>">
                                    <a class="page-link" href="items?page=<%= i%><%= queryString.toString()%>"><%= i%></a>
                                </li>
                                <% }%>
                                <li class="page-item <%= (currentPage != null && totalPages != null && currentPage == totalPages) ? "disabled" : ""%>">
                                    <a class="page-link" href="items?page=<%= (currentPage != null ? currentPage + 1 : 1)%><%= queryString.toString()%>">Next &raquo;</a>
                                </li>
                            </ul>
                        </nav>
                    </div>
                </div>
            </div>
        </div>
        <jsp:include page="footer.jsp" />
        <script src="<%=request.getContextPath()%>/assets/js/bootstrap.bundle.min.js"></script>
        <script src="<%=request.getContextPath()%>/assets/js/tiny-slider.js"></script>
        <script src="<%=request.getContextPath()%>/assets/js/index.js"></script>
        <script>
            document.addEventListener('DOMContentLoaded', function () {
                var minSlider = document.getElementById('minPriceSlider');
                var maxSlider = document.getElementById('maxPriceSlider');
                var minInput = document.getElementById('minPriceInput');
                var maxInput = document.getElementById('maxPriceInput');

                function syncFromSlider() {
                    var minVal = parseInt(minSlider.value);
                    var maxVal = parseInt(maxSlider.value);
                    if (minVal > maxVal) {
                        var temp = minVal;
                        minVal = maxVal;
                        maxVal = temp;
                    }
                    minInput.value = minVal;
                    maxInput.value = maxVal;
                }

                function syncFromInput() {
                    var minVal = parseInt(minInput.value) || 0;
                    var maxVal = parseInt(maxInput.value) || 0;
                    if (minVal > maxVal) {
                        var temp = minVal;
                        minVal = maxVal;
                        maxVal = temp;
                    }
                    minSlider.value = minVal;
                    maxSlider.value = maxVal;
                }

                minSlider.addEventListener('input', syncFromSlider);
                maxSlider.addEventListener('input', syncFromSlider);
                minInput.addEventListener('input', syncFromInput);
                maxInput.addEventListener('input', syncFromInput);

                // Initial sync
                syncFromSlider();
            });

            document.getElementById('sortBy').addEventListener('change', function () {
                var sortOrder = document.getElementById('sortOrder');
                if (this.value === 'topSelling') {
                    sortOrder.disabled = true;
                } else {
                    sortOrder.disabled = false;
                }
            });

            // Initial check to disable sortOrder if topSelling is already selected
            window.addEventListener('DOMContentLoaded', (event) => {
                var sortBy = document.getElementById('sortBy');
                var sortOrder = document.getElementById('sortOrder');
                if (sortBy.value === 'topSelling') {
                    sortOrder.disabled = true;
                }
            });
        </script>
    </body>
</html>

