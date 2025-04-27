/**
 *
 * @author herman
 */
package controller;

import java.io.IOException;
import java.sql.Timestamp;
import javax.ejb.EJB;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import model.Delivery;
import model.DeliveryDAO;
import model.OrderDAO;
import model.Orders;

@WebServlet(name = "ConfirmDeliveryServlet", urlPatterns = {"/user/ConfirmDeliveryServlet"})
public class ConfirmDeliveryServlet extends HttpServlet {

    @EJB
    private DeliveryDAO deliveryDAO;
    @EJB
    private OrderDAO orderDAO;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String deliveryId = request.getParameter("deliveryId");
        if (deliveryId != null && !deliveryId.isEmpty()) {
            Delivery delivery = deliveryDAO.findByDeliveryId(deliveryId);
            if (delivery != null) {
                delivery.setDeliveredDate((Timestamp) new java.util.Date());
                deliveryDAO.update(delivery);
                
                // Update order status to 'delivered'
                Orders order = delivery.getOrderId();
                if (order != null) {
                    order.setStatus("delivered");
                    orderDAO.update(order);
                }
            }
        }
        response.sendRedirect("ViewUserOrdersServlet");
    }
}
