<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!-- Start Header/Navigation -->
<nav class="custom-navbar navbar navbar-expand-md navbar-dark bg-dark" aria-label="Furni navigation bar">
    <div class="container">
        <a class="navbar-brand" href="index.jsp">HarveyHerman<span>.</span></a>

        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarsFurni" 
                aria-controls="navbarsFurni" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>

        <div class="collapse navbar-collapse" id="navbarsFurni">
            <ul class="custom-navbar-nav navbar-nav ms-auto mb-2 mb-md-0">
                <li class="nav-item"><a class="nav-link" href="index.jsp">Home</a></li>
                <li class="nav-item active"><a class="nav-link" href="item.jsp">Shop</a></li>
                <li class="nav-item"><a class="nav-link" href="about.jsp">About us</a></li>
                <li class="nav-item"><a class="nav-link" href="services.jsp">Services</a></li>
                <li class="nav-item"><a class="nav-link" href="blog.jsp">Blog</a></li>
                <li class="nav-item"><a class="nav-link" href="contact.jsp">Contact us</a></li>
            </ul>

            <ul class="custom-navbar-cta navbar-nav mb-2 mb-md-0 ms-5">
                <% if (session.getAttribute("loggedInUser") != null) {%>
                <li class="user-dropdown-container">
                    <a class="nav-link" href="#"><img src="<%=request.getContextPath()%>/assets/images/user.svg" alt="User"></a>
                    <div class="user-dropdown">
                        <a href="profile.jsp">View User Details</a>
                        <a href="<%=request.getContextPath()%>/user/UserLogoutServlet">Log Out</a>
                    </div>
                </li>
                <% } else {%>
                <li>
                    <a class="nav-link" href="<%=request.getContextPath()%>/user/login.jsp">
                        <img src="<%=request.getContextPath()%>/assets/images/user.svg" alt="Login">
                    </a>
                </li>
                <% }%>
                <li><a class="nav-link" href="cart.jsp"><img src="<%=request.getContextPath()%>/assets/images/cart.svg" alt="Cart"></a></li>
            </ul>
        </div>
    </div>
</nav>
