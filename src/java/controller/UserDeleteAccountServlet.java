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
import model.UserDataDAO;
import model.UserLogin;
import model.UserLoginDAO;

@WebServlet(name = "UserDeleteAccountServlet", urlPatterns = {"/user/UserDeleteAccountServlet"})
public class UserDeleteAccountServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @EJB
    private UserDataDAO userDataDAO;
    @EJB
    private UserLoginDAO userLoginDAO;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loggedInUser") == null) {
            response.sendRedirect(request.getContextPath() + "/user/login.jsp");
            return;
        }

        try {
            String confirmPassword = request.getParameter("confirmPassword");
            UserData userData = (UserData) session.getAttribute("loggedInUser");
            UserLogin userLogin = userLoginDAO.findByUserId(userData.getUserId());

            if (userLogin == null || !userLogin.getPassword().equals(confirmPassword)) {
                response.sendRedirect(request.getContextPath() + "/user/profile.jsp?error=password");
                return;
            }

            String userId = userData.getUserId();

            userLoginDAO.delete(userLogin.getLoginId());
            userDataDAO.delete(userId);
            session.removeAttribute("loggedInUser");

            request.getSession().setAttribute("deleteSuccess", Boolean.TRUE);
            response.sendRedirect(request.getContextPath() + "/user/login.jsp");
        } catch (Exception ex) {
            ex.printStackTrace();
            session.setAttribute("errorMessage", "Failed to delete account. Please try again later.");
            response.sendRedirect(request.getContextPath() + "/user/profile.jsp");
        }
    }
}
