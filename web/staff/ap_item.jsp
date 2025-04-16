<!-- For Staff -->
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Comparator"%>
<%@ page import="java.util.Collections"%>
<%@ page import="java.util.Arrays"%>
<%@ page import="java.util.ArrayList" %>
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
        <title>Item Management - Staff</title>
        <!-- Bootstrap CSS -->
        <link href="<%= request.getContextPath()%>/assets/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">
        <link href="<%= request.getContextPath()%>/assets/css/style.css" rel="stylesheet">
        <!-- Custom CSS -->
        <link rel="stylesheet" href="<%= request.getContextPath()%>/assets/css/ap_index.css">
        <link rel="stylesheet" href="<%= request.getContextPath()%>/assets/css/ap_item.css">
    </head>
    <body>
        <%@ include file="ap_sidebar.jsp" %>
        <!-- Main Content -->
        <div class="main-content flex-grow-1">
            <%@ include file="/staff/ap_item_navbar.jsp" %>
            <div class="container">

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

                    if (filteredItems != null) {
                        Collections.sort(filteredItems, new Comparator<Item>() {
                            @Override
                            public int compare(Item i1, Item i2) {
                                if (i1.getCreatedDate() == null || i2.getCreatedDate() == null) {
                                    return 0;
                                }
                                return i2.getCreatedDate().compareTo(i1.getCreatedDate());
                            }
                        });
                    }
                    // Limit number of rows displayed
                    List<Item> limitedItems = filteredItems.size() > rowCount ? filteredItems.subList(0, rowCount) : filteredItems;
                %>
                <!-- Dashboard Overview Section -->
                <div class="dashboard-summary">
                    <div class="summary-box fs-6" id="totalItems">Total Items: <%= totalItems%></div>
                    <div class="summary-box fs-6" id="inStock">In Stock: <%= inStockCount%></div>
                    <div class="summary-box fs-6" id="outOfStock">Out of Stock: <%= outOfStockCount%></div>
                    <div class="summary-box fs-6" id="categories">Categories: <%= categoriesCount%></div>
                </div>
                <!-- /Dashboard Overview Section -->

                <!-- Filter Section -->
                <form method="POST" action="<%= request.getContextPath()%>/staff/ap_item.jsp">
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
                <!-- /Filter Section -->

                <!-- Item Table -->
                <table class="item-table">
                    <thead>
                        <tr>
                            <th>No</th>
                            <th>ID</th>
                            <th>Item Name</th>
                            <th>Category</th>
                            <th>Stock Quantity</th>
                            <th>Price</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody id="itemTableBody">
                        <% if (limitedItems == null || limitedItems.isEmpty()) { %>
                        <tr>
                            <td colspan="6" class="text-center">No items available.</td>
                        </tr>
                        <%
                        } else {
                            int i = 1;
                            for (Item item : limitedItems) {
                        %>
                        <tr>
                            <td><%=i%></td>
                            <td><%=item.getItemId()%></td>
                            <td><%=item.getName()%></td>
                            <td><%=item.getCategory()%></td>
                            <td><%=item.getStockQuantity()%></td>
                            <td>RM <%=String.format("%.2f", item.getPrice())%></td>
                            <td>
                                <button class="btn btn-edit btn-sm" onclick="location.href='<%= request.getContextPath() %>/staff/ap_edit_item.jsp?itemId=<%=item.getItemId()%>'">Edit</button>
                                <button class="btn btn-view btn-sm" onclick="viewItem('<%=item.getItemId()%>')">View</button>
                            </td>
                        </tr>
                        <%
                                    i++;
                                }
                            }
                        %>
                    </tbody>
                </table>
                <!-- /Item Table -->
            </div>
            <!-- /Container -->

            <!-- Item Result Message Modal -->
            <div class="modal fade" id="itemResultMessageModal" tabindex="-1" aria-labelledby="itemResultMessageModalLabel" aria-hidden="true">
                <div class="modal-dialog modal-dialog-centered">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title" id="itemResultMessageModalLabel">Item Result Message</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <div class="modal-body">
                            <p id="itemResultMessage"></p>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                        </div>
                    </div>
                </div>
            </div>
            <!-- /Item Result Message Modal -->

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
                                    <%
                                        // Define the default categories
                                        List<String> defaultCategories = new ArrayList<String>(Arrays.asList("Kitchen Appliances", "Cooking & Bakeware", "Refrigeration & Cooling",
                                                "Laundry & Cleaning", "Lighting & Electrical", "Heating & Air Conditioning", "Bathroom Essentials", "Furniture & Décor"));
                                        List<String> mergedCategories = new ArrayList<String>(defaultCategories);
                                        // Merge the two lists, excluding duplicates and "Others"
                                        if (allCategories != null) {
                                            for (String cat : allCategories) {
                                                if (cat != null && !cat.trim().isEmpty() && !mergedCategories.contains(cat) && !"Others".equals(cat)) {
                                                    mergedCategories.add(cat);
                                                }
                                            }
                                        }
                                    %>
                                    <label class="form-label">Category</label> <select class="form-control" name="category"
                                                                                       id="category" onchange="toggleCustomCategory();" required>
                                        <option value="">Select category...</option>
                                        <% for (String cat : mergedCategories) {%>
                                        <option value="<%=cat%>"><%=cat%></option>
                                        <% }%>
                                        <option value="Others">Others</option>
                                    </select>
                                </div>
                                <div class="mb-3" id="customCategoryDiv" style="display: none;">
                                    <label class="form-label">Custom Category</label> <input type="text" class="form-control"
                                                                                             id="customCategory" name="customCategory" placeholder="Type custom category...">
                                </div>
                                <!-- Image Upload -->
                                <div class="mb-3">
                                    <label class="form-label">Image</label>
                                    <input type="file" class="form-control text-center file-input" name="image" accept=".jpg, .jpeg, .png, .webp, .svg" required>
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
            <!-- /Add Item Modal -->

            <!-- View Item Modal -->
            <div class="modal fade" id="viewItemModal" tabindex="-1" aria-labelledby="viewItemModalLabel" aria-hidden="true">
                <div class="modal-dialog modal-dialog-centered modal-lg">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title" id="viewItemModalLabel">View Item</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <div class="modal-body">
                            <!-- Large Image -->
                            <div class="text-center mb-3">
                                <img id="viewItemImage" src="" alt="Item Image" class="img-fluid rounded border" style="max-height: 300px;">
                            </div>
                            <!-- Image URL/Name -->
                            <div class="text-center mb-3">
                                <small id="viewItemImageUrl" class="text-muted"></small>
                            </div>
                            <!-- Item Details -->
                            <div class="container">
                                <div class="row mb-2">
                                    <div class="col-sm-4 font-weight-bold">Item ID:</div>
                                    <div class="col-sm-8" id="viewItemId"></div>
                                </div>
                                <div class="row mb-2">
                                    <div class="col-sm-4 font-weight-bold">Name:</div>
                                    <div class="col-sm-8" id="viewItemName"></div>
                                </div>
                                <div class="row mb-2">
                                    <div class="col-sm-4 font-weight-bold">Description:</div>
                                    <div class="col-sm-8" id="viewItemDescription"></div>
                                </div>
                                <div class="row mb-2">
                                    <div class="col-sm-4 font-weight-bold">Category:</div>
                                    <div class="col-sm-8" id="viewItemCategory"></div>
                                </div>
                                <div class="row mb-2">
                                    <div class="col-sm-4 font-weight-bold">Price:</div>
                                    <div class="col-sm-8" id="viewItemPrice"></div>
                                </div>
                                <div class="row mb-2">
                                    <div class="col-sm-4 font-weight-bold">Stock Quantity:</div>
                                    <div class="col-sm-8" id="viewItemStock"></div>
                                </div>
                                <div class="row mb-2">
                                    <div class="col-sm-4 font-weight-bold">Created Date:</div>
                                    <div class="col-sm-8" id="viewItemCreatedDate"></div>
                                </div>
                                <div class="row mb-2">
                                    <div class="col-sm-4 font-weight-bold">Updated Date:</div>
                                    <div class="col-sm-8" id="viewItemUpdatedDate"></div>
                                </div>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                        </div>
                    </div>
                </div>
            </div>
            <!-- /View Item Modal -->

        </div>
        <!-- /Main Content -->

        <!-- JavaScript Import -->
        <script src="<%= request.getContextPath()%>/assets/js/bootstrap.bundle.min.js"></script>
        <script src="<%= request.getContextPath()%>/assets/js/ap_index.js"></script>
        <!-- Set default context path (staff/) -->
        <script> var contextPath = "<%=request.getContextPath()%>";</script>
        <script src="<%= request.getContextPath()%>/assets/js/ap_item.js"></script>
        <!-- /JavaScript Import -->
    </body>
</html>
