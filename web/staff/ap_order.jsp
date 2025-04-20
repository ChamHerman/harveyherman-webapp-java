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
        <link href="<%= request.getContextPath()%>assets/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">
        <link href="<%= request.getContextPath()%>assets/css/style.css" rel="stylesheet">

        <!-- Custom CSS -->
        <link rel="stylesheet" href="<%= request.getContextPath()%>assets/css/ap_index.css">
        <link rel="stylesheet" href="<%= request.getContextPath()%>assets/css/ap_order.css">
        <link rel="stylesheet" href="<%= request.getContextPath()%>assets/css/ap_item.css">
    </head>

    <body>
        <div class="d-flex">
            <%@ include file="apsidebar.jsp" %>
            <div class="main-content flex-grow-1">
                <%@ include file="/staff/ap_item_navbar.jsp" %>
                <div class="container">
                    <%
                        OrderDAO orderDAO = null;
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

                    <!-- Dashboard Overview Section -->
                    <h2>Order Dashboard</h2>
                    <div class="dashboard-summary single-summary">
                        <div class="summary-box total-orders">
                            Total Orders: <%= totalOrders%>
                        </div>
                    </div>
                    <%
                        long pendingCount = orderDAO.countOrdersByStatus("pending");
                        long packagingCount = orderDAO.countOrdersByStatus("packaging");
                        long shippingCount = orderDAO.countOrdersByStatus("shipping");
                        long deliveredCount = orderDAO.countOrdersByStatus("delivered");
                    %>

                    <div class="dashboard-summary">
                        <div class="summary-box" id="pending">
                            <p>Pending: <%= pendingCount%></p>
                        </div>
                        <div class="summary-box" id="processing">
                            <p>Packaging: <%= packagingCount%></p>
                        </div>
                        <div class="summary-box" id="shipping"> 
                            <p>Shipping: <%= shippingCount%></p>
                        </div>
                        <div class="summary-box" id="delivered">
                            <p> Delivered: <%= deliveredCount%></p>
                        </div>
                    </div>
                </div>

                <!-- Search Function -->
                <div class="order-search-section">
                    <form action="FilterOrderServlet" method="get">
                        <div class="form-group">
                            <label for="statusSelect">Order Status:</label>
                            <select name="status" id="statusSelect" class="form-control">
                                <option value="">All</option>
                                <option value="Pending">Pending</option>
                                <option value="Packaging">Packaging</option>
                                <option value="Shipping">Shipping</option>
                                <option value="Delivered">Delivered</option>
                            </select>
                        </div>
                        <button type="submit" class="btn btn-primary" id="searchButton">Search</button>
                    </form>

                    <div class="modal fade" id="orderDetailsModal" tabindex="-1" aria-labelledby="orderDetailsModalLabel" aria-hidden="true">
                        <div class="modal-dialog">
                            <div class="modal-content">
                                <div class="modal-header">
                                    <h5 class="modal-title" id="orderDetailsModalLabel">Order Details</h5>
                                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                </div>
                                <div class="modal-body">
                                    <p><strong>Order ID:</strong> <span id="orderId"></span></p>
                                    <p><strong>User:</strong> <span id="user"></span></p>
                                    <p><strong>Total Amount:</strong> <span id="totalAmount"></span></p>
                                    <p><strong>Created Date:</strong> <span id="createdDate"></span></p>
                                </div>
                                <div class="modal-footer">
                                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Add Order Button -->
                </div>
                <div class="right-controls">
                    <br/>
                    <button class="btn btn-primary" onclick="location.href = 'AddOrderServlet?action=new'" id="addOrder">Add Order</button>
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
                            <th colspan="2" >Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <%
                                if (ordersList != null) {
                                    for (Orders order : ordersList) {
                            %>
                            <%
                                SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
                            %>
                            <td> </td>
                            <td><%= order.getOrderId()%></td>
                            <td><%= order.getUserId()%></td>
                            <td><%= order.getTotalAmount()%></td>
                            <td><%= order.getPaymentMethod()%></td>
                            <td><%= order.getStatus().toLowerCase()%></td>
                            <td><%= sdf.format(order.getCreatedDate())%></td>
                            <td>
                                <button class="btn btn-danger" onclick="confirmDeleteOrder('<%= order.getOrderId()%>')">
                                    Delete
                                </button>
                            </td>

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

                    <td>
                        <a href="UpdateOrderServlet?orderId=<%= order.getOrderId()%>" class="btn btn-secondary">Edit</a>
                    </td>
                    </tr>
                    <%
                        }
                    } else {
                    %>
                    <tr>
                        <td colspan="8">No orders found.</td>
                    </tr>
                    <%
                        }
                    %>
                    </tbody>
                </table>
            </div>
        </div>
    <script src="<%= request.getContextPath()%>assets/js/bootstrap.bundle.min.js"></script>
    <script src="<%= request.getContextPath()%>/assets/js/ap_index.js"></script>
    <script> var contextPath = "<%=request.getContextPath()%>";</script>
    <script src="<%= request.getContextPath()%>assets/js/ap_order.js"></script>
    </body>
</html>