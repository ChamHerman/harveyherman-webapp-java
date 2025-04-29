<%@ page isErrorPage="true" contentType="text/html" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
    <head>
        <!-- Default Head -->
        <jsp:include page="head.jsp" />
        <title>Error - HarveyHerman</title>
        <!-- Bootstrap Template CSS -->
        <link href="<%=request.getContextPath()%>/assets/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css"
              rel="stylesheet">
        <link href="<%=request.getContextPath()%>/assets/css/tiny-slider.css" rel="stylesheet">
        <link href="<%=request.getContextPath()%>/assets/css/style.css" rel="stylesheet">
        <style>
            body {
                font-family: Arial, sans-serif;
                background: #f8f8f8;
                text-align: center;
                padding-top: 60px;
            }
            .error-container {
                background: #fff;
                padding: 40px 30px;
                border-radius: 8px;
                box-shadow: 0 2px 8px rgba(0,0,0,0.08);
                display: inline-block;
                margin-top: 6rem; 
            }
            h1 {
                color: #d32f2f;
            }
        </style>
    </head>
    <body>
        <!-- Header -->
        <jsp:include page="header.jsp" />

        <div class="error-container">
            <h1>Oops! Something went wrong.</h1>
            <% Integer statusCode = (Integer) request.getAttribute("javax.servlet.error.status_code"); %>
            <% if (statusCode != null) { %>
            <% if (statusCode == 404) { %>
            <p>The page you are looking for could not be found.</p>
            <% } else if (statusCode == 500 || statusCode == 405) { %>
            <p>There was an internal server error. Please try again later.</p>
            <% } else {%>
            <p>An unexpected error has occurred. (Error code: <%= statusCode%>)</p>
            <% } %>
            <% } else { %>
            <p>An unexpected error has occurred. Please try again later.</p>
            <% }%>
            <a href="<%=request.getContextPath()%>/user/index.jsp" class="btn btn-primary">Return to Home</a>
        </div>
    </body>
    <!-- Footer -->
    <jsp:include page="footer.jsp" />

    <!-- Scripts -->
    <script src="<%=request.getContextPath()%>/assets/js/bootstrap.bundle.min.js"></script>
</html>
