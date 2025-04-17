/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import model.OrderDAO;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Timestamp;
import javax.ejb.EJB;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import model.UserData;
import model.Orders;
import model.OrderDAO;

/**
 *
 * @author user
 */
@WebServlet(name = "UpdateOrderServlet", urlPatterns = {"/UpdateOrderServlet"})
public class UpdateOrderServlet extends HttpServlet {

    @EJB
    private OrderDAO orderDAO;
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String orderId = request.getParameter("orderId");
        Orders existingOrder = orderDAO.selectOrder(orderId);
        request.setAttribute("order", existingOrder);
        RequestDispatcher dispatcher = request.getRequestDispatcher("ap_editOrder.jsp");
        dispatcher.forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Get parameters from the form
            String orderId = request.getParameter("orderId");
            String userId = request.getParameter("userId"); // Optional based on your form
            String totalAmountStr = request.getParameter("totalAmount");
            String paymentMethod = request.getParameter("paymentMethod");
            String status = request.getParameter("status");
            String promotionId = request.getParameter("promotionId");
            String createdDateStr = request.getParameter("createdDate");

            // Convert parameters to proper types
            BigDecimal totalAmount = new BigDecimal(totalAmountStr);
            java.sql.Date createdDate = java.sql.Date.valueOf(createdDateStr);

            // Get the existing order from DB
            Orders order = orderDAO.selectOrder(orderId);
            if (order == null) {
                request.setAttribute("error", "Order not found.");
                request.getRequestDispatcher("ap_order.jsp").forward(request, response);
                return;
            }

            // Update the order fields
            if (userId != null && !userId.isEmpty()) {
                UserData user = new UserData();
                user.setUserId(userId);
                order.setUserId(user);
            }

            order.setTotalAmount(totalAmount);
            order.setPaymentMethod(paymentMethod);
            order.setStatus(status);
            order.setCreatedDate(createdDate);
            order.setPromotionId(promotionId != null && !promotionId.trim().isEmpty() ? promotionId : null);

            // Save to DB
            orderDAO.update(order);

            // Redirect back to order list
            response.sendRedirect("OrderServlet");

        } catch (Exception ex) {
            ex.printStackTrace();
            request.setAttribute("error", "An error occurred while updating the order.");
            request.getRequestDispatcher("ap_order.jsp").forward(request, response);
        }
    }
}
