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
    
    // Valid security questions
    private static final String[] VALID_SECURITY_QUESTIONS = {
        "What is your favorite color?",
        "What is your nickname?",
        "Which animal do you like?"
    };

    private void sendJsonResponse(HttpServletRequest request, HttpServletResponse response, boolean success, String message)
            throws IOException {
        // Disable caching
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
            
            String userId = request.getParameter("userId");
            if (userId == null || userId.trim().isEmpty()) {
                sendJsonResponse(request, response, false, "User ID is required.");
                return;
            }
            
            // Check if this is a password reset request
            String resetPassword = request.getParameter("resetPassword");
            if (resetPassword != null && resetPassword.equals("true")) {
                // Handle password reset
                UserLogin userLogin = userLoginDAO.findByUserId(userId);
                if (userLogin == null) {
                    sendJsonResponse(request, response, false, "User login information not found.");
                    return;
                }
                
                userLogin.setPassword(DEFAULT_PASSWORD);
                userLoginDAO.update(userLogin);
                
                sendJsonResponse(request, response, true, "User password has been reset to default.");
                return;
            }
            
            // Regular edit operation
            UserData userData = userDataDAO.findByUserId(userId);
            if (userData == null) {
                sendJsonResponse(request, response, false, "User not found.");
                return;
            }
            
            // Get user login information
            UserLogin userLogin = userLoginDAO.findByUserId(userId);
            if (userLogin == null) {
                sendJsonResponse(request, response, false, "User login information not found.");
                return;
            }
            
            // Validate and update fullname
            String fullname = request.getParameter("fullname");
            if (fullname == null || fullname.trim().isEmpty()) {
                sendJsonResponse(request, response, false, "Full name is required.");
                return;
            }
            if (fullname.length() > 255) {
                sendJsonResponse(request, response, false, "Full name must be less than 255 characters.");
                return;
            }
            
            // Validate and update email
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
            
            // Check for duplicate email
            if (!email.equals(userData.getEmail())) {
                UserData existingUserWithEmail = userDataDAO.findByEmail(email);
                if (existingUserWithEmail != null && !existingUserWithEmail.getUserId().equals(userId)) {
                    sendJsonResponse(request, response, false, "Email address is already in use by another user.");
                    return;
                }
            }
            
            // Validate and update contact number
            String contactNumber = request.getParameter("contactNumber");
            if (contactNumber == null || contactNumber.trim().isEmpty()) {
                sendJsonResponse(request, response, false, "Contact number is required.");
                return;
            }
            if (contactNumber.length() > 255) {
                sendJsonResponse(request, response, false, "Contact number must be less than 255 characters.");
                return;
            }
            
            // Check for duplicate contact number
            if (!contactNumber.equals(userData.getContactNumber())) {
                UserData existingUserWithContact = userDataDAO.findByContactNumber(contactNumber);
                if (existingUserWithContact != null && !existingUserWithContact.getUserId().equals(userId)) {
                    sendJsonResponse(request, response, false, "Contact number is already in use by another user.");
                    return;
                }
            }
            
            // Apply updates to the user data object
            userData.setFullname(fullname);
            userData.setEmail(email);
            userData.setContactNumber(contactNumber);
            
            // Update address (optional)
            String address = request.getParameter("address");
            if (address != null && address.length() > 1000) {
                sendJsonResponse(request, response, false, "Address must be less than 1000 characters.");
                return;
            }
            userData.setAddress(address);
            
            // Validate and update birth date
            String birthDateStr = request.getParameter("birthDate");
            if (birthDateStr != null && !birthDateStr.trim().isEmpty()) {
                try {
                    SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
                    Date birthDate = dateFormat.parse(birthDateStr);
                    
                    // Check if birth date is in the future
                    if (birthDate.after(new Date())) {
                        sendJsonResponse(request, response, false, "Birth date cannot be in the future.");
                        return;
                    }
                    
                    userData.setBirthDate(birthDate);
                } catch (ParseException e) {
                    sendJsonResponse(request, response, false, "Invalid birth date format. Please use YYYY-MM-DD.");
                    return;
                }
            } else {
                userData.setBirthDate(null);
            }
            
            // Validate and update gender
            String gender = request.getParameter("gender");
            if (gender == null || gender.trim().isEmpty()) {
                sendJsonResponse(request, response, false, "Gender is required.");
                return;
            }
            if (!gender.equals("Male") && !gender.equals("Female") && !gender.equals("Other")) {
                sendJsonResponse(request, response, false, "Gender must be 'Male', 'Female', or 'Other'.");
                return;
            }
            userData.setGender(gender);
            
            // Check if security question needs to be updated
            String securityQuestion = request.getParameter("securityQuestion");
            if (securityQuestion != null && !securityQuestion.trim().isEmpty()) {
                // Validate security question
                boolean validQuestion = false;
                for (String validSecurityQuestion : VALID_SECURITY_QUESTIONS) {
                    if (securityQuestion.equals(validSecurityQuestion)) {
                        validQuestion = true;
                        break;
                    }
                }
                
                if (!validQuestion) {
                    sendJsonResponse(request, response, false, "Invalid security question selected.");
                    return;
                }
                
                userLogin.setChallengeQuestion(securityQuestion);
            }
            
            // Check if security answer needs to be updated
            String securityAnswer = request.getParameter("securityAnswer");
            if (securityAnswer != null && !securityAnswer.trim().isEmpty()) {
                if (securityAnswer.length() > 255) {
                    sendJsonResponse(request, response, false, "Security answer must be less than 255 characters.");
                    return;
                }
                userLogin.setAnswer(securityAnswer);
            }
            
            // Update the user data and login info
            userDataDAO.update(userData);
            userLoginDAO.update(userLogin);
            
            sendJsonResponse(request, response, true, "User information updated successfully.");
        } catch (Exception ex) {
            ex.printStackTrace();
            sendJsonResponse(request, response, false, "Failed to update user information. Error: " + ex.getMessage());
        }
    }
}
