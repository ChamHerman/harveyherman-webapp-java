<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Orders" %>

<html>
    <head>
        <meta charset="UTF-8">
        <title>Add Order - HarveyHerman</title>
        <link href="<%= request.getContextPath()%>assets/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="<%= request.getContextPath()%>/assets/css/ap_index.css">
        <link rel="stylesheet" href="<%= request.getContextPath()%>/assets/css/ap_item.css">
        <link rel="stylesheet" href="<%= request.getContextPath()%>/assets/css/ap_order.css">
        
        <script>
            function confirmAdd() {
                return confirm("Are you sure you want to add this order?");
            }

            //when user click cancel back to Order page
            function cancelForm() {
                window.location.href = 'ap_order.jsp';
            }
        </script>
    </head>
    <body>
        <div class="container mt-4">
            <h2>Add Order</h2>
            <form method="post" action="AddOrderServlet" onsubmit="return confirmAdd();">
                <div class="mb-3">
                    <label for="userId" class="form-label">User Id</label>
                    <input type="text" class="form-control" id="userId" name="userId" required>
                </div>
                <div class="mb-3">
                    <label for="totalAmount" class="form-label">Total Amount</label>
                    <input type="number" step="1.0" class="form-control" id="totalAmount" name="totalAmount" required>
                </div>
                <div class="mb-3">
                    <label for="paymentMethod" class="form-label">Payment Method</label>
                    <select class="form-select" id="paymentMethod" name="paymentMethod" required>
                        <option value="cash">Cash</option>
                        <option value="debit_card">Debit Card</option>
                        <option value="credit_card">Credit Card</option>
                        <option value="e-wallet">E-wallet</option>
                    </select>
                </div>
                <div class="mb-3">
                    <label for="status" class="form-label">Status</label>
                    <select class="form-select" id="status" name="status" required>
                        <option value="pending">Pending</option>
                        <option value="packaging">Packaging</option>
                        <option value="shipping">Shipping</option>
                        <option value="delivered">Delivered</option>
                    </select>
                </div>
                <div class="mb-3">
                    <label for="promotionId" class="form-label">Promotion Id (Optional)</label>
                    <input type="text" class="form-control" id="promotionId" name="promotionId">
                </div>
                <div class="mb-3">
                    <label for="createdDate" class="form-label">Created Date</label>
                    <input type="date" class="form-control" id="createdDate" name="createdDate" required>
                </div>
                <button type="submit" class="btn btn-primary">OK</button>
                <button type="reset" class="btn btn-secondary">Reset</button>
                <button type="cancel" class="btn btn-danger" onclick="cancelForm()">Cancel</button>
            </form>
        </div>
        <script src="<%= request.getContextPath()%>assets/js/bootstrap.bundle.min.js"></script>
    </body>
</html>