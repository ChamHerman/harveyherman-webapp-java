<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.UserData"%>
<%@ page import="model.ItemDAO,model.Item,java.util.List,java.util.Collections,javax.naming.InitialContext,javax.naming.NamingException,model.ManagerDashboardDAO" %>
<!doctype html>
<html lang="en">
    <head>
        <!-- Default Head -->
        <jsp:include page="head.jsp" />
        <title>Home - HarveyHerman</title>

        <!-- Bootstrap CSS -->
        <link href="<%=request.getContextPath()%>/assets/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">
        <!-- Custom CSS -->
        <link href="<%=request.getContextPath()%>/assets/css/index.css" rel="stylesheet">
        <!-- Bootstrap CSS -->
        <link href="<%=request.getContextPath()%>/assets/css/tiny-slider.css" rel="stylesheet">
        <link href="<%=request.getContextPath()%>/assets/css/style.css" rel="stylesheet">
        <!-- Custom CSS -->
        <link href="<%=request.getContextPath()%>/assets/css/index_carousel.css" rel="stylesheet">
        <style>
            #index-popup {
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

            #index-popup.show {
                opacity: 1;
                transform: translateX(-50%) translateY(0px);
                bottom: 40px;
            }

            #index-popup.hide {
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
            String logoutNotice = (String) session.getAttribute("logoutNotice");
            if (logoutNotice != null) {
        %>
        <script>
            alert("<%= logoutNotice.replace("\"", "\\\"")%>");
        </script>
        <%
                session.removeAttribute("logoutNotice");
            }
        %>

        <!-- Start Hero Section -->
        <div class="hero" style="padding: 4.5rem 0;">
            <div class="container">
                <div class="row justify-content-between">
                    <div class="col-lg-5">
                        <div class="intro-excerpt animate-fade-in">
                            <h1 class="animate-slide-up">
                                Elevate Your Home with Premium Appliances & Accessories
                            </h1>
                            <p class="mb-4 animate-fade-in-delay">Discover a curated collection of state-of-the-art home appliances and elegant accessories. Transform your living spaces with innovation, style, and unmatched quality—crafted for modern lifestyles.</p>
                            <p>
                                <a href="<%=request.getContextPath()%>/user/items" class="btn btn-secondary me-2 animate-bounce">Shop Now</a>
                            </p>
                        </div>
                    </div>
                    <div class="col-lg-7 d-flex align-items-center justify-content-center animate-fade-in">
                        <div class="hero-img-wrap w-100">
                            <!-- Bootstrap Carousel Start -->
                            <div id="heroCarousel" class="carousel slide carousel-fade" data-bs-ride="carousel" data-bs-interval="3500">
                                <div class="carousel-inner">
                                    <div class="carousel-item active">
                                        <img src="<%=request.getContextPath()%>/assets/images/smartoven.jpg" class="d-block w-100 hero-slider-img" alt="Promotion 1">
                                        <div class="carousel-caption d-block bg-dark bg-opacity-50 rounded p-2 mb-2">
                                            <h4>New Arrival: Smart Oven</h4>
                                            <p>Early Bird Discount: 20% off for the first 50 customers!</p>
                                        </div>
                                    </div>
                                    <div class="carousel-item">
                                        <img src="<%=request.getContextPath()%>/assets/images/voucher.png" class="d-block w-100 hero-slider-img" alt="Promotion 2">
                                        <div class="carousel-caption d-block bg-dark bg-opacity-50 rounded p-2 mb-2">
                                            <h4>Super Valuable! Use Code: <span style="color:#ffd700;">SUPER50</span></h4>
                                            <p>Up to 50% off with minimum spend of RM500. Available now!</p>
                                        </div>
                                    </div>
                                    <div class="carousel-item">
                                        <img src="<%=request.getContextPath()%>/assets/images/mothersales.jpg" class="d-block w-100 hero-slider-img" alt="Promotion 3">
                                        <div class="carousel-caption d-block bg-dark bg-opacity-50 rounded p-2 mb-2">
                                            <h4>Flash Sale: 48 Hours Only!</h4>
                                            <p>Up to 40% off selected items. Don’t miss out!</p>
                                        </div>
                                    </div>
                                </div>

                                <div class="carousel-indicators mt-3">
                                    <button type="button" data-bs-target="#heroCarousel" data-bs-slide-to="0" class="active" aria-current="true" aria-label="Slide 1"></button>
                                    <button type="button" data-bs-target="#heroCarousel" data-bs-slide-to="1" aria-label="Slide 2"></button>
                                    <button type="button" data-bs-target="#heroCarousel" data-bs-slide-to="2" aria-label="Slide 3"></button>
                                </div>
                            </div>
                            <button class="carousel-control-prev" type="button" data-bs-target="#heroCarousel" data-bs-slide="prev">
                                <span class="carousel-control-prev-icon" aria-hidden="true"></span>
                                <span class="visually-hidden">Previous</span>
                            </button>
                            <button class="carousel-control-next" type="button" data-bs-target="#heroCarousel" data-bs-slide="next">
                                <span class="carousel-control-next-icon" aria-hidden="true"></span>
                                <span class="visually-hidden">Next</span>
                            </button>
                            <!-- Bootstrap Carousel End -->
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <!-- End Hero Section -->

        <!-- Start Product Section -->
        <div class="product-section" style="margin: 4rem 0 3rem 0;">
            <div class="container">
                <div class="row">

                    <!-- Start Column 1 -->
                    <div class="col-md-12 col-lg-3 mb-5 mb-lg-0">
                        <h2 class="mb-4 section-title animate-slide-up">Top 3 Best Sellers</h2>
                        <p class="mb-4 animate-fade-in-delay">Discover our most popular products, loved by customers for their quality, performance, and value. These best sellers are proven favorites—see why they're flying off the shelves!</p>
                        <p>
                            <a href="<%=request.getContextPath()%>/user/items" class="btn animate-bounce">View All Products</a>
                        </p>
                    </div>
                    <!-- End Column 1 -->

                    <!-- Start Columns 2, 3, 4: Top 3 Best Sellers -->
                    <%
                        ItemDAO itemDAO = null;
                        ManagerDashboardDAO dashboardDAO = null;
                        try {
                            InitialContext context = new InitialContext();
                            itemDAO = (ItemDAO) context.lookup("java:global/HarveyHerman/ItemDAO");
                            dashboardDAO = (ManagerDashboardDAO) context.lookup("java:global/HarveyHerman/ManagerDashboardDAO");
                        } catch (NamingException ne) {
                            ne.printStackTrace();
                        }
                        java.util.List<Item> displayItems = new java.util.ArrayList<>();
                        java.util.Set<String> addedItemIds = new java.util.HashSet<>();
                        if (dashboardDAO != null && itemDAO != null) {
                            java.util.List<Object[]> topSales = dashboardDAO.getTopSales();
                            if (topSales != null) {
                                for (Object[] row : topSales) {
                                    String itemId = (String) row[1]; // row[1] is itemId (see getTopSales)
                                    Item item = itemDAO.getItemById(itemId);
                                    if (item != null && item.getStockQuantity() > 0 && !addedItemIds.contains(item.getItemId())) {
                                        displayItems.add(item);
                                        addedItemIds.add(item.getItemId());
                                        if (displayItems.size() == 3) {
                                            break;
                                        }
                                    }
                                }
                            }
                        }
                        // If less than 3, fill with newest in-stock items not already shown
                        if (displayItems.size() < 3 && itemDAO != null) {
                            java.util.List<Item> newestItems = itemDAO.getAll();
                            if (newestItems != null) {
                                java.util.Iterator<Item> it = newestItems.iterator();
                                while (it.hasNext()) {
                                    Item i = it.next();
                                    if (i.getStockQuantity() <= 0 || addedItemIds.contains(i.getItemId())) {
                                        it.remove();
                                    }
                                }
                                java.util.Collections.sort(newestItems, new java.util.Comparator<Item>() {
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
                                for (Item i : newestItems) {
                                    if (displayItems.size() == 3) {
                                        break;
                                    }
                                    displayItems.add(i);
                                    addedItemIds.add(i.getItemId());
                                }
                            }
                        }
                    %>
                    <% for (int i = 0; i < displayItems.size(); i++) {
                            Item item = displayItems.get(i);
                    %>
                    <div class="col-12 col-md-4 col-lg-3 mb-5 mb-md-0">
                        <a class="product-item border rounded p-3 d-block text-center" href="details?itemId=<%=item.getItemId()%>">
                            <img src="<%=request.getContextPath()%>/assets/<%=item.getImageUrl()%>" class="img-fluid product-thumbnail" alt="<%=item.getName()%>">
                            <h3 class="product-title"><%=item.getName()%></h3>
                            <strong class="product-price">RM <%=String.format("%.2f", item.getPrice())%></strong>
                            <span class="icon-cross">
                                <img src="<%=request.getContextPath()%>/assets/images/cross.svg" class="img-fluid">
                            </span>
                        </a>
                    </div>
                    <% }%>
                    <form id="itemForm" action="<%=request.getContextPath()%>/user/details" method="post" style="display: none;">
                        <input type="hidden" name="itemId" id="itemId">
                    </form>
                    <!-- End Top 3 Best Sellers -->

                </div>
            </div>
        </div>
        <!-- End Product Section -->

        <div class="card-section">
            <!-- Start Why Choose Us Section -->
            <div class="why-choose-section">
                <div class="container">
                    <div class="row justify-content-between">
                        <div class="col-lg-6">
                            <h2 class="section-title animate-slide-up">Why Shop With Us?</h2>
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
                                <img src="<%=request.getContextPath()%>/assets/images/why-choose-us-img-2.svg" alt="Image" class="img-fluid">
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
                            <h2 class="section-title mb-4 animate-slide-up">We Help You Create a Smarter, More Beautiful Home</h2>
                            <p class="animate-fade-in-delay">From kitchen essentials to smart home upgrades, our experts are here to inspire and support your journey to a more comfortable, efficient, and stylish living space.</p>
                            <ul class="list-unstyled custom-list my-4 animate-fade-in-delay">
                                <li>Personalized recommendations for your unique needs.</li>
                                <li>Expert tips for maximizing appliance performance and longevity.</li>
                                <li>Flexible delivery and professional installation services.</li>
                                <li>Dedicated after-sales support for lasting satisfaction.</li>
                            </ul>
                            <p>
                                <a href="<%=request.getContextPath()%>/user/items" class="btn animate-bounce">Discover More</a>
                            </p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <!-- End We Help Section -->

        <!-- Start Testimonial Slider -->
        <div class="testimonial-section">
            <div class="container">
                <div class="row">
                    <div class="col-lg-7 mx-auto text-center">
                        <h2 class="section-title animate-slide-up">Testimonials</h2>
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

                                            <div class="testimonial-block text-center animate-fade-in">
                                                <blockquote class="mb-5">
                                                    <p>&ldquo;We upgraded our entire kitchen with HarveyHerman's appliances. The quality and design exceeded our expectations—our team loves the new break room!&rdquo;</p>
                                                </blockquote>

                                                <div class="author-info">
                                                    <div class="author-pic">
                                                        <img src="<%=request.getContextPath()%>/assets/images/person_2.jpg" alt="James Lee" class="img-fluid">
                                                    </div>
                                                    <h3 class="font-weight-bold">James Lee</h3>
                                                    <span class="position d-block mb-3">Facilities Manager, UrbanTech Solutions</span>
                                                </div>
                                            </div>

                                        </div>
                                    </div>
                                </div>
                                <!-- END item -->

                                <div class="item">
                                    <div class="row justify-content-center">
                                        <div class="col-lg-8 mx-auto">

                                            <div class="testimonial-block text-center animate-fade-in">
                                                <blockquote class="mb-5">
                                                    <p>&ldquo;Our boutique hotel guests rave about the elegant accessories and smart features. HarveyHerman delivers both luxury and reliability.&rdquo;</p>
                                                </blockquote>

                                                <div class="author-info">
                                                    <div class="author-pic">
                                                        <img src="<%=request.getContextPath()%>/assets/images/person_3.jpg" alt="Ethan Tan" class="img-fluid">
                                                    </div>
                                                    <h3 class="font-weight-bold">Ethan Tan</h3>
                                                    <span class="position d-block mb-3">General Manager, The Luxe Stay</span>
                                                </div>
                                            </div>

                                        </div>
                                    </div>
                                </div>
                                <!-- END item -->

                                <div class="item">
                                    <div class="row justify-content-center">
                                        <div class="col-lg-8 mx-auto">

                                            <div class="testimonial-block text-center animate-fade-in">
                                                <blockquote class="mb-5">
                                                    <p>&ldquo;Exceptional service and top-notch products. Our office's new air purifiers and coffee machines have made a noticeable difference!&rdquo;</p>
                                                </blockquote>

                                                <div class="author-info">
                                                    <div class="author-pic">
                                                        <img src="<%=request.getContextPath()%>/assets/images/person-1.png" alt="Priya Nair" class="img-fluid">
                                                    </div>
                                                    <h3 class="font-weight-bold">Priya Nair</h3>
                                                    <span class="position d-block mb-3">Operations Director, GreenLeaf Co.</span>
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


    </body>
    <!-- Notification Popup -->
    <%
        UserData user = (UserData) session.getAttribute("loggedInUser");
        Boolean loginSuccess = (Boolean) session.getAttribute("loginSuccess");

        if (loginSuccess != null && loginSuccess && user != null) {
    %>
    <div id="index-popup">
        <i class="fa fa-check-circle me-2" style="color:#ffd700;"></i>Welcome! <%= user.getFullname()%>
    </div>
    <%
        }
        session.removeAttribute("loginSuccess");
    %>
    <!-- Footer -->
    <jsp:include page="footer.jsp" />

    <script src="<%=request.getContextPath()%>/assets/js/bootstrap.bundle.min.js"></script>
    <script src="<%=request.getContextPath()%>/assets/js/tiny-slider.js"></script>
    <script src="<%=request.getContextPath()%>/assets/js/custom.js"></script>
    <script src="<%=request.getContextPath()%>/assets/js/index.js"></script>

</html>