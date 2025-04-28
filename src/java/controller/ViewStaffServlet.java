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
import model.StaffData;
import model.StaffDataDAO;
import model.StaffLogin;
import model.StaffLoginDAO;

@WebServlet(name = "ViewStaffServlet", urlPatterns = {"/manager/ViewStaffServlet"})
public class ViewStaffServlet extends HttpServlet {

    @EJB
    private StaffDataDAO staffDataDAO;

    @EJB
    private StaffLoginDAO staffLoginDAO;

    private static final long serialVersionUID = 1L;

    private void sendJsonResponse(HttpServletRequest request, HttpServletResponse response, boolean success, String message, String viewData)
            throws IOException {
        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        response.setHeader("Pragma", "no-cache");
        response.setDateHeader("Expires", 0);

        String contextPath = request.getContextPath();
        String json;
        String encodedMessage;
        if (success && viewData != null) {
            json = viewData;
            encodedMessage = URLEncoder.encode(json, "UTF-8");
            response.sendRedirect(contextPath + "/manager/ap_staff.jsp?viewData=" + encodedMessage);

        } else {
            json = "Error: " + message.replace("\"", "\\\"");
            encodedMessage = URLEncoder.encode(json, "UTF-8");
            response.sendRedirect(contextPath + "/manager/ap_staff.jsp?message=" + encodedMessage);
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
            String staffId = request.getParameter("staffId");
            if (staffId == null || staffId.trim().isEmpty()) {
                sendJsonResponse(request, response, false, "Staff ID not provided.", null);
                return;
            }

            StaffData staffData = staffDataDAO.findByStaffId(staffId);
            if (staffData == null) {
                sendJsonResponse(request, response, false, "Staff not found.", null);
                return;
            }

            StaffLogin staffLogin = staffLoginDAO.findByStaffId(staffId);
            if (staffLogin == null) {
                sendJsonResponse(request, response, false, "Staff login information not found.", null);
                return;
            }

            // Format dates
            SimpleDateFormat sdf = new SimpleDateFormat("dd MMM yyyy HH:mm:ss");
            sdf.setTimeZone(TimeZone.getDefault());
            String createdDateStr = (staffData.getCreatedDate() != null) ? sdf.format(staffData.getCreatedDate()) : "";
            String lastLoginStr = (staffLogin.getLastLogin() != null) ? sdf.format(staffLogin.getLastLogin()) : "";

            // Build a JSON string with necessary fields.
            StringBuilder sb = new StringBuilder();
            sb.append("{");
            sb.append("\"success\": true,");
            sb.append("\"staffId\": \"").append(staffData.getStaffId()).append("\",");
            sb.append("\"fullName\": \"").append(staffData.getFullname().replace("\"", "\\\"")).append("\",");
            sb.append("\"email\": \"").append(staffData.getEmail().replace("\"", "\\\"")).append("\",");
            sb.append("\"contactNumber\": \"").append(staffData.getContactNumber() != null ? staffData.getContactNumber().replace("\"", "\\\"") : "").append("\",");
            sb.append("\"address\": \"").append((staffData.getAddress() != null ? staffData.getAddress().replace("\"", "\\\"") : "")).append("\",");
            sb.append("\"position\": \"").append(staffData.getPosition().replace("\"", "\\\"")).append("\",");
            sb.append("\"gender\": \"").append(staffData.getGender()).append("\",");
            sb.append("\"createdDate\": \"").append(createdDateStr).append("\",");
            sb.append("\"loginId\": \"").append(staffLogin.getLoginId()).append("\",");
            sb.append("\"username\": \"").append(staffLogin.getUsername().replace("\"", "\\\"")).append("\",");
            sb.append("\"password\": \"").append(staffLogin.getPassword().replace("\"", "\\\"")).append("\",");
            sb.append("\"role\": \"").append(staffLogin.getRole().replace("\"", "\\\"")).append("\",");
            sb.append("\"lastLogin\": \"").append(lastLoginStr).append("\"");
            sb.append("}");
            sendJsonResponse(request, response, true, null, sb.toString());
        } catch (Exception ex) {
            ex.printStackTrace();
            sendJsonResponse(request, response, false, "Error retrieving staff information: " + ex.getMessage(), null);
        }
    }
}
