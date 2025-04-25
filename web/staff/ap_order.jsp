<%@ page import="java.util.List"%>
<%@ page import="model.Orders"%>
<%@ page import="model.OrderDAO" %>
<%@ page import="controller.AddOrderServlet" %>
<%@ page import="java.util.Arrays"%>
<%@ page import="java.util.Set"%>
<%@ page import="java.util.HashSet"%>
<%@ page import="javax.naming.InitialContext" %>
<%@ page import="javax.naming.NamingException" %>
<%@ page import="java.text.SimpleDateFormat" %>


<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Order Management - HarveyHerman</title>

        <!-- Bootstrap CSS Side -->
        <link href="<%= request.getContextPath()%>/assets/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">
        <link href="<%= request.getContextPath()%>/assets/css/style.css" rel="stylesheet">

        <!-- Custom CSS -->
        <link rel="stylesheet" href="<%= request.getContextPath()%>/assets/css/ap_index.css">
        <link rel="stylesheet" href="<%= request.getContextPath()%>/assets/css/ap_item.css">
        <link rel="stylesheet" href="<%= request.getContextPath()%>/assets/css/ap_order.css">
    </head>

    <body>
        <%@ include file="ap_sidebar.jsp" %>
        <div class="main-content flex-grow-1">
            <div class="container">
                <%                    OrderDAO orderDAO = null;
                    try {
                        InitialContext context = new InitialContext();
                        // Adjust the JNDI lookup path as needed depending on your server configuration
                        orderDAO = (OrderDAO) context.lookup("java:global/HarveyHerman/OrderDAO");
                    } catch (NamingException ne) {
                        ne.printStackTrace();
                    }

                    // Use OrderDAO to retrieve order data
                    List<Orders> ordersList = null;
                    if (orderDAO != null) {
                        ordersList = orderDAO.getAllOrders();
                    }

                    long totalOrders = orderDAO != null ? orderDAO.countAllOrders() : 0;
                %>
                <%
                    long packagingCount = orderDAO.countOrdersByStatus("packaging");
                    long shippingCount = orderDAO.countOrdersByStatus("shipping");
                    long deliveryCount = orderDAO.countOrdersByStatus("delivery");
                    long deliveredCount = orderDAO.countOrdersByStatus("delivered");
                %>
                <!-- Dashboard Overview Section -->
                <h2>Order Dashboard</h2>
                <div class="total-order-box">
                    <div class="total-orders">
                        <p>Total Orders: <%= totalOrders%></p>
                    </div>
                </div>


                <div class="dashboard-summary">
                    <div class="summary-box" id="processing">
                        <p>Packaging: <%= packagingCount%></p>
                    </div>
                    <div class="summary-box" id="shipping"> 
                        <p>Shipping: <%= shippingCount%></p>
                    </div>
                    <div class="summary-box" id="delivery">
                        <p>Delivery <%= deliveryCount%></p>
                    </div>
                    <div class="summary-box" id="delivered">
                        <p> Delivered: <%= deliveredCount%></p>
                    </div>
                </div>


                <!-- Search Function -->
                <div class="order-controls d-flex align-items-end mb-3">
                    <form action="FilterOrderServlet" method="get" class="flex-grow-1 me-2 d-flex align-items-end">
                        <div class="form-group mb-0 me-2">
                            <label for="statusSelect" class="form-label mb-0 me-2">Order Status:</label>
                            <select name="status" id="statusSelect" class="form-control me-2">
                                <option value="">All</option>
                                <option value="Packaging">Packaging</option>
                                <option value="Shipping">Shipping</option>
                                <option value="Delivery">Delivery</option>
                                <option value="Delivered">Delivered</option>
                            </select>
                        </div>
                        <button type="submit" class="btn btn-primary" id="searchButton">Search</button>
                    </form>
                </div>

                <!-- Order Table -->
                <table class="order-table">
                    <thead>
                        <tr>
                            <th>No.</th>
                            <th>Order ID</th>
                            <th>User ID</th>
                            <th>Total Amount (RM)</th>
                            <th>Payment method</th>
                            <th>Status</th>
                            <th>Created Date</th>
                            <th colspan="3" >Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <%
    List<Orders> orders = (List<Orders>) session.getAttribute("filteredOrders");
    if (orders == null) {
        // fallback: load all orders if not filtered
        orders = ... // call your DAO or whatever you did before
    }
