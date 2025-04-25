/**
 *
 * @author weikang
 */
package controller;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
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
import java.util.Date;

@WebServlet(name = "AddStaffServlet", urlPatterns = {"/manager/AddStaffServlet"})
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, maxFileSize = 1024 * 1024 * 10, maxRequestSize = 1024 * 1024 * 50)
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
        
        String servletPath = request.getServletPath();
        String contextPath = request.getContextPath();

        String json;

        if (success) {
            json = "MESSAGE: " + message.replace("\"", "\\\"");
        } else {
            json = "ERROR: " + message.replace("\"", "\\\"");
        }

        String encodedMessage = URLEncoder.encode(json, "UTF-8");

        if (servletPath.contains("/manager/")) {
            response.sendRedirect(contextPath + "/manager/ap_staff.jsp?message=" + encodedMessage);
        } else if (servletPath.contains("/staff/")) {
            response.sendRedirect(contextPath + "/staff/ap_staff.jsp?message=" + encodedMessage);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            request.setCharacterEncoding("UTF-8");
            
            // Get form parameters
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
            
            // Check for existing username
            StaffLogin existingLogin = staffLoginDAO.findByUsername(username);
            if (existingLogin != null) {
                sendJsonResponse(request, response, false, "Username is already taken. Please choose another one.");
                return;
            }
            
            // Check for duplicate email
            StaffData existingStaffWithEmail = staffDataDAO.findByEmail(email);
            if (existingStaffWithEmail != null) {
                sendJsonResponse(request, response, false, "Email address is already in use.");
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
            
            // Save the StaffData first to get the generated ID
            staffDataDAO.create(staffData);
            
            // Create StaffLogin object
            StaffLogin staffLogin = new StaffLogin();
            staffLogin.setStaffId(staffData);
            staffLogin.setUsername(username);
            staffLogin.setPassword(DEFAULT_PASSWORD);
            staffLogin.setRole("staff");
            staffLogin.setDbstatus("active");
            
            // Save the StaffLogin
            staffLoginDAO.create(staffLogin);
            
            sendJsonResponse(request, response, true, "Staff created successfully. Default password is: " + DEFAULT_PASSWORD);
        } catch (Exception ex) {
            ex.printStackTrace();
            sendJsonResponse(request, response, false, "Failed to create staff. Error: " + ex.getMessage());
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Redirect GET requests to the add staff form
        response.sendRedirect(request.getContextPath() + "/manager/ap_add_staff.jsp");
    }
} 