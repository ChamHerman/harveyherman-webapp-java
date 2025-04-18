<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Login</title>
    </head>
    <body>
        <form action="<%= request.getContextPath()%>/user/UserLoginServlet" method="post">
            <%
                if (session.getAttribute("loginError") != null) {
                    session.removeAttribute("loginError");
            %>
            <div>
                <h3>Invalid username or wrong password!</h3>
            </div>
            <% } %>
            
            <input type="text" name="username" placeholder="Username" required>
            <input type="password" name="password" placeholder="Password" required>
            <button type="submit">Login</button>
        </form>
            
            <h3>Don't have an account?</h3>
            <a href="register.jsp">Register for a new account</a>
            
            <h3>Forgot your password?</h3>
            <a href="challengeQuestion.jsp">Reset password</a>
    </body>
</html>