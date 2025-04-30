<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <!-- Default Head -->
        <jsp:include page="head.jsp" />
        <title>Who Are You?</title>
        <link href="<%=request.getContextPath()%>/assets/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">
        <link href="<%=request.getContextPath()%>/assets/css/style.css" rel="stylesheet">
        <style>
            .who-card {
                max-width: 400px;
                margin: 60px auto;
                padding: 2rem;
                border-radius: 1rem;
                box-shadow: 0 2px 16px rgba(0,0,0,0.08);
                text-align: center;
            }
        </style>
    </head>
    <body>
        <!-- Header -->
        <jsp:include page="header.jsp" />
        <div class="who-card bg-white">
            <div class="who-icon">
                <img src="<%=request.getContextPath()%>/assets/images/whoareyou.svg" alt="Who Are You Icon" style="width:5rem; height:5rem;">
            </div>
            <h2 style="color: black;">Welcome!</h2>
            <p>To add items to your cart and complete your purchase, please log in or create an account.</p>
            <div class="d-grid gap-2 mb-3">
                <a href="login.jsp" class="btn btn-primary btn-lg">Log In</a>
                <a href="register.jsp" class="btn btn-outline-secondary btn-lg">Register</a>
            </div>
            <hr>
            <h5>Why create an account?</h5>
            <ul class="list-unstyled">
                <li>✔ Save your cart</li>
                <li>✔ Track your orders</li>
                <li>✔ Get special offers</li>
            </ul>
        </div>
    </body>
    <!-- Footer -->
    <jsp:include page="footer.jsp" />
</html>
