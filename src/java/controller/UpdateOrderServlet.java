/**
 *
 * @author kaibin
 */
package controller;

import java.io.IOException;
import javax.ejb.EJB;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
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
        // Redirect back to the order management page
        String servletPath = request.getServletPath();
        if (servletPath.contains("/manager/")) {
            response.sendRedirect(request.getContextPath() + "/manager/ap_order.jsp");
        } else if (servletPath.contains("/staff/")) {
            response.sendRedirect(request.getContextPath() + "/staff/ap_order.jsp");
        }
    }
}
