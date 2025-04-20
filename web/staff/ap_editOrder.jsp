<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Orders" %>
<%@ page import="model.OrderDAO" %>
<%@ page import="java.text.SimpleDateFormat" %>

<%
    OrderDAO orderDAO = null;
    try {
        javax.naming.InitialContext context = new javax.naming.InitialContext();
        OrderDAO = (model.OrderDAO) context.lookup("java:global/HarveyHerman/OrderDAO");
    } catch (javax.naming.NamingException ne) {
        ne.printStackTrace();
    }
%>  

<%
    Orders order = (Orders) request.getAttribute("order");
    if (order == null) {
        out.println("Order not found.");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Edit Order - Harvey Herman</title>
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
                <h2>Edit Order</h2>
                <form action="UpdateOrderServlet" method="post">
                    <!-- Hidden input for order id -->
                    <input type="hidden" name="orderId" value="<%= order.getOrderId()%>">

                    <div class="mb-3">
                        <label for="totalAmount" class="form-label">Total Amount</label>
                        <input type="number" step="1.0" class="form-control" id="totalAmount" name="totalAmount" 
                               value="<%= order.getTotalAmount()%>" required>
                    </div>

                    <div class="mb-3">
                        <label for="paymentMethod" class="form-label">Payment Method</label>
                        <select class="form-select" id="paymentMethod" name="paymentMethod" required>
                            <option value="cash" <%= "cash".equals(order.getPaymentMethod()) ? "selected" : ""%>>Cash</option>
                            <option value="debit_card" <%= "debit_card".equals(order.getPaymentMethod()) ? "selected" : ""%>>Debit Card</option>
                            <option value="credit_card" <%= "credit_card".equals(order.getPaymentMethod()) ? "selected" : ""%>>Credit Card</option>
                            <option value="e-wallet" <%= "e-wallet".equals(order.getPaymentMethod()) ? "selected" : ""%>>E-wallet</option>
                        </select>
                    </div>

                    <div class="mb-3">
                        <label for="status" class="form-label">Status</label>
                        <select class="form-select" id="status" name="status" required>
                            <option value="pending" <%= "pending".equals(order.getStatus()) ? "selected" : ""%>>Pending</option>
                            <option value="packaging" <%= "packaging".equals(order.getStatus()) ? "selected" : ""%>>Packaging</option>
                            <option value="shipping" <%= "shipping".equals(order.getStatus()) ? "selected" : ""%>>Shipping</option>
                            <option value="delivered" <%= "delivered".equals(order.getStatus()) ? "selected" : ""%>>Delivered</option>
                        </select>
                    </div>

                    <div class="mb-3">
                        <label for="promotionId" class="form-label">Promotion Id (Optional)</label>
                        <input type="text" class="form-control" id="promotionId" name="promotionId" 
                               value="<%= order.getPromotionId() != null ? order.getPromotionId() : ""%>">
                    </div>

                    <div class="mb-3">
                        <label for="createdDate" class="form-label">Created Date</label>
                        <input type="date" class="form-control" id="createdDate" name="createdDate" 
                               value="<%= new java.text.SimpleDateFormat("yyyy-MM-dd").format(order.getCreatedDate())%>" required>
                    </div>

                    <button type="submit" class="btn btn-primary">Save</button>
                    <a href="OrderServlet" class="btn btn-secondary">Cancel</a>
                </form>
            </div>
        </div>
            <script src="assets/js/bootstrap.bundle.min.js"></script>
    </body>
</html>