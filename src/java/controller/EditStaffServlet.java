package controller;

import java.io.IOException;
import java.util.Date;
import javax.ejb.EJB;
import javax.servlet.RequestDispatcher;
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
        String errorMessage = null;
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

            if (fullname == null || fullname.trim().isEmpty()
                    || email == null || email.trim().isEmpty()
                    || contactNumber == null || contactNumber.trim().isEmpty()
                    || address == null || address.trim().isEmpty()
                    || gender == null || gender.trim().isEmpty()) {
                errorMessage = "All fields should be completed";
            } else if (fullname.length() >= 255) {
                errorMessage = "Full name must be less than 255 characters.";
            } else if (email.length() >= 255) {
                errorMessage = "Email must be less than 255 characters.";
            } else if (address.length() >= 1000) {
                errorMessage = "Address must be less than 1000 characters.";
            } else if (!email.matches("^[a-z0-9@._+\\-]+$") || !email.matches("^[a-z0-9._+\\-]+@[a-z0-9._+\\-]+\\.[a-z]{2,}$")) {
                errorMessage = "Invalid email format.";
            } else if (!contactNumber.matches("^60\\d{9,10}$")) {
                errorMessage = "Contact number must start with 60 and be 11 or 12 digits long.";
            } else {
                StaffData existingEmail = staffDataDAO.findByEmail(email);
                StaffData existingContact = staffDataDAO.findByContactNumber(contactNumber);
                if ((existingEmail != null && !existingEmail.getStaffId().equals(staff.getStaffId()))) {
                    errorMessage = "Email address is already in use by another staff.";
                } else if ((existingContact != null && !existingContact.getStaffId().equals(staff.getStaffId()))) {
                    errorMessage = "Contact number is already in use by another staff.";
                }
            }

            if (errorMessage != null) {
                request.setAttribute("error", errorMessage);
                if (servletPath.contains("/manager/")) {
                    RequestDispatcher dispatcher = request.getRequestDispatcher("/manager/ap_editProfile.jsp");
                    dispatcher.forward(request, response);
                } else if (servletPath.contains("/staff/")) {
                    RequestDispatcher dispatcher = request.getRequestDispatcher("/staff/ap_editProfile.jsp");
                    dispatcher.forward(request, response);
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
                response.sendRedirect(contextPath + "/manager/ap_profile.jsp?success=edit");
            } else if (servletPath.contains("/staff/")) {
                response.sendRedirect(contextPath + "/staff/ap_profile.jsp?success=edit");
            }
        } else {
            response.sendRedirect(contextPath + "/staff/ap_login.jsp");
        }
    }
}
