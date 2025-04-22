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

@WebServlet(name = "EditStaffServlet", urlPatterns = {"/manager/EditStaffServlet", "/staff/EditStaffServlet"})
public class EditStaffServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @EJB
    private StaffDataDAO staffDataDAO;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String servletPath = request.getServletPath();
        String contextPath = request.getContextPath();
        StaffData staff = null;
        HttpSession session = request.getSession();
        if (servletPath.contains("/manager/")) {
            staff = (StaffData) session.getAttribute("loggedInManager");
        } else if (servletPath.contains("/staff/")) {
            staff = (StaffData) session.getAttribute("loggedInStaff");
        }

        if (staff != null) {
            String fullname = request.getParameter("fullname");
            String email = request.getParameter("email");
            String contactNumber = request.getParameter("contactNumber");
            String address = request.getParameter("address");
            String gender = request.getParameter("gender");

            // Check for duplicate email and contact number
            StaffData existingEmail = staffDataDAO.findByEmail(email);
            StaffData existingContact = staffDataDAO.findByContactNumber(contactNumber);

            if ((existingEmail != null && !existingEmail.getStaffId().equals(staff.getStaffId()))
                    || (existingContact != null && !existingContact.getStaffId().equals(staff.getStaffId()))) {
                if (servletPath.contains("/manager/")) {
                    response.sendRedirect(contextPath + "/manager/ap_editProfile.jsp?error=duplicate");
                } else if (servletPath.contains("/staff/")) {
                    response.sendRedirect(contextPath + "/staff/ap_editProfile.jsp?error=duplicate");
                }
                return;
            }

            staff.setFullname(fullname);
            staff.setEmail(email);
            staff.setContactNumber(contactNumber);
            staff.setAddress(address);
            staff.setGender(gender);

            staffDataDAO.update(staff);
            if (servletPath.contains("/manager/")) {
                session.setAttribute("loggedInManager", staff);
            } else if (servletPath.contains("/staff/")) {
                session.setAttribute("loggedInStaff", staff);
            }

            if (servletPath.contains("/manager/")) {
                response.sendRedirect(contextPath + "/manager/ap_profile.jsp?success=true");
            } else if (servletPath.contains("/staff/")) {
                response.sendRedirect(contextPath + "/staff/ap_profile.jsp?success=true");
            }
        } else {
            response.sendRedirect(contextPath + "/staff/ap_login.jsp");
        }
    }
}
