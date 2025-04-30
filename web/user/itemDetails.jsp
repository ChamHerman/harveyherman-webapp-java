<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ page import="model.Item"%>
<%@ page import="java.util.List"%>

<!DOCTYPE html>
<html lang="en">
    <head>
        <!-- Default Head -->
        <jsp:include page="head.jsp" />

        <%
            Item item = (Item) request.getAttribute("item");
        %>
        <title><%= (item != null) ? item.getName() + " - HarveyHerman" : "Item Not Found - HarveyHerman"%></title>


        <!-- Bootstrap Template CSS -->
        <link href="<%=request.getContextPath()%>/assets/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css"
              rel="stylesheet">
        <link href="<%=request.getContextPath()%>/assets/css/style.css" rel="stylesheet">
        <!-- Custom CSS -->
        <link href="<%=request.getContextPath()%>/assets/css/item.css" rel="stylesheet">
        <style>
            #details-popup {
                display: block;
                position: fixed;
                left: 50%;
                transform: translateX(-50%) translateY(100px);
                bottom: 0;
                z-index: 9999;
                background: #3b5d50;
                color: #fff;
                padding: 1.2rem 2.2rem;
                border-radius: 12px;
                box-shadow: 0 4px 24px rgba(34,84,61,0.18);
                font-size: 1.1rem;
                opacity: 0;
                transition: transform 0.5s cubic-bezier(.4,2,.6,1), opacity 0.5s;
            }

            #details-popup.show {
                opacity: 1;
                transform: translateX(-50%) translateY(0px);
                bottom: 40px;
            }

            #details-popup.hide {
                opacity: 0;
                transform: translateX(-50%) translateY(100px);
                bottom: 0;
            }
        </style>
    </head>
    <body>

        <!-- Header -->
        <jsp:include page="header.jsp" />

        <%
            if (item == null) {
        %>
        <div class="container mt-5">
            <div class="alert alert-danger">Item not found.</div>
        </div>
        <%
        } else {
        %>
        <div class="container">
            <div class="item-details-container">
                <!-- Product Image -->
                <div class="item-image-section">
                    <img src="<%=request.getContextPath()%>/assets/<%=item.getImageUrl()%>"
                         alt="<%=item.getName()%>">
                </div>

                <!-- Product Details -->
                <div class="item-info-section">
                    <!-- Product Name and Category -->
                    <div class="item-title"><%=item.getName()%></div>
                    <div class="item-category">Category: <%=item.getCategory()%></div>

                    <!-- Price and Stock Status -->
                    <div class="item-price">RM <%=String.format("%.2f", item.getPrice())%></div>
                    <% if (item.getStockQuantity() > 0) { %>
                    <span class="badge bg-success item-stock-badge">In Stock</span>
                    <% } else { %>
                    <span class="badge bg-danger item-stock-badge">Out of Stock</span>
                    <% }%>

                    <!-- Description -->
                    <div class="item-description"><%=item.getDescription()%></div>

                    <!-- Quantity Left -->
                    <div class="item-quantity-left"><span class="item-quantity-label">Quantity Left:</span> <%=item.getStockQuantity()%></div>

                    <!-- Show over stock error -->
                    <% String error = (String) request.getAttribute("error"); %>
                    <% if (error != null) {%>
                    <div class="alert alert-danger"><%= error%></div>
                    <% }%>

                    <!-- Add to Cart Form -->
                    <form action="CartServlet" method="post" class="item-cart-form">
                        <input type="hidden" name="itemId" value="<%=item.getItemId()%>">
                        <label for="quantity" class="form-label">Quantity:</label>
                        <input type="number"
                               class="form-control"
                               id="quantity"
                               name="quantity"
                               value="1"
                               min="1"
                               max="<%=item.getStockQuantity()%>"
                               required
                               <% if (item.getStockQuantity() == 0) { %> disabled <% } %>>
                        <% if (item.getStockQuantity() == 0) { %>
                        <button type="submit" class="btn btn-success" disabled>
                            <i class="fas fa-times-circle"></i> Out of Stock
                        </button>
                        <% } else {%>
                        <button type="submit" class="btn btn-success">
                            <i class="fas fa-cart-plus"></i> Add to Cart
                        </button>
                        <% } %>

                    </form>
                </div>
            </div>
        </div>
        <%
            }
        %>


    </body>
    <!-- Notification Popup -->
    <%
        Boolean addToCartSuccess = (Boolean) session.getAttribute("addToCartSuccess");
        if (addToCartSuccess != null && addToCartSuccess) {
    %>
    <div id="details-popup">
        <i class="fa fa-check-circle me-2" style="color:#ffd700;"></i>Add to cart successfully!
    </div>
    <%
        }
        session.removeAttribute("addToCartSuccess");
        session.removeAttribute("itemId");
    %>
    <!-- Footer -->
    <jsp:include page="footer.jsp" />

    <!-- Scripts -->
    <script src="<%=request.getContextPath()%>/assets/js/bootstrap.bundle.min.js"></script>
    <script src="<%=request.getContextPath()%>/assets/js/cart.js"></script>
    <script>
        var popup = document.getElementById('details-popup');
        if (popup) {
            // Slide in
            setTimeout(function () {
                popup.classList.add('show');
            }, 100); // slight delay for transition

            // Slide out after 3 seconds
            setTimeout(function () {
                popup.classList.remove('show');
                popup.classList.add('hide');
            }, 3100);

            // Remove from DOM after animation
            setTimeout(function () {
                if (popup.parentNode) {
                    popup.parentNode.removeChild(popup);
                }
            }, 3700);
        }
    </script>
</html>
