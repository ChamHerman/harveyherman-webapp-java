<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List"%>
<%@ page import="model.CartItem"%>
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
        <style>
            .shop-hero {
                background: linear-gradient(120deg, #3b5d50 60%, #f9bf29 100%);
                padding: 5rem 0 3rem 0;
                position: relative;
                overflow: hidden;
                margin-top: 120px;
            }
            .shop-hero h1 {
                color: #fff !important;
                font-weight: 800;
                letter-spacing: 0.01em;
                margin-bottom: 0.7rem;
            }
            .shop-hero .shop-hero-words {
                color: #fff;
                font-size: 1.25rem;
                font-weight: 500;
                margin-bottom: 1.5rem;
                letter-spacing: 0.03em;
                opacity: 0.92;
                animation: shopFadeInUp 1.2s cubic-bezier(.23,1.01,.32,1) 0.2s;
            }
            .shop-hero .shop-hero-anim {
                position: absolute;
                right: 40px;
                width: 60%;
                max-width: 300px;
                min-width: 300px;
                height: auto;
                opacity: 0.20;
                z-index: 1;
                animation: shopFloat 4s ease-in-out infinite alternate;
                pointer-events: none;
            }
            @keyframes shopFadeInUp {
                from {
                    opacity: 0;
                    transform: translateY(30px);
                }
                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }
            @keyframes shopFloat {
                from {
                    transform: translateY(-80px);
                }
                to {
                    transform: translateY(-100px);
                }
            }
            @media (max-width: 991px) {
                .shop-hero .shop-hero-anim {
                    right: 10px;
                    top: 60%;
                    width: 55%;
                    max-width: 180px;
                    min-width: 90px;
                    opacity: 0.13;
                }
            }
        </style>


    </head>

    <body>

        <!-- Header -->
        <jsp:include page="header.jsp" />

        <!-- Hero Section (Checkout Page) -->
        <div class="shop-hero" style="margin-top: 120px;">
            <div class="container">
                <div class="row justify-content-between align-items-center">
                    <div class="col-lg-6">
                        <div class="intro-excerpt">
                            <h1>Checkout</h1>
                            <div class="shop-hero-words">
                                You're almost there! Please review your order, confirm your delivery details, and select your preferred payment method to complete your purchase.
                            </div>
                        </div>
                    </div>
                    <div class="col-lg-6 d-none d-lg-block position-relative">
                        <img src="<%=request.getContextPath()%>/assets/images/checkout-hero.svg" class="shop-hero-anim" alt="Checkout Animation" />
                    </div>
                </div>
            </div>
        </div>
        <!-- /Hero Section -->
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

                <form id="checkoutForm" action="AddOrderServlet" method="post">
                    <div class="row">
                        <hr class="mb-4">
                        <!-- Your Order -->
                        <div class="order-section">
                            <h3 class="mb-4">Your Order</h3>
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
                                        <td colspan="4">Delivery Fee</td>
                                        <td>RM <span id="deliveryFee"><%= deliveryFee != null ? String.format("%.2f", deliveryFee) : "0.00"%>  </span></td>
                                    </tr>
                                    <tr>
                                        <td colspan="4">Discount</td>
                                        <td>RM <span id="discount"><%= discount != null ? String.format("%.2f", discount) : "0.00"%></span></td>
                                    </tr>
                                    <tr>
                                        <td colspan="4"><strong>Total</strong></td>
                                        <td><strong>RM <span id="cartTotal"><%= cartTotal != null ? String.format("%.2f", cartTotal) : "0.00"%></span></strong></td>
                                    </tr>
                                </tfoot>
                            </table>
                        </div>
                        <hr class="mb-4">

                        <div class="row">
                            <!-- Delivery Details (left) -->
                            <div class="col-md-5">
                                <div class="billing-section">
                                    <h3>Delivery Details</h3>
                                    <div class="form-group mb-4">
                                        <label>Receiver Name</label>
                                        <input type="text" name="receiverName" class="form-control" maxlength="50" autocomplete="off" value="<%= user.getFullname()%>" required>
                                    </div>
                                    <div class="form-group mb-4">
                                        <label>Contact Number</label>
                                        <input type="text" id="contactNumber" name="receiverContact" maxlength="12" class="form-control" autocomplete="off" value="<%= user.getContactNumber()%>" required>
                                    </div> 
                                    <div class="form-group mb-4">
                                        <label>Address</label>
                                        <input type="text" id="address" name="receiverAddress" class="form-control" maxlength="100" autocomplete="off" value="<%= user.getAddress()%>" required>
                                    </div>
                                </div>
                            </div>
                            <!-- Payment Method, Card Details, Place Order (right, stacked) -->
                            <div class="col-md-7 d-flex flex-column">
                                <div class="row">
                                    <div style="padding-left: 4rem"class="col-md-6">
                                        <h3 class="mb-4">Payment Method</h3> 
                                        <div class="payment-options mb-3">
                                            <div class="form-check mb-3 d-flex align-items-center">
                                                <input type="radio" name="paymentMethod" value="cash" id="cash" class="form-check-input me-2">
                                                <label for="cash" class="form-check-label me-2"><i class="fa fa-money-bill-wave me-2"></i>Cash on Delivery</label>
                                            </div>
                                            <div class="form-check mb-3 d-flex align-items-center">
                                                <input type="radio" name="paymentMethod" value="debit_card" id="debit" class="form-check-input me-2">
                                                <label for="debit" class="form-check-label me-2"><i class="fa fa-credit-card me-2"></i>Debit Card</label>
                                            </div>
                                            <div class="form-check mb-3 d-flex align-items-center">
                                                <input type="radio" name="paymentMethod" value="credit_card" id="credit" class="form-check-input me-2">
                                                <label for="credit" class="form-check-label me-2"><i class="fa fa-credit-card me-2"></i>Credit Card</label>
                                            </div>
                                            <div class="form-check mb-3 d-flex align-items-center">
                                                <input type="radio" name="paymentMethod" value="e-wallet" id="ewallet" class="form-check-input me-2">
                                                <label for="ewallet" class="form-check-label me-2"><i class="fa fa-mobile-alt me-2"></i>E-Wallet</label>
                                            </div>
                                        </div>
                                        <div id="paymentError" class="alert alert-danger" style="display: none;"></div>
                                    </div>
                                    <!-- Card Details (right in right col) -->
                                    <div class="col-md-6 d-flex justify-content-center align-items-start">
                                        <div id="cardInfo" class="card-details mb-3 border rounded shadow-sm p-4 bg-white" style="display:none; max-width:400px; width:100%;">
                                            <div class="d-flex align-items-center mb-4">
                                                <h3 class="mb-0">Card Details</h3>
                                            </div>
                                            <!-- Card Error (text only, no background) -->
                                            <span id="cardError" class="text-danger mb-2" style="display: none; font-size: 0.95em;"></span>
                                            <div class="form-group mb-3">
                                                <label for="cardHolder">Card Holder Name</label>
                                                <input type="text" name="cardHolder" id="cardHolder" class="form-control" maxlength="50" autocomplete="off" placeholder="Enter card holder name">
                                            </div>
                                            <div class="form-group mb-3">
                                                <label for="cardNumber">Card Number</label>
                                                <input type="text" name="cardNumber" id="cardNumber" class="form-control" maxlength="19" placeholder="XXXX-XXXX-XXXX-XXXX" autocomplete="cc-number">
                                            </div>
                                            <div class="row">
                                                <div class="col-md-6">
                                                    <div class="form-group mb-3">
                                                        <label for="expiryDate">Expiry Date</label>
                                                        <input type="text" name="expiryDate" id="expiryDate" class="form-control" maxlength="5" placeholder="MM-YY" autocomplete="cc-exp">
                                                    </div>
                                                </div>
                                                <div class="col-md-6">
                                                    <div class="form-group mb-3">
                                                        <label for="cvv">CVV</label>
                                                        <input type="text" name="cvv" id="cvv" class="form-control" maxlength="3" placeholder="CVV" autocomplete="cc-csc">
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                        <hr class="mb-4">
                        <div class="mt-auto d-flex justify-content-end mb-5">
                            <button type="submit" class="btn btn-primary btn-lg">Place Order</button>
                        </div>
                </form>


            </div>

        </div>


    </body>
    <!-- Footer -->
    <jsp:include page="footer.jsp" />	


    <script src="<%= request.getContextPath()%>/assets/js/bootstrap.bundle.min.js"></script>
    <script src="<%= request.getContextPath()%>/assets/js/tiny-slider.js"></script>
    <script src="<%= request.getContextPath()%>/assets/js/custom.js"></script>
    <script src="<%= request.getContextPath()%>/assets/js/cart.js"></script>
    <script src="<%= request.getContextPath()%>/assets/js/checkoutForm.js"></script>

</html>