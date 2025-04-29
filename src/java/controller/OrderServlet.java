/**
 *
 * @author kaibin
 */
package controller;

import javax.ejb.EJB;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.List;
import model.Orders;
import model.OrderDAO;

@WebServlet(name = "OrderServlet", urlPatterns = {"/manager/OrderServlet", "/staff/OrderServlet"})
public class OrderServlet extends HttpServlet {

    @EJB
    private OrderDAO orderDAO;
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            List<Orders> ordersList = orderDAO.getAllOrders();
            long totalOrders = orderDAO.getTotalOrderCount();
            long packagingCount = orderDAO.countOrdersByStatus("Packaging");
            long shippingCount = orderDAO.countOrdersByStatus("Shipping");
            long deliveryCount = orderDAO.countOrdersByStatus("Delivery");
            long deliveredCount = orderDAO.countOrdersByStatus("Delivered");

            //grouped counts:
            request.setAttribute("ordersList", ordersList);
            request.setAttribute("totalOrders", totalOrders);
            request.setAttribute("packagingCount", packagingCount);
            request.setAttribute("shippingCount", shippingCount);
            request.setAttribute("deliveryCount", deliveryCount);
            request.setAttribute("deliveredCount", deliveredCount);

            request.getRequestDispatcher("ap_order.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            throw new ServletException("Error loading orders", e);
        }
    }

}
