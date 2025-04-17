/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import javax.ejb.EJB;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import model.OrderDAO;
import model.Orders;

/**
 *
 * @author user
 */
@WebServlet(name = "FilterOrderServlet", urlPatterns = {"/FilterOrderServlet"})
public class FilterOrderServlet extends HttpServlet {

    @EJB
    private OrderDAO orderDAO;
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String status = request.getParameter("status");
        List<Orders> orders = orderDAO.getFilteredOrders(null, status);

        response.setContentType("application/json");
        response.getWriter().write(ordersToJson(orders));
    }

    private String ordersToJson(List<Orders> orders) {
        StringBuilder json = new StringBuilder("[");
        for (Orders order : orders) {
            json.append("{")
                    .append("\"orderId\":\"").append(order.getOrderId()).append("\",")
                    .append("\"user\":\"").append(order.getUserId() != null ? order.getUserId().getFullname() : "N/A").append("\",")
                    .append("\"totalAmount\":").append(order.getTotalAmount()).append(",")
                    .append("\"status\":\"").append(order.getStatus()).append("\",")
                    .append("\"createdDate\":\"").append(order.getCreatedDate()).append("\"")
                    .append("},");
        }
        if (!orders.isEmpty()) {
            json.setLength(json.length() - 1);
        }
        json.append("]");
        return json.toString();
    }
}
