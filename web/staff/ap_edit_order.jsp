<%@ page import="model.Orders" %>
<%@ page import="java.text.SimpleDateFormat" %>
<html>
    <%
        Orders order = (Orders) request.getAttribute("order");
        if (order == null) {
    %>
    <div class="alert alert-danger">Order not found.</div>
    <%
    } else {
    %>


    <head>
        <title>Edit Order</title>
        <link href="<%= request.getContextPath()%>/assets/css/bootstrap.min.css" rel="stylesheet">
    </head>
    <body>
        <div class="container mt-4">
            <h2>Edit Order</h2>
            <form method="post" action="UpdateOrderServlet">
                <input type="hidden" name="orderId" value="<%= order.getOrderId()%>">
                <div class="mb-3">
                    <label for="userId" class="form-label">User ID</label>
                    <input type="text" class="form-control" id="userId" name="userId" value="<%= order.getUserId().getUserId()%>" required pattern="U\d{3}">
                    <div class="form-text">Format: U??? (e.g. U001)</div>
                </div>
                <div class="mb-3">
                    <label for="totalAmount" class="form-label">Total Amount</label>
                    <input type="number" class="form-control" id="totalAmount" name="totalAmount" value="<%= order.getTotalAmount()%>" readonly>
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
                    <label for="promotionId" class="form-label">Promotion ID</label>
                    <input type="text" class="form-control" id="promotionId" name="promotionId" value="<%= order.getPromotionId() != null ? order.getPromotionId().getPromotionId() : ""%>" readonly>
                </div>
                <div class="mb-3">
                    <label for="createdDate" class="form-label">Created Date</label>
                    <input type="text" class="form-control" id="createdDate" name="createdDate" value="<%= new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(order.getCreatedDate())%>" readonly>
                </div>
                <button type="submit" class="btn btn-primary">Save Changes</button>
                <a href="ap_order.jsp" class="btn btn-secondary">Cancel</a>
            </form>
        </div>

        <!-- Show Edit Error Modal -->
        <div class="modal fade" id="errorModal" tabindex="-1" aria-labelledby="errorModalLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header bg-danger text-white">
                        <h5 class="modal-title" id="errorModalLabel">Error</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <%= request.getAttribute("error") != null ? request.getAttribute("error") : ""%>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                    </div>
                </div>
            </div>
        </div>

        <% if (request.getAttribute("error") != null) { %>
        <script>
            document.addEventListener('DOMContentLoaded', function () {
                var errorModal = new bootstrap.Modal(document.getElementById('errorModal'));
                errorModal.show();
            });
        </script>
        <% }%>


        <script src="<%= request.getContextPath()%>/assets/js/bootstrap.bundle.min.js"></script>
        <script src="<%= request.getContextPath()%>/assets/js/ap_index.js"></script>
        <script src="<%= request.getContextPath()%>/assets/js/ap_order.js"></script>
    </body>
</html>
<%
    }
%>
