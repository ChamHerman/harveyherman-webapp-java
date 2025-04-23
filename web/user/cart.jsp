<%@page import="model.UserData"%>
<%@page import="java.math.BigDecimal"%>
<%@page import="javax.naming.NamingException"%>
<%@page import="javax.naming.InitialContext"%>
<%@ page import="java.util.List"%>
<%@ page import="model.CartItem"%>
<%@ page import="model.Cart"%>
<%@ page import="model.Item"%>
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
        <title>Cart - Harvey Herman</title>
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
                            <h1>Cart</h1>
                        </div>
                    </div>
                    <div class="col-lg-7">

                    </div>
                </div>
            </div>
        </div>
        <!-- End Hero Section -->



        <div class="untree_co-section before-footer-section">
            <div class="container">
                <div class="row mb-5">
                    <form class="col-md-12" method="post">
                        <div class="site-blocks-table">
                            <table class="table">
                                <thead>
                                    <tr>
                                        <th>No.</th>
                                        <th>Image</th>
                                        <th>Item</th>
                                        <th>Unit Price</th>
                                        <th>Quantity</th>
                                        <th>Subtotal</th>
                                        <th>Action</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <%
                                        List<CartItem> cartItems = (List<CartItem>) request.getAttribute("cartItems");
                                        int rowNum = 1;
                                        double cartSubtotal = (Double) request.getAttribute("cartSubtotal");
                                        double deliveryFee = (Double) request.getAttribute("deliveryFee");
                                        double discount = (Double) request.getAttribute("discount");
                                        double cartTotal = (Double) request.getAttribute("cartTotal");
                                        if (cartItems != null && !cartItems.isEmpty()) {
                                            for (CartItem cartItem : cartItems) {
                                    %>
                                    <tr id="cartItem_<%= cartItem.getCartItemId()%>">
                                        <!-- Row Number -->
                                        <td><%= rowNum++%>.</td>
                                        <!-- Product Image -->
                                        <td>
                                            <img src="<%= cartItem.getItemId().getImageUrl()%>" alt="Product Image" style="width: 80px; height: 80px;">
                                        </td>
                                        <!-- Product Name -->
                                        <td>
                                            <%= cartItem.getItemId().getName()%>
                                        </td>
                                        <!-- Unit Price -->
                                        <td>
                                            RM <%= cartItem.getUnitPrice()%>
                                        </td>
                                        <!-- Quantity with AJAX buttons -->
                                        <td>
                                            <button type="button" class="btn btn-outline-secondary btn-sm" onclick="updateQuantity('<%= cartItem.getCartItemId()%>', -1)">-</button>
                                            <span id="qty_<%= cartItem.getCartItemId()%>"><%= cartItem.getQuantity()%></span>
                                            <button type="button" class="btn btn-outline-secondary btn-sm" onclick="updateQuantity('<%= cartItem.getCartItemId()%>', 1)">+</button>
                                        </td>
                                        <!-- Subtotal -->
                                        <td>
                                            RM <span id="subtotal_<%= cartItem.getCartItemId()%>"><%= cartItem.getSubtotal()%></span>
                                        </td>
                                        <!-- Remove -->
                                        <td>
                                            <button type="button" class="btn btn-danger btn-sm" onclick="removeCartItem('<%= cartItem.getCartItemId()%>')">Remove</button>
                                        </td>
                                    </tr>
                                    <%
                                        }
                                    } else {
                                    %>
                                    <tr>
                                        <td colspan="6">Your cart is empty.</td>
                                    </tr>
                                    <%
                                        }
                                    %>
                                </tbody>
                                <%
                                    cartSubtotal = (Double) request.getAttribute("cartSubtotal");
                                %>

                                Purchase more than RM1000, free delivery !!!
                            </table>
                        </div>
                    </form>
                </div>

                <div class="row">
                    <div class="col-md-6">
                        <div class="row mb-5">
                            <div class="col-md-6">
                                <a href="item.jsp" class="btn btn-outline-black btn-sm btn-block">Continue Shopping</a>
                            </div>
                        </div>
                        <div class="row mb-3">
                            <strong>Promotion Code:</strong>                     
                            <div class="col-md-6">
                                <input type="text" id="promoCode" class="form-control" placeholder="Enter promotion code">
                            </div>
                            <div class="col-md-2">
                                <button class="btn btn-primary" onclick="applyPromotion()">Apply</button>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-6 pl-5">
                        <div class="row justify-content-end">
                            <div class="col-md-7">
                                <div class="row">
                                    <div class="col-md-12 text-right border-bottom mb-5">
                                        <h3 class="text-black h4 text-uppercase">Cart Totals</h3>
                                    </div>
                                </div>
                                <div class="row mb-3">
                                    <div class="col-md-6">
                                        <span class="text-black">Subtotal</span>
                                    </div>
                                    <div class="col-md-6 text-right">
                                        <strong class="text-black">RM <span id="cartSubtotal"><%= cartSubtotal%></span></strong>
                                    </div>
                                </div>
                                <div class="row mb-3">
                                    <div class="col-md-6">
                                        <span class="text-black">Delivery Fee</span>
                                    </div>
                                    <div class="col-md-6 text-right">
                                        <strong class="text-black">RM <span id="deliveryFee"><%= deliveryFee%></span></strong>
                                    </div>
                                </div>
                                <div class="row mb-3">
                                    <div class="col-md-6">
                                        <span class="text-black">Discount</span>
                                    </div>
                                    <div class="col-md-6 text-right">
                                        <strong class="text-black">RM <span id="discount"><%= discount%></span></strong> 
                                    </div>
                                </div>

                                <div class="row mb-5">
                                    <div class="col-md-6">
                                        <span class="text-black">Total</span>
                                    </div>
                                    <div class="col-md-6 text-right">
                                        <strong class="text-black">RM <span id="cartTotal"><%= cartTotal%></span></strong>
                                    </div>
                                </div>

                                <div class="row">
                                    <form action="CheckOutServlet" method="post">
                                        <button class="btn btn-black btn-lg py-3 btn-block" type="submit">Proceed To Checkout</button>
                                    </form>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        

        <!-- Modal to show Promotion Error -->
        <div class="modal fade" id="promoModal" tabindex="-1" aria-labelledby="promoModalLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="promoModalLabel">Promotion</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body" id="promoModalBody">
                        <!-- Message will be set by JS -->
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">OK</button>
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