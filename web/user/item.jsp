<%@ page import="java.util.Comparator"%>
<%@ page import="java.util.Collections"%>
<%@ page import="java.util.Collections"%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ page import="java.util.List"%>
<%@ page import="model.Item"%>
<%@ page import="model.ItemDAO"%>
<%@ page import="java.util.Arrays"%>
<%@ page import="java.util.Set"%>
<%@ page import="java.util.HashSet"%>
<%@ page import="javax.naming.InitialContext" %>
<%@ page import="javax.naming.NamingException" %>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <title>Item - HarveyHerman</title>

        <!-- Bootstrap CSS -->
        <link href="<%=request.getContextPath()%>/assets/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css"
              rel="stylesheet">
        <link href="<%=request.getContextPath()%>/assets/css/tiny-slider.css" rel="stylesheet">
        <link href="<%=request.getContextPath()%>/assets/css/style.css" rel="stylesheet">
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

            ItemDAO itemDAO = null;
            try {
                InitialContext context = new InitialContext();
                itemDAO = (ItemDAO) context.lookup("java:global/HarveyHerman/ItemDAO");
            } catch (NamingException ne) {
                ne.printStackTrace();
            }
            // Fetch categories & filtered items
            List<String> categories = itemDAO.getAllCategories();
            List<Item> items = itemDAO.getFilteredItems(searchQuery, selectedCategories);

            if (items != null) {
                Collections.sort(items, new Comparator<Item>() {
                    @Override
                    public int compare(Item i1, Item i2) {
                        // Check for null to avoid NullPointerException
                        if (i1.getCreatedDate() == null || i2.getCreatedDate() == null) {
                            return 0;
                        }
                        // Newest items come first
                        return i2.getCreatedDate().compareTo(i1.getCreatedDate());
                    }
                });
            }
        %>

        <!-- Main Content -->
        <div class="untree_co-section product-section before-footer-section">
            <div class="container">
                <div class="row">

                    <!-- Side Bar (Filter) -->
                    <div class="col-md-3">
                        <form action="item.jsp" method="post">
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

                                <!-- Stock Filter -->
                                <h5 class="mt-3">Stock</h5>
                                <select class="form-select" name="stock">
                                    <option value="All" <%= (request.getParameter("stock") == null || "All".equals(request.getParameter("stock"))) ? "selected" : "" %>>All</option>
                                    <option value="InStock" <%= "InStock".equals(request.getParameter("stock")) ? "selected" : "" %>>In Stock</option>
                                    <option value="OutOfStock" <%= "OutOfStock".equals(request.getParameter("stock")) ? "selected" : "" %>>Out of Stock</option>
                                </select>

                                <!-- Price Range Filter -->
                                <h5 class="mt-3">Price Range</h5>
                                <div class="d-flex gap-2">
                                    <input type="number" class="form-control" name="minPrice" placeholder="Min" min="0" step="0.01" value="<%=request.getParameter("minPrice") != null ? request.getParameter("minPrice") : ""%>">
                                    <input type="number" class="form-control" name="maxPrice" placeholder="Max" min="0" step="0.01" value="<%=request.getParameter("maxPrice") != null ? request.getParameter("maxPrice") : ""%>">
                                </div>

                                <!-- Sort By Filter -->
                                <h5 class="mt-3">Sort By</h5>
                                <div class="d-flex gap-2">
                                    <select class="form-select" name="sortBy">
                                        <option value="createdDate" <%= (request.getParameter("sortBy") == null || "createdDate".equals(request.getParameter("sortBy"))) ? "selected" : "" %>>Date</option>
                                        <option value="name" <%= "name".equals(request.getParameter("sortBy")) ? "selected" : "" %>>Name</option>
                                        <option value="price" <%= "price".equals(request.getParameter("sortBy")) ? "selected" : "" %>>Price</option>
                                    </select>
                                    <select class="form-select" name="sortOrder">
                                        <option value="desc" <%= (request.getParameter("sortOrder") == null || "desc".equals(request.getParameter("sortOrder"))) ? "selected" : "" %>>Desc</option>
                                        <option value="asc" <%= "asc".equals(request.getParameter("sortOrder")) ? "selected" : "" %>>Asc</option>
                                    </select>
                                </div>

                                <!-- Buttons: Apply Filter & Clear Filter -->
                                <div class="d-flex gap-2 mt-3">
                                    <button type="submit" class="btn btn-primary flex-grow-1">Apply Filters</button>
                                    <a href="item.jsp" class="btn btn-secondary flex-grow-1">Clear Filters</a>
                                </div>
                            </div>
                        </form>
                    </div>
                    <!-- /Side Bar (Filter) -->

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
                                        src="<%=request.getContextPath()%>/assets/<%=item.getImageUrl()%>" class="img-fluid product-thumbnail" alt="Product Image">
                                    <h3 class="product-title"><%=item.getName()%></h3> <strong class="product-price">RM
                                        <%=String.format("%.2f", item.getPrice())%></strong>
                                    <!-- Stock label below price -->
                                    <% if (item.getStockQuantity() > 0) { %>
                                        <div class="mt-1"><span class="badge bg-success" style="font-size: 0.95em;">In Stock</span></div>
                                    <% } else { %>
                                        <div class="mt-1"><span class="badge bg-danger" style="font-size: 0.95em;">Out of Stock</span></div>
                                    <% } %>
                                    <span class="icon-cross"> <img
                                        src="<%=request.getContextPath()%>/assets/images/cross.svg" class="img-fluid">
                                    </span>
                                </a>
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
                    <!-- /Products Section -->
                </div>
            </div>
        </div>
        <!-- /Main Content -->

        <form id="itemForm" action="details" method="post" style="display: none;">
            <input type="hidden" name="itemId" id="itemId">
        </form>

        <!-- Footer -->
        <jsp:include page="footer.jsp" />

        <!-- Scripts -->
        <script src="<%=request.getContextPath()%>/assets/js/bootstrap.bundle.min.js"></script>
        <script src="<%=request.getContextPath()%>/assets/js/tiny-slider.js"></script>
        <script>
                                       function postItemDetails(itemId) {
                                           document.getElementById("itemId").value = itemId;
                                           document.getElementById("itemForm").submit();
                                       }
        </script>

    </body>
</html>
