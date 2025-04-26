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

@WebServlet(name = "UserLogoutServlet", urlPatterns = {"/user/UserLogoutServlet"})
public class UserLogoutServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        if (session != null) {
            // Remove set session attributes when log out.
            session.removeAttribute("loggedInUserOrders");
            session.removeAttribute("orderDetailsMap");
            session.removeAttribute("orderDeliveryMap");
            session.removeAttribute("loggedInUser");
        }

        response.sendRedirect(request.getContextPath() + "/user/login.jsp");
    }
}
