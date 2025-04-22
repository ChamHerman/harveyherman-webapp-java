<!-- For Manager -->
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
        <title>Item Management - Manager</title>
        <!-- Bootstrap CSS -->
        <link href="<%= request.getContextPath()%>/assets/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">
        <link href="<%= request.getContextPath()%>/assets/css/style.css" rel="stylesheet">
        <!-- Custom CSS -->
        <link rel="stylesheet" href="<%= request.getContextPath()%>/assets/css/ap_index.css">
        <link rel="stylesheet" href="<%= request.getContextPath()%>/assets/css/ap_item.css">
    </head>
    <body>
        <!-- Side Bar -->
        <%@ include file="ap_sidebar.jsp" %>
        <!-- Main Content -->
        <div class="main-content flex-grow-1">
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

                    // Clear filters if requested
                    if ("1".equals(request.getParameter("clearFilter"))) {
                        session.removeAttribute("categoryFilter");
                        session.removeAttribute("stockFilter");
                        session.removeAttribute("rowsFilter");
                        session.removeAttribute("pageFilter");
                        session.removeAttribute("sortFilter");
                        session.removeAttribute("orderFilter");
                    }

                    String paramSort = request.getParameter("sort");
                    String paramOrder = request.getParameter("order");

                    if (paramSort != null) {
                        session.setAttribute("sortFilter", paramSort);
                    }
                    if (paramOrder != null) {
                        session.setAttribute("orderFilter", paramOrder);
                    }

                    String sessionSort = (String) session.getAttribute("sortFilter");
                    String sessionOrder = (String) session.getAttribute("orderFilter");

                    if (sessionSort == null) {
                        sessionSort = "createdDate"; // default sort
                    }
                    if (sessionOrder == null) {
                        sessionOrder = "desc";      // default order
                    }
                    // Get or set session filter values
                    String paramCategory = request.getParameter("category");
                    String paramStock = request.getParameter("stock");
                    String paramRows = request.getParameter("rows");

                    // Only update session if user changed filter (i.e., form submitted)
                    if (paramCategory != null) {
                        session.setAttribute("categoryFilter", paramCategory);
                    }
                    if (paramStock != null) {
                        session.setAttribute("stockFilter", paramStock);
                    }
                    if (paramRows != null) {
                        session.setAttribute("rowsFilter", paramRows);
                    }

                    // Use session value if available, else default
                    String sessionCategory = (String) session.getAttribute("categoryFilter");
                    String sessionStock = (String) session.getAttribute("stockFilter");
                    String sessionRows = (String) session.getAttribute("rowsFilter");

                    if (sessionCategory == null) {
                        sessionCategory = "All";
                    }
                    if (sessionStock == null) {
                        sessionStock = "All";
                    }
                    if (sessionRows == null) {
                        sessionRows = "15";
                    }

                    // For search, do not persist
                    String paramSearch = request.getParameter("search");
                    if (paramSearch == null) {
                        paramSearch = "";
                    }

                    // Retrieve filtered items from DAO using category and stock
                    List<Item> filteredItems = itemDAO.getFilteredItemsByCategoryAndStock(sessionCategory, sessionStock);
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
                        final String sortField = sessionSort;
                        final String sortOrder = sessionOrder;

                        Collections.sort(filteredItems, new Comparator<Item>() {
                            @Override
                            public int compare(Item i1, Item i2) {
                                int result = 0;
                                if ("name".equals(sortField)) {
                                    result = i1.getName().compareToIgnoreCase(i2.getName());
                                } else if ("price".equals(sortField)) {
                                    result = i1.getPrice().compareTo(i2.getPrice());
                                } else if ("stock".equals(sortField)) {
                                    result = Integer.compare(i1.getStockQuantity(), i2.getStockQuantity());
                                } else { // "createdDate" or default
                                    if (i1.getCreatedDate() == null || i2.getCreatedDate() == null) {
                                        return 0;
                                    }
                                    result = i1.getCreatedDate().compareTo(i2.getCreatedDate());
                                }
                                return "desc".equals(sortOrder) ? -result : result;
                            }
                        });
                    }

                    String paramPage = request.getParameter("page");
                    if (paramPage != null) {
                        session.setAttribute("pageFilter", paramPage);
                    }
                    String sessionPage = (String) session.getAttribute("pageFilter");
                    int currentPage = 1;
                    try {
                        if (sessionPage != null) {
                            currentPage = Integer.parseInt(sessionPage);
                        }
                    } catch (Exception e) {
                        currentPage = 1;
                    }

                    int rowCount = Integer.parseInt(sessionRows);
                    int totalItemsCount = filteredItems.size();
                    int totalPages = (int) Math.ceil((double) totalItemsCount / rowCount);

                    // Clamp currentPage
                    if (currentPage < 1) {
                        currentPage = 1;
                    }
                    if (currentPage > totalPages && totalPages > 0) {
                        currentPage = totalPages;
                    }
                    if (totalPages == 0) {
                        currentPage = 1; // If no items, stay on page 1
                    }
                    int startIdx = (currentPage - 1) * rowCount;
                    if (startIdx < 0) {
                        startIdx = 0;
                    }
                    int endIdx = Math.min(startIdx + rowCount, totalItemsCount);

                    // Avoid subList errors if no items
                    List<Item> limitedItems = (startIdx < endIdx) ? filteredItems.subList(startIdx, endIdx) : new ArrayList<>();
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
                <form method="post" action="ap_item.jsp">
                    <div class="filter-section">
                        <!-- Row 1 -->
                        <div class="row mb-3">
                            <div class="col-md-3">
                                <!-- Category Filter -->
                                <label>Category:</label>
                                <select id="categoryFilter" name="category" class="form-select">
                                    <option value="All" <%= "All".equals(sessionCategory) ? "selected" : ""%>>All</option>
                                    <% for (String category : allCategories) {%>
                                    <option value="<%= category%>" <%= category.equals(sessionCategory) ? "selected" : ""%>><%= category%></option>
                                    <% }%>
                                </select>
                            </div>
                            <div class="col-md-3">
                                <!-- Stock Filter -->
                                <label>Stock:</label>
                                <select id="stockFilter" name="stock" class="form-select">
                                    <option value="All" <%= "All".equals(sessionStock) ? "selected" : ""%>>All</option>
                                    <option value="InStock" <%= "InStock".equals(sessionStock) ? "selected" : ""%>>In Stock</option>
                                    <option value="OutOfStock" <%= "OutOfStock".equals(sessionStock) ? "selected" : ""%>>Out of Stock</option>
                                </select>
                            </div>
                            <div class="col-md-3">
                                <!-- Rows Filter -->
                                <label>Show Rows:</label>
                                <select id="rowCount" name="rows" class="form-select">
                                    <option value="15" <%= "15".equals(sessionRows) ? "selected" : ""%>>15</option>
                                    <option value="30" <%= "30".equals(sessionRows) ? "selected" : ""%>>30</option>
                                    <option value="50" <%= "50".equals(sessionRows) ? "selected" : ""%>>50</option>
                                </select>
                            </div>
                            <div class="col-md-3 d-flex align-items-end">
                                <button type="submit" class="btn btn-primary me-2">Apply Filter</button>
                                <a href="ap_item.jsp?clearFilter=1" class="btn btn-outline-secondary">Clear Filter</a>
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
                            <th>
                                <a href="ap_item.jsp?sort=name&order=<%= "name".equals(sessionSort) && "asc".equals(sessionOrder) ? "desc" : "asc"%>">
                                    Item Name
                                    <% if ("name".equals(sessionSort)) {%>
                                    <%= "asc".equals(sessionOrder) ? "↑" : "↓"%>
                                    <% } %>
                                </a>
                            </th>
                            <th>Category</th>
                            <th>Stock Quantity</th>
                            <th>Price</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody id="itemTableBody">
                        <% if (limitedItems == null || limitedItems.isEmpty()) { %>
                        <tr>
                            <td colspan="7" class="text-center">No items available.</td>
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
                                <button class="btn btn-edit btn-sm" onclick="location.href = '<%= request.getContextPath()%>/manager/ap_edit_item.jsp?itemId=<%=item.getItemId()%>'">Edit</button>
                                <button class="btn btn-view btn-sm" onclick="viewItem('<%=item.getItemId()%>')">View</button>
                                <button class="btn btn-delete btn-sm" 
                                        data-itemid="<%=item.getItemId()%>" 
                                        data-bs-toggle="modal" 
                                        data-bs-target="#deleteItemModal">Delete</button>
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
                <% if (totalPages > 1) {%>
                <div class="d-flex justify-content-end align-items-center mt-3">
                    <nav>
                        <ul class="pagination mb-0">
                            <li class="page-item <%= (currentPage == 1) ? "disabled" : ""%>">
                                <a class="page-link" href="ap_item.jsp?page=<%= currentPage - 1%>" tabindex="-1">&laquo; Prev</a>
                            </li>
                            <% for (int i = 1; i <= totalPages; i++) {%>
                            <li class="page-item <%= (i == currentPage) ? "active" : ""%>">
                                <a class="page-link" href="ap_item.jsp?page=<%= i%>"><%= i%></a>
                            </li>
                            <% }%>
                            <li class="page-item <%= (currentPage == totalPages) ? "disabled" : ""%>">
                                <a class="page-link" href="ap_item.jsp?page=<%= currentPage + 1%>">Next &raquo;</a>
                            </li>
                        </ul>
                    </nav>
                </div>
                <% }%>
            </div>
            <!-- /Container -->

            <!-- Delete Item Modal -->
            <form id="deleteItemForm" method="post" action="<%=request.getContextPath()%>/manager/DeleteItemsServlet">
                <div class="modal fade" id="deleteItemModal" tabindex="-1" aria-labelledby="deleteItemModalLabel" aria-hidden="true">
                    <div class="modal-dialog modal-dialog-centered">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h5 class="modal-title" id="deleteItemModalLabel">Delete Item</h5>
                                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                            </div>
                            <div class="modal-body">
                                Are you sure you want to delete this item?
                                <input type="hidden" name="itemId" id="deleteModalItemId" value="" />
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                                <button type="submit" class="btn btn-primary" id="confirmDelete">Delete</button>             
                            </div>
                        </div>
                    </div>
                </div>
            </form>
            <!-- /Delete Item Modal -->

            <!-- Item Result Message Modal -->
            <div class="modal fade" id="itemResultMessageModal" tabindex="-1" aria-labelledby="itemResultMessageModalLabel" aria-hidden="true">
                <div class="modal-dialog modal-dialog-centered">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title" id="itemResultMessageModalLabel">Item Result Message</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <div class="modal-body">
                            <p id="itemResultMessage" class="item-result-message"></p>
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
                              onsubmit="return validateAddItemForm();" autocomplete="off">
                            <div class="modal-header">
                                <h5 class="modal-title" id="addItemModalLabel">Add New Item</h5>
                                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                            </div>
                            <div class="modal-body">
                                <!-- Image Upload -->
                                <div class="mb-3 text-center" id="addImageUploadArea" style="position:relative; cursor:pointer; max-width:220px; margin:auto;">
                                    <img id="addItemImagePreview" src="<%= request.getContextPath()%>/assets/images/default.svg" alt="Item Image" class="img-fluid rounded border" style="max-height:200px;">
                                    <div id="addUploadOverlay" style="position:absolute; top:0; left:0; width:100%; height:100%; background:rgba(0,0,0,0.4); color:#fff; display:flex; align-items:center; justify-content:center; opacity:0; transition:opacity 0.2s;">
                                        <span>Click to upload image</span>
                                    </div>
                                    <input type="file" class="form-control d-none" name="image" id="addImageInput" accept=".jpg, .jpeg, .png, .webp, .svg">
                                </div>
                                <!-- Item Name -->
                                <div class="mb-3">
                                    <label class="form-label">Item Name <span class="text-muted">(Max Characters: 100)</span></label><input type="text" class="form-control"
                                                                                       name="itemName" placeholder="Type item name..." autocomplete="off" required>
                                </div>
                                <!-- Description -->
                                <div class="mb-3">
                                    <label class="form-label">Description <span class="text-muted">(Max Characters: 1000)</span></label>
                                    <textarea class="form-control" name="description" rows="3"></textarea>
                                </div>
                                <!-- Price -->
                                <div class="mb-3">
                                    <label class="form-label">Price <span class="text-muted">(Min: 0.01 | Max: 9999999.99)</span></label>
                                    <input type="number" step="0.01" min="0.01" max="9999999.99" class="form-control" name="price" id="price" placeholder="Enter price (0.01 - 9999999.99)" required>
                                </div>
                                <!-- Stock Quantity -->
                                <div class="mb-3">
                                    <label class="form-label">Stock Quantity <span class="text-muted">(Min: 0 | Max: 9999999)</span></label>
                                    <input type="number" step="1" min="0" max="9999999" class="form-control" name="stockQuantity" id="stockQuantity" placeholder="Enter stock (0 - 9999999)" required>
                                </div>
                                <!-- Category -->
                                <div class="mb-3">
                                    <%
                                        // Define the default categories
                                        List<String> defaultCategories = new ArrayList<>(Arrays.asList("Kitchen Appliances", "Cooking & Bakeware", "Refrigeration & Cooling",
                                                "Laundry & Cleaning", "Lighting & Electrical", "Heating & Air Conditioning", "Bathroom Essentials", "Furniture & Decor"));
                                        List<String> mergedCategories = new ArrayList<>(defaultCategories);
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
                                <!-- Custom Category -->
                                <div class="mb-3" id="customCategoryDiv" style="display: none;">
                                    <label class="form-label">Custom Category <span class="text-muted">(Max Characters: 50)</span></label>
                                    <input type="text" class="form-control" id="customCategory" name="customCategory" placeholder="Type custom category..." autocomplete="off">
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

            <!-- Loading Modal -->
            <div class="modal fade" id="loadingModal" tabindex="-1" aria-hidden="true" data-bs-backdrop="static" data-bs-keyboard="false">
                <div class="modal-dialog modal-dialog-centered">
                    <div class="modal-content text-center" style="background: transparent; border: none; box-shadow: none;">
                        <div class="modal-body">
                            <div class="spinner-border text-primary" style="width: 4rem; height: 4rem;" role="status"></div>
                            <div class="mt-3 text-white fs-5">Processing, please wait...</div>
                        </div>
                    </div>
                </div>
            </div>
            <!-- /Loading Modal -->

        </div>
        <!-- /Main Content -->

        <!-- JavaScript Import -->
        <script src="<%= request.getContextPath()%>/assets/js/bootstrap.bundle.min.js"></script>
        <!-- Set default context path (manager/) -->
        <script> var contextPath = "<%=request.getContextPath()%>";</script>
        <script src="<%= request.getContextPath()%>/assets/js/ap_item.js"></script>
        <!-- /JavaScript Import -->
    </body>
</html>
