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
@WebServlet(name = "AddOrderServlet", urlPatterns = {"/AddOrderServlet"})
public class AddOrderServlet extends HttpServlet {

    @EJB
    private OrderDAO orderDAO;
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("new".equals(action)) {
            // Forward request to order form page
            RequestDispatcher dispatcher = request.getRequestDispatcher("ap_orderform.jsp");
            dispatcher.forward(request, response);
        } else {
            // You could handle listing or redirection here
            response.sendRedirect("OrderServlet");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String userId = request.getParameter("userId");
            String totalAmountStr = request.getParameter("totalAmount");
            String paymentMethod = request.getParameter("paymentMethod");
            String status = request.getParameter("status");
            String promotionId = request.getParameter("promotionId");
            String createdDateParam = request.getParameter("createdDate");

            if (!createdDateParam.contains(" ")) {
             createdDateParam += " 00:00:00";
            }
            Timestamp createdDate = Timestamp.valueOf(createdDateParam);

            BigDecimal totalAmount = new BigDecimal(totalAmountStr);

            // Create a new order (adjust field population as needed)
            Orders newOrder = new Orders();
            newOrder.setUserId(new model.UserData(userId)); // assuming proper UserData instance creation
            newOrder.setTotalAmount(totalAmount);
            newOrder.setPaymentMethod(paymentMethod);
            newOrder.setStatus(status);
            newOrder.setCreatedDate(createdDate);

            orderDAO.create(newOrder);

        } catch (Exception ex) {
            ex.printStackTrace();
            throw new ServletException("Error adding order", ex);
        }
        response.sendRedirect("OrderServlet");
    }

}
