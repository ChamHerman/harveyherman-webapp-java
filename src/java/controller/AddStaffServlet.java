/**
 *
 * @author weikang
 */
package controller;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.*;
import java.net.URLEncoder;
import javax.ejb.EJB;
import model.StaffData;
import model.StaffDataDAO;
import model.StaffLogin;
import model.StaffLoginDAO;

@WebServlet(name = "AddStaffServlet", urlPatterns = {"/manager/AddStaffServlet"})
public class AddStaffServlet extends HttpServlet {
    
    @EJB
    private StaffDataDAO staffDataDAO;
    
    @EJB
    private StaffLoginDAO staffLoginDAO;
    
    private static final long serialVersionUID = 1L;
    
    private static final String DEFAULT_PASSWORD = "password";

    // Helper method to send JSON-formatted response via redirect.
    private void sendJsonResponse(HttpServletRequest request, HttpServletResponse response, boolean success, String message)
            throws IOException {
        // Disable caching
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

        String encodedMessage = URLEncoder.encode(json, "UTF-8");
        response.sendRedirect(contextPath + "/manager/ap_staff.jsp?message=" + encodedMessage);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            request.setCharacterEncoding("UTF-8");

            String fullname = request.getParameter("fullname");
            String email = request.getParameter("email");
            String contactNumber = request.getParameter("contactNumber");
            String address = request.getParameter("address");
            String position = request.getParameter("position");
            String gender = request.getParameter("gender");
            String username = request.getParameter("username");
            
            // Validate required fields
            if (fullname == null || fullname.trim().isEmpty()) {
                sendJsonResponse(request, response, false, "Full name is required.");
                return;
            }
            
            if (email == null || email.trim().isEmpty()) {
                sendJsonResponse(request, response, false, "Email is required.");
                return;
            }
            
            if (contactNumber == null || contactNumber.trim().isEmpty()) {
                sendJsonResponse(request, response, false, "Contact number is required.");
                return;
            }
            
            if (position == null || position.trim().isEmpty()) {
                sendJsonResponse(request, response, false, "Position is required.");
                return;
            }
            
            if (gender == null || gender.trim().isEmpty()) {
                sendJsonResponse(request, response, false, "Gender is required.");
                return;
            }
            
            if (username == null || username.trim().isEmpty()) {
                sendJsonResponse(request, response, false, "Username is required.");
                return;
            }

            StaffLogin existingLogin = staffLoginDAO.findByUsername(username);
            if (existingLogin != null) {
                sendJsonResponse(request, response, false, "Username is already taken. Please check on the record and try again.");
                return;
            }

            StaffData existingStaffWithEmail = staffDataDAO.findByEmail(email);
            if (existingStaffWithEmail != null) {
                sendJsonResponse(request, response, false, "Email address is already in use. Please check on the record and try again.");
                return;
            }
            
            StaffData existingStaffWithContact = staffDataDAO.findByContactNumber(contactNumber);
            if (existingStaffWithContact != null) {
                sendJsonResponse(request, response, false, "Contact number is already in use. Please check on the record and try again.");
                return;
            }
            
            if (fullname.length() >= 255) {
                sendJsonResponse(request, response, false, "Full name must be less than 255 characters.");
                return;
            }
            if (email.length() >= 255) {
                sendJsonResponse(request, response, false, "Email must be less than 255 characters.");
                return ;
            }
            if (address.length() >= 1000) {
                sendJsonResponse(request, response, false, "Address must be less than 1000 characters.");
                return;
            }
            if (position.length() >= 255) {
                sendJsonResponse(request, response, false, "Position must be less than 255 characters.");
                return;
            }
            if (username.length() >= 255) {
                sendJsonResponse(request, response, false, "Username must be less than 255 characters.");
                return;
            }
            if (!email.matches("^[a-z0-9@._+\\-]+$") || !email.matches("^[a-z0-9._+\\-]+@[a-z0-9._+\\-]+\\.[a-z]{2,}$")) {
                sendJsonResponse(request, response, false, "Invalid email format.");
                return;
            }
            if (!contactNumber.matches("^60\\d{9,10}$")) {
                sendJsonResponse(request, response, false, "Contact number must start with 60 and be 11 or 12 digits long.");
                return;
            }
            
            // Create the StaffData object
            StaffData staffData = new StaffData();
            staffData.setFullname(fullname);
            staffData.setEmail(email);
            staffData.setContactNumber(contactNumber);
            staffData.setAddress(address);
            staffData.setPosition(position);
            staffData.setGender(gender);
            staffData.setDbstatus("active");
            staffData.setCreatedDate(new java.sql.Timestamp(System.currentTimeMillis()));
            
            staffDataDAO.create(staffData);
            
            // Create StaffLogin object
            StaffLogin staffLogin = new StaffLogin();
            staffLogin.setStaffId(staffData);
            staffLogin.setUsername(username);
            staffLogin.setPassword(DEFAULT_PASSWORD);
            staffLogin.setRole("staff");
            staffLogin.setDbstatus("active");
            
            staffLoginDAO.create(staffLogin);
            
            sendJsonResponse(request, response, true, "Staff created successfully. Default password is: " + DEFAULT_PASSWORD);
        } catch (Exception ex) {
            ex.printStackTrace();
            sendJsonResponse(request, response, false, "Failed to create staff. Error: " + ex.getMessage());
        }
    }
} 