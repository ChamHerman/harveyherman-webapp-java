<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="java.util.Arrays" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Item" %>

<%
if (request.getParameter("itemId") != null && request.getAttribute("item") == null) {
    model.ItemDAO itemDAO = null;
    try {
        javax.naming.InitialContext context = new javax.naming.InitialContext();
        itemDAO = (model.ItemDAO) context.lookup("java:global/HarveyHerman/ItemDAO");
    } catch (javax.naming.NamingException ne) {
        ne.printStackTrace();
    }
    String itemId = request.getParameter("itemId");
    model.Item itemTemp = itemDAO.getItemById(itemId);
    request.setAttribute("item", itemTemp);
}
%>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Edit Item - HarveyHerman</title>
        <!-- Bootstrap CSS -->
        <link href="<%= request.getContextPath()%>/assets/css/bootstrap.min.css" rel="stylesheet">
        <link href="<%= request.getContextPath()%>/assets/css/style.css" rel="stylesheet">
        <!-- Custom CSS -->
        <link rel="stylesheet" href="<%= request.getContextPath()%>/assets/css/ap_index.css">
        <link rel="stylesheet" href="<%= request.getContextPath()%>/assets/css/ap_item.css">
    </head>
    <body>
        <%@ include file="ap_sidebar.jsp" %>
        <div class="main-content flex-grow-1">
            <div class="container mt-4">
                <h2>Edit Item</h2>
                <%
                    Item item = (Item) request.getAttribute("item");
                    if (item == null) {
                %>
                <div class="alert alert-danger mt-4">Item not found.</div>
                <%
                } else {
                    // Default category list for the dropdown
                    List<String> defaultCategories = new ArrayList<String>(
                            Arrays.asList("Kitchen Appliances", "Cooking & Bakeware", "Refrigeration & Cooling",
                                    "Laundry & Cleaning", "Lighting & Electrical", "Heating & Air Conditioning",
                                    "Bathroom Essentials", "Furniture & Décor")
                    );
                %>
                <form id="editItemForm" method="post" enctype="multipart/form-data" action="<%= request.getContextPath()%>/manager/EditItemsServlet" onsubmit="return validateEditItemForm();">
                    <input type="hidden" name="itemId" value="<%= item.getItemId()%>">
                    <div class="mb-3">
                        <label class="form-label">Item Name</label>
                        <input type="text" class="form-control" name="itemName" value="<%= item.getName()%>" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Description</label>
                        <textarea class="form-control" name="description" rows="3"><%= item.getDescription() != null ? item.getDescription() : ""%></textarea>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Price</label>
                        <input type="number" step="0.01" class="form-control" name="price" value="<%=item.getPrice()%>" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Stock Quantity</label>
                        <input type="number" class="form-control" name="stockQuantity" value="<%=item.getStockQuantity()%>" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Category</label>
                        <select class="form-select" name="category" id="category" onchange="toggleCustomCategory();">
                            <option value="">Select category...</option>
                            <%
                                for (String cat : defaultCategories) {
                                    String selected = cat.equals(item.getCategory()) ? "selected" : "";
                            %>
                            <option value="<%= cat%>" <%= selected%>><%= cat%></option>
                            <%
                                }
                                String othersSelected = !defaultCategories.contains(item.getCategory()) ? "selected" : "";
                            %>
                            <option value="Others" <%= othersSelected%>>Others</option>
                        </select>
                    </div>
                    <div class="mb-3" id="customCategoryDiv" style="display: <%= othersSelected.equals("selected") ? "block" : "none"%>;">
                        <label class="form-label">Custom Category</label>
                        <input type="text" class="form-control" id="customCategory" name="customCategory" value="<%= othersSelected.equals("selected") ? item.getCategory() : ""%>">
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Picture</label>
                        <div class="mb-2" id="imageContainer" style="cursor:pointer;">
                            <img id="itemImagePreview" src="<%= request.getContextPath()%>/assets/<%= item.getImageUrl() != null ? item.getImageUrl() : "assets/default.jpg"%>" alt="Item Image" class="img-fluid rounded border" style="max-height:200px;">
                            <small class="form-text text-muted">Click image to select a new one.</small>
                        </div>
                        <input type="file" class="form-control d-none" name="image" id="imageInput" accept=".jpg, .jpeg, .png, .webp, .svg">
                    </div>
                    <div class="mb-3">
                        <button type="submit" class="btn btn-primary">Save Changes</button>
                        <a href="<%= request.getContextPath()%>/manager/ap_item.jsp" class="btn btn-secondary ms-2">Cancel</a>
                    </div>
                </form>
                <%
                } // end if item exists
%>
            </div>
        </div>
        <script src="<%= request.getContextPath()%>/assets/js/bootstrap.bundle.min.js"></script>
        <script src="<%= request.getContextPath()%>/assets/js/ap_item.js"></script>
    </body>
</html>
