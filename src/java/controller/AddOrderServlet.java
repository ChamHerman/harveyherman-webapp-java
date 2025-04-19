/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import java.io.IOException;
import java.math.BigDecimal;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.sql.Timestamp;
import javax.ejb.EJB;


import model.OrderDAO;
import model.Orders;
import javax.servlet.RequestDispatcher;
import model.UserData;

/**
 *
 * @author user
 */
@WebServlet(name = "AddOrderServlet", urlPatterns = {"/manager/AddOrderServlet", "/staff/AddOrderServlet"})
public class AddOrderServlet extends HttpServlet {

    @EJB
    private OrderDAO orderDAO;
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            Orders newOrder = buildOrderFromRequest(request);
            orderDAO.create(newOrder);
            response.sendRedirect("OrderServlet");
        } catch (Exception ex) {
            ex.printStackTrace(); // For debugging, check your server log!
            request.setAttribute("error", "Failed to add order. Please check your input.");
            request.getRequestDispatcher("ap_order.jsp").forward(request, response);
        }
    }
    
    private Orders buildOrderFromRequest(HttpServletRequest request) {
         String userId = request.getParameter("userId");
        String totalAmountStr = request.getParameter("totalAmount");
        String paymentMethod = request.getParameter("paymentMethod");
        String status = request.getParameter("status");
        String promotionId = request.getParameter("promotionId");

        Orders newOrder = new Orders();
        newOrder.setUserId(new model.UserData(userId)); // Just set the ID, let JPA handle FK
        newOrder.setTotalAmount(new java.math.BigDecimal(totalAmountStr));
        newOrder.setPaymentMethod(paymentMethod);
        newOrder.setStatus(status);
        newOrder.setCreatedDate(new java.sql.Timestamp(System.currentTimeMillis()));
        if (promotionId != null && !promotionId.trim().isEmpty()) {
            newOrder.setPromotionId(new model.Promotion(promotionId));
        }
        newOrder.setDbstatus("active");
        return newOrder;
    }

}
