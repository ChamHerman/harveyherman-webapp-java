/**
 *
 * @author weikang
 */
package controller;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;
import java.nio.file.Paths;
import java.io.*;
import java.math.BigDecimal;
import java.net.URLEncoder;
import java.util.Arrays;
import java.util.HashSet;
import java.util.Set;
import java.util.UUID;
import javax.ejb.EJB;
import model.Item;
import model.ItemDAO;
import model.UserData;
import model.UserDataDAO;
import model.UserLogin;
import model.UserLoginDAO;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

@WebServlet(name = "AddUsersServlet", urlPatterns = {"/manager/AddUsersServlet", "/staff/AddUsersServlet"})
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, maxFileSize = 1024 * 1024 * 10, maxRequestSize = 1024 * 1024 * 50)
public class AddUsersServlet extends HttpServlet {

    @EJB
    private ItemDAO itemDAO;
    
    @EJB
    private UserDataDAO userDataDAO;
    
    @EJB
    private UserLoginDAO userLoginDAO;
    
    private static final long serialVersionUID = 1L;
    
    private static final String DEFAULT_PASSWORD = "password";

    // Helper method to send JSON-formatted response via redirect.
    private void sendJsonResponse(HttpServletRequest request, HttpServletResponse response, boolean success, String message)
            throws IOException {
        // Disable caching
        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        response.setHeader("Pragma", "no-cache");
        response.setDateHeader("Expires", 0);
        
        String servletPath = request.getServletPath();
        String contextPath = request.getContextPath();

        String json;

        if (success) {
            json = "MESSAGE: " + message.replace("\"", "\\\"");
        } else {
            json = "ERROR: " + message.replace("\"", "\\\"");
        }

        String encodedMessage = URLEncoder.encode(json, "UTF-8");

        if (servletPath.contains("/manager/")) {
            response.sendRedirect(contextPath + "/manager/ap_user.jsp?message=" + encodedMessage);
        } else if (servletPath.contains("/staff/")) {
            response.sendRedirect(contextPath + "/staff/ap_user.jsp?message=" + encodedMessage);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            request.setCharacterEncoding("UTF-8");
            
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
            
            // Validate and get username
            String username = request.getParameter("username");
            if (username == null || username.trim().isEmpty()) {
                sendJsonResponse(request, response, false, "Username is required.");
                return;
            }
            if (username.length() > 255) {
                sendJsonResponse(request, response, false, "Username must be less than 255 characters.");
                return;
            }
            if (!username.matches("^[a-zA-Z0-9_-]{3,20}$")) {
                sendJsonResponse(request, response, false, "Username must be 3-20 characters and can only contain letters, numbers, underscores, and hyphens.");
                return;
            }
            
            // Check for existing username
            UserLogin existingLogin = userLoginDAO.findByUsername(username);
            if (existingLogin != null) {
                sendJsonResponse(request, response, false, "Username is already taken. Please choose another one.");
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
            
            // Check for duplicate email
            UserData existingUserWithEmail = userDataDAO.findByEmail(email);
            if (existingUserWithEmail != null) {
                sendJsonResponse(request, response, false, "Email address is already in use.");
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
            
            // Check for duplicate contact number
            UserData existingUserWithContact = userDataDAO.findByContactNumber(contactNumber);
            if (existingUserWithContact != null) {
                sendJsonResponse(request, response, false, "Contact number is already in use.");
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
            
            // Validate and get security question
            String securityQuestion = request.getParameter("securityQuestion");
            if (securityQuestion == null || securityQuestion.trim().isEmpty()) {
                sendJsonResponse(request, response, false, "Security question is required.");
                return;
            }
            if (securityQuestion.length() > 255) {
                sendJsonResponse(request, response, false, "Security question must be less than 255 characters.");
                return;
            }
            
            // Validate and get security answer
            String securityAnswer = request.getParameter("securityAnswer");
            if (securityAnswer == null || securityAnswer.trim().isEmpty()) {
                sendJsonResponse(request, response, false, "Security answer is required.");
                return;
            }
            if (securityAnswer.length() > 255) {
                sendJsonResponse(request, response, false, "Security answer must be less than 255 characters.");
                return;
            }
            
            // Create the UserData object
            UserData userData = new UserData();
            userData.setUserId(null); // Will be auto-generated
            userData.setFullname(fullname);
            userData.setEmail(email);
            userData.setContactNumber(contactNumber);
            userData.setAddress(address);
            userData.setBirthDate(birthDate);
            userData.setGender(gender);
            userData.setDbstatus("active");
            userData.setCreatedDate(new java.sql.Timestamp(System.currentTimeMillis())); // Set current timestamp as created date
            
            // Save the UserData first to get the generated ID
            userDataDAO.create(userData);
            
            // Create UserLogin object
            UserLogin userLogin = new UserLogin();
            userLogin.setLoginId(null); // Will be auto-generated
            userLogin.setUserId(userData);
            userLogin.setUsername(username);
            userLogin.setPassword(DEFAULT_PASSWORD); // Default password
            userLogin.setChallengeQuestion(securityQuestion);
            userLogin.setAnswer(securityAnswer);
            userLogin.setDbstatus("active");
            
            // Save the UserLogin
            userLoginDAO.create(userLogin);
            
            sendJsonResponse(request, response, true, "User created successfully. Default password is: " + DEFAULT_PASSWORD);
        } catch (Exception ex) {
            ex.printStackTrace();
            sendJsonResponse(request, response, false, "Failed to create user. Error: " + ex.getMessage());
        }
    }

}
