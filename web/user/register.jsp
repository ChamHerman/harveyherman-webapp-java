<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Register</title>
    </head>
    <body>
        <% if (request.getAttribute("errorMessage") != null) {%>
        <div class="error">
            <%= request.getAttribute("errorMessage")%>
        </div>
        <% }%>
        <form action="<%= request.getContextPath()%>/user/RegisterServlet1" method="get">
            <input type="text" name="fullname" placeholder="Full Name" required>
            <input type="email" name="email" placeholder="Email" required>
            <input type="text" name="contact_number" placeholder="Contact Number">
            <input type="text" name="address" placeholder="Address">
            <input type="text" name="username" placeholder="Username" required>
            <input type="password" name="password" placeholder="Password" required>
            <input type="date" name="birthdate" required>
            <select name="challenge_question" required>
                <option value="">Select Security Question</option>
                <option value="What is your favourite colors?">What is your favorite colors?</option>
                <option value="What is your nickname?">What is your nickname?</option>
                <option value="Which animal do you like?">Which animal do you like?</option>
            </select>
            <input type="text" name="answer" placeholder="Your Answer" required>
            <button type="submit">Register</button>
        </form>
        <%= request.getContextPath()%>
    </body>
</html>