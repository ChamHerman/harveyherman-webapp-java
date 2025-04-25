<%@page import="java.util.List"%>
<%@page import="model.CartItem"%>
<%@ page import="model.UserData" %>
<%@ page import="model.Cart" %>
<!doctype html>
<html lang="en">
    <head>
        <!-- Default Head -->
        <jsp:include page="head.jsp" />
        <title>Checkout - HarveyHerman</title>

        <!-- Bootstrap CSS -->
        <link href="<%= request.getContextPath()%>/assets/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">
        <link href="<%= request.getContextPath()%>/assets/css/tiny-slider.css" rel="stylesheet">
        <link href="<%= request.getContextPath()%>/assets/css/style.css" rel="stylesheet">
        <!-- Custom CSS -->
        <link href="<%= request.getContextPath()%>/assets/css/checkout.css" rel="stylesheet">

    </head>

    <body>

        <!-- Header -->
        <jsp:include page="header.jsp" />

        <!-- Start Hero Section -->
        <div class="hero">
            <div class="container">
                <div class="row justify-content-between">
                    <div class="col-lg-5">
                        <div class="intro-excerpt">
                            <h1>Checkout</h1>
                        </div>
                    </div>

                </div>
            </div>
        </div>
        <!-- End Hero Section -->
        <%
            UserData user = (UserData) session.getAttribute("loggedInUser");
            Cart cart = (Cart) session.getAttribute("cart");
            List<CartItem> cartItems = (List<CartItem>) session.getAttribute("cartItems");
            Double cartSubtotal = (Double) session.getAttribute("cartSubtotal");
            Double deliveryFee = (Double) session.getAttribute("deliveryFee");
            Double discount = (Double) session.getAttribute("discount");
            Double cartTotal = (Double) session.getAttribute("cartTotal");
            String paymentMethod = (String) session.getAttribute("paymentMethod");
        %>
        <!-- Delivery Banner -->
        <div class="container" style="margin-top: 1rem;">
            <div class="alert alert-info d-flex align-items-center justify-content-center p-3 rounded shadow-sm" style="background: linear-gradient(90deg, #d4f5e9 0%, #e8fbe6 100%); color: #22543d; font-size: 1.1rem; font-weight: 500; border: 1px solid #b7e4c7;">
                <i class="fa fa-shopping-basket me-2" style="font-size: 1.3em;"></i>
                Please check & verify your <span style="color:#38a169;font-weight:700;" class="mx-1">Delivery Details</span> before <span style="color:#38a169;font-weight:700;" class="mx-1">Placed Order</span>!
            </div>
        </div>
        <% String error = (String) request.getAttribute("error"); %>
        <% if (error != null) {%>
        <div class="alert alert-danger text-center mb-4"><%= error%></div>
        <% }%>
        <div class="untree_co-section">
            <div class="container">
                <div class="row">
                    <form id="checkoutForm" action="AddOrderServlet" method="post">
                        <!-- left -->
                        <div class="col-md-5">
                            <!-- Billing Details -->
                            <div class="billing-section">
                                <h3>Delivery Details</h3>
                                <div class="form-group mb-4">
                                    <label>Receiver Name</label>
                                    <input type="text" name="receiverName" class="form-control" value="<%= user.getFullname()%>">
                                </div>
                                <div class="form-group mb-4">
                                    <label>Contact Number</label>
                                    <input type="text" name="receiverContact" class="form-control" value="<%= user.getContactNumber()%>">
                                </div>
                                <div class="form-group mb-4">
                                    <label>Address</label>
                                    <input type="text" name="receiverAddress" class="form-control" value="<%= user.getAddress()%>">
                                </div>
                            </div>
                        </div>


                        <div class="col-md-5">
                            <!-- Your Order -->
                            <div class="order-section">
                                <h3>Your Order</h3>
                                <table class="table">
                                    <thead>
                                        <tr>
                                            <th>No.</th>
                                            <th>Product</th>
                                            <th>Unit Price</th>
                                            <th>Quantity</th>
                                            <th>Subtotal</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <%
                                            int rowNum = 1;
                                            if (cartItems != null) {
                                                for (CartItem item : cartItems) {
                                        %>
                                        <tr>
                                            <td><%= rowNum++%></td>
                                            <td><%= item.getItemId().getName()%></td>
                                            <td>RM <%= item.getUnitPrice()%></td>
                                            <td><%= item.getQuantity()%></td>
                                            <td>RM <%= item.getSubtotal()%></td>
                                        </tr>
                                        <%
                                                }
                                            }
                                        %>
                                    </tbody>
                                    <tfoot>
                                        <tr>
                                            <td colspan="4">Subtotal</td>
                                            <td>RM <span id="cartSubtotal"><%= cartSubtotal != null ? String.format("%.2f", cartSubtotal) : "0.00"%></span></td>
                                        </tr>
                                        <tr>
                                            <td colspan="4">Discount</td>
                                            <td>RM <span id="discount"><%= discount != null ? String.format("%.2f", discount) : "0.00"%></span></td>
                                        </tr>
                                        <tr>
                                            <td colspan="4">Delivery Fee</td>
                                            <td>RM <span id="deliveryFee"><%= deliveryFee != null ? String.format("%.2f", deliveryFee) : "0.00"%>  </span></td>
                                        </tr>
                                        <tr>
                                            <td colspan="4"><strong>Total</strong></td>
                                            <td><strong>RM <span id="cartTotal"><%= cartTotal != null ? String.format("%.2f", cartTotal) : "0.00"%></span></strong></td>
                                        </tr>
                                    </tfoot>
                                </table>
                            </div>
                            <!-- Payment Method -->

                            <div class="payment-section mt-4">
                                <h3>Payment Method</h3>
                                <div>
                                    <input type="radio" name="paymentMethod" value="cash" id="cash" checked onclick="toggleCardForm(false)">
                                    <label for="cash">Cash on Delivery</label>
                                </div>
                                <div>
                                    <input type="radio" name="paymentMethod" value="debit_card" id="debit" onclick="toggleCardForm(true)">
                                    <label for="debit">Debit Card</label>
                                </div>
                                <div>
                                    <input type="radio" name="paymentMethod" value="credit_card" id="credit" onclick="toggleCardForm(true)">
                                    <label for="credit">Credit Card</label>
                                </div>
                                <div>
                                    <input type="radio" name="paymentMethod" value="e-wallet" id="ewallet" onclick="toggleCardForm(false)">
                                    <label for="ewallet">E-Wallet</label>
                                </div>
                            </div>

                            <!-- Card Info Modal -->
                            <div id="cardInfo" style="display:none;">
                                <div class="form-group mt-3">
                                    <label>Card Number</label>
                                    <input type="text" name="cardNumber" class="form-control" pattern="\\d{16}" title="16 digits" required>
                                </div>
                                <div class="form-group">
                                    <label>Expiry Date</label>
                                    <input type="text" name="expiryDate" class="form-control" pattern="\\d{2}/\\d{2}" maxlength="5" title="MM/YY" required>
                                </div>
                                <div class="form-group">
                                    <label>CVV</label>
                                    <input type="text" name="cvv" class="form-control" pattern="\\d{3}" maxlength="3" minlength="3" title="3 digits" required>
                                </div>
                            </div>

                            <button type="submit" class="btn btn-primary btn-block mt-4">Place Order</button>

                        </div>
                    </form>
                </div>
            </div>

        </div>


    </body>
    <!-- Footer -->
    <jsp:include page="footer.jsp" />	


    <script src="<%= request.getContextPath()%>/assets/js/bootstrap.bundle.min.js"></script>
    <script src="<%= request.getContextPath()%>/assets/js/tiny-slider.js"></script>
    <script src="<%= request.getContextPath()%>/assets/js/custom.js"></script>
    <script src="<%= request.getContextPath()%>/assets/js/cart.js"></script>
</html>