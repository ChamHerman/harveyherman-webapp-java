<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="model.Orders" %>
<%@ page import="model.Delivery" %>
<%@ page import="model.OrderDetails" %>
<%@ page import="model.Item" %>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.Collections"%>
<%@ page import="java.util.Comparator"%>
<%@ page import="java.util.ArrayList"%>

<%
    List<Orders> orders = (List<Orders>) session.getAttribute("loggedInUserOrders");
    Map<String, Delivery> orderDeliveryMap = (Map<String, Delivery>) session.getAttribute("orderDeliveryMap");
    Map<String, List<OrderDetails>> orderDetailsMap = (Map<String, List<OrderDetails>>) session.getAttribute("orderDetailsMap");
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");

    List<Orders> undeliveredOrders = new ArrayList<>();
    List<Orders> deliveredOrders = new ArrayList<>();
    if (orders != null) {
        for (Orders order : orders) {
            if ("delivered".equalsIgnoreCase(order.getStatus())) {
                deliveredOrders.add(order);
            } else {
                undeliveredOrders.add(order);
            }
        }
    }
    // Sort both lists by created date descending (latest first)
    Comparator<Orders> byCreatedDateDesc = new Comparator<Orders>() {
        public int compare(Orders o1, Orders o2) {
            return o2.getCreatedDate().compareTo(o1.getCreatedDate());
        }
    };
    Collections.sort(undeliveredOrders, byCreatedDateDesc);
    Collections.sort(deliveredOrders, byCreatedDateDesc);
