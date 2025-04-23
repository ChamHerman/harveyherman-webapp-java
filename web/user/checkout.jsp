<%@page import="java.util.List"%>
<%@page import="model.CartItem"%>
<%@ page import="model.UserData" %>
<%@ page import="model.Cart" %>
<!doctype html>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <meta name="author" content="Untree.co">
        <link rel="shortcut icon" href="favicon.png">

        <meta name="description" content="" />
        <meta name="keywords" content="bootstrap, bootstrap4" />

        <!-- Bootstrap CSS -->
        <link href="<%= request.getContextPath()%>/assets/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">
        <link href="<%= request.getContextPath()%>/assets/css/tiny-slider.css" rel="stylesheet">
        <link href="<%= request.getContextPath()%>/assets/css/style.css" rel="stylesheet">
        <title>Checkout - HarveyHerman</title>
    </head>

    <body>

        <!-- Start Header/Navigation -->
        <nav class="custom-navbar navbar navbar navbar-expand-md navbar-dark bg-dark" arial-label="Furni navigation bar">

            <div class="container">
                <a class="navbar-brand" href="index.html">Furni<span>.</span></a>

                <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarsFurni" aria-controls="navbarsFurni" aria-expanded="false" aria-label="Toggle navigation">
                    <span class="navbar-toggler-icon"></span>
                </button>

                <div class="collapse navbar-collapse" id="navbarsFurni">
                    <ul class="custom-navbar-nav navbar-nav ms-auto mb-2 mb-md-0">
                        <li class="nav-item ">
                            <a class="nav-link" href="index.html">Home</a>
                        </li>
                        <li><a class="nav-link" href="shop.html">Shop</a></li>
                        <li><a class="nav-link" href="about.html">About us</a></li>
                        <li><a class="nav-link" href="services.html">Services</a></li>
                        <li><a class="nav-link" href="blog.html">Blog</a></li>
                        <li><a class="nav-link" href="contact.html">Contact us</a></li>
                    </ul>

                    <ul class="custom-navbar-cta navbar-nav mb-2 mb-md-0 ms-5">
                        <li><a class="nav-link" href="#"><img src="assets/images/user.svg"></a></li>
                        <li><a class="nav-link" href="cart2.html"><img src="assets/images/cart.svg"></a></li>
                    </ul>
                </div>
            </div>

        </nav>
        <!-- End Header/Navigation -->

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
        <div class="untree_co-section">
            <div class="container">
                <div class="row">
                    <!-- left -->
                    <div class="col-md-7">

                        <!-- Billing Details -->
                        <div class="billing-section">
                            <h3>Billing Details</h3>
                            <div class="form-group mb-4">
                                <label>Full Name</label>
                                <input type="text" name="fullname" class="form-control" value="<%= user.getFullname()%>" readonly>
                            </div>
                            <div class="form-group mb-4">
                                <label>Address</label>
                                <input type="text" name="address" class="form-control" value="<%= user.getAddress()%>" readonly>
                            </div>
                            <div class="form-group mb-4">
                                <label>Contact Number</label>
                                <input type="text" name="contact" class="form-control" value="<%= user.getContactNumber()%>" readonly>
                            </div>
                            <div class="form-group mb-4">
                                <label>Email Address</label>
                                <input type="email" name="email" class="form-control" value="<%= user.getEmail()%>" readonly>
                            </div>
                            <a href="editProfile.jsp" class="btn btn-secondary mt-2">Edit Profile</a>
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
                        <form id="checkoutForm" action="AddOrderServlet" method="post">
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
                        </form>
                    </div>
                </div>
            </div>

        </div>

        <!-- Start Footer Section -->
        <footer class="footer-section">
            <div class="container relative">

                <div class="sofa-img">
                    <img src="assets/images/sofa.png" alt="Image" class="img-fluid">
                </div>

                <div class="row">
                    <div class="col-lg-8">
                        <div class="subscription-form">
                            <h3 class="d-flex align-items-center"><span class="me-1"><img src="assets/images/envelope-outline.svg" alt="Image" class="img-fluid"></span><span>Subscribe to Newsletter</span></h3>

                            <form action="#" class="row g-3">
                                <div class="col-auto">
                                    <input type="text" class="form-control" placeholder="Enter your name">
                                </div>
                                <div class="col-auto">
                                    <input type="email" class="form-control" placeholder="Enter your email">
                                </div>
                                <div class="col-auto">
                                    <button class="btn btn-primary">
                                        <span class="fa fa-paper-plane"></span>
                                    </button>
                                </div>
                            </form>

                        </div>
                    </div>
                </div>

                <div class="row g-5 mb-5">
                    <div class="col-lg-4">
                        <div class="mb-4 footer-logo-wrap"><a href="#" class="footer-logo">Furni<span>.</span></a></div>
                        <p class="mb-4">Donec facilisis quam ut purus rutrum lobortis. Donec vitae odio quis nisl dapibus malesuada. Nullam ac aliquet velit. Aliquam vulputate velit imperdiet dolor tempor tristique. Pellentesque habitant</p>

                        <ul class="list-unstyled custom-social">
                            <li><a href="#"><span class="fa fa-brands fa-facebook-f"></span></a></li>
                            <li><a href="#"><span class="fa fa-brands fa-twitter"></span></a></li>
                            <li><a href="#"><span class="fa fa-brands fa-instagram"></span></a></li>
                            <li><a href="#"><span class="fa fa-brands fa-linkedin"></span></a></li>
                        </ul>
                    </div>

                    <div class="col-lg-8">
                        <div class="row links-wrap">
                            <div class="col-6 col-sm-6 col-md-3">
                                <ul class="list-unstyled">
                                    <li><a href="#">About us</a></li>
                                    <li><a href="#">Services</a></li>
                                    <li><a href="#">Blog</a></li>
                                    <li><a href="#">Contact us</a></li>
                                </ul>
                            </div>

                            <div class="col-6 col-sm-6 col-md-3">
                                <ul class="list-unstyled">
                                    <li><a href="#">Support</a></li>
                                    <li><a href="#">Knowledge base</a></li>
                                    <li><a href="#">Live chat</a></li>
                                </ul>
                            </div>

                            <div class="col-6 col-sm-6 col-md-3">
                                <ul class="list-unstyled">
                                    <li><a href="#">Jobs</a></li>
                                    <li><a href="#">Our team</a></li>
                                    <li><a href="#">Leadership</a></li>
                                    <li><a href="#">Privacy Policy</a></li>
                                </ul>
                            </div>

                            <div class="col-6 col-sm-6 col-md-3">
                                <ul class="list-unstyled">
                                    <li><a href="#">Nordic Chair</a></li>
                                    <li><a href="#">Kruzo Aero</a></li>
                                    <li><a href="#">Ergonomic Chair</a></li>
                                </ul>
                            </div>
                        </div>
                    </div>

                </div>

                <div class="border-top copyright">
                    <div class="row pt-4">
                        <div class="col-lg-6">
                            <p class="mb-2 text-center text-lg-start">Copyright &copy;<script>document.write(new Date().getFullYear());</script>. All Rights Reserved. &mdash; Designed with love by <a href="https://untree.co">Untree.co</a> Distributed By <a hreff="https://themewagon.com">ThemeWagon</a>  <!-- License information: https://untree.co/license/ -->
                            </p>
                        </div>

                        <div class="col-lg-6 text-center text-lg-end">
                            <ul class="list-unstyled d-inline-flex ms-auto">
                                <li class="me-4"><a href="#">Terms &amp; Conditions</a></li>
                                <li><a href="#">Privacy Policy</a></li>
                            </ul>
                        </div>

                    </div>
                </div>

            </div>
        </footer>
        <!-- End Footer Section -->	


        <script src="<%= request.getContextPath()%>/assets/js/bootstrap.bundle.min.js"></script>
        <script src="<%= request.getContextPath()%>/assets/js/tiny-slider.js"></script>
        <script src="<%= request.getContextPath()%>/assets/js/custom.js"></script>
        <script src="<%= request.getContextPath()%>/assets/js/cart.js"></script>
    </body>

</html>