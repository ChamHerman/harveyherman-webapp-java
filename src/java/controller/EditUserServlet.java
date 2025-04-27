/**
 *
 * @author weikang
 */
package controller;

import java.io.IOException;
import java.text.ParseException;
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
        String contactNumber = request.getParameter("contactNumber");
        String address = request.getParameter("address");
        String birthDateStr = request.getParameter("birthDate");
        Date birthDate = null;

        if (birthDateStr != null && !birthDateStr.trim().isEmpty()) {
            try {
                birthDate = parseBirthdate(birthDateStr);

            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        if (fullName == null || fullName.trim().isEmpty()
                || email == null || email.trim().isEmpty()
                || contactNumber == null || contactNumber.trim().isEmpty()
                || address == null || address.trim().isEmpty()
                || birthDateStr == null || birthDateStr.trim().isEmpty()) {
            errorMessage = "All fields should be completed";
        } else if (fullName.length() >= 255) {
            errorMessage = "Full name must be less than 255 characters.";
        } else if (email.length() >= 255) {
            errorMessage = "Email must be less than 255 characters.";
        } else if (address.length() >= 1000) {
            errorMessage = "Address must be less than 1000 characters.";
        } else if (!email.matches("^[a-z0-9@._+\\-]+$") || !email.matches("^[a-z0-9._+\\-]+@[a-z0-9._+\\-]+\\.[a-z]{2,}$")) {
            errorMessage = "Invalid email format.";
        } else if (!contactNumber.matches("^60\\d{9,10}$")) {
            errorMessage = "Contact number must start with 60 and be 11 or 12 digits long.";
        } else if (birthDate == null) {
            errorMessage = "Invalid birthdate format.";
        } else if (birthDate.after(new Date())) {
            errorMessage = "Birthdate cannot be in the future.";
        } else {
            UserData existingUserWithEmail = userDataDAO.findByEmail(email);
            UserData existingUserWithContact = userDataDAO.findByContactNumber(contactNumber);
            if (existingUserWithEmail != null && !existingUserWithEmail.getUserId().equals(userId)) {
                errorMessage = "Email address is already in use by another user.";
            } else if (existingUserWithContact != null && !existingUserWithContact.getUserId().equals(userId)) {
                errorMessage = "Contact number is already in use by another user.";
            }
        }

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
            userData.setBirthDate(birthDate);

            userDataDAO.update(userData);
            session.setAttribute("loggedInUser", userData);

            session.setAttribute("profileUpdateSuccess", Boolean.TRUE);
            response.sendRedirect(request.getContextPath() + "/user/profile.jsp");

        } catch (Exception ex) {
            ex.printStackTrace();
            RequestDispatcher dispatcher = request.getRequestDispatcher("/user/editProfile.jsp");
            dispatcher.forward(request, response);
        }
    }

    private Date parseBirthdate(String birthdateStr) {
        try {
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            return sdf.parse(birthdateStr);
        } catch (ParseException ex) {
            ex.printStackTrace();
            return null;
        }
    }
}
