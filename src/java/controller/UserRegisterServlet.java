/**
 *
 * @author weikang
 */
package controller;

import java.io.IOException;
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

@WebServlet(name = "UserRegisterServlet", urlPatterns = {"/user/UserRegisterServlet"})
public class UserRegisterServlet extends HttpServlet {

    @EJB
    private UserDataDAO userDataDAO;
    @EJB
    private UserLoginDAO userLoginDAO;
    private static final long serialVersionUID = 1L;
    private String errorMsg = "";

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
        String challengeQuestion = request.getParameter("challenge_question");
        String answer = request.getParameter("answer");

        boolean success = registerUser(fullName, email, contactNumber, address, username, birthdateStr, gender, password, challengeQuestion, answer);

        if (success) {
            request.setAttribute("registerSuccess", Boolean.TRUE);
            RequestDispatcher dispatcher = request.getRequestDispatcher("/user/login.jsp");
            dispatcher.forward(request, response);
        } else {
            request.setAttribute("errorMessage", errorMsg);
            RequestDispatcher dispatcher = request.getRequestDispatcher("/user/register.jsp");
            dispatcher.forward(request, response);
        }
    }

    private boolean registerUser(String fullName, String email, String contactNumber, String address, String username, String birthdateStr, String gender, String password, String challengeQuestion, String answer) {
        try {
            // Check for duplicate email
            if (userDataDAO.findByEmail(email) != null) {
                errorMsg = "Registration failed: Duplicate Email Used!";
                return false;
            }

            // Check for duplicate contact number
            if (userDataDAO.findByContactNumber(contactNumber) != null) {
                errorMsg = "Registration failed: Duplicate Contact Number!";
                return false;
            }

            // Check for duplicate username
            if (userLoginDAO.findByUsername(username) != null) {
                errorMsg = "Registration failed: Duplicate Username!";
                return false;
            }

            Date birthdate = parseBirthdate(birthdateStr);
            if (birthdate == null) {
                return false;
            }

            UserData user = createUserData(null, fullName, email, contactNumber, address, birthdate, gender);
            UserLogin userLogin = createUserLogin(null, username, password, user, challengeQuestion, answer);

            userDataDAO.create(user);
            userLoginDAO.create(userLogin);

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
}
