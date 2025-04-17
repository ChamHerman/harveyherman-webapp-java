<%@ page import="java.util.List"%>
<%@ page import="model.ItemDAO"%>
<%@ page import="model.Item"%>
<%@ page import="javax.naming.InitialContext" %>
<%@ page import="javax.naming.NamingException" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Item Management - HarveyHerman</title>

        <!-- Bootstrap CSS -->
        <link href="../assets/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css"
              rel="stylesheet">
        <link href="../assets/css/style.css" rel="stylesheet">

        <!-- Custom CSS -->
        <link rel="stylesheet" href="../assets/css/ap_index.css">
        <link rel="stylesheet" href="../assets/css/ap_item.css">

    </head>
    <body>
        <div class="d-flex">
            <%@ include file="apsidebar.jsp"%>
            <div class="main-content flex-grow-1">
                <%@ include file="apnavbar.jsp"%>
                <div class="container">
                    <!-- Dashboard Overview Section -->
                    <div class="dashboard-summary">
                        <div class="summary-box" id="totalItems">Total Items:</div>
                        <div class="summary-box" id="inStock">In Stock:</div>
                        <div class="summary-box" id="outOfStock">Out of Stock:</div>
                        <div class="summary-box" id="categories">Categories:</div>
                    </div>

                    <%
                        ItemDAO itemDAO = null;
                        try {
                            InitialContext context = new InitialContext();
                            itemDAO = (ItemDAO) context.lookup("java:global/HarveyHerman/ItemDAO");
                        } catch (NamingException ne) {
                            ne.printStackTrace();
                        }
                        List<String> categories = itemDAO.getAllCategories();
                    %>

                    <!-- Filter Section -->
                    <div class="filter-section">
                        <label>Category:</label> <select id="categoryFilter" name="category">
                            <option value="All">All</option>
                            <%
                                for (String category : categories) {
                            %>
                            <option value="<%=category%>"><%=category%></option>
                            <%
                                }
                            %>
                        </select> <label>Stock:</label> <select id="stockFilter" name="stock">
                            <option value="All">All</option>
                            <option value="InStock">In Stock</option>
                            <option value="OutOfStock">Out of Stock</option>
                        </select>
                    </div>

                    <!-- Search and Controls Section -->
                    <div class="search-controls">
                        <input type="text" id="searchInput" placeholder="Search item...">
                        <div class="right-controls">
                            <span>Show Rows: <select id="rowCount" name="rows" class="form-select" style="display:inline-block; width:auto;">
                                    <option value="15" selected>15</option>
                                    <option value="30">30</option>
                                    <option value="50">50</option>
                                </select>
                            </span>
                            <button id="addItemBtn" type="button" class="btn btn-primary" data-bs-toggle="modal"
                                    data-bs-target="#addItemModal">Add Item</button>
                        </div>
                    </div>

                    <!-- Item Table -->
                    <table class="item-table">
                        <thead>
                            <tr>
                                <th><input type="checkbox"></th>
                                <th>Item Name</th>
                                <th>Category</th>
                                <th>Stock Quantity</th>
                                <th>Price</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody id="itemTableBody">
                            <!-- AJAX will populate this -->
                        </tbody>
                    </table>
                </div>
                <!-- /Container -->
            </div>
        </div>

        <!-- Bootstrap Modal for Add Item -->
        <div class="modal fade" id="addItemModal" tabindex="-1" aria-labelledby="addItemModalLabel"
             aria-hidden="true">
            <div class="modal-dialog modal-lg">
                <div class="modal-content">
                    <form id="addItemForm" method="post" enctype="multipart/form-data" action="AddItemsServlet"
                          onsubmit="return validateAddItemForm();">
                        <div class="modal-header">
                            <h5 class="modal-title" id="addItemModalLabel">Add Item</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <div class="modal-body">
                            <!-- Item Name -->
                            <div class="mb-3">
                                <label class="form-label">Item Name</label> <input type="text" class="form-control"
                                                                                   name="itemName" required>
                            </div>
                            <!-- Description -->
                            <div class="mb-3">
                                <label class="form-label">Description</label>
                                <textarea class="form-control" name="description" rows="3"></textarea>
                            </div>
                            <!-- Price -->
                            <div class="mb-3">
                                <label class="form-label">Price</label> <input type="number" step="0.01" class="form-control"
                                                                               name="price" id="price" required>
                            </div>
                            <!-- Stock Quantity -->
                            <div class="mb-3">
                                <label class="form-label">Stock Quantity</label> <input type="number" class="form-control"
                                                                                        name="stockQuantity" id="stockQuantity" required>
                            </div>
                            <!-- Category -->
                            <div class="mb-3">
                                <label class="form-label">Category</label> <select class="form-control" name="category"
                                                                                   id="category" onchange="toggleCustomCategory();" required>
                                    <option value="">Select Category</option>
                                    <option value="Electronics">Electronics</option>
                                    <option value="Clothing">Clothing</option>
                                    <option value="Books">Books</option>
                                    <option value="Others">Others</option>
                                </select>
                            </div>
                            <div class="mb-3" id="customCategoryDiv" style="display: none;">
                                <label class="form-label">Custom Category</label> <input type="text" class="form-control"
                                                                                         id="customCategory" name="customCategory" placeholder="Type custom category">
                            </div>
                            <!-- Image Upload -->
                            <div class="mb-3">
                                <label class="form-label">Image</label> <input type="file" class="form-control" name="image"
                                                                               accept="image/*">
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                            <button type="submit" class="btn btn-primary">Save Item</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </body>
    <!-- Scripts -->
    <script src="assets/js/bootstrap.bundle.min.js"></script>
    <script src="assets/js/ap_index.js"></script>
    <script src="assets/js/ap_item.js"></script>
</html>
