<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
        <!-- Custom CSS -->
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

        <!-- Hero Section (Services Page) -->
        <div class="shop-hero" style="margin-top: 120px;">
            <div class="container">
                <div class="row justify-content-between align-items-center">
                    <div class="col-lg-6">
                        <div class="intro-excerpt">
                            <h1>Our Services</h1>
                            <div class="shop-hero-words">
                                Our comprehensive services are designed to ensure a seamless, worry-free experience from the moment you browse our store to long after your purchase.
                            </div>
                        </div>
                    </div>
                    <div class="col-lg-6 d-none d-lg-block position-relative">
                        <img src="<%=request.getContextPath()%>/assets/images/services-hero.svg" class="shop-hero-anim" alt="Services Animation" />
                    </div>
                </div>
            </div>
        </div>
        <!-- /Hero Section -->

        <!-- Start Why Choose Us Section -->
        <div class="why-choose-section" id="why-us">
            <div class="container">
                <div class="row justify-content-between">
                    <div class="col-lg-6">
                        <h2 class="section-title animate-slide-up">Why Choose Us?</h2>
                        <p class="animate-fade-in-delay">Experience the difference with our commitment to quality, customer satisfaction, and exclusive after-sales support. Here's why discerning homeowners choose us for their appliance and accessory needs:</p>
                        <div class="row my-5">
                            <div class="col-6 col-md-6">
                                <div class="feature">
                                    <div class="icon">
                                        <img src="<%=request.getContextPath()%>/assets/images/truck.svg" alt="Image" class="imf-fluid">
                                    </div>
                                    <h3>Fast &amp; Free Shipping</h3>
                                    <p>Enjoy complimentary, insured delivery on every order. Your appliances and accessories arrive swiftly and securely, ready to enhance your home.</p>
                                </div>
                            </div>
                            <div class="col-6 col-md-6">
                                <div class="feature">
                                    <div class="icon">
                                        <img src="<%=request.getContextPath()%>/assets/images/bag.svg" alt="Image" class="imf-fluid">
                                    </div>
                                    <h3>Easy Shopping Experience</h3>
                                    <p>Our intuitive platform makes it effortless to find, compare, and purchase the perfect products for your home. Secure checkout and multiple payment options included.</p>
                                </div>
                            </div>
                            <div class="col-6 col-md-6">
                                <div class="feature">
                                    <div class="icon">
                                        <img src="<%=request.getContextPath()%>/assets/images/support.svg" alt="Image" class="imf-fluid">
                                    </div>
                                    <h3>24/7 Expert Support</h3>
                                    <p>Our knowledgeable team is always available to assist with product advice, installation guidance, and after-sales care—anytime you need us.</p>
                                </div>
                            </div>
                            <div class="col-6 col-md-6">
                                <div class="feature">
                                    <div class="icon">
                                        <img src="<%=request.getContextPath()%>/assets/images/return.svg" alt="Image" class="imf-fluid">
                                    </div>
                                    <h3>Hassle-Free Returns</h3>
                                    <p>Shop with confidence. If you're not fully satisfied, our straightforward return policy ensures a smooth and worry-free process.</p>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-lg-5">
                        <div class="img-wrap">
                            <img src="<%=request.getContextPath()%>/assets/images/why-choose-us-img.svg" alt="Image" class="img-fluid">
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
