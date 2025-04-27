/**
 *
 * @author weikang
 */
package controller;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import javax.ejb.EJB;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import model.StaffData;
import model.StaffLogin;
import model.StaffLoginDAO;

@WebServlet(name = "StaffChangePasswordServlet", urlPatterns = {"/manager/StaffChangePasswordServlet", "/staff/StaffChangePasswordServlet"})
public class StaffChangePasswordServlet extends HttpServlet {

    @EJB
    private StaffLoginDAO staffLoginDAO;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        String servletPath = request.getServletPath();
        String contextPath = request.getContextPath();
        String sourcePath = "";
        StaffData staff = null;

        HttpSession session = request.getSession();
        
        if (servletPath.contains("/manager/")) {
            staff = (StaffData) session.getAttribute("loggedInManager");
            sourcePath = "/manager";
        } else if (servletPath.contains("/staff/")) {
            staff = (StaffData) session.getAttribute("loggedInStaff");
            sourcePath = "/staff";
        }
        
        if (staff == null) {
            response.sendRedirect(contextPath + "/staff/ap_login.jsp");
            return;
        }

        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmNewPassword = request.getParameter("confirmNewPassword");

        if (currentPassword == null || currentPassword.trim().isEmpty()
                || newPassword == null || newPassword.trim().isEmpty()
                || confirmNewPassword == null || confirmNewPassword.trim().isEmpty()) {
            response.sendRedirect(contextPath + sourcePath + "/ap_changePassword.jsp?error=All+fields+are+required");
            return;
        }

        if (!newPassword.equals(confirmNewPassword)) {
            response.sendRedirect(contextPath + sourcePath + "/ap_changePassword.jsp?error=New+passwords+do+not+match");
            return;
        }
        
        if (newPassword.length() >= 255) {
            response.sendRedirect(contextPath + sourcePath + "/ap_changePassword.jsp?error=Password+must+be+less+than+255+characters");
            return;
        }

        if (!newPassword.matches("^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[!@#$%^&_.\\-+=]).{8,}$")) {
            String errorMsg = "Password must be at least 8 characters and include uppercase, lowercase, number, and symbol (!@#$%^&_.-+=)";
            String encodedMsg = URLEncoder.encode(errorMsg, StandardCharsets.UTF_8.toString());
            response.sendRedirect(contextPath + sourcePath + "/ap_changePassword.jsp?error=" + encodedMsg);
            return;
        }

        try {
            StaffLogin staffLogin = staffLoginDAO.findByStaffId(staff.getStaffId());

            if (staffLogin == null) {
                response.sendRedirect(contextPath + sourcePath + "/ap_changePassword.jsp?error=Staff+account+not+found");
                return;
            }

            if (!staffLogin.getPassword().equals(currentPassword)) {
                response.sendRedirect(contextPath + sourcePath + "/ap_changePassword.jsp?error=Current+password+is+incorrect");
                return;
            }

            staffLogin.setPassword(newPassword);
            staffLoginDAO.update(staffLogin);
            response.sendRedirect(contextPath + sourcePath + "/ap_profile.jsp?success=password");

        } catch (Exception e) {
            response.sendRedirect(contextPath + sourcePath + "/ap_changePassword.jsp?error=" + e.getMessage());
        }
    }
}
