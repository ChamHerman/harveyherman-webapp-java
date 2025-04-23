/**
 *
 * @author weikang
 */
package controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "StaffLogoutServlet", urlPatterns = {"/manager/StaffLogoutServlet", "/staff/StaffLogoutServlet"})
public class StaffLogoutServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        if (session != null) {
            session.removeAttribute("loggedInManager");
            session.removeAttribute("loggedInStaff");
        }

        response.sendRedirect(request.getContextPath() + "/staff/ap_login.jsp");
    }
}