%>
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
        <!-- Custom CSS -->
        <link href="<%=request.getContextPath()%>/assets/css/viewOrders.css" rel="stylesheet">
    </head>
    <body>
        <!-- Header -->
        <jsp:include page="header.jsp" />

        <!-- Hero Section (Order Page) -->
        <div class="shop-hero" style="margin-top: 120px;">
            <div class="container">
                <div class="row justify-content-between align-items-center">
                    <div class="col-lg-6">
                        <div class="intro-excerpt">
                            <h1>Your Orders</h1>
                            <div class="shop-hero-words">
                                View your order history, track delivery status, and confirm receipt of your items.
                            </div>
                        </div>
                    </div>
                    <div class="col-lg-6 d-none d-lg-block position-relative">
                        <img src="<%=request.getContextPath()%>/assets/images/hero-anim-order.svg" class="shop-hero-anim" alt="Order Animation" />
                    </div>
                </div>
            </div>
        </div>
        <!-- /Hero Section -->

        <!-- Delivery Orders -->
        <div class="container mt-4">

            <%
                List<Orders> displayOrders = new ArrayList<>();
                displayOrders.addAll(undeliveredOrders);
                displayOrders.addAll(deliveredOrders);

                if (orders != null && !orders.isEmpty()) {
                    for (Orders order : displayOrders) {
                        Delivery delivery = orderDeliveryMap != null ? orderDeliveryMap.get(order.getOrderId()) : null;
                        String status = order.getStatus() != null ? order.getStatus().toLowerCase() : "";
                        String statusLabel = status.substring(0, 1).toUpperCase() + status.substring(1);
            %>
            <div class="order-card">
                <table class="order-header-table">
                    <tr>
                        <td>No: HH-<%= delivery != null ? delivery.getDeliveryId() : "N/A"%></td>
                        <td>Name: <%= delivery != null ? delivery.getReceiverName() : "N/A"%></td>
                        <td>Contact: <%= delivery != null ? delivery.getReceiverContact() : "N/A"%></td>
                        <%
                            String method = "N/A";
                            if (order.getPaymentMethod().equals("cash")) {
                                method = "Cash on Delivery";
                            } else if (order.getPaymentMethod().equals("debit_card")) {
                                method = "Debit Card";
                            } else if (order.getPaymentMethod().equals("credit_card")) {
                                method = "Credit Card";
                            } else if (order.getPaymentMethod().equals("e-wallet")) {
                                method = "e-Wallet";
                            }
                        %>
                        <td>Payment Method: <%= method%></td>
                        <td style="text-align:right;">
                            Status: <span class="order-status <%= status%>"><%= statusLabel%></span>
                        </td>
                    </tr>
                </table>
                <!-- Address Row (styled like order info) -->
                <table class="order-meta-table">
                    <tr>
                        <td>
                            <span class="meta-label">Address:</span>
                            <span class="meta-value"><%= delivery != null ? delivery.getReceiverAddress() : "N/A"%></span>
                        </td>
                    </tr>
                </table>
                <table class="order-table">
                    <thead>
                        <tr>
                            <th class="item-col" style="text-align: center;">Item</th>
                            <th class="quantity-col" style="text-align: center;">Quantity</th>
                            <th class="price-col" style="text-align: center;">Price</th>
                            <th class="subtotal-col" style="text-align: center;">Subtotal</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            double total = 0.0;
                            List<OrderDetails> details = orderDetailsMap != null ? orderDetailsMap.get(order.getOrderId()) : null;
                            if (details != null) {
                                for (OrderDetails detail : details) {
                                    Item item = detail.getItemId();
                                    double price = detail.getPricePerItem().doubleValue();
                                    int qty = detail.getQuantity();
                                    double subtotal = price * qty;
                                    total += subtotal;
                        %>
                        <tr>
                            <td style="display: flex; align-items: center;">
                                <img src="<%=request.getContextPath()%>/assets/<%=item.getImageUrl()%>" onclick="postItemDetails('<%=item.getItemId()%>')" alt="Item Image" style="width: 30%; height: 30%; object-fit: cover; border-radius: 8px; margin-right: 2rem; cursor: pointer; box-shadow: 0 4px 16px rgba(56,161,105,0.13); ">
                                <a class="item-link" href="javascript:void(0);" onclick="postItemDetails('<%=item.getItemId()%>')">
                                    <%= item.getName()%>
                                </a>
                            </td>
                            <td style="text-align: center;"><%= qty%></td>
                            <td style="text-align: center;">RM <%= String.format("%.2f", price)%></td>
                            <td style="text-align: center;">RM <%= String.format("%.2f", subtotal)%></td>
                        </tr>
                        <%
                                }
                            }
                        %>
                    </tbody>
                    <tfoot>
                        <tr class="order-total-row">
                            <td colspan="3" style="text-align:right;">Total:</td>
                            <td style="text-align: center;">RM <%= String.format("%.2f", total)%></td>
                        </tr>
                    </tfoot>
                </table>
                <!-- Created/Delivered Date Row + Confirm Button -->
                <table class="order-meta-table" style="margin-top: 0.5rem;">
                    <tr>
                        <td>
                            <span class="meta-label">Order Created:</span>
                            <span class="meta-value"><%= order.getCreatedDate() != null ? sdf.format(order.getCreatedDate()) : "N/A"%></span>
                            <% if ("delivered".equals(status) && delivery != null && delivery.getDeliveredDate() != null) {%>
                            <span class="meta-label" style="margin-left:2em;">Confirm Delivered:</span>
                            <span class="meta-value"><%= sdf.format(delivery.getDeliveredDate())%></span>
                            <% } %>
                            <% if ("delivery".equals(status)) {%>
                            <span style="float:right;">
                                <button class="confirm-btn" onclick="showConfirmModal('<%= delivery != null ? delivery.getDeliveryId() : ""%>')">Confirm Order Delivered</button>
                            </span>
                            <% } else if ("delivered".equals(status)) { %>
                            <span style="float:right;">
                                <button class="delivered-btn" disabled>Order Delivered</button>
                            </span>
                            <% } %>
                        </td>
                    </tr>
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
        <!-- /Delivery Orders -->

        <!-- Confirm Modal -->
        <div class="modal fade" id="confirmModal" tabindex="-1" aria-labelledby="confirmModalLabel" aria-hidden="true">
            <div class="modal-dialog">
                <form id="confirmForm" method="post" action="ConfirmDeliveryServlet">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title" id="confirmModalLabel">Confirm Delivery</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <div class="modal-body">
                            Are you sure this order has been delivered?
                            <input type="hidden" name="deliveryId" id="modalDeliveryId">
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-success" data-bs-dismiss="modal">Cancel</button>
                            <button type="submit" class="btn btn-primary">Yes, Confirm</button>
                        </div>
                    </div>
                </form>
            </div>
        </div>

        <!-- Hidden form and JS for item details navigation -->
        <form id="itemForm" action="details" method="post" style="display: none;">
            <input type="hidden" name="itemId" id="itemId">
        </form>

    </body>
    <!-- Footer -->
    <jsp:include page="footer.jsp" />

    <!-- Scripts -->
    <script src="<%=request.getContextPath()%>/assets/js/bootstrap.bundle.min.js"></script>
    <script>
                                    function postItemDetails(itemId) {
                                        document.getElementById("itemId").value = itemId;
                                        document.getElementById("itemForm").submit();
                                    }
                                    function showConfirmModal(deliveryId) {
                                        document.getElementById("modalDeliveryId").value = deliveryId;
                                        var modal = new bootstrap.Modal(document.getElementById('confirmModal'));
                                        modal.show();
                                    }
    </script>


</html>
