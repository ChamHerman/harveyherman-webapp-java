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

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        
        // Check if user is logged in as manager
        StaffData loggedInManager = (StaffData) session.getAttribute("loggedInManager");
        if (loggedInManager == null) {
            session.setAttribute("errorMessage", "You do not have permission to edit staff members");
            response.sendRedirect(request.getContextPath() + "/staff/ap_login.jsp");
            return;
        }
        
        try {
            // Get parameters from the form
            String staffId = request.getParameter("staffId");
            String fullname = request.getParameter("fullname");
            String email = request.getParameter("email");
            String contactNumber = request.getParameter("contactNumber");
            String address = request.getParameter("address");
            String position = request.getParameter("position");
            String gender = request.getParameter("gender");
            String dbstatus = request.getParameter("dbstatus");
            
            String username = request.getParameter("username");
            String password = request.getParameter("password");
            String role = request.getParameter("role");
            
            // Validate required fields
            if (staffId == null || fullname == null || email == null || 
                position == null || gender == null || username == null || 
                role == null) {
                
                session.setAttribute("errorMessage", "Missing required fields");
                response.sendRedirect(request.getContextPath() + "/manager/ap_edit_staff.jsp?staffId=" + staffId);
                return;
            }
            
            // Get the staff data object
            StaffData staffData = staffDataDAO.findByStaffId(staffId);
            if (staffData == null) {
                session.setAttribute("errorMessage", "Staff not found");
                response.sendRedirect(request.getContextPath() + "/manager/ap_staff.jsp");
                return;
            }
            
            // Get the staff login object
            StaffLogin staffLogin = staffLoginDAO.findByStaffId(staffId);
            if (staffLogin == null) {
                session.setAttribute("errorMessage", "Staff login not found");
                response.sendRedirect(request.getContextPath() + "/manager/ap_staff.jsp");
                return;
            }
            
            // Update StaffData object
            staffData.setFullname(fullname);
            staffData.setEmail(email);
            staffData.setContactNumber(contactNumber);
            staffData.setAddress(address);
            staffData.setPosition(position);
            staffData.setGender(gender);
            staffData.setDbstatus(dbstatus);
            
            // Update StaffLogin object
            staffLogin.setUsername(username);
            staffLogin.setRole(role);
            
            // Update password only if it has been changed
            String oldPassword = staffLogin.getPassword();
            if (password != null && !password.isEmpty() && !password.equals(oldPassword)) {
                staffLogin.setPassword(password);
            }
            
            // Save changes
            staffDataDAO.update(staffData);
            staffLoginDAO.update(staffLogin);
            
            // Redirect with success message
            String successMessage = "Staff updated successfully";
            response.sendRedirect(request.getContextPath() + "/manager/ap_staff.jsp?message=" + 
                    java.net.URLEncoder.encode(successMessage, "UTF-8"));
            
        } catch (Exception e) {
            // Handle any exceptions
            e.printStackTrace();
            String errorMessage = "Error updating staff: " + e.getMessage();
            response.sendRedirect(request.getContextPath() + "/manager/ap_staff.jsp?message=" + 
                    java.net.URLEncoder.encode(errorMessage, "UTF-8"));
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Redirect GET requests to the staff list page
        response.sendRedirect(request.getContextPath() + "/manager/ap_staff.jsp");
    }
} 