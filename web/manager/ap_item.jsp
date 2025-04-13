
<%@ page import="java.util.List" %>
<%@ page import="model.ItemDAO" %>
<%@ page import="model.Item" %>
<%@ page import="javax.naming.InitialContext" %>
<%@ page import="javax.naming.NamingException" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Item Management - HarveyHerman</title>
        <!-- Bootstrap CSS -->
        <link href="<%= request.getContextPath()%>/assets/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">
        <link href="<%= request.getContextPath()%>/assets/css/style.css" rel="stylesheet">
        <!-- Custom CSS -->
        <link rel="stylesheet" href="<%= request.getContextPath()%>/assets/css/ap_index.css">
        <link rel="stylesheet" href="<%= request.getContextPath()%>/assets/css/ap_item.css">
    </head>
    <body>
        <%@ include file="apsidebar.jsp" %>
        <div class="main-content flex-grow-1">
            <%@ include file="ap_item_navbar.jsp" %>
            <div class="container">
                <!-- Dashboard Overview Section -->
                <%
                    ItemDAO itemDAO = null;
                    try {
                        InitialContext context = new InitialContext();
                        itemDAO = (ItemDAO) context.lookup("java:global/HarveyHerman/ItemDAO");
                    } catch (NamingException ne) {
                        ne.printStackTrace();
                    }
                    long totalItems = itemDAO.getTotalItemCount();
                    long inStockCount = itemDAO.getInStockItemCount();
                    long outOfStockCount = totalItems - inStockCount;
                    long categoriesCount = itemDAO.getCategoryCount();
                    List<String> allCategories = itemDAO.getAllCategories();

                    // Retrieve filter parameters from request
                    String paramCategory = request.getParameter("category");
                    String paramStock = request.getParameter("stock");
                    String paramSearch = request.getParameter("search");
                    String paramRows = request.getParameter("rows");

                    // Set default values on first load
                    if (paramCategory == null) {
                        paramCategory = "All";
                    }
                    if (paramStock == null) {
                        paramStock = "All";
                    }
                    if (paramSearch == null) {
                        paramSearch = "";
                    }
                    if (paramRows == null) {
                        paramRows = "15";
                    }
                    int rowCount = 15;
                    try {
                        rowCount = Integer.parseInt(paramRows);
                    } catch (Exception e) {
                    }

                    // Retrieve filtered items from DAO using category and stock
                    List<Item> filteredItems = itemDAO.getFilteredItemsByCategoryAndStock(paramCategory, paramStock);
                    // Apply search filter if provided
                    if (paramSearch != null && !paramSearch.trim().isEmpty()) {
                        String searchLower = paramSearch.toLowerCase();
                        java.util.Iterator<Item> iterator = filteredItems.iterator();
                        while (iterator.hasNext()) {
                            Item item = iterator.next();
                            if (!item.getName().toLowerCase().contains(searchLower)) {
                                iterator.remove();
                            }
                        }
                    }
                    // Limit number of rows displayed
                    List<Item> limitedItems = filteredItems.size() > rowCount
                            ? filteredItems.subList(0, rowCount) : filteredItems;
                %>
                <div class="dashboard-summary">
                    <div class="summary-box fs-6" id="totalItems">Total Items: <%= totalItems%></div>
                    <div class="summary-box fs-6" id="inStock">In Stock: <%= inStockCount%></div>
                    <div class="summary-box fs-6" id="outOfStock">Out of Stock: <%= outOfStockCount%></div>
                    <div class="summary-box fs-6" id="categories">Categories: <%= categoriesCount%></div>
                </div>

                <!-- Filter Section -->
                <form method="GET" action="ap_item.jsp">
                    <div class="filter-section">
                        <!-- Row 1 -->
                        <div class="row mb-3">
                            <div class="col-md-3">
                                <label>Category:</label>
                                <select id="categoryFilter" name="category" class="form-select">
                                    <option value="All" <%= "All".equals(paramCategory) ? "selected" : ""%>>All</option>
                                    <% for (String category : allCategories) {%>
                                    <option value="<%= category%>" <%= category.equals(paramCategory) ? "selected" : ""%>>
                                        <%= category%>
                                    </option>
                                    <% }%>
                                </select>
                            </div>
                            <div class="col-md-3">
                                <label>Stock:</label>
                                <select id="stockFilter" name="stock" class="form-select">
                                    <option value="All" <%= "All".equals(paramStock) ? "selected" : ""%>>All</option>
                                    <option value="InStock" <%= "InStock".equals(paramStock) ? "selected" : ""%>>In Stock</option>
                                    <option value="OutOfStock" <%= "OutOfStock".equals(paramStock) ? "selected" : ""%>>Out of Stock</option>
                                </select>
                            </div>
                            <div class="col-md-3">
                                <label>Show Rows:</label>
                                <select id="rowCount" name="rows" class="form-select">
                                    <option value="15" <%= "15".equals(paramRows) ? "selected" : ""%>>15</option>
                                    <option value="30" <%= "30".equals(paramRows) ? "selected" : ""%>>30</option>
                                    <option value="50" <%= "50".equals(paramRows) ? "selected" : ""%>>50</option>
                                </select>
                            </div>
                            <div class="col-md-3 d-flex align-items-end">
                                <button type="submit" class="btn btn-primary me-2">Apply Filter</button>
                                <a href="ap_item.jsp" class="btn btn-outline-secondary">Clear Filter</a>
                            </div>
                        </div>
                        <!-- Row 2 -->
                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label>Search:</label>
                                <div class="input-group">
                                    <input type="text" id="searchInput" name="search" class="form-control" value="<%= paramSearch%>" placeholder="Search item...">
                                    <button class="btn btn-outline-secondary me-2" type="button" id="clearSearch"><i class="fas fa-times"></i></button>
                                </div>
                            </div>
                            <div class="col-md-3 d-flex align-items-end">
                                <button type="submit" class="btn btn-outline-secondary w-100 me-2">Search</button>
                            </div>
                            <div class="col-md-3 d-flex align-items-end">
                                <button type="button" class="btn btn-primary w-100" data-bs-toggle="modal" data-bs-target="#addItemModal">Add Item</button>
                            </div>
                        </div>
                    </div>
                </form>

                <!-- Item Table -->
                <table class="item-table">
                    <thead>
                        <tr>
                            <th>No</th>
                            <th>Item Name</th>
                            <th>Category</th>
                            <th>Stock Quantity</th>
                            <th>Price</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody id="itemTableBody">
                        <% 
                            int i = 1;
                            for (Item item : limitedItems) {                                
                        %>
                        <tr>
                            <td><%=i%></td>
                            <td><%=item.getName()%></td>
                            <td><%=item.getCategory()%></td>
                            <td><%=item.getStockQuantity()%></td>
                            <td>RM <%=item.getPrice()%></td>
                            <td>
                                <button class="btn btn-success btn-sm">Edit</button>
                                <button class="btn btn-primary btn-sm">View</button>
                                <button class="btn btn-danger btn-sm" 
                                        data-itemid="<%=item.getItemId()%>" 
                                        data-bs-toggle="modal" 
                                        data-bs-target="#deleteItemModal">Delete</button>
                            </td>
                        </tr>
                        <%
                          i++;}
                        %>
                    </tbody>
                </table>
            </div>

            <!-- Delete Item Modal -->
            <div class="modal fade" id="deleteItemModal" tabindex="-1" aria-labelledby="deleteItemModalLabel" aria-hidden="true">
                <div class="modal-dialog">
                    <div class="modal-content">
                        <div class="modal-header">
                                <h5 class="modal-title" id="addItemModalLabel">Delete Item</h5>
                                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                            </div>
                        <div class="modal-body">
                            Are you sure you want to delete this item?
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                            <button type="button" class="btn btn-primary" id="confirmDelete">Delete</button>             
                        </div>
                    </div>
                </div>
            </div>

            <!-- Item Deleted Message Modal -->
            <div class="modal fade" id="deleteSuccessModal" tabindex="-1" aria-labelledby="deleteSuccessModalLabel" aria-hidden="true">
                <div class="modal-dialog modal-dialog-centered">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title" id="deleteSuccessModalLabel">Item Deleted Successfully</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <div class="modal-body">
                            <p id="deleteSuccessMessage"></p>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Add Item Modal -->
            <div class="modal fade" id="addItemModal" tabindex="-1" aria-labelledby="addItemModalLabel" aria-hidden="true">
                <div class="modal-dialog modal-lg">
                    <div class="modal-content">
                        <form id="addItemForm" method="post" enctype="multipart/form-data" action="AddItemsServlet"
                              onsubmit="return validateAddItemForm();">
                            <div class="modal-header">
                                <h5 class="modal-title" id="addItemModalLabel">Add New Item</h5>
                                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                            </div>
                            <div class="modal-body">
                                <!-- Item Name -->
                                <div class="mb-3">
                                    <label class="form-label">Item Name</label> <input type="text" class="form-control"
                                                                                       name="itemName" placeholder="Type item name..." required>
                                </div>
                                <!-- Description -->
                                <div class="mb-3">
                                    <label class="form-label">Description</label>
                                    <textarea class="form-control" name="description" rows="3"></textarea>
                                </div>
                                <!-- Price -->
                                <div class="mb-3">
                                    <label class="form-label">Price</label> <input type="number" step="0.01" class="form-control"
                                                                                   name="price" id="price" placeholder="1 - ?" required>
                                </div>
                                <!-- Stock Quantity -->
                                <div class="mb-3">
                                    <label class="form-label">Stock Quantity</label> <input type="number" class="form-control"
                                                                                            name="stockQuantity" id="stockQuantity" placeholder="1 - ?" required>
                                </div>
                                <!-- Category -->
                                <div class="mb-3">
                                    <label class="form-label">Category</label> <select class="form-control" name="category"
                                                                                       id="category" onchange="toggleCustomCategory();" required>
                                        <option value="">Select category...</option>
                                        <option value="Electronics">Electronics</option>
                                        <option value="Clothing">Clothing</option>
                                        <option value="Books">Books</option>
                                        <option value="Others">Others</option>
                                    </select>
                                </div>
                                <div class="mb-3" id="customCategoryDiv" style="display: none;">
                                    <label class="form-label">Custom Category</label> <input type="text" class="form-control"
                                                                                             id="customCategory" name="customCategory" placeholder="Type custom category...">
                                </div>
                                <!-- Image Upload -->
                                <div class="mb-3">
                                    <label class="form-label">Image</label> <input type="file" class="form-control" name="image"
                                                                                   accept="image/*">
                                </div>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                                <button type="submit" class="btn btn-primary">Save New Item</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
            <!-- /Container -->
        </div>
        <script src="<%= request.getContextPath()%>/assets/js/bootstrap.bundle.min.js"></script>
        <script src="<%= request.getContextPath()%>/assets/js/ap_index.js"></script>
        <script> var contextPath = "<%=request.getContextPath()%>";</script>
        <script src="<%= request.getContextPath()%>/assets/js/ap_item.js"></script>

    </body>
</html>
