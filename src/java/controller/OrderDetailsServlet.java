/**
 *
 * @author kaibin
 */
package controller;

import java.io.IOException;
import java.util.List;
import javax.ejb.EJB;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import model.OrderDAO;
import model.OrderDetails;
import model.OrderDetailsDAO;
import model.Orders;

@WebServlet(name = "OrderDetailsServlet", urlPatterns = {"/manager/OrderDetailsServlet", "/staff/OrderDetailsServlet"})
public class OrderDetailsServlet extends HttpServlet {

    @EJB
    private OrderDAO orderDAO;
    @EJB
    private OrderDetailsDAO orderDetailsDAO;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String orderId = request.getParameter("orderId");
        Orders order = orderDAO.selectOrder(orderId);
        List<OrderDetails> details = orderDetailsDAO.getByOrderId(orderId);

        // Calculate subtotal
        double subtotal = 0.0;
        for (OrderDetails d : details) {
            subtotal += d.getQuantity() * d.getPricePerItem().doubleValue();
        }
        double discount = 0.0; // Not implemented yet
        double delivery = 0.0;

        if (subtotal >= 1000) {
            delivery = 0.0;
        } else {
            delivery = 25.0;
        }

        response.setContentType("application/json");
        StringBuilder stb = new StringBuilder();
        stb.append("{");
        stb.append(String.format("\"orderId\":\"%s\",", order.getOrderId()));
        stb.append(String.format("\"userId\":\"%s\",", order.getUserId().getUserId()));
        stb.append(String.format("\"status\":\"%s\",", order.getStatus()));
        stb.append(String.format("\"paymentMethod\":\"%s\",", order.getPaymentMethod()));
        stb.append(String.format("\"createdDate\":\"%s\",", new java.text.SimpleDateFormat("dd/MM/yyyy").format(order.getCreatedDate())));
        stb.append(String.format("\"totalAmount\":%.2f,", order.getTotalAmount()));
        stb.append(String.format("\"subtotal\":%.2f,", subtotal));
        stb.append(String.format("\"discount\":%.2f,", discount));
        stb.append(String.format("\"delivery\":%.2f,", delivery));
        stb.append("\"orderDetails\":[");
        for (int i = 0; i < details.size(); i++) {
            OrderDetails d = details.get(i);
            stb.append(String.format("{\"itemId\":\"%s\",\"itemName\":\"%s\",\"quantity\":%d,\"pricePerItem\":%.2f}",
                    d.getItemId().getItemId(),
                    d.getItemId().getName().replace("\"", "\\\""),
                    d.getQuantity(), d.getPricePerItem()));
            if (i < details.size() - 1) {
                stb.append(",");
            }
        }
        stb.append("]");
        stb.append("}");
        response.getWriter().print(stb.toString());
    }
}
