<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!doctype html>
<html lang="en">
    <head>
        <!-- Default Head -->
        <jsp:include page="head.jsp" />
        <title>About Us - HarveyHerman</title>

        <!-- Bootstrap CSS -->
        <link href="<%=request.getContextPath()%>/assets/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">
        <style>
            /* Testimonials */
            .testimonial-block {
                background: #fff;
                border-radius: 18px;
                box-shadow: 0 2px 16px rgba(10,37,64,0.06);
                padding: 2rem 2.5rem;
                border-left: 6px solid #ffd700;
                transition: box-shadow 0.3s;
            }
            .testimonial-block:hover {
                box-shadow: 0 8px 32px rgba(218,165,32,0.10), 0 2px 16px rgba(10,37,64,0.08);
            }
            .testimonial-block blockquote {
                color: #0a2540;
                font-size: 1.1rem;
                font-style: italic;
            }
            .author-info h3 {
                color: #bfa14a;
                font-size: 1rem;
                font-weight: 700;
            }
            .author-info .position {
                color: #4b5563;
                font-size: 0.95rem;
            }

            .custom-social li a {
                background: #ffd700;
                color: #0a2540;
                transition: background 0.3s, color 0.3s;
            }
            .custom-social li a:hover {
                background: #0a2540;
                color: #ffd700;
            }
        </style>
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
                            <h1>About Us</h1>
                            <p class="mb-4">At HarveyHerman, we believe your home deserves the very best. Our passion is to bring you premium appliances and accessories that combine cutting-edge technology, timeless design, and everyday practicality. We are dedicated to helping you create a living space that is both beautiful and brilliantly functional—where comfort, style, and innovation meet.</p>
                            <p><a href="<%=request.getContextPath()%>/user/item.jsp" class="btn btn-secondary me-2">Shop Our Collection</a><a href="#our-team" class="btn btn-white-outline">Our Team</a></p>
                        </div>
                    </div>
                    <div class="col-lg-7">
                        <div class="hero-img-wrap">
                            <img src="<%=request.getContextPath()%>/assets/images/hero-index.png" class="img-fluid">
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <!-- End Hero Section -->

        <!-- Start Team Section -->
        <div class="untree_co-section">
            <div class="container">

                <div class="row mb-5">
                    <div class="col-lg-5 mx-auto text-center">
                        <h2 class="section-title">Our Team</h2>
                    </div>
                </div>

                <div class="row" id="our-team">

                    <!-- Start Column 1 -->
                    <div class="col-12 col-md-6 col-lg-3 mb-5 mb-md-0">
                        <img src="<%=request.getContextPath()%>/assets/images/team-1.png" class="img-fluid mb-5">
                        <h3><span class="">Herman</span></h3>
                        <span class="d-block position mb-4">CEO & Co-Founder</span>
                        <p>"At HarveyHerman, my vision is to redefine how people experience their homes. I believe that every household deserves appliances and accessories that blend innovation, elegance, and reliability. Our mission is to deliver products that truly elevate daily living."</p>
                    </div> 
                    <!-- End Column 1 -->

                    <!-- Start Column 2 -->
                    <div class="col-12 col-md-6 col-lg-3 mb-5 mb-md-0">
                        <img src="<%=request.getContextPath()%>/assets/images/team-2.png" class="img-fluid mb-5">
                        <h3><span class="">Wei</span> Kang</h3>
                        <span class="d-block position mb-4">CTO & Co-Founder</span>
                        <p>"I am passionate about integrating the latest technology into our products, ensuring they are not only beautiful but also smart and efficient. At HarveyHerman, we are committed to making your home more connected and convenient, one innovation at a time."</p>
                    </div> 
                    <!-- End Column 2 -->

                    <!-- Start Column 3 -->
                    <div class="col-12 col-md-6 col-lg-3 mb-5 mb-md-0">
                        <img src="<%=request.getContextPath()%>/assets/images/team-3.png" class="img-fluid mb-5">
                        <h3><span class="">Kai</span> Bin</h3>
                        <span class="d-block position mb-4">COO & Co-Founder</span>
                        <p>"My focus is on delivering a seamless experience from our store to your doorstep. I take pride in our attention to detail, from product selection to customer service. We want every customer to feel valued and delighted with every purchase."</p>
                    </div> 
                    <!-- End Column 3 -->

                    <!-- Start Column 4 -->
                    <div class="col-12 col-md-6 col-lg-3 mb-5 mb-md-0">
                        <img src="<%=request.getContextPath()%>/assets/images/team-4.png" class="img-fluid mb-5">
                        <h3><span class="">Kai</span> Sheng</h3>
                        <span class="d-block position mb-4">CMO & Co-Founder</span>
                        <p>"I believe that a beautiful home starts with inspiration. My goal is to share our story and products with the world, helping customers discover new ways to enhance their living spaces. At HarveyHerman, we celebrate style, comfort, and innovation."</p>
                    </div> 
                    <!-- End Column 4 -->

                </div>
            </div>
        </div>
        <!-- End Team Section -->



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

        <!-- Start Why Choose Us Section -->
            <div class="why-choose-section">
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
