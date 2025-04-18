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
import model.UserLogin;
import model.UserLoginDAO;

@WebServlet(name = "ResetPasswordServlet", urlPatterns = {"/user/ResetPasswordServlet"})
public class ResetPasswordServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @EJB
    private UserLoginDAO userLoginDAO;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        HttpSession session = request.getSession();
        String loginId = (String) session.getAttribute("resetPasswordLoginId");

        if (loginId == null) {
            response.sendRedirect(request.getContextPath() + "/user/challengeQuestion.jsp");
            return;
        }

        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        if (newPassword == null || !newPassword.equals(confirmPassword) || newPassword.length() < 6) {
            request.setAttribute("errorMessage", "Password must be at least 6 characters and match confirmation.");
            RequestDispatcher dispatcher = request.getRequestDispatcher("/user/resetPassword.jsp");
            dispatcher.forward(request, response);
            return;
        }

        try {
            UserLogin userLogin = userLoginDAO.findByLoginId(loginId);

            if (userLogin == null) {
                request.setAttribute("errorMessage", "User account not found.");
                RequestDispatcher dispatcher = request.getRequestDispatcher("/user/resetPassword.jsp");
                dispatcher.forward(request, response);
                return;
            }
            
            userLogin.setPassword(newPassword);
            userLoginDAO.update(userLogin);
            session.removeAttribute("resetPasswordLoginId");
            response.sendRedirect(request.getContextPath() + "/user/login.jsp");
            
        } catch (Exception e) {
            request.setAttribute("errorMessage", "Failed to reset password: " + e.getMessage());
            RequestDispatcher dispatcher = request.getRequestDispatcher("/user/resetPassword.jsp");
            dispatcher.forward(request, response);
        }
    }
}
