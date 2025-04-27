<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <jsp:include page="head.jsp" />
        <title>Privacy Policy - HarveyHerman</title>

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
                    <h1 class="mb-4 text-center">Privacy Policy</h1>
                    <p>At HarveyHerman, we are committed to protecting your privacy and ensuring the security of your personal information. This Privacy Policy explains how we collect, use, and safeguard your data when you interact with our website and services.</p>
                    <h3>1. Information We Collect</h3>
                    <ul>
                        <li><strong>Personal Information:</strong> Name, email address, phone number, shipping address, and payment details when you make a purchase or create an account.</li>
                        <li><strong>Non-Personal Information:</strong> Browser type, device information, IP address, and browsing behavior collected via cookies and analytics tools.</li>
                    </ul>
                    <h3>2. How We Use Your Information</h3>
                    <ul>
                        <li>To process orders, deliver products, and provide customer support.</li>
                        <li>To personalize your shopping experience and recommend relevant products.</li>
                        <li>To send updates, promotions, and newsletters (you may opt out at any time).</li>
                        <li>To improve our website, services, and security.</li>
                    </ul>
                    <h3>3. Sharing Your Information</h3>
                    <ul>
                        <li>We do not sell or rent your personal information to third parties.</li>
                        <li>We may share your data with trusted partners (e.g., payment processors, delivery services) solely to fulfill your orders and improve our services.</li>
                        <li>We may disclose information if required by law or to protect our rights and safety.</li>
                    </ul>
                    <h3>4. Data Security</h3>
                    <ul>
                        <li>We implement industry-standard security measures to protect your data from unauthorized access, alteration, or disclosure.</li>
                        <li>Account passwords are encrypted and we recommend using a strong, unique password for your HarveyHerman account.</li>
                    </ul>
                    <h3>5. Cookies &amp; Tracking</h3>
                    <ul>
                        <li>Our website uses cookies to enhance your browsing experience and analyze site traffic.</li>
                        <li>You can manage cookie preferences through your browser settings.</li>
                    </ul>
                    <h3>6. Your Rights</h3>
                    <ul>
                        <li>You may access, update, or delete your personal information by logging into your account or contacting us.</li>
                        <li>You may opt out of marketing communications at any time by following the unsubscribe instructions in our emails.</li>
                    </ul>
                    <h3>7. Changes to This Policy</h3>
                    <ul>
                        <li>We may update this Privacy Policy from time to time. Changes will be posted on this page with the updated effective date.</li>
                    </ul>
                    <h3>8. Contact Us</h3>
                    <ul>
                        <li>If you have any questions or concerns about our Privacy Policy or data practices, please <a href="contact.jsp">contact us</a>.</li>
                    </ul>
                </div>
            </div>
        </div>
        <!-- Footer -->
        <jsp:include page="footer.jsp" />
    </body>
</html> 