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
protected void doGet(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
    String orderId = request.getParameter("orderId");
    if (orderId == null || orderId.trim().isEmpty()) {
        request.setAttribute("error", "Order ID is missing.");
        request.getRequestDispatcher("ap_edit_order.jsp").forward(request, response);
        return;
    }
    Orders order = orderDAO.selectOrder(orderId);
    if (order == null) {
        request.setAttribute("error", "Order not found.");
        request.getRequestDispatcher("ap_edit_order.jsp").forward(request, response);
        return;
    }
    request.setAttribute("order", order);
    request.getRequestDispatcher("ap_edit_order.jsp").forward(request, response);
}

    @Override
protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
    try {
        String orderId = request.getParameter("orderId");
        String userId = request.getParameter("userId");
        String paymentMethod = request.getParameter("paymentMethod");
        String status = request.getParameter("status");

        Orders order = orderDAO.selectOrder(orderId);
        if (order == null) {
            request.setAttribute("error", "Order not found.");
            request.getRequestDispatcher("ap_edit_order.jsp").forward(request, response);
            return;
        }

        // Validate userId format
        if (userId == null || !userId.matches("U\\d{3}")) {
            request.setAttribute("error", "Invalid information");
            request.setAttribute("order", order); // Always set the order!
            request.getRequestDispatcher("ap_edit_order.jsp").forward(request, response);
            return;
        }

        // Update only allowed fields
        model.UserData user = new model.UserData();
        user.setUserId(userId);
        order.setUserId(user);
        order.setPaymentMethod(paymentMethod);
        order.setStatus(status);

        orderDAO.update(order);

        response.sendRedirect("OrderServlet");
    } catch (Exception ex) {
        ex.printStackTrace();
        request.setAttribute("error", "Invalid information");
        // You may want to reload the order here as well
        String orderId = request.getParameter("orderId");
        Orders order = orderDAO.selectOrder(orderId);
        request.setAttribute("order", order);
        request.getRequestDispatcher("ap_edit_order.jsp").forward(request, response);
    }
}
}
