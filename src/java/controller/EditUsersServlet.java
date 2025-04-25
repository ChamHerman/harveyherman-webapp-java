/**
 *
 * @author weikang
 */
package controller;

import java.io.IOException;
import java.net.URLEncoder;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import javax.ejb.EJB;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import model.UserData;
import model.UserDataDAO;
import model.UserLogin;
import model.UserLoginDAO;

@WebServlet(name = "EditUsersServlet", urlPatterns = {"/manager/EditUsersServlet"})
public class EditUsersServlet extends HttpServlet {

    @EJB
    private UserDataDAO userDataDAO;
    
    @EJB
    private UserLoginDAO userLoginDAO;
    
    private static final long serialVersionUID = 1L;

    private static final String DEFAULT_PASSWORD = "password";

    // Helper method to send JSON-formatted response via redirect.
    private void sendJsonResponse(HttpServletRequest request, HttpServletResponse response, boolean success, String message)
            throws IOException {
        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        response.setHeader("Pragma", "no-cache");
        response.setDateHeader("Expires", 0);

        String contextPath = request.getContextPath();
        String json;

        if (success) {
            json = "MESSAGE: " + message.replace("\"", "\\\"");
        } else {
            json = "ERROR: " + message.replace("\"", "\\\"");
        }

        String encodedMessage = URLEncoder.encode(json, "UTF-8");
        response.sendRedirect(contextPath + "/manager/ap_user.jsp?message=" + encodedMessage);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
        request.setCharacterEncoding("UTF-8");

            // Check if this is a password reset operation
            String resetPassword = request.getParameter("resetPassword");
            if (resetPassword != null && resetPassword.equals("true")) {
                handlePasswordReset(request, response);
            return;
        }
            
            // Normal user update operation
            String userId = request.getParameter("userId");
            if (userId == null || userId.trim().isEmpty()) {
                sendJsonResponse(request, response, false, "User ID is required.");
            return;
        }

            // Get the user data from the database
            UserData userData = userDataDAO.findByUserId(userId);
            if (userData == null) {
                sendJsonResponse(request, response, false, "User not found.");
            return;
        }
            
            // Get the user login data from the database
            UserLogin userLogin = userLoginDAO.findByUserId(userId);
            if (userLogin == null) {
                sendJsonResponse(request, response, false, "User login information not found.");
            return;
        }
            
            // Validate and get full name
            String fullname = request.getParameter("fullname");
            if (fullname == null || fullname.trim().isEmpty()) {
                sendJsonResponse(request, response, false, "Full name is required.");
            return;
        }
            if (fullname.length() > 255) {
                sendJsonResponse(request, response, false, "Full name must be less than 255 characters.");
            return;
        }
            
            // Validate and get email
            String email = request.getParameter("email");
            if (email == null || email.trim().isEmpty()) {
                sendJsonResponse(request, response, false, "Email is required.");
                return;
            }
            if (email.length() > 255) {
                sendJsonResponse(request, response, false, "Email must be less than 255 characters.");
                return;
            }
            if (!email.matches("^[A-Za-z0-9+_.-]+@(.+)$")) {
                sendJsonResponse(request, response, false, "Email format is invalid.");
            return;
        }
            
            // Check for duplicate email (excluding current user)
            UserData existingUserWithEmail = userDataDAO.findByEmail(email);
            if (existingUserWithEmail != null && !existingUserWithEmail.getUserId().equals(userId)) {
                sendJsonResponse(request, response, false, "Email address is already in use by another user.");
            return;
        }
            
            // Validate and get contact number
            String contactNumber = request.getParameter("contactNumber");
            if (contactNumber == null || contactNumber.trim().isEmpty()) {
                sendJsonResponse(request, response, false, "Contact number is required.");
                return;
            }
            if (contactNumber.length() > 255) {
                sendJsonResponse(request, response, false, "Contact number must be less than 255 characters.");
            return;
        }
            
            // Check for duplicate contact number (excluding current user)
            UserData existingUserWithContact = userDataDAO.findByContactNumber(contactNumber);
            if (existingUserWithContact != null && !existingUserWithContact.getUserId().equals(userId)) {
                sendJsonResponse(request, response, false, "Contact number is already in use by another user.");
                return;
            }
            
            // Get optional address
            String address = request.getParameter("address");
            if (address != null && address.length() > 1000) {
                sendJsonResponse(request, response, false, "Address must be less than 1000 characters.");
                return;
            }
            
            // Validate and parse birth date if provided
            Date birthDate = null;
            String birthDateStr = request.getParameter("birthDate");
            if (birthDateStr != null && !birthDateStr.trim().isEmpty()) {
                try {
                    SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
                    birthDate = dateFormat.parse(birthDateStr);
                    
                    // Check if birth date is in the future
                    if (birthDate.after(new Date())) {
                        sendJsonResponse(request, response, false, "Birth date cannot be in the future.");
                        return;
                    }
                } catch (ParseException e) {
                    sendJsonResponse(request, response, false, "Invalid birth date format. Please use YYYY-MM-DD.");
                    return;
                }
            }

            // Validate and get gender
            String gender = request.getParameter("gender");
            if (gender == null || gender.trim().isEmpty()) {
                sendJsonResponse(request, response, false, "Gender is required.");
                return;
            }
            if (!gender.equals("Male") && !gender.equals("Female") && !gender.equals("Other")) {
                sendJsonResponse(request, response, false, "Gender must be 'Male', 'Female', or 'Other'.");
                return;
            }
            
            // Check for security question and answer updates
            String securityQuestion = request.getParameter("securityQuestion");
            String securityAnswer = request.getParameter("securityAnswer");
            
            // Update the user data in the database
            userData.setFullname(fullname);
            userData.setEmail(email);
            userData.setContactNumber(contactNumber);
            userData.setAddress(address);
            userData.setBirthDate(birthDate);
            userData.setGender(gender);
            
            userDataDAO.update(userData);
            
            // Update security question and answer if provided
            if (securityQuestion != null && !securityQuestion.trim().isEmpty()) {
                userLogin.setChallengeQuestion(securityQuestion);
            }
            
            if (securityAnswer != null && !securityAnswer.trim().isEmpty()) {
                userLogin.setAnswer(securityAnswer);
            }
            
            userLoginDAO.update(userLogin);
            
            sendJsonResponse(request, response, true, "User updated successfully.");
            
        } catch (Exception ex) {
            ex.printStackTrace();
            sendJsonResponse(request, response, false, "Failed to update user: " + ex.getMessage());
        }
    }
    
    private void handlePasswordReset(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            String userId = request.getParameter("userId");
            if (userId == null || userId.trim().isEmpty()) {
                sendJsonResponse(request, response, false, "User ID is required for password reset.");
                return;
            }
            
            UserData userData = userDataDAO.findByUserId(userId);
            if (userData == null) {
                sendJsonResponse(request, response, false, "User not found.");
                return;
            }
            
            UserLogin userLogin = userLoginDAO.findByUserId(userId);
            if (userLogin == null) {
                sendJsonResponse(request, response, false, "User login information not found.");
                return;
            }
            
            // Reset the password to the default
            userLogin.setPassword(DEFAULT_PASSWORD);
            userLoginDAO.update(userLogin);

            sendJsonResponse(request, response, true, "Password reset to '" + DEFAULT_PASSWORD + "' successfully.");
            
        } catch (Exception ex) {
            ex.printStackTrace();
            sendJsonResponse(request, response, false, "Failed to reset password: " + ex.getMessage());
        }
    }
} 