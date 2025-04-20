<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.ItemDAO,model.Item,java.util.List,java.util.Collections,javax.naming.InitialContext,javax.naming.NamingException" %>
<!-- /*
* Bootstrap 5
* Template Name: Furni
* Template Author: Untree.co
* Template URI: https://untree.co/
* License: https://creativecommons.org/licenses/by/3.0/
*/ -->
<!doctype html>
<html lang="en">
    <head>
        <!-- Default Head -->
        <jsp:include page="head.jsp" />
        <title>Home - HarveyHerman</title>
        
        <!-- Bootstrap CSS -->
        <link href="<%=request.getContextPath()%>/assets/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">
        <link href="<%=request.getContextPath()%>/assets/css/tiny-slider.css" rel="stylesheet">
        <link href="<%=request.getContextPath()%>/assets/css/style.css" rel="stylesheet">
        
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
                            <h1>
                                Discover Quality Furniture for Every Home
                            </h1>
                            <p class="mb-4">At HarveyHerman, we bring you a curated selection of stylish, durable, and affordable furniture to transform your living spaces. Shop the latest arrivals and timeless classics, all crafted with care and attention to detail.</p>
                            <p>
                                <a href="<%=request.getContextPath()%>/user/item.jsp" class="btn btn-secondary me-2">Explore</a>
                            </p>
                        </div>
                    </div>
                    <div class="col-lg-7">
                        <div class="hero-img-wrap">
                            <img src="<%=request.getContextPath()%>/assets/images/couch.png" class="img-fluid">
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <!-- End Hero Section -->

        <!-- Start Product Section -->
        <div class="product-section">
            <div class="container">
                <div class="row">

                    <!-- Start Column 1 -->
                    <div class="col-md-12 col-lg-3 mb-5 mb-lg-0">
                        <h2 class="mb-4 section-title">Crafted with Excellent Materials</h2>
                        <p class="mb-4">Every piece at HarveyHerman is made from premium, sustainably sourced materials, ensuring both comfort and longevity. Our commitment to quality means you can enjoy your furniture for years to come.</p>
                        <p>
                            <a href="<%=request.getContextPath()%>/user/item.jsp" class="btn">Shop Now</a>
                        </p>
                    </div>
                    <!-- End Column 1 -->

                    <!-- Start Columns 2, 3, 4: Top 3 Newest Products -->

                    <%
                        ItemDAO itemDAO = null;
                        try {
                            InitialContext context = new InitialContext();
                            itemDAO = (ItemDAO) context.lookup("java:global/HarveyHerman/ItemDAO");
                        } catch (NamingException ne) {
                            ne.printStackTrace();
                        }
                        List<Item> newestItems = null;
                        if (itemDAO != null) {
                            newestItems = itemDAO.getAll();
                            if (newestItems != null) {
                                // Only keep in-stock items
                                java.util.Iterator<Item> it = newestItems.iterator();
                                while (it.hasNext()) {
                                    Item i = it.next();
                                    if (i.getStockQuantity() <= 0) {
                                        it.remove();
                                    }
                                }
                                Collections.sort(newestItems, new java.util.Comparator<Item>() {
                                    public int compare(Item i1, Item i2) {
                                        if (i1.getCreatedDate() == null && i2.getCreatedDate() == null) {
                                            return 0;
                                        }
                                        if (i1.getCreatedDate() == null) {
                                            return 1;
                                        }
                                        if (i2.getCreatedDate() == null) {
                                            return -1;
                                        }
                                        return i2.getCreatedDate().compareTo(i1.getCreatedDate()); // Descending
                                    }
                                });
                            }
                        }
                    %>
                    <% if (newestItems != null) {
                            for (int i = 0; i < Math.min(3, newestItems.size()); i++) {
                                Item item = newestItems.get(i);
                    %>
                    <div class="col-12 col-md-4 col-lg-3 mb-5 mb-md-0">
                        <a class="product-item border rounded p-3 d-block text-center" href="#" onclick="postItemDetails('<%=item.getItemId()%>')">
                            <img src="<%=request.getContextPath()%>/assets/<%=item.getImageUrl()%>" class="img-fluid product-thumbnail" alt="<%=item.getName()%>">
                            <h3 class="product-title"><%=item.getName()%></h3>
                            <strong class="product-price">RM <%=String.format("%.2f", item.getPrice())%></strong>
                            <span class="icon-cross">
                                <img src="<%=request.getContextPath()%>/assets/images/cross.svg" class="img-fluid">
                            </span>
                        </a>
                    </div>
                    <% }
                        }%>
                    <form id="itemForm" action="<%=request.getContextPath()%>/user/details" method="post" style="display: none;">
                        <input type="hidden" name="itemId" id="itemId">
                    </form>

                    <!-- End Top 3 Newest Products -->

                </div>
            </div>
        </div>
        <!-- End Product Section -->

        <!-- Start Why Choose Us Section -->
        <div class="why-choose-section">
            <div class="container">
                <div class="row justify-content-between">
                    <div class="col-lg-6">
                        <h2 class="section-title">Why Choose Us</h2>
                        <p>At HarveyHerman, we believe your home deserves the best. Here's why our customers keep coming back:</p>
                        <div class="row my-5">
                            <div class="col-6 col-md-6">
                                <div class="feature">
                                    <div class="icon">
                                        <img src="<%=request.getContextPath()%>/assets/images/truck.svg" alt="Image" class="imf-fluid">
                                    </div>
                                    <h3>Fast &amp; Free Shipping</h3>
                                    <p>Enjoy complimentary shipping on all orders, delivered quickly and safely to your doorstep. We partner with trusted couriers to ensure your furniture arrives in perfect condition, every time.</p>
                                </div>
                            </div>
                            <div class="col-6 col-md-6">
                                <div class="feature">
                                    <div class="icon">
                                        <img src="<%=request.getContextPath()%>/assets/images/bag.svg" alt="Image" class="imf-fluid">
                                    </div>
                                    <h3>Easy to Shop</h3>
                                    <p>Our user-friendly website makes it simple to browse, filter, and find the perfect piece for your space. Secure checkout and multiple payment options make shopping a breeze.</p>
                                </div>
                            </div>
                            <div class="col-6 col-md-6">
                                <div class="feature">
                                    <div class="icon">
                                        <img src="<%=request.getContextPath()%>/assets/images/support.svg" alt="Image" class="imf-fluid">
                                    </div>
                                    <h3>24/7 Support</h3>
                                    <p>Questions? Our dedicated support team is available around the clock to assist you with product inquiries, order tracking, and after-sales service.</p>
                                </div>
                            </div>
                            <div class="col-6 col-md-6">
                                <div class="feature">
                                    <div class="icon">
                                        <img src="<%=request.getContextPath()%>/assets/images/return.svg" alt="Image" class="imf-fluid">
                                    </div>
                                    <h3>Hassle Free Returns</h3>
                                    <p>If you're not completely satisfied, our easy return policy ensures you can shop with confidence. We make returns and exchanges straightforward and stress-free.</p>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-lg-5">
                        <div class="img-wrap">
                            <img src="<%=request.getContextPath()%>/assets/images/why-choose-us-img.jpg" alt="Image" class="img-fluid">
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <!-- End Why Choose Us Section -->

        <!-- Start We Help Section -->
        <div class="we-help-section">
            <div class="container">
                <div class="row justify-content-between">
                    <div class="col-lg-7 mb-5 mb-lg-0">
                        <div class="imgs-grid">
                            <div class="grid grid-1">
                                <img src="<%=request.getContextPath()%>/assets/images/img-grid-1.jpg" alt="HarveyHerman Living Room">
                            </div>
                            <div class="grid grid-2">
                                <img src="<%=request.getContextPath()%>/assets/images/img-grid-2.jpg" alt="HarveyHerman Workspace">
                            </div>
                            <div class="grid grid-3">
                                <img src="<%=request.getContextPath()%>/assets/images/img-grid-3.jpg" alt="HarveyHerman Bedroom">
                            </div>
                        </div>
                    </div>
                    <div class="col-lg-5 ps-lg-5">
                        <h2 class="section-title mb-4">We Help You Make Modern Interior Design</h2>
                        <p>Our team is passionate about helping you create a home that reflects your style and meets your needs. Whether you're furnishing a new space or updating your current one, we're here to guide you every step of the way.</p>
                        <ul class="list-unstyled custom-list my-4">
                            <li>Personalization based on your preferences.</li>
                            <li>Expert tips and inspiration for every room in your home.</li>
                            <li>Flexible delivery and assembly options to fit your schedule.</li>
                            <li>After-sales support to ensure your complete satisfaction.</li>
                        </ul>
                        <p>
                            <a href="<%=request.getContextPath()%>/user/item.jsp" class="btn">Shop Now</a>
                        </p>
                    </div>
                </div>
            </div>
        </div>
        <!-- End We Help Section -->

        <!-- Start Popular Product -->
        <div class="popular-product">
            <div class="container">
                <div class="row">

                    <div class="col-12 col-md-6 col-lg-4 mb-4 mb-lg-0">
                        <div class="product-item-sm d-flex">
                            <div class="thumbnail">
                                <img src="<%=request.getContextPath()%>/assets/images/product-1.png" alt="Image"
                                     class="img-fluid">
                            </div>
                            <div class="pt-3">
                                <h3>Nordic Chair</h3>
                                <p>Donec facilisis quam ut purus rutrum lobortis. Donec vitae
                                    odio</p>
                                <p>
                                    <a href="#">Read More</a>
                                </p>
                            </div>
                        </div>
                    </div>

                    <div class="col-12 col-md-6 col-lg-4 mb-4 mb-lg-0">
                        <div class="product-item-sm d-flex">
                            <div class="thumbnail">
                                <img src="<%=request.getContextPath()%>/assets/images/product-2.png" alt="Image"
                                     class="img-fluid">
                            </div>
                            <div class="pt-3">
                                <h3>Kruzo Aero Chair</h3>
                                <p>Donec facilisis quam ut purus rutrum lobortis. Donec vitae
                                    odio</p>
                                <p>
                                    <a href="#">Read More</a>
                                </p>
                            </div>
                        </div>
                    </div>

                    <div class="col-12 col-md-6 col-lg-4 mb-4 mb-lg-0">
                        <div class="product-item-sm d-flex">
                            <div class="thumbnail">
                                <img src="<%=request.getContextPath()%>/assets/images/product-3.png" alt="Image"
                                     class="img-fluid">
                            </div>
                            <div class="pt-3">
                                <h3>Ergonomic Chair</h3>
                                <p>Donec facilisis quam ut purus rutrum lobortis. Donec vitae
                                    odio</p>
                                <p>
                                    <a href="#">Read More</a>
                                </p>
                            </div>
                        </div>
                    </div>

                </div>
            </div>
        </div>
        <!-- End Popular Product -->

        <!-- Start Testimonial Slider -->
        <div class="testimonial-section">
            <div class="container">
                <div class="row">
                    <div class="col-lg-7 mx-auto text-center">
                        <h2 class="section-title">Testimonials</h2>
                    </div>
                </div>

                <div class="row justify-content-center">
                    <div class="col-lg-12">
                        <div class="testimonial-slider-wrap text-center">

                            <div id="testimonial-nav">
                                <span class="prev" data-controls="prev"><span
                                        class="fa fa-chevron-left"></span></span> <span class="next"
                                                                                data-controls="next"><span class="fa fa-chevron-right"></span></span>
                            </div>

                            <div class="testimonial-slider">

                                <div class="item">
                                    <div class="row justify-content-center">
                                        <div class="col-lg-8 mx-auto">

                                            <div class="testimonial-block text-center">
                                                <blockquote class="mb-5">
                                                    <p>&ldquo;Donec facilisis quam ut purus rutrum lobortis.
                                                        Donec vitae odio quis nisl dapibus malesuada. Nullam ac
                                                        aliquet velit. Aliquam vulputate velit imperdiet dolor
                                                        tempor tristique. Pellentesque habitant morbi tristique
                                                        senectus et netus et malesuada fames ac turpis egestas.
                                                        Integer convallis volutpat dui quis scelerisque.&rdquo;</p>
                                                </blockquote>

                                                <div class="author-info">
                                                    <div class="author-pic">
                                                        <img src="<%=request.getContextPath()%>/assets/images/person-1.png" alt="Maria Jones"
                                                             class="img-fluid">
                                                    </div>
                                                    <h3 class="font-weight-bold">Maria Jones</h3>
                                                    <span class="position d-block mb-3">CEO, Co-Founder,
                                                        XYZ Inc.</span>
                                                </div>
                                            </div>

                                        </div>
                                    </div>
                                </div>
                                <!-- END item -->

                                <div class="item">
                                    <div class="row justify-content-center">
                                        <div class="col-lg-8 mx-auto">

                                            <div class="testimonial-block text-center">
                                                <blockquote class="mb-5">
                                                    <p>&ldquo;Donec facilisis quam ut purus rutrum lobortis.
                                                        Donec vitae odio quis nisl dapibus malesuada. Nullam ac
                                                        aliquet velit. Aliquam vulputate velit imperdiet dolor
                                                        tempor tristique. Pellentesque habitant morbi tristique
                                                        senectus et netus et malesuada fames ac turpis egestas.
                                                        Integer convallis volutpat dui quis scelerisque.&rdquo;</p>
                                                </blockquote>

                                                <div class="author-info">
                                                    <div class="author-pic">
                                                        <img src="<%=request.getContextPath()%>/assets/images/person-1.png" alt="Maria Jones"
                                                             class="img-fluid">
                                                    </div>
                                                    <h3 class="font-weight-bold">Maria Jones</h3>
                                                    <span class="position d-block mb-3">CEO, Co-Founder,
                                                        XYZ Inc.</span>
                                                </div>
                                            </div>

                                        </div>
                                    </div>
                                </div>
                                <!-- END item -->

                                <div class="item">
                                    <div class="row justify-content-center">
                                        <div class="col-lg-8 mx-auto">

                                            <div class="testimonial-block text-center">
                                                <blockquote class="mb-5">
                                                    <p>&ldquo;Donec facilisis quam ut purus rutrum lobortis.
                                                        Donec vitae odio quis nisl dapibus malesuada. Nullam ac
                                                        aliquet velit. Aliquam vulputate velit imperdiet dolor
                                                        tempor tristique. Pellentesque habitant morbi tristique
                                                        senectus et netus et malesuada fames ac turpis egestas.
                                                        Integer convallis volutpat dui quis scelerisque.&rdquo;</p>
                                                </blockquote>

                                                <div class="author-info">
                                                    <div class="author-pic">
                                                        <img src="<%=request.getContextPath()%>/assets/images/person-1.png" alt="Maria Jones"
                                                             class="img-fluid">
                                                    </div>
                                                    <h3 class="font-weight-bold">Maria Jones</h3>
                                                    <span class="position d-block mb-3">CEO, Co-Founder,
                                                        XYZ Inc.</span>
                                                </div>
                                            </div>

                                        </div>
                                    </div>
                                </div>
                                <!-- END item -->

                            </div>

                        </div>
                    </div>
                </div>
            </div>
        </div>
        <!-- End Testimonial Slider -->

        <!-- Header -->
        <jsp:include page="footer.jsp" />

        <script src="<%=request.getContextPath()%>/assets/js/bootstrap.bundle.min.js"></script>
        <script src="<%=request.getContextPath()%>/assets/js/tiny-slider.js"></script>
        <script src="<%=request.getContextPath()%>/assets/js/custom.js"></script>
        <script src="<%=request.getContextPath()%>/assets/js/index.js"></script>
        <script>
                            function postItemDetails(itemId) {
                                document.getElementById("itemId").value = itemId;
                                document.getElementById("itemForm").submit();
                            }
        </script>
    </body>

</html>