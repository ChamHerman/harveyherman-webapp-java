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
import model.StaffLogin;
import model.StaffLoginDAO;

@WebServlet(name = "StaffLoginServlet", urlPatterns = {"/staff/StaffLoginServlet"})
public class StaffLoginServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @EJB
    private StaffLoginDAO staffLoginDAO;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        StaffLogin staffLogin = authenticateStaff(username, password);

        if (staffLogin != null) {
            HttpSession session = request.getSession();
            StaffData staffData = staffLogin.getStaffId();
            updateLastLoginTime(staffLogin);

            if ("manager".equalsIgnoreCase(staffLogin.getRole())) {
                session.setAttribute("loggedInManager", staffData);
                response.sendRedirect(request.getContextPath() + "/manager/ap_index.jsp");
            } else {
                session.setAttribute("loggedInStaff", staffData);
                response.sendRedirect(request.getContextPath() + "/staff/ap_index.jsp");
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/staff/ap_login.jsp?error=true");
        }
    }

    private StaffLogin authenticateStaff(String username, String password) {
        try {
            StaffLogin staffLogin = staffLoginDAO.findByUsername(username);

            if (staffLogin != null && staffLogin.getPassword().equals(password)) {
                return staffLogin;
            }
        } catch (Exception e) {
            System.out.println("Authentication error: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    private void updateLastLoginTime(StaffLogin staffLogin) {
        try {
            StaffLogin managedStaffLogin = staffLoginDAO.findByLoginId(staffLogin.getLoginId());

            if (managedStaffLogin != null) {
                java.util.Date currentTime = new java.util.Date();
                managedStaffLogin.setLastLogin(currentTime);
                staffLoginDAO.update(managedStaffLogin);
            }
        } catch (Exception e) {
            System.out.println("Failed to update login time: " + e.getMessage());
            e.printStackTrace();
        }
    }
}