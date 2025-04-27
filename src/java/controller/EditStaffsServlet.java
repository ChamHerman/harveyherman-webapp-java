/**
 *
 * @author weikang
 */
package controller;

import java.io.IOException;
import javax.ejb.EJB;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import model.StaffData;
import model.StaffDataDAO;
import model.StaffLogin;
import model.StaffLoginDAO;

@WebServlet(name = "EditStaffsServlet", urlPatterns = {"/manager/EditStaffsServlet"})
public class EditStaffsServlet extends HttpServlet {

    @EJB
    private StaffDataDAO staffDataDAO;

    @EJB
    private StaffLoginDAO staffLoginDAO;

    private void sendJsonResponse(HttpServletRequest request, HttpServletResponse response, boolean success, String message)
            throws IOException {
        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        response.setHeader("Pragma", "no-cache");
        response.setDateHeader("Expires", 0);

        String contextPath = request.getContextPath();
        String json;

        if (success) {
            json = "MESSAGE: " + message.replace("\"", "\\\"");
        } else {
            json = "ERROR: " + message.replace("\"", "\\\"");
        }

        String encodedMessage = java.net.URLEncoder.encode(json, "UTF-8");
        response.sendRedirect(contextPath + "/manager/ap_staff.jsp?message=" + encodedMessage);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        StaffData loggedInManager = (StaffData) session.getAttribute("loggedInManager");
        if (loggedInManager == null) {
            sendJsonResponse(request, response, false, "You do not have permission to edit staff members");
            return;
        }

        try {
            String staffId = request.getParameter("staffId");
            String fullname = request.getParameter("fullname");
            String email = request.getParameter("email");
            String contactNumber = request.getParameter("contactNumber");
            String address = request.getParameter("address");
            String position = request.getParameter("position");
            String gender = request.getParameter("gender");
            String username = request.getParameter("username");
            String password = request.getParameter("password");

            if (staffId == null || staffId.trim().isEmpty()
                    || fullname == null || fullname.trim().isEmpty()
                    || email == null || email.trim().isEmpty()
                    || contactNumber == null || contactNumber.trim().isEmpty()
                    || address == null || address.trim().isEmpty()
                    || position == null || position.trim().isEmpty()
                    || gender == null || gender.trim().isEmpty()
                    || username == null || username.trim().isEmpty()
                    || password == null || password.trim().isEmpty()) {
                sendJsonResponse(request, response, false, "Missing required fields");
                return;
            }
            
            if (fullname.length() > 255) {
                sendJsonResponse(request, response, false, "Full name must be less than 255 characters.");
                return;
            }
            
            if (email.length() > 255) {
                sendJsonResponse(request, response, false, "Email must be less than 255 characters.");
                return;
            }
            if (!email.matches("^[a-z0-9@._+\\-]+$") || !email.matches("^[a-z0-9._+\\-]+@[a-z0-9._+\\-]+\\.[a-z]{2,}$")) {
                sendJsonResponse(request, response, false, "Email format is invalid.");
                return;
            }
            StaffData existingStaffWithEmail = staffDataDAO.findByEmail(email);
            if (existingStaffWithEmail != null && !existingStaffWithEmail.getStaffId().equals(staffId)) {
                sendJsonResponse(request, response, false, "Email address is already in use by another staff. Please check on the record and try again.");
                return;
            }

            if (!contactNumber.matches("^60\\d{9,10}$")) {
                sendJsonResponse(request, response, false, "Contact number must start with 60 and be 11 or 12 digits long.");
                return;
            }
            StaffData existingStaffWithContact = staffDataDAO.findByContactNumber(contactNumber);
            if (existingStaffWithContact != null && !existingStaffWithContact.getStaffId().equals(staffId)) {
                sendJsonResponse(request, response, false, "Contact number is already in use by another staff. Please check on the record and try again.");
                return;
            }

            if (address.length() > 1000) {
                sendJsonResponse(request, response, false, "Address must be less than 1000 characters.");
                return;
            }
            
            if (position.length() > 255) {
                sendJsonResponse(request, response, false, "Position must be less than 255 characters.");
                return;
            }
            
            if (username.length() > 255) {
                sendJsonResponse(request, response, false, "Username must be less than 255 characters.");
                return;
            }
            StaffLogin existingStaffWithUsername = staffLoginDAO.findByUsername(username);
            if (existingStaffWithUsername != null && !existingStaffWithUsername.getStaffId().getStaffId().equals(staffId)) {
                sendJsonResponse(request, response, false, "Username is already in use by another staff. Please check on the record and try again.");
                return;
            }
            
            if (password.length() > 255) {
                sendJsonResponse(request, response, false, "Password must be less than 255 characters.");
                return;
            }
            if (!password.matches("^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[!@#$%^&_.\\-+=]).{8,}$")) {
                sendJsonResponse(request, response, false, "Password must be at least 8 characters and include uppercase, lowercase, number, and symbol (!@#$%^&_.-+=).");
                return;
            }

            StaffData staffData = staffDataDAO.findByStaffId(staffId);
            if (staffData == null) {
                sendJsonResponse(request, response, false, "Staff not found");
                return;
            }
            StaffLogin staffLogin = staffLoginDAO.findByStaffId(staffId);
            if (staffLogin == null) {
                sendJsonResponse(request, response, false, "Staff login not found");
                return;
            }

            staffData.setFullname(fullname);
            staffData.setEmail(email);
            staffData.setContactNumber(contactNumber);
            staffData.setAddress(address);
            staffData.setPosition(position);
            staffData.setGender(gender);

            staffLogin.setUsername(username);

            String oldPassword = staffLogin.getPassword();
            if (password != null && !password.isEmpty() && !password.equals(oldPassword)) {
                staffLogin.setPassword(password);
            }

            staffDataDAO.update(staffData);
            staffLoginDAO.update(staffLogin);

            sendJsonResponse(request, response, true, "Staff updated successfully");
        } catch (Exception e) {
            e.printStackTrace();
            sendJsonResponse(request, response, false, "Error updating staff: " + e.getMessage());
        }
    }
}
