/*package controller;

import controller.UserService;

import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;

public class RegisterServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private UserService userService;

    @Override
    public void init() {
        userService = new UserService();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Collect form inputs
        String fullName = request.getParameter("fullname");
        String email = request.getParameter("email");
        String contactNumber = request.getParameter("contact_number");
        String address = request.getParameter("address");
        String username = request.getParameter("username");
        String birthdate = request.getParameter("birthdate");
        String password = request.getParameter("password");

        // Register user
        boolean registered = userService.registerUser(fullName, email, contactNumber, address, username, birthdate, password);

        if (registered) {
            response.sendRedirect("success.jsp"); // Redirect to success page
        } else {
            response.getWriter().println("Registration failed: Duplicate email or username.");
        }
    }
}*/
