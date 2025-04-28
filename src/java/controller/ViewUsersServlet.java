/**
 *
 * @author weikang
 */
package controller;

import java.io.IOException;
import java.net.URLEncoder;
import java.text.SimpleDateFormat;
import java.util.TimeZone;
import javax.ejb.EJB;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import model.UserData;
import model.UserDataDAO;
import model.UserLogin;
import model.UserLoginDAO;

@WebServlet(name = "ViewUsersServlet", urlPatterns = {"/manager/ViewUsersServlet", "/staff/ViewUsersServlet"})
public class ViewUsersServlet extends HttpServlet {

    @EJB
    private UserDataDAO userDataDAO;
    
    @EJB
    private UserLoginDAO userLoginDAO;
    
    private static final long serialVersionUID = 1L;

    private void sendJsonResponse(HttpServletRequest request, HttpServletResponse response, boolean success, String message, String viewData)
            throws IOException {
        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        response.setHeader("Pragma", "no-cache");
        response.setDateHeader("Expires", 0);

        // Determine which URL pattern was used
        String servletPath = request.getServletPath();
        String contextPath = request.getContextPath();
        String json;
        String encodedMessage;
        if (success && viewData != null) {
            json = viewData;
            encodedMessage = URLEncoder.encode(json, "UTF-8");
            if (servletPath.contains("/manager/")) {
                response.sendRedirect(contextPath + "/manager/ap_user.jsp?viewData=" + encodedMessage);
            } else if (servletPath.contains("/staff/")) {
                response.sendRedirect(contextPath + "/staff/ap_user.jsp?viewData=" + encodedMessage);
            }
        } else {
            json = "Error: " + message.replace("\"", "\\\"");
            encodedMessage = URLEncoder.encode(json, "UTF-8");
            if (servletPath.contains("/manager/")) {
                response.sendRedirect(contextPath + "/manager/ap_user.jsp?message=" + encodedMessage);
            } else if (servletPath.contains("/staff/")) {
                response.sendRedirect(contextPath + "/staff/ap_user.jsp?message=" + encodedMessage);
            }
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doPost(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String userId = request.getParameter("userId");
            if (userId == null || userId.trim().isEmpty()) {
                sendJsonResponse(request, response, false, "User ID not provided.", null);
                return;
            }

            UserData userData = userDataDAO.findByUserId(userId);
            if (userData == null) {
                sendJsonResponse(request, response, false, "User not found.", null);
                return;
            }
            
            UserLogin userLogin = userLoginDAO.findByUserId(userId);
            if (userLogin == null) {
                sendJsonResponse(request, response, false, "User login information not found.", null);
                return;
            }
            
            // Format dates
            SimpleDateFormat sdf = new SimpleDateFormat("dd MMM yyyy HH:mm:ss");
            sdf.setTimeZone(TimeZone.getDefault());
            String birthDateStr = (userData.getBirthDate() != null) ? new SimpleDateFormat("dd MMM yyyy").format(userData.getBirthDate()) : "";
            String createdDateStr = (userData.getCreatedDate() != null) ? sdf.format(userData.getCreatedDate()) : "";
            String lastLoginStr = (userLogin.getLastLogin() != null) ? sdf.format(userLogin.getLastLogin()) : "";
            
            // Build a JSON string with necessary fields.
            StringBuilder sb = new StringBuilder();
            sb.append("{");
            sb.append("\"success\": true,");
            sb.append("\"userId\": \"").append(userData.getUserId()).append("\",");
            sb.append("\"fullName\": \"").append(userData.getFullname().replace("\"", "\\\"")).append("\",");
            sb.append("\"email\": \"").append(userData.getEmail().replace("\"", "\\\"")).append("\",");
            sb.append("\"contactNumber\": \"").append(userData.getContactNumber().replace("\"", "\\\"")).append("\",");
            sb.append("\"address\": \"").append((userData.getAddress() != null ? userData.getAddress().replace("\"", "\\\"") : "")).append("\",");
            sb.append("\"birthDate\": \"").append(birthDateStr).append("\",");
            sb.append("\"gender\": \"").append(userData.getGender()).append("\",");
            sb.append("\"createdDate\": \"").append(createdDateStr).append("\",");
            sb.append("\"loginId\": \"").append(userLogin.getLoginId()).append("\",");
            sb.append("\"username\": \"").append(userLogin.getUsername().replace("\"", "\\\"")).append("\",");
            sb.append("\"challengeQuestion\": \"").append(userLogin.getChallengeQuestion().replace("\"", "\\\"")).append("\",");
            sb.append("\"answer\": \"").append(userLogin.getAnswer().replace("\"", "\\\"")).append("\",");
            sb.append("\"lastLogin\": \"").append(lastLoginStr).append("\"");
            sb.append("}");
            sendJsonResponse(request, response, true, null, sb.toString());
        } catch (Exception ex) {
            ex.printStackTrace();
            sendJsonResponse(request, response, false, "Error retrieving user: " + ex.getMessage(), null);
        }
    }
}
