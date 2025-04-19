package controller;

import java.io.IOException;
import java.io.PrintWriter;
import javax.ejb.EJB;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import model.UserData;
import model.UserLogin;
import model.UserLoginDAO;

@WebServlet(name = "UserLoginServlet", urlPatterns = {"/user/UserLoginServlet"})
public class UserLoginServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    @EJB
    private UserLoginDAO userLoginDAO;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        UserData userData = authenticateUser(username, password);

        if (userData != null) {
            HttpSession session = request.getSession();
            session.setAttribute("loggedInUser", userData);
            response.sendRedirect(request.getContextPath() + "/user/index.jsp");
        } else {
            HttpSession session = request.getSession();
            session.setAttribute("loginError", true);
            response.sendRedirect(request.getContextPath() + "/user/login.jsp");
        }
    }

    private UserData authenticateUser(String username, String password) {
        try {
            UserLogin userLogin = userLoginDAO.findByUsername(username);

            if (userLogin != null && userLogin.getPassword().equals(password)) {
                UserData userData = userLogin.getUserId();
                if (userData != null) {
                    try {
                        updateLastLoginTime(userLogin);
                    } catch (Exception e) {
                        System.out.println("Warning: Failed to update last login time: " + e.getMessage());
                    }
                    return userData;
                }
            }
        } catch (Exception e) {
            System.out.println("Authentication error: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    private void updateLastLoginTime(UserLogin userLogin) {
        try {
            UserLogin managedUserLogin = userLoginDAO.findByLoginId(userLogin.getLoginId());

            if (managedUserLogin != null) {
                java.sql.Timestamp currentTime = new java.sql.Timestamp(System.currentTimeMillis());
                managedUserLogin.setLastLogin(currentTime);
                userLoginDAO.update(managedUserLogin);
            }
        } catch (Exception e) {
            System.out.println("Failed to update login time: " + e.getMessage());
        }
    }
}
