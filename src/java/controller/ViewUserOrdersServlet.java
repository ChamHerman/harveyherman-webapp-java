/**
 *
 * @author herman
 */
package controller;

import java.io.IOException;
import java.util.List;
import java.util.HashMap;
import java.util.Map;
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
import model.DeliveryDAO;
import model.Delivery;
import model.OrderDetails;
import model.OrderDetailsDAO;

@WebServlet(name = "ViewUserOrdersServlet", urlPatterns = {"/user/ViewUserOrdersServlet"})
public class ViewUserOrdersServlet extends HttpServlet {

    @EJB
    private OrderDAO orderDAO;
    @EJB
    private DeliveryDAO deliveryDAO;
    @EJB
    private OrderDetailsDAO orderDetailsDAO;
    

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loggedInUser") == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        UserData user = (UserData) session.getAttribute("loggedInUser");
        String userId = user.getUserId();
        List<Orders> orders = orderDAO.getOrdersByUserId(userId);

        // Fetch order details(items) for each order, put in a map
        Map<String, List<OrderDetails>> orderDetailsMap = new HashMap<>();
        for (Orders order : orders) {
            List<OrderDetails> details = orderDetailsDAO.getByOrderId(order.getOrderId());
            orderDetailsMap.put(order.getOrderId(), details);
        }

        // Fetch delivery for each order, put in a map
        Map<String, Delivery> orderDeliveryMap = new HashMap<>();
        for (Orders order : orders) {
            List<Delivery> deliveries = deliveryDAO.getDeliveriesByOrderId(order.getOrderId());
            if (deliveries != null && !deliveries.isEmpty()) {
                orderDeliveryMap.put(order.getOrderId(), deliveries.get(0)); // One delivery per order
            }
        }

        session.setAttribute("loggedInUserOrders", orders);
        session.setAttribute("orderDetailsMap", orderDetailsMap);
        session.setAttribute("orderDeliveryMap", orderDeliveryMap);
        response.sendRedirect("viewOrders.jsp");
    }
}
