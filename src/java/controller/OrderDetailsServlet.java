/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.List;
import javax.ejb.EJB;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import model.OrderDAO;
import model.OrderDetails;
import model.OrderDetailsDAO;
import model.Orders;

/**
 *
 * @author user
 */
@WebServlet(name = "OrderDetailsServlet", urlPatterns = {"/manager/OrderDetailsServlet", "/staff/OrderDetailsServlet"})
public class OrderDetailsServlet extends HttpServlet {
    @EJB
    private OrderDAO orderDAO;
    @EJB
    private OrderDetailsDAO orderDetailsDAO;

 
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String orderId = request.getParameter("orderId");
        Orders order = orderDAO.selectOrder(orderId);
        List<OrderDetails> details = orderDetailsDAO.getByOrderId(orderId);

        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        out.print("{");
        out.printf("\"orderId\":\"%s\",", order.getOrderId());
        out.printf("\"userId\":\"%s\",", order.getUserId().getUserId());
        out.printf("\"status\":\"%s\",", order.getStatus());
        out.printf("\"paymentMethod\":\"%s\",", order.getPaymentMethod());
        out.printf("\"createdDate\":\"%s\",", new java.text.SimpleDateFormat("dd/MM/yyyy").format(order.getCreatedDate()));
        out.printf("\"totalAmount\":%.2f,", order.getTotalAmount());
        out.print("\"orderDetails\":[");
        for (int i = 0; i < details.size(); i++) {
            OrderDetails d = details.get(i);
            out.printf("{\"itemId\":\"%s\",\"quantity\":%d,\"pricePerItem\":%.2f}",
                d.getItemId().getItemId(), d.getQuantity(), d.getPricePerItem());
            if (i < details.size() - 1) out.print(",");
        }
        out.print("]");
        out.print("}");

    }
}
