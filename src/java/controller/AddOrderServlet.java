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
import java.util.List;
import javax.ejb.EJB;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;

import controller.CustomIdGenerator;
import model.OrderDAO;
import model.Orders;
import javax.servlet.RequestDispatcher;
import javax.servlet.http.HttpSession;
import model.UserData;
import model.*;

/**
 *
 * @author user
 */
@WebServlet(name = "AddOrderServlet", urlPatterns = {"/manager/AddOrderServlet", "/staff/AddOrderServlet", "/user/AddOrderServlet"})
public class AddOrderServlet extends HttpServlet {

    @EJB
    private OrderDAO orderDAO;
    private static final long serialVersionUID = 1L;
    
    @EJB
    private CartDAO cartDAO;
    @EJB
    private CartItemDAO cartItemDAO;
    @EJB
    private PromotionDAO promotionDAO;


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
        
        HttpSession session = request.getSession(false);
        String userId = (String) session.getAttribute("userId");
        String promoCode = request.getParameter("promoCode");
        String paymentMethod = request.getParameter("paymentMethod");

        createOrderForUser(userId, promoCode, paymentMethod, request, response);
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
    
    private void createOrderForUser(String userId, String promoCode, String paymentMethod,
                                    HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Cart cart = cartDAO.getActiveCartByUserId(userId);
        List<CartItem> cartItems = cartItemDAO.getActiveCartItemsByCartId(cart.getCartId());

        BigDecimal subtotal = BigDecimal.ZERO;
        for (CartItem item : cartItems) {
            BigDecimal quantity = BigDecimal.valueOf(item.getQuantity());
            subtotal = subtotal.add(item.getUnitPrice().multiply(quantity));
        }

        BigDecimal deliveryFee = subtotal.compareTo(new BigDecimal("1000")) > 0 ? BigDecimal.ZERO : new BigDecimal("25");

        String promotionId = null;
        BigDecimal discount = BigDecimal.ZERO;
//        if (promoCode != null && !promoCode.isEmpty()) {
//            Promotion promotion = promotionDAO.findByPromotionCode(promoCode);
//            if (promotion != null && "active".equals(promotion.getStatus()) &&
//                (promotion.getMinimumPurchase() == null || subtotal.compareTo(promotion.getMinimumPurchase()) >= 0)) {
//                discount = promotion.getDiscountValue();
//                promotionId = promotion.getPromotionId();
//            }
//        }

        BigDecimal totalAmount = subtotal.add(deliveryFee).subtract(discount);
        


        Orders order = new Orders();
        order.setUserId(new model.UserData(userId));
        order.setTotalAmount(totalAmount);
        order.setPaymentMethod(paymentMethod);
        order.setStatus("pending");
        order.setPromotionId(new model.Promotion(promotionId));
        order.setCreatedDate(new Timestamp(System.currentTimeMillis()));
        order.setDbstatus("active");

        orderDAO.create(order);

        // ... handle order details, clear cart, etc. ...

        response.sendRedirect("/user/thankyou.html");
    }
}