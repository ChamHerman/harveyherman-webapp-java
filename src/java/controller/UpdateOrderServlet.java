/**
 *
 * @author kaibin
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
import model.Orders;
import model.OrderDAO;

@WebServlet(name = "UpdateOrderServlet", urlPatterns = {"/manager/UpdateOrderServlet", "/staff/UpdateOrderServlet"})
public class UpdateOrderServlet extends HttpServlet {

    @EJB
    private OrderDAO orderDAO;
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String orderId = request.getParameter("orderId");
        String newStatus = request.getParameter("status");

        if (orderId != null && newStatus != null) {
            Orders order = orderDAO.selectOrder(orderId);
            if (order != null) {
                order.setStatus(newStatus.toLowerCase());
                orderDAO.update(order);
            }
        }

        HttpSession session = request.getSession();
        // Get the current filter from session
        String statusFilter = (String) session.getAttribute("orderStatusFilter");

        // Update the filteredOrders session attribute
        List<Orders> filteredOrders;
        if (statusFilter == null || statusFilter.isEmpty()) {
            filteredOrders = orderDAO.getAllOrders();
        } else {
            filteredOrders = orderDAO.filterOrderByStatus(statusFilter);
        }
        session.setAttribute("filteredOrders", filteredOrders);

        // Redirect back to the order management page
        String servletPath = request.getServletPath();
        if (servletPath.contains("/manager/")) {
            response.sendRedirect(request.getContextPath() + "/manager/ap_order.jsp");
        } else if (servletPath.contains("/staff/")) {
            response.sendRedirect(request.getContextPath() + "/staff/ap_order.jsp");
        }
    }
}
