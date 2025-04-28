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
import model.OrderDAO;
import model.Orders;
import model.OrderDetailsDAO;
import model.OrderDetails;
import java.util.List;
import javax.servlet.http.HttpSession;

@WebServlet(name = "DeleteOrderServlet", urlPatterns = {"/manager/DeleteOrderServlet", "/staff/DeleteOrderServlet"})
public class DeleteOrderServlet extends HttpServlet {

    @EJB
    private OrderDAO orderDAO;
    @EJB
    private OrderDetailsDAO orderDetailsDAO;
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String orderId = request.getParameter("orderId");
        if (orderId != null && !orderId.trim().isEmpty()) {
            // Delete all order details for this order
            List<OrderDetails> details = orderDetailsDAO.getByOrderId(orderId);
            for (OrderDetails detail : details) {
                orderDetailsDAO.delete(detail.getDetailId());
            }
            // Now delete the order
            orderDAO.delete(orderId);
        }

        HttpSession session = request.getSession();
        String statusFilter = (String) session.getAttribute("orderStatusFilter");
        List<Orders> filteredOrders;
        if (statusFilter == null || statusFilter.isEmpty()) {
            filteredOrders = orderDAO.getAllOrders();
        } else {
            filteredOrders = orderDAO.filterOrderByStatus(statusFilter);
        }
        session.setAttribute("filteredOrders", filteredOrders);

        // Redirect back to the order listing page (e.g., OrderServlet)
        response.sendRedirect("OrderServlet");
    }

}
