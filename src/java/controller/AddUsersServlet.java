/**
 *
 * @author weikang
 */
package controller;

import static controller.PasswordUtil.hashPasswordSHA256;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.*;
import java.math.BigDecimal;
import java.net.URLEncoder;
import javax.ejb.EJB;
import model.UserData;
import model.UserDataDAO;
import model.UserLogin;
import model.UserLoginDAO;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import model.Cart;
import model.CartDAO;

@WebServlet(name = "AddUsersServlet", urlPatterns = "/manager/AddUsersServlet")
public class AddUsersServlet extends HttpServlet {

    @EJB
    private UserDataDAO userDataDAO;

    @EJB
    private UserLoginDAO userLoginDAO;

    @EJB
    private CartDAO cartDAO;

    private static final long serialVersionUID = 1L;

    private static final String DEFAULT_PASSWORD = "password";

    // Helper method to send JSON-formatted response via redirect.
    private void sendJsonResponse(HttpServletRequest request, HttpServletResponse response, boolean success, String message)
            throws IOException {
        // Disable caching
        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        response.setHeader("Pragma", "no-cache");
        response.setDateHeader("Expires", 0);

        String contextPath = request.getContextPath();

        String json;

        if (success) {
            json = "Message: " + message.replace("\"", "\\\"");
        } else {
            json = "Error: " + message.replace("\"", "\\\"");
        }

        String encodedMessage = URLEncoder.encode(json, "UTF-8");
        response.sendRedirect(contextPath + "/manager/ap_user.jsp?message=" + encodedMessage);

    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            request.setCharacterEncoding("UTF-8");

            String fullname = request.getParameter("fullname");
            if (fullname == null || fullname.trim().isEmpty()) {
                sendJsonResponse(request, response, false, "Full name is required.");
                return;
            }
            if (fullname.length() > 255) {
                sendJsonResponse(request, response, false, "Full name must be less than 255 characters.");
                return;
            }

            String username = request.getParameter("username");
            if (username == null || username.trim().isEmpty()) {
                sendJsonResponse(request, response, false, "Username is required.");
                return;
            }
            if (username.length() > 255) {
                sendJsonResponse(request, response, false, "Username must be less than 255 characters.");
                return;
            }
            UserLogin existingLogin = userLoginDAO.findByUsername(username);
            if (existingLogin != null) {
                sendJsonResponse(request, response, false, "Username is already taken. Please check on the record and try again.");
                return;
            }

            String email = request.getParameter("email");
            if (email == null || email.trim().isEmpty()) {
                sendJsonResponse(request, response, false, "Email is required.");
                return;
            }
            if (email.length() > 255) {
                sendJsonResponse(request, response, false, "Email must be less than 255 characters.");
                return;
            }
            if (!email.matches("^[a-z0-9@._+\\-]+$") || !email.matches("^[a-z0-9._+\\-]+@[a-z0-9._+\\-]+\\.[a-z]{2,}$")) {
                sendJsonResponse(request, response, false, "Email format is invalid.");
                return;
            }
            UserData existingUserWithEmail = userDataDAO.findByEmail(email);
            if (existingUserWithEmail != null) {
                sendJsonResponse(request, response, false, "Email address is already in use. Please check on the record and try again.");
                return;
            }

            String contactNumber = request.getParameter("contactNumber");
            if (contactNumber == null || contactNumber.trim().isEmpty()) {
                sendJsonResponse(request, response, false, "Contact number is required.");
                return;
            }
            if (!contactNumber.matches("^60\\d{9,10}$")) {
                sendJsonResponse(request, response, false, "Contact number must start with 60 and be 11 or 12 digits long.");
                return;
            }
            UserData existingUserWithContact = userDataDAO.findByContactNumber(contactNumber);
            if (existingUserWithContact != null) {
                sendJsonResponse(request, response, false, "Contact number is already in use. Please check on the record and try again.");
                return;
            }

            String address = request.getParameter("address");
            if (address != null && address.length() > 1000) {
                sendJsonResponse(request, response, false, "Address must be less than 1000 characters.");
                return;
            }

            Date birthDate = null;
            String birthDateStr = request.getParameter("birthDate");
            if (birthDateStr != null && !birthDateStr.trim().isEmpty()) {
                try {
                    SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
                    birthDate = dateFormat.parse(birthDateStr);

                    if (birthDate.after(new Date())) {
                        sendJsonResponse(request, response, false, "Birth date cannot be in the future.");
                        return;
                    }
                } catch (ParseException e) {
                    sendJsonResponse(request, response, false, "Invalid birth date format. Please use YYYY-MM-DD.");
                    return;
                }
            }

            String gender = request.getParameter("gender");
            if (gender == null || gender.trim().isEmpty()) {
                sendJsonResponse(request, response, false, "Gender is required.");
                return;
            }

            String securityQuestion = request.getParameter("securityQuestion");
            if (securityQuestion == null || securityQuestion.trim().isEmpty()) {
                sendJsonResponse(request, response, false, "Security question is required.");
                return;
            }

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
            userData.setFullname(fullname);
            userData.setEmail(email);
            userData.setContactNumber(contactNumber);
            userData.setAddress(address);
            userData.setBirthDate(birthDate);
            userData.setGender(gender);
            userData.setDbstatus("active");
            userData.setCreatedDate(new java.sql.Timestamp(System.currentTimeMillis()));

            userDataDAO.create(userData);

            // Create UserLogin object
            UserLogin userLogin = new UserLogin();
            userLogin.setLoginId(null);
            userLogin.setUserId(userData);
            userLogin.setUsername(username);
            userLogin.setPassword(hashPasswordSHA256(DEFAULT_PASSWORD));
            userLogin.setChallengeQuestion(securityQuestion);
            userLogin.setAnswer(securityAnswer);
            userLogin.setDbstatus("active");

            userLoginDAO.create(userLogin);

            // Create Cart object
            Cart cart = new Cart();
            cart.setCartId(null);
            cart.setUserId(userData);
            cart.setCreatedDate(new java.sql.Timestamp(System.currentTimeMillis()));
            cart.setUpdatedDate(null);
            cart.setDbstatus("active");
            cart.setTotal(new BigDecimal("0.0"));
            
            cartDAO.create(cart);

            sendJsonResponse(request, response, true, "User created successfully. Default password is: " + DEFAULT_PASSWORD);
        } catch (Exception ex) {
            ex.printStackTrace();
            sendJsonResponse(request, response, false, "Failed to create user. Error: " + ex.getMessage());
        }
    }
}
