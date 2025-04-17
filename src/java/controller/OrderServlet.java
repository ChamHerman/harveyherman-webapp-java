/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
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

/**
 *
 * @author user
 */
@WebServlet(name = "OrderServlet", urlPatterns = {"/OrderServlet"})
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
            long pendingCount = orderDAO.countOrdersByStatus("Pending");
            long packagingCount = orderDAO.countOrdersByStatus("Packaging");
            long shippingCount = orderDAO.countOrdersByStatus("Shipping");
            long deliveredCount = orderDAO.countOrdersByStatus("Delivered");

            // Optionally, if you want grouped counts:
            List<Object[]> statusCounts = orderDAO.countOrdersGroupedByStatus();

            request.setAttribute("ordersList", ordersList);
            request.setAttribute("totalOrders", totalOrders);
            request.setAttribute("pendingCount", pendingCount);
            request.setAttribute("packagingCount", packagingCount);
            request.setAttribute("shippingCount", shippingCount);
            request.setAttribute("deliveredCount", deliveredCount);
            request.setAttribute("statusCounts", statusCounts);

            request.getRequestDispatcher("ap_order.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            throw new ServletException("Error loading orders", e);
        }
    }

}
