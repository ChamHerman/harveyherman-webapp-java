<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
    String companyName = application.getInitParameter("companyName");
    String companyEmail = application.getInitParameter("companyEmail");
    String companyCopyright = application.getInitParameter("companyCopyright");
%>
<head>
    <link href="<%=request.getContextPath()%>/assets/css/footer.css" rel="stylesheet">
    <style>
        #footer-popup {
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

        #footer-popup.show {
            opacity: 1;
            transform: translateX(-50%) translateY(0px);
            bottom: 40px;
        }

        #footer-popup.hide {
            opacity: 0;
            transform: translateX(-50%) translateY(100px);
            bottom: 0;
        }
    </style>
</head>

<!-- Notification Popup -->
<div id="footer-popup">
    <i class="fa fa-check-circle me-2" style="color:#ffd700;"></i>Thank you! Check your email on your free time.
</div>

<!-- Start Footer Section -->
<footer class="footer-section" style="margin-top: 5rem;">
    <div class="container relative">

        <div class="sofa-img">
            <img src="<%=request.getContextPath()%>/assets/images/sofa.png" alt="Image" class="img-fluid">
        </div>

        <div class="row">
            <div class="col-lg-8">
                <div class="subscription-form">
                    <h3 class="d-flex align-items-center">
                        <span class="me-1">
                            <img src="<%=request.getContextPath()%>/assets/images/envelope-outline.svg" alt="Image" class="img-fluid">
                        </span>
                        <span>Stay Updated with Exclusive Offers</span>
                    </h3>

                    <form id="footer-form" class="row g-3" autocomplete="off" onsubmit="return showFooter(event)">
                        <div class="col-auto">
                            <input type="text" class="form-control" placeholder="Enter your name" autocomplete="off" required>
                        </div>
                        <div class="col-auto">
                            <input type="email" class="form-control" placeholder="Enter your email" autocomplete="off" required>
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
            <div class="col-lg-6 align-items-center">
                <div class="mb-4 footer-logo-wrap">
                    <a href="/HarveyHerman/user/index.jsp" class="footer-logo"><%= companyName%></a>
                </div>
                <p class="mb-4">
                    HarveyHerman is your trusted destination for premium home appliances and accessories. We blend cutting-edge technology with elegant design, helping you create a smarter, more beautiful home. Discover innovative solutions for every room—crafted for comfort, efficiency, and style.
                </p>


            </div>

            <div class="col-lg-6 d-flex justify-content-end">
                <div class="row links-wrap" style="width: 100%;">
                    <div class="col-6 col-sm-6 col-md-4">
                        <ul class="list-unstyled">
                            <li><a href="/HarveyHerman/user/about.jsp">About us</a></li>
                            <li><a href="/HarveyHerman/user/services.jsp">Services</a></li>
                            <li><a href="/HarveyHerman/user/contact.jsp">Contact us</a></li>
                        </ul>
                    </div>

                    <div class="col-6 col-sm-6 col-md-4">
                        <ul class="list-unstyled">
                            <li><a href="/HarveyHerman/user/about.jsp#our-team">Our team</a></li>
                            <li><a href="/HarveyHerman/user/about.jsp#testimonial">Testimonials</a></li>
                            <li><a href="/HarveyHerman/user/about.jsp#why-us">Why Choose Us</a></li>
                        </ul>
                    </div>

                    <div class="col-6 col-sm-6 col-md-4">
                        <ul class="list-unstyled">
                            <li><a href="/HarveyHerman/user/termsConditions.jsp">Terms & Conditions</a></li>
                            <li><a href="/HarveyHerman/user/privacyPolicy.jsp">Privacy Policy</a></li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>

        <div class="border-top copyright">
            <div class="row pt-4">
                <div class="col-lg-6">
                    <p class="mb-2 text-center text-lg-start">
                        <%= companyCopyright%> | Contact: <a href="mailto:<%= companyEmail%>"><%= companyEmail%></a>
                    </p>
                </div>

                <div class="col-lg-6 text-center text-lg-end">
                    <ul class="list-unstyled d-inline-flex ms-auto custom-social">
                        <li><a href="/HarveyHerman/user/index.jsp"><span class="fa fa-brands fa-facebook-f"></span></a></li>
                        <li><a href="/HarveyHerman/user/index.jsp"><span class="fa fa-brands fa-twitter"></span></a></li>
                        <li><a href="/HarveyHerman/user/index.jsp"><span class="fa fa-brands fa-instagram"></span></a></li>
                        <li><a href="/HarveyHerman/user/index.jsp"><span class="fa fa-brands fa-linkedin"></span></a></li>
                    </ul>
                </div>
            </div>
        </div>

    </div>
</footer>
<!-- End Footer Section -->

<script>
    function showFooter(event) {
        event.preventDefault();
        var popup = document.getElementById('footer-popup');
        if (popup) {
            // Reset popup state
            popup.classList.remove('hide');
            popup.classList.remove('show');
            popup.style.display = 'block';

            // Slide in
            setTimeout(function () {
                popup.classList.add('show');
            }, 100);

            // Slide out after 2.5 seconds
            setTimeout(function () {
                popup.classList.remove('show');
                popup.classList.add('hide');
            }, 2600);

            // Remove from DOM after animation, or just hide
            setTimeout(function () {
                popup.style.display = 'none';
            }, 3200);

            // Reset the form
            document.getElementById('footer-form').reset();
        }
        return false;
    }
</script>
