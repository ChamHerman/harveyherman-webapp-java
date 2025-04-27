/**
 *
 * @author weikang
 */
package controller;

import static controller.PasswordUtil.hashPasswordSHA256;
import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import javax.ejb.EJB;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import model.UserData;
import model.UserLogin;
import model.UserLoginDAO;

@WebServlet(name = "ChangePasswordServlet", urlPatterns = {"/user/ChangePasswordServlet"})
public class ChangePasswordServlet extends HttpServlet {

    @EJB
    private UserLoginDAO userLoginDAO;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        HttpSession session = request.getSession();
        UserData userData = (UserData) session.getAttribute("loggedInUser");

        if (userData == null) {
            response.sendRedirect(request.getContextPath() + "/user/login.jsp");
            return;
        }

        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmNewPassword = request.getParameter("confirmNewPassword");

        if (currentPassword == null || currentPassword.trim().isEmpty()
                || newPassword == null || newPassword.trim().isEmpty()
                || confirmNewPassword == null || confirmNewPassword.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/user/changePassword.jsp?error=All+fields+are+required");
            return;
        }

        if (!newPassword.equals(confirmNewPassword)) {
            response.sendRedirect(request.getContextPath() + "/user/changePassword.jsp?error=New+passwords+do+not+match");
            return;
        }
        
        if (newPassword.length() >= 255) {
            response.sendRedirect(request.getContextPath() + "/user/changePassword.jsp?error=Password+must+be+less+than+255+characters");
            return;
        }

        if (!newPassword.matches("^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[!@#$%^&_.\\-+=]).{8,}$")) {
            String errorMsg = "Password must be at least 8 characters and include uppercase, lowercase, number, and symbol (!@#$%^&_.-+=)";
            String encodedMsg = URLEncoder.encode(errorMsg, StandardCharsets.UTF_8.toString());
            response.sendRedirect(request.getContextPath() + "/user/changePassword.jsp?error=" + encodedMsg);
            return;
        }

        try {

            UserLogin userLogin = userLoginDAO.findByUserId(userData.getUserId());

            if (userLogin == null) {
                response.sendRedirect(request.getContextPath() + "/user/changePassword.jsp?error=User+account+not+found");
                return;
            }
            
            if (!userLogin.getPassword().equals(hashPasswordSHA256(currentPassword))) {
                response.sendRedirect(request.getContextPath() + "/user/changePassword.jsp?error=Current+password+is+incorrect");
                return;
            }

            userLogin.setPassword(hashPasswordSHA256(newPassword));
            userLoginDAO.update(userLogin);
            session.setAttribute("changePasswordSuccess", Boolean.TRUE);
            response.sendRedirect(request.getContextPath() + "/user/profile.jsp");
        } catch (Exception ex) {
            ex.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/user/changePassword.jsp?error=" + ex.getMessage());
        }
    }
}
