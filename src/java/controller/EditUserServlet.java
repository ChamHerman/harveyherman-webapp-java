package controller;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import javax.ejb.EJB;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import model.UserData;
import model.UserDataDAO;

@WebServlet(name = "EditUserServlet", urlPatterns = {"/user/EditUserServlet"})
public class EditUserServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @EJB
    private UserDataDAO userDataDAO;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        HttpSession session = request.getSession();
        UserData loggedInUser = (UserData) session.getAttribute("loggedInUser");
        String errorMessage = null;

        if (loggedInUser == null) {
            response.sendRedirect(request.getContextPath() + "/user/login.jsp");
            return;
        }

        String userId = request.getParameter("userId");
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        // Email validation
        if (email == null || !email.contains("@")) {
            errorMessage = "Email must contain '@' symbol.";
        } else {
            // Check uniqueness (except for current user)
            UserData existingUser = userDataDAO.findByEmail(email);
            if (existingUser != null && !existingUser.getUserId().equals(userId)) {
                errorMessage = "Email is already in use by another account.";
            }
        }
        String contactNumber = request.getParameter("contactNumber");
        // Contact number validation
        if (contactNumber != null && !contactNumber.isEmpty()) {
            if (!contactNumber.matches("^\\+60\\d{8,13}$")) {
                errorMessage = "Contact number must start with +60 and be up to 15 characters (e.g. +601234567890).";
            } else {
                // Check uniqueness (except for current user)
                UserData existingContact = userDataDAO.findByContactNumber(contactNumber);
                if (existingContact != null && !existingContact.getUserId().equals(userId)) {
                    errorMessage = "Contact number is already in use by another account.";
                }
            }
        }
        String address = request.getParameter("address");
        String birthDateStr = request.getParameter("birthDate");

        if (errorMessage != null) {
            request.setAttribute("errorMessage", errorMessage);
            RequestDispatcher dispatcher = request.getRequestDispatcher("/user/editProfile.jsp");
            dispatcher.forward(request, response);
            return;
        }

        try {
            if (!loggedInUser.getUserId().equals(userId)) {
                throw new SecurityException("Unauthorized access attempt detected");
            }

            UserData userData = userDataDAO.findByUserId(userId);

            if (userData == null) {
                throw new Exception("User not found");
            }

            userData.setFullname(fullName);
            userData.setEmail(email);
            userData.setContactNumber(contactNumber);
            userData.setAddress(address);

            if (birthDateStr != null && !birthDateStr.trim().isEmpty()) {
                try {
                    SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
                    Date birthDate = dateFormat.parse(birthDateStr);
                    userData.setBirthDate(birthDate);
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }

            userDataDAO.update(userData);
            session.setAttribute("loggedInUser", userData);

            request.setAttribute("profileUpdateSuccess", Boolean.TRUE);
            RequestDispatcher dispatcher = request.getRequestDispatcher("/user/profile.jsp");
            dispatcher.forward(request, response);

        } catch (Exception ex) {
            ex.printStackTrace();
            RequestDispatcher dispatcher = request.getRequestDispatcher("/user/editProfile.jsp");
            dispatcher.forward(request, response);
        }
    }
}
