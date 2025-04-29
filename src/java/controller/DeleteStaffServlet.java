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
import model.StaffData;
import model.StaffDataDAO;
import model.StaffLogin;
import model.StaffLoginDAO;

@WebServlet("/manager/DeleteStaffServlet")
public class DeleteStaffServlet extends HttpServlet {

    @EJB
    private StaffDataDAO staffDataDAO;
    
    @EJB
    private StaffLoginDAO staffLoginDAO;
    
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
        response.sendRedirect(contextPath + "/manager/ap_staff.jsp?message=" + encodedMessage);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String staffId = request.getParameter("staffId");
            if (staffId == null || staffId.trim().isEmpty()) {
                sendJsonResponse(request, response, false, "Staff ID not provided.");
                return;
            }

            StaffData staffData = staffDataDAO.findByStaffId(staffId);
            if (staffData == null) {
                sendJsonResponse(request, response, false, "Staff not found.");
                return;
            }
            
            StaffLogin staffLogin = staffLoginDAO.findByStaffId(staffId);
            
            if (staffLogin.getLoginId().equalsIgnoreCase("L000")) {
                sendJsonResponse(request, response, false, "You cannot delete a default account");
                return;
            }
            
            if (staffLogin != null) {
                staffLoginDAO.delete(staffLogin.getLoginId());
            }
            staffDataDAO.delete(staffId);
            
            sendJsonResponse(request, response, true, "Staff deleted successfully.");
        } catch (Exception ex) {
            ex.printStackTrace();
            sendJsonResponse(request, response, false, "Staff failed to delete. Exception: " + ex.getMessage());
        }
    }
}
