<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!-- Header-specific CSS -->
<link href="<%=request.getContextPath()%>/assets/css/header.css" rel="stylesheet">

<!-- Start Header/Navigation -->
<nav id="main-header" class="custom-navbar navbar navbar-expand-md navbar-dark bg-dark" aria-label="Furni navigation bar">
    <div class="container">
        <a class="navbar-brand" href="index.jsp">
            <img src="<%=request.getContextPath()%>/assets/images/logo.png" alt="HarveyHerman Logo" style="height:100px; width:auto; vertical-align:middle;">
        </a>

        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarsFurni" 
                aria-controls="navbarsFurni" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>

        <div class="collapse navbar-collapse" id="navbarsFurni">
            <ul class="custom-navbar-nav navbar-nav ms-auto mb-2 mb-md-0">
                <li class="nav-item"><a class="nav-link" id="index-link" href="index.jsp">Home</a></li>
                <li class="nav-item"><a class="nav-link" id="shop-link" href="item.jsp">Shop</a></li>
                <li class="nav-item"><a class="nav-link" id="about-link" href="about.jsp">About us</a></li>
                <li class="nav-item"><a class="nav-link" id="services-link" href="services.jsp">Services</a></li>
                <li class="nav-item"><a class="nav-link" id="contact-link" href="contact.jsp">Contact us</a></li>
            </ul>

            <ul class="custom-navbar-cta navbar-nav mb-2 mb-md-0 ms-5">
                <% if (session.getAttribute("loggedInUser") != null) {%>
                <li class="user-dropdown-container">
                    <a class="nav-link" href="profile.jsp"><img src="<%=request.getContextPath()%>/assets/images/user.svg" alt="User"></a>
                    <div class="user-dropdown">
                        <a href="profile.jsp">View User Details</a>
                        <a href="UserLogoutServlet">Log Out</a>
                    </div>
                </li>
                <li class="user-dropdown-container">
                    <a class="nav-link" href="CartServlet">
                        <img src="<%=request.getContextPath()%>/assets/images/cart.svg" alt="Cart">
                    </a>
                    <div class="user-dropdown">
                        <a href="CartServlet">Cart</a>
                        <a href="ViewUserOrdersServlet">View Order(s)</a>
                    </div>
                </li>
                <% } else {%>
                <li>
                    <a class="nav-link" href="login.jsp">
                        <img src="<%=request.getContextPath()%>/assets/images/user.svg" alt="Login">
                    </a>
                </li>
                <li>
                    <a class="nav-link" href="cart.jsp">
                        <img src="<%=request.getContextPath()%>/assets/images/cart.svg" alt="Cart">
                    </a>
                </li>
                <% }%>

            </ul>
        </div>
    </div>
</nav>

<script>
    (function () {
        var header = document.getElementById('main-header');
        var lastScrollY = window.scrollY;
        var ticking = false;
        var heroHeight = 0;
        var body = document.body;
        function getHeroHeight() {
            var hero = document.querySelector('.shop-hero, .hero');
            return hero ? hero.offsetHeight : 0;
        }
        function onScroll() {
            if (!ticking) {
                window.requestAnimationFrame(function () {
                    var currentY = window.scrollY;
                    if (currentY > getHeroHeight() - 40) {
                        body.classList.add('has-fixed-header');
                        if (currentY < lastScrollY - 10) {
                            // Scrolling up
                            header.classList.add('header-visible');
                            header.classList.remove('header-hidden');
                        } else if (currentY > lastScrollY + 10) {
                            // Scrolling down
                            header.classList.remove('header-visible');
                            header.classList.add('header-hidden');
                        }
                    } else {
                        // At top/hero
                        header.classList.remove('header-visible', 'header-hidden');
                        body.classList.remove('has-fixed-header');
                    }
                    lastScrollY = currentY;
                    ticking = false;
                });
                ticking = true;
            }
        }
        window.addEventListener('scroll', onScroll, {passive: true});
        // Show header on page load if not at top
        window.addEventListener('DOMContentLoaded', function () {
            heroHeight = getHeroHeight();
            if (window.scrollY > heroHeight - 40) {
                body.classList.add('has-fixed-header');
                header.classList.add('header-visible');
            }
        });
    })();
</script>


