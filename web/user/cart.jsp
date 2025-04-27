<%@ page import="model.CartDAO"%>
<%@ page import="model.UserData"%>
<%@ page import="java.math.BigDecimal"%>
<%@ page import="javax.naming.NamingException"%>
<%@ page import="javax.naming.InitialContext"%>
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
        <!-- Header -->
        <jsp:include page="header.jsp" />

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
                            <div class="container" style="margin-top: 1rem;">
                                <div class="alert alert-info d-flex align-items-center justify-content-center p-3 rounded shadow-sm" style="background: linear-gradient(90deg, #d4f5e9 0%, #e8fbe6 100%); color: #22543d; font-size: 1.1rem; font-weight: 500; border: 1px solid #b7e4c7;">
                                    <i class="fa fa-truck me-2" style="font-size: 1.3em;"></i>
                                    Enjoy <span style="color:#38a169;font-weight:700;" class="mx-1">FREE delivery</span> on orders of <span style="color:#38a169;font-weight:700;" class="mx-1">RM1000</span> and above! For orders below RM1000, a delivery charge of <span style="color:#38a169;font-weight:700;" class="mx-1">RM25</span> applies.
                                </div>
                            </div>
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
                                        List<CartItem> cartItems = (List<CartItem>) session.getAttribute("cartItems");
                                        int rowNum = 1;
                                        double cartSubtotal = (Double) session.getAttribute("cartSubtotal");
                                        double deliveryFee = (Double) session.getAttribute("deliveryFee");
                                        double discount = (Double) session.getAttribute("discount");
                                        double cartTotal = (Double) session.getAttribute("cartTotal");
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
                                            <button type="button" class="btn btn-outline-secondary btn-sm" onclick="increaseQuantity(
                                                            '<%= cartItem.getCartItemId()%>',
                                                    <%= cartItem.getQuantity()%>,
                                                    <%= cartItem.getItemId().getStockQuantity()%>
                                                    )">+</button>
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
                                    cartSubtotal = (Double) session.getAttribute("cartSubtotal");
                                %>
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
                                <!--  display error-->
                                <div class="col-md-12">
                                    <span id="promoError" class="text-danger"></span>
                                </div>
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
                                    <form action="CheckOutServlet" method="post" onsubmit="return validateCheckout();">
                                        <div id="checkoutError" class="text-danger mb-2"></div>
                                        <button class="btn btn-black btn-lg py-3 btn-block" id="checkoutBtn" type="submit">Proceed To Checkout</button>
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

        <!--        modal to show stock not enough-->
        <div class="modal fade" id="stockModal" tabindex="-1" role="dialog" aria-labelledby="stockModalLabel" aria-hidden="true">
            <div class="modal-dialog" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="stockModalLabel">Stock Limit</h5>
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                    <div class="modal-body">
                        You cannot add more than the available stock.
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-dismiss="modal">OK</button>
                    </div>
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