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

@WebServlet(name = "VerifyChallengeServlet", urlPatterns = {"/user/VerifyChallengeServlet"})
public class VerifyChallengeServlet extends HttpServlet {
    
    private static final long serialVersionUID = 1L;
    
    @EJB
    private UserLoginDAO userLoginDAO;
    @EJB
    private UserDataDAO userDataDAO;
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String identifier = request.getParameter("identifier");
        String challengeQuestion = request.getParameter("challengeQuestion");
        String answer = request.getParameter("answer");
        
        try {
            UserLogin userLogin = userLoginDAO.findByUsername(identifier);

            if (userLogin == null) {
                UserData userData = userDataDAO.findByEmail(identifier);
                if (userData != null && userLoginDAO.findByUserId(userData.getUserId()) != null) {
                    userLogin = userLoginDAO.findByUserId(userData.getUserId());
                }
            }
            
            if (userLogin == null || 
                !userLogin.getChallengeQuestion().equals(challengeQuestion) || 
                !userLogin.getAnswer().equals(answer)) {
                
                request.setAttribute("errorMessage", "Invalid information provided. Please try again.");
                RequestDispatcher dispatcher = request.getRequestDispatcher("/user/challengeQuestion.jsp");
                dispatcher.forward(request, response);
                return;
            }
            
            HttpSession session = request.getSession();
            session.setAttribute("resetPasswordLoginId", userLogin.getLoginId());
            response.sendRedirect(request.getContextPath() + "/user/resetPassword.jsp");
            
        } catch (Exception e) {
            request.setAttribute("errorMessage", "An error occurred: " + e.getMessage());
            RequestDispatcher dispatcher = request.getRequestDispatcher("/user/challengeQuestion.jsp");
            dispatcher.forward(request, response);
        }
    }
}