<%@page contentType="text/html" pageEncoding="UTF-8"%>
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
        <title>Services - HarveyHerman</title>

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
        <div class="hero" style="padding: 2rem 0;">
            <div class="container">
                <div class="row justify-content-between align-items-center" style="min-height: 420px;">
                    <div class="col-lg-6">
                        <div class="intro-excerpt">
                            <h1>Our Services</h1>
                            <p class="mb-4">At HarveyHerman, we go beyond just selling home appliances and accessories. Our comprehensive services are designed to ensure a seamless, worry-free experience from the moment you browse our store to long after your purchase. We are committed to making your home more comfortable, stylish, and efficient.</p>
                            <p><a href="<%=request.getContextPath()%>/user/item.jsp" class="btn btn-secondary me-2">Shop Now</a><a href="<%=request.getContextPath()%>/user/contact.jsp" class="btn btn-white-outline">Contact Support</a></p>
                        </div>
                    </div>
                    <div class="col-lg-6 d-flex align-items-center justify-content-center" style="height: 100%;">
                        <div class="hero-img-wrap d-flex align-items-center justify-content-center w-100" style="height: 100%; min-height: 150px;">
                            <img src="<%=request.getContextPath()%>/assets/images/services-hero.png" class="img-fluid" alt="Our Services" style="max-width: 80%; height: auto; display: block; margin-right: 2rem; box-shadow: 0 8px 32px rgba(34,84,61,0.08); border-radius: 18px; background: #e8fbe6; padding: 1rem;">
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <!-- End Hero Section -->



        <!-- Start Why Choose Us Section -->
        <div class="why-choose-section">
            <div class="container">


                <div class="row my-5">
                    <div class="col-6 col-md-6 col-lg-3 mb-4">
                        <div class="feature">
                            <div class="icon">
                                <img src="<%=request.getContextPath()%>/assets/images/truck.svg" alt="Image" class="imf-fluid">
                            </div>
                            <h3>Fast &amp; Free Shipping</h3>
                            <p>Enjoy complimentary shipping on all orders, delivered quickly and safely to your doorstep. We partner with trusted couriers to ensure your furniture arrives in perfect condition, every time.</p>
                        </div>
                    </div>

                    <div class="col-6 col-md-6 col-lg-3 mb-4">
                        <div class="feature">
                            <div class="icon">
                                <img src="<%=request.getContextPath()%>/assets/images/bag.svg" alt="Image" class="imf-fluid">
                            </div>
                            <h3>Easy to Shop</h3>
                            <p>Our user-friendly website makes it simple to browse, filter, and find the perfect piece for your space. Secure checkout and multiple payment options make shopping a breeze.</p>
                        </div>
                    </div>

                    <div class="col-6 col-md-6 col-lg-3 mb-4">
                        <div class="feature">
                            <div class="icon">
                                <img src="<%=request.getContextPath()%>/assets/images/support.svg" alt="Image" class="imf-fluid">
                            </div>
                            <h3>24/7 Support</h3>
                            <p>Questions? Our dedicated support team is available around the clock to assist you with product inquiries, order tracking, and after-sales service.</p>
                        </div>
                    </div>

                    <div class="col-6 col-md-6 col-lg-3 mb-4">
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
        </div>
        <!-- End Why Choose Us Section -->

        <!-- Footer -->
        <jsp:include page="footer.jsp" />

        <script src="<%=request.getContextPath()%>/assets/js/bootstrap.bundle.min.js"></script>
        <script src="<%=request.getContextPath()%>/assets/js/tiny-slider.js"></script>
        <script src="<%=request.getContextPath()%>/assets/js/custom.js"></script>
        <script src="<%=request.getContextPath()%>/assets/js/index.js"></script>

    </body>

</html>
