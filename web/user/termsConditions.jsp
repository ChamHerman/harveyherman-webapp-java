<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <jsp:include page="head.jsp" />
        <title>Terms & Conditions - HarveyHerman</title>

        <!-- Bootstrap CSS -->
        <link href="<%=request.getContextPath()%>/assets/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">
        <link href="<%=request.getContextPath()%>/assets/css/style.css" rel="stylesheet">
    </head>
    <body>
        <jsp:include page="header.jsp" />
        <div class="container my-5">
            <div class="row justify-content-center">
                <div class="col-lg-8 bg-white p-5 rounded shadow-sm">
                    <h1 class="mb-4 text-center">Terms &amp; Conditions</h1>
                    <p>Welcome to HarveyHerman. By accessing or using our website and services, you agree to be bound by the following terms and conditions. Please read them carefully.</p>
                    <h3>1. General</h3>
                    <ul>
                        <li>HarveyHerman is a retailer of premium home appliances and accessories, offering products for sale through our website.</li>
                        <li>By using our site, you confirm that you are at least 18 years old or have the consent of a parent or guardian.</li>
                    </ul>
                    <h3>2. Orders &amp; Payments</h3>
                    <ul>
                        <li>All orders are subject to acceptance and availability. We reserve the right to refuse or cancel any order at our discretion.</li>
                        <li>Prices are listed in Malaysian Ringgit (RM) and include applicable taxes unless otherwise stated.</li>
                        <li>Payment must be made in full at the time of order using the payment methods provided on our site.</li>
                    </ul>
                    <h3>3. Shipping &amp; Delivery</h3>
                    <ul>
                        <li>We offer fast and free shipping within Malaysia. Delivery times are estimates and may vary due to external factors.</li>
                        <li>Risk of loss and title for products pass to you upon delivery.</li>
                    </ul>
                    <h3>4. Returns &amp; Warranty</h3>
                    <ul>
                        <li>If you are not satisfied with your purchase, you may return eligible items within 14 days of receipt, subject to our <a href="contact.jsp">Return Policy</a>.</li>
                        <li>All appliances come with a manufacturer's warranty. Please refer to the product page for specific warranty details.</li>
                    </ul>
                    <h3>5. User Accounts</h3>
                    <ul>
                        <li>You are responsible for maintaining the confidentiality of your account and password.</li>
                        <li>HarveyHerman is not liable for any loss or damage arising from your failure to protect your account information.</li>
                    </ul>
                    <h3>6. Intellectual Property</h3>
                    <ul>
                        <li>All content on this site, including images, text, logos, and product information, is the property of HarveyHerman or its licensors and is protected by copyright laws.</li>
                        <li>You may not reproduce, distribute, or use any content without our express written permission.</li>
                    </ul>
                    <h3>7. Limitation of Liability</h3>
                    <ul>
                        <li>HarveyHerman is not liable for any indirect, incidental, or consequential damages arising from the use of our products or website.</li>
                        <li>Our total liability to you for any claim shall not exceed the amount paid for the product in question.</li>
                    </ul>
                    <h3>8. Changes to Terms</h3>
                    <ul>
                        <li>We reserve the right to update these terms at any time. Changes will be posted on this page and are effective immediately.</li>
                    </ul>
                    <h3>9. Contact Us</h3>
                    <ul>
                        <li>If you have any questions about these Terms &amp; Conditions, please <a href="contact.jsp">contact us</a>.</li>
                    </ul>
                </div>
            </div>
        </div>
        <!-- Footer -->
        <jsp:include page="footer.jsp" />
    </body>
</html> 