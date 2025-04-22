/**
 *
 * @author weikang
 */
package controller;

import java.io.IOException;
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

        if (currentPassword == null || newPassword == null || confirmNewPassword == null) {
            response.sendRedirect(request.getContextPath() + "/user/changePassword.jsp?error=All+fields+are+required");
            return;
        }

        if (!newPassword.equals(confirmNewPassword)) {
            response.sendRedirect(request.getContextPath() + "/user/changePassword.jsp?error=New+passwords+do+not+match");
            return;
        }

        if (newPassword.length() < 6) {
            response.sendRedirect(request.getContextPath() + "/user/changePassword.jsp?error=Password+must+be+at+least+6+characters+long");
            return;
        }

        try {

            UserLogin userLogin = userLoginDAO.findByUserId(userData.getUserId());

            if (userLogin == null) {
                response.sendRedirect(request.getContextPath() + "/user/changePassword.jsp?error=User+account+not+found");
                return;
            }

            if (!userLogin.getPassword().equals(currentPassword)) {
                response.sendRedirect(request.getContextPath() + "/user/changePassword.jsp?error=Current+password+is+incorrect");
                return;
            }

            userLogin.setPassword(newPassword);
            userLoginDAO.update(userLogin);
            request.setAttribute("changePasswordSuccess", Boolean.TRUE);
            RequestDispatcher dispatcher = request.getRequestDispatcher("/user/profile.jsp");
            dispatcher.forward(request, response);


        } catch (Exception ex) {
            ex.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/user/changePassword.jsp?error=" + ex.getMessage());
        }
    }
}
