/**
 *
 * @author weikang
 */
package controller;

import javax.ejb.EJB;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.net.URLEncoder;
import model.UserData;
import model.UserDataDAO;
import model.UserLogin;
import model.UserLoginDAO;

@WebServlet("/manager/DeleteUsersServlet")
public class DeleteUsersServlet extends HttpServlet {

    @EJB
    private UserDataDAO userDataDAO;
    
    @EJB
    private UserLoginDAO userLoginDAO;
    
    private static final long serialVersionUID = 1L;

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
            String userId = request.getParameter("userId");
            if (userId == null || userId.trim().isEmpty()) {
                sendJsonResponse(request, response, false, "User ID not provided.");
                return;
            }

            // Get user data to verify it exists
            UserData userData = userDataDAO.findByUserId(userId);
            if (userData == null) {
                sendJsonResponse(request, response, false, "User not found.");
                return;
            }
            
            UserLogin userLogin = userLoginDAO.findByUserId(userId);
            
            if (userLogin != null) {
                userLoginDAO.delete(userLogin.getLoginId());
            }
            userDataDAO.delete(userId);
            
            sendJsonResponse(request, response, true, "User deleted successfully.");
        } catch (Exception ex) {
            ex.printStackTrace();
            sendJsonResponse(request, response, false, "User failed to delete. Exception: " + ex.getMessage());
        }
    }
}
