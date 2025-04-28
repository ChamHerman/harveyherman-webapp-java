/**
 *
 * @author weikang
 */
package controller;

import static controller.PasswordUtil.hashPasswordSHA256;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Timestamp;
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
import model.UserData;
import model.UserDataDAO;
import model.UserLogin;
import model.UserLoginDAO;
import model.Cart;
import model.CartDAO;

@WebServlet(name = "UserRegisterServlet", urlPatterns = {"/user/UserRegisterServlet"})
public class UserRegisterServlet extends HttpServlet {

    @EJB
    private UserDataDAO userDataDAO;
    @EJB
    private UserLoginDAO userLoginDAO;
    private static final long serialVersionUID = 1L;
    private String errorMsg = "";
    @EJB
    private CartDAO cartDAO;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        String fullName = request.getParameter("fullname");
        String email = request.getParameter("email");
        String contactNumber = request.getParameter("contact_number");
        String address = request.getParameter("address");
        String username = request.getParameter("username");
        String birthdateStr = request.getParameter("birthdate");
        String gender = request.getParameter("gender");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String challengeQuestion = request.getParameter("challenge_question");
        String answer = request.getParameter("answer");

        boolean success = registerUser(fullName, email, contactNumber, address, username, birthdateStr, gender, password, confirmPassword, challengeQuestion, answer);

        if (success) {
            request.getSession().setAttribute("registerSuccess", Boolean.TRUE);
            response.sendRedirect(request.getContextPath() + "/user/login.jsp");
        } else {
            request.setAttribute("errorMessage", errorMsg);
            request.setAttribute("reg_fullname", fullName);
            request.setAttribute("reg_email", email);
            request.setAttribute("reg_contactNumber", contactNumber);
            request.setAttribute("reg_address", address);
            request.setAttribute("reg_username", username);
            request.setAttribute("reg_birthdate", birthdateStr);
            request.setAttribute("reg_gender", gender);
            request.setAttribute("reg_challengeQuestion", challengeQuestion);
            request.setAttribute("reg_answer", answer);
            RequestDispatcher dispatcher = request.getRequestDispatcher("/user/register.jsp");
            dispatcher.forward(request, response);
        }
    }

    private boolean registerUser(String fullName, String email, String contactNumber, String address, String username, String birthdateStr, String gender, String password, String confirmPassword, String challengeQuestion, String answer) {
        try {
            if (fullName == null || fullName.trim().isEmpty()
                    || email == null || email.trim().isEmpty()
                    || contactNumber == null || contactNumber.trim().isEmpty()
                    || address == null || address.trim().isEmpty()
                    || username == null || username.trim().isEmpty()
                    || birthdateStr == null || birthdateStr.trim().isEmpty()
                    || gender == null || gender.trim().isEmpty()
                    || password == null || password.trim().isEmpty()
                    || confirmPassword == null || confirmPassword.trim().isEmpty()
                    || challengeQuestion == null || challengeQuestion.trim().isEmpty()
                    || answer == null || answer.trim().isEmpty()) {
                errorMsg = "Registration failed: All fields should be completed";
                return false;
            }

            if (userDataDAO.findByEmail(email) != null) {
                errorMsg = "Registration failed: Email address is already in use by another user.";
                return false;
            }

            if (userDataDAO.findByContactNumber(contactNumber) != null) {
                errorMsg = "Registration failed: Contact number is already in use by another user.";
                return false;
            }

            if (userLoginDAO.findByUsername(username) != null) {
                errorMsg = "Registration failed: Username is already in use by another user.";
                return false;
            }

            if (fullName.length() >= 255) {
                errorMsg = "Registration failed: Full name must be less than 255 characters.";
                return false;
            }
            if (email.length() >= 255) {
                errorMsg = "Registration failed: Email must be less than 255 characters.";
                return false;
            }
            if (address.length() >= 1000) {
                errorMsg = "Registration failed: Address must be less than 1000 characters.";
                return false;
            }
            if (username.length() >= 255) {
                errorMsg = "Registration failed: Username must be less than 255 characters.";
                return false;
            }
            if (password.length() >= 255) {
                errorMsg = "Registration failed: Password must be less than 255 characters.";
                return false;
            }
            if (answer.length() >= 255) {
                errorMsg = "Registration failed: Challenge question answer must be less than 255 characters.";
                return false;
            }

            if (!email.matches("^[a-z0-9@._+\\-]+$") || !email.matches("^[a-z0-9._+\\-]+@[a-z0-9._+\\-]+\\.[a-z]{2,}$")) {
                errorMsg = "Registration failed: Invalid email format.";
                return false;
            }

            if (!contactNumber.matches("^60\\d{9,10}$")) {
                errorMsg = "Registration failed: Contact number must start with 60 and be 11 or 12 digits long.";
                return false;
            }

            if (!password.matches("^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[!@#$%^&_.\\-+=]).{8,}$")) {
                errorMsg = "Registration failed: Password must be at least 8 characters and include uppercase, lowercase, number, and symbol (!@#$%^&_.-+=).";
                return false;
            }
            
            if (!confirmPassword.equals(password) ) {
                errorMsg = "Registration failed: Confirm password does not match with password.";
                return false;
            }

            Date birthdate = parseBirthdate(birthdateStr);
            if (birthdate == null) {
                errorMsg = "Registration failed: Invalid birthdate format.";
                return false;
            }
            if (birthdate.after(new Date())) {
                errorMsg = "Registration failed: Birthdate cannot be in the future.";
                return false;
            }

            password = hashPasswordSHA256(password);
            UserData user = createUserData(null, fullName, email, contactNumber, address, birthdate, gender);
            UserLogin userLogin = createUserLogin(null, username, password, user, challengeQuestion, answer);
            Cart cart = createCart(null, user);

            userDataDAO.create(user);
            userLoginDAO.create(userLogin);
            cartDAO.create(cart);

            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
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

    private UserData createUserData(String userId, String fullName, String email, String contactNumber, String address, Date birthdate, String gender) {
        UserData user = new UserData();
        user.setUserId(userId);
        user.setFullname(fullName);
        user.setEmail(email);
        user.setContactNumber(contactNumber);
        user.setAddress(address);
        user.setBirthDate(birthdate);
        user.setGender(gender);
        user.setCreatedDate(new Timestamp(System.currentTimeMillis()));
        user.setDbstatus("active");
        return user;
    }

    private UserLogin createUserLogin(String loginId, String username, String password, UserData user, String challengeQuestion, String answer) {
        UserLogin userLogin = new UserLogin();
        userLogin.setLoginId(loginId);
        userLogin.setUsername(username);
        userLogin.setPassword(password);
        userLogin.setUserId(user);
        userLogin.setChallengeQuestion(challengeQuestion);
        userLogin.setAnswer(answer);
        userLogin.setDbstatus("active");
        return userLogin;
    }

    private Cart createCart(String cartId, UserData user) {
        Cart cart = new Cart();
        cart.setCartId(cartId);
        cart.setUserId(user);
        cart.setCreatedDate(new java.sql.Timestamp(System.currentTimeMillis()));
        cart.setUpdatedDate(null);
        cart.setDbstatus("active");
        cart.setTotal(new BigDecimal("0.0"));
        return cart;
    }
}
