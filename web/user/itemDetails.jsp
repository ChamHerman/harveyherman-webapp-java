<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ page import="model.Item"%>
<%@ page import="java.util.List"%>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

        <%
            // Loads Item (object) from Servlet
            Item item = (Item) request.getAttribute("item");
        %>
        <title><%= (item != null) ? item.getName() + " - HarveyHerman" : "Item Not Found - HarveyHerman"%></title>


        <!-- Bootstrap CSS -->
        <link href="<%=request.getContextPath()%>/assets/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css"
              rel="stylesheet">
        <link href="<%=request.getContextPath()%>/assets/css/style.css" rel="stylesheet">
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

        <div class="container mt-5 mb-5" style="margin-bottom: 7rem;">
            <div class="row">
                <!-- Product Image -->
                <div class="col-md-5">
                    <img src="<%=request.getContextPath()%>/assets/<%=item.getImageUrl()%>" class="img-fluid rounded border"
                         alt="<%=item.getName()%>">
                </div>

                <!-- Product Details -->
                <div class="col-md-7">
                    <h2><strong><%=item.getName()%></strong></h2>
                    <p class="text-muted">Category: <%=item.getCategory()%></p>
                    <p><%=item.getDescription()%></p>
                    
                    <h4 class="text-primary">RM <%=String.format("%.2f", item.getPrice())%></h4>
                    <p><strong>Quantity Left: <%=item.getStockQuantity()%></strong></p>

                    <!-- Add to Cart Form -->
                    <form action="AddToCartServlet" method="post">
                        <input type="hidden" name="itemId" value="<%=item.getItemId()%>">

                        <div class="mb-3">
                            <label for="quantity" class="form-label">Quantity:</label> 
                            <input type="number"
                                   class="form-control" id="quantity" name="quantity" value="1" min="1"
                                   max="<%=item.getStockQuantity()%>" required>
                        </div>

                        <button type="submit" class="btn btn-success" onclick="addToCart('<%= item.getItemId() %>', item.getStockQuantity())">
                            <i class="fas fa-cart-plus"></i> Add to Cart
                        </button>
                    </form>
                </div>
            </div>
        </div>
        <%
            }
        %>

        <!-- Footer -->
        <jsp:include page="footer.jsp" />

        <!-- Scripts -->
        <script src="<%=request.getContextPath()%>/assets/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
