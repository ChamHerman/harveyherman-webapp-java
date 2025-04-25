<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="model.Orders" %>
<%@ page import="model.Delivery" %>
<%@ page import="model.OrderDetails" %>
<%@ page import="model.Item" %>
<!DOCTYPE html>
<html>
    <head>
        <!-- Default Head -->
        <jsp:include page="head.jsp" />
        <title>View Orders - HarveyHerman</title>

        <!-- Bootstrap Template CSS -->
        <link href="<%=request.getContextPath()%>/assets/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css"
              rel="stylesheet">
        <link href="<%=request.getContextPath()%>/assets/css/tiny-slider.css" rel="stylesheet">
        <link href="<%=request.getContextPath()%>/assets/css/style.css" rel="stylesheet">
        <!-- Custom CSS for Orders -->
        <link href="<%=request.getContextPath()%>/assets/css/viewOrders.css" rel="stylesheet">
    </head>
    <body>
        <!-- Header -->
        <jsp:include page="header.jsp" />
        <div class="container mt-4">
            <h2>Your Orders</h2>
            <%
                List<Orders> orders = (List<Orders>) session.getAttribute("loggedInUserOrders");
                int orderCount = 1;
            %>
            <%
                if (orders != null && !orders.isEmpty()) {
                    for (Orders order : orders) {
                        Delivery delivery = null;
                        if (order.getDeliveryList() != null && !order.getDeliveryList().isEmpty()) {
                            delivery = order.getDeliveryList().get(0); // Assuming one delivery per order
                        }
            %>
            <div class="order-card">
                <div class="order-header">
                    No: DO-<%= orderCount++ %> |
                    Name: <%= delivery != null ? delivery.getReceiverName() : "N/A" %> |
                    Contact: <%= delivery != null ? delivery.getReceiverContact() : "N/A" %>
                </div>
                <div class="order-address">
                    Address: <%= delivery != null ? delivery.getReceiverAddress() : "N/A" %>
                </div>
                <table class="order-table">
                    <thead>
                        <tr>
                            <th>Item</th>
                            <th>Description</th>
                            <th>Quantity</th>
                            <th>Price (per unit)</th>
                            <th>Subtotal</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            double total = 0.0;
                            for (OrderDetails detail : order.getOrderDetailsList()) {
                                Item item = detail.getItemId();
                                double price = detail.getPricePerItem().doubleValue();
                                int qty = detail.getQuantity();
                                double subtotal = price * qty;
                                total += subtotal;
                        %>
                        <tr>
                            <td>
                                <a class="item-link" href="javascript:void(0);" onclick="postItemDetails('<%=item.getItemId()%>')">
                                    <%= item.getName() %>
                                </a>
                            </td>
                            <td><%= item.getDescription() %></td>
                            <td><%= qty %></td>
                            <td>RM <%= String.format("%.2f", price) %></td>
                            <td>RM <%= String.format("%.2f", subtotal) %></td>
                        </tr>
                        <%
                            }
                        %>
                    </tbody>
                    <tfoot>
                        <tr class="order-total-row">
                            <td colspan="4" style="text-align:right;">Total:</td>
                            <td>RM <%= String.format("%.2f", total) %></td>
                        </tr>
                    </tfoot>
                </table>
            </div>
            <%
                    }
                } else {
            %>
            <div class="alert alert-info">You have no orders yet.</div>
            <%
                }
            %>
        </div>
        <!-- Hidden form and JS for item details navigation -->
        <form id="itemForm" action="<%=request.getContextPath()%>/user/details" method="post" style="display: none;">
            <input type="hidden" name="itemId" id="itemId">
        </form>
        <script>
            function postItemDetails(itemId) {
                document.getElementById("itemId").value = itemId;
                document.getElementById("itemForm").submit();
            }
        </script>
        <!-- Footer -->
        <jsp:include page="footer.jsp" />
        <!-- Scripts -->
        <script src="<%=request.getContextPath()%>/assets/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
