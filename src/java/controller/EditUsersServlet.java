/**
 *
 * @author weikang
 */
package controller;

import static controller.PasswordUtil.hashPasswordSHA256;
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
import javax.servlet.http.HttpSession;
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

            String fullname = request.getParameter("fullname");
            if (fullname == null || fullname.trim().isEmpty()) {
                sendJsonResponse(request, response, false, "Full name is required.");
                return;
            }
            if (fullname.length() > 255) {
                sendJsonResponse(request, response, false, "Full name must be less than 255 characters.");
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
            if (existingUserWithEmail != null && !existingUserWithEmail.getUserId().equals(userId)) {
                sendJsonResponse(request, response, false, "Email address is already in use by another user. Please check on the record and try again.");
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
            if (existingUserWithContact != null && !existingUserWithContact.getUserId().equals(userId)) {
                sendJsonResponse(request, response, false, "Contact number is already in use by another user. Please check on the record and try again.");
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

            String username = request.getParameter("username");
            if (username == null || username.trim().isEmpty()) {
                sendJsonResponse(request, response, false, "Username is required.");
                return;
            }
            if (username.length() > 255) {
                sendJsonResponse(request, response, false, "Username must be less than 255 characters.");
                return;
            }
            UserLogin existingUserWithUsername = userLoginDAO.findByUsername(username);
            if (existingUserWithUsername != null && !existingUserWithUsername.getUserId().getUserId().equals(userId)) {
                sendJsonResponse(request, response, false, "Username is already in use by another user. Please check on the record and try again.");
                return;
            }

            String securityQuestion = request.getParameter("securityQuestion");
            String securityAnswer = request.getParameter("securityAnswer");

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

            userLogin.setUsername(username);
            userLoginDAO.update(userLogin);
            
            // Update session if edited account is currently logged in
            HttpSession session = request.getSession();
            if ((session.getAttribute("loggedInUser") != null)) {
                UserData currentLoginUser = (UserData) session.getAttribute("loggedInUser");
                if (currentLoginUser.getUserId().equals(userData.getUserId())) {
                    session.setAttribute("loggedInUser", userData);
                }
            }

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

            userLogin.setPassword(hashPasswordSHA256(DEFAULT_PASSWORD));
            userLoginDAO.update(userLogin);

            sendJsonResponse(request, response, true, "Password reset to '" + DEFAULT_PASSWORD + "' successfully.");

        } catch (Exception ex) {
            ex.printStackTrace();
            sendJsonResponse(request, response, false, "Failed to reset password: " + ex.getMessage());
        }
    }
}
