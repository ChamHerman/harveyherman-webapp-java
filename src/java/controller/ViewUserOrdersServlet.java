/**
 *
 * @author herman
 */
package controller;

import java.io.IOException;
import java.util.List;
import javax.ejb.EJB;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import model.OrderDAO;
import model.Orders;
import model.UserData;

@WebServlet(name = "ViewUserOrdersServlet", urlPatterns = {"/user/ViewUserOrdersServlet"})
public class ViewUserOrdersServlet extends HttpServlet {
    @EJB
    private OrderDAO orderDAO;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loggedInUser") == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        session.removeAttribute("loggedInUserOrders");
        UserData user = (UserData) session.getAttribute("loggedInUser");
        String userId = user.getUserId();
        List<Orders> orders = orderDAO.getOrdersByUserId(userId);
        session.setAttribute("loggedInUserOrders", orders);
        response.sendRedirect("viewOrders.jsp");
    }
}
