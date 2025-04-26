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
import model.OrderDAO;
import model.Orders;
import javax.servlet.http.HttpSession;
import model.UserData;
import model.*;

/**
 *
 * @author user
 */
@WebServlet(name = "AddOrderServlet", urlPatterns = {"/user/AddOrderServlet"})
public class AddOrderServlet extends HttpServlet {

    @EJB
    private OrderDAO orderDAO;
    private static final long serialVersionUID = 1L;

    @EJB
    private CartItemDAO cartItemDAO;

    @EJB
    private ItemDAO itemDAO;

    @EJB
    private OrderDetailsDAO orderDetailsDAO;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loggedInUser") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        UserData user = (UserData) session.getAttribute("loggedInUser");
        Cart cart = (Cart) session.getAttribute("cart");
        List<CartItem> cartItems = (List<CartItem>) session.getAttribute("cartItems");
        Double cartTotal = (Double) session.getAttribute("cartTotal");
        String paymentMethod = request.getParameter("paymentMethod");
        String promotionId = null;

        // If card, validate details (already done by HTML, but double-check)
        if ("debit_card".equals(paymentMethod) || "credit_card".equals(paymentMethod)) {
            String cardNumber = request.getParameter("cardNumber");
            String expiryDate = request.getParameter("expiryDate");
            String cvv = request.getParameter("cvv");
            if (!cardNumber.matches("\\d{16}") || !expiryDate.matches("\\d{2}/\\d{2}") || !cvv.matches("\\d{3}")) {
                request.setAttribute("error", "Invalid card details.");
                request.getRequestDispatcher("checkout.jsp").forward(request, response);
                return;
            }
        }

        Orders order = createOrder(null, user, cartTotal, paymentMethod, promotionId);
        orderDAO.create(order);

        for (CartItem cartItem : cartItems) {
            OrderDetails detail = createOrderDetail(null, order, cartItem);
            orderDetailsDAO.create(detail);

            // Decrease stock
            Item item = cartItem.getItemId();
            int newStock = item.getStockQuantity() - cartItem.getQuantity();
            item.setStockQuantity(newStock);
            itemDAO.update(item);
            
            cartItemDAO.softDelete(cartItem.getCartItemId());
        }

        session.removeAttribute("cart");
        session.removeAttribute("cartItems");
        session.removeAttribute("cartSubtotal");
        session.removeAttribute("deliveryFee");
        session.removeAttribute("discount");
        session.removeAttribute("cartTotal");

        response.sendRedirect("thankyou.jsp");
    }

    private Orders createOrder(String orderId, UserData user, Double total, String paymentMethod, String promotionId) {
        Orders order = new Orders();
        order.setOrderId(orderId);
        order.setUserId(user);
        order.setTotalAmount(BigDecimal.valueOf(total));
        order.setPaymentMethod(paymentMethod);
        order.setStatus("packaging");
//        order.setPromotionId(Promotion.getPromotionId);
        order.setCreatedDate(new Timestamp(System.currentTimeMillis()));
        order.setDbstatus("active");
        return order;
    }

    private OrderDetails createOrderDetail(String detailId, Orders order, CartItem cartItem) {
        OrderDetails detail = new OrderDetails();
        detail.setDetailId(detailId);
        detail.setOrderId(order);
        detail.setItemId(cartItem.getItemId());
        detail.setQuantity(cartItem.getQuantity());
        detail.setPricePerItem(cartItem.getUnitPrice());
        detail.setDbstatus("active");
        return detail;
    }

}