%>
                            <%
                                if (ordersList != null) {
                                    int rowNum = 1;
                                    for (Orders order : ordersList) {
                            %>
                            <%
                                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
                            %>
                            <td><%= rowNum++%>. </td>
                            <td><%= order.getOrderId()%></td>
                            <td><%= order.getUserId() != null ? order.getUserId().getUserId() : ""%></td>
                            <td>
                                <%= order.getTotalAmount()%>
                            </td>
                            <td><%= order.getPaymentMethod() != null ? order.getPaymentMethod().replace("_", " ").substring(0, 1).toUpperCase() + order.getPaymentMethod().replace("_", " ").substring(1) : ""%>
                            </td>
                            <td><%= order.getStatus().toLowerCase()%></td>
                            <td><%= sdf.format(order.getCreatedDate())%></td>
                            <td>
                                <button class="btn btn-info" onclick="viewOrder('<%= order.getOrderId()%>')">View</button>
                            </td>
                            <td>
                                <button class="btn btn-secondary" onclick="confirmDeleteOrder('<%= order.getOrderId()%>')">
                                    Delete
                                </button>
                            </td>


                            <%
                                String status = order.getStatus().toLowerCase();
                            %>
                            <td>
                                <form class="status-form d-flex align-items-center" method="post" action="<%= request.getContextPath()%>/staff/UpdateOrderServlet" onsubmit="return confirmStatusChange(this, '<%= order.getOrderId()%>');">
                                    <input type="hidden" name="orderId" value="<%= order.getOrderId()%>">
                                    <input type="hidden" name="oldStatus" value="<%= order.getStatus()%>">

                                    <%
                                        if ("packaging".equals(status)) {
                                    %>
                                    <select name="status" class="form-select form-select-sm me-2">
                                        <option value="packaging" <%= "packaging".equalsIgnoreCase(order.getStatus()) ? "selected" : ""%>>Packaging</option>
                                        <option value="shipping" <%= "shipping".equalsIgnoreCase(order.getStatus()) ? "selected" : ""%>>Shipping</option>
                                        <option value="delivery" <%= "delivery".equalsIgnoreCase(order.getStatus()) ? "selected" : ""%>>Delivery</option>
                                    </select>
                                    <button type="submit" class="btn btn-sm btn-primary">Save</button>
                                    <%
                                    } else if ("shipping".equals(status)) {
                                    %>
                                    <select name="status" class="form-select form-select-sm me-2">
                                        <option value="shipping" <%= "shipping".equalsIgnoreCase(order.getStatus()) ? "selected" : ""%>>Shipping</option>
                                        <option value="delivery" <%= "delivery".equalsIgnoreCase(order.getStatus()) ? "selected" : ""%>>Delivery</option>
                                    </select>
                                    <button type="submit" class="btn btn-sm btn-primary">Save</button>
                                    <%
                                    } else if ("delivery".equals(status)) {
                                    %>        <select name="status" class="form-select form-select-sm me-2" disabled>
                                        <option value="delivery" selected>Delivery</option>
                                    </select>
                                    <%
                                        }
                                    %>
                                    
                                </form>
                            </td>
                        </tr>
                        <%
                            }
                        } else {
                        %>
                        <tr>
                            <td colspan="9">No orders found.</td>
                        </tr>
                        <%
                            }
                        %>
                    </tbody>
                </table>
            </div>
        </div>

        <!-- Search Results Modal -->
        <div class="modal fade" id="statusOrdersModal" tabindex="-1" aria-labelledby="statusOrdersModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-lg">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="statusOrdersModalLabel">Orders by Status</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <table class="table table-bordered">
                            <thead>
                                <tr>
                                    <th>Order ID</th>
                                    <th>User</th>
                                    <th>Total Amount</th>
                                    <th>Status</th>
                                    <th>Created Date</th>
                                </tr>
                            </thead>
                            <tbody id="statusOrdersTableBody">
                                <!-- Results will be inserted here -->
                            </tbody>
                        </table>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                    </div>
                </div>
            </div>
        </div>

        <!-- View Order Modal -->
        <div class="modal fade" id="orderDetailsModal" tabindex="-1" aria-labelledby="orderDetailsModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-lg">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="orderDetailsModalLabel">Order Details</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body" id="orderDetailsBody">
                        <!-- Details will be loaded here -->
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                    </div>
                </div>
            </div>
        </div>

        <!-- Delete Order Modal -->
        <div class="modal fade" id="deleteOrderModal" tabindex="-1" aria-labelledby="deleteOrderModalLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 id="deleteOrderModalLabel" class="modal-title">Confirm Delete</h5>
                    </div>
                    <div class="modal-body">
                        Are you sure you want to delete order with id "<span id="orderToDelete"> </span>" ?
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="button" class="btn btn-danger" id="confirmDeleteOrder">Yes, Delete</button>
                    </div>
                </div>
            </div>
        </div>

        <!-- Edit status confirmation modal -->
        <div class="modal fade" id="confirmStatusModal" tabindex="-1" aria-labelledby="confirmStatusModalLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="confirmStatusModalLabel">Confirm Status Change</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body" id="confirmStatusModalBody">
                        <!-- Content set by JS -->
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="button" class="btn btn-primary" id="confirmStatusBtn">Confirm</button>
                    </div>
                </div>
            </div>
        </div>




        <script src="<%= request.getContextPath()%>/assets/js/bootstrap.bundle.min.js"></script>
        <script src="<%= request.getContextPath()%>/assets/js/ap_order.js"></script>

        <script> var contextPath = "<%=request.getContextPath()%>";</script>
    </body>
</html>