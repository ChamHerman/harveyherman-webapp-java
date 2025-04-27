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
    
    @EJB
    private PromotionDAO promotionDAO;

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
        String promoCode = (String) session.getAttribute("appliedPromotionCode");
        Promotion promotion = null;
        if (promoCode != null) {
            promotion = promotionDAO.findByPromotionCode(promoCode);
        }
        Orders order = createOrder(null, user, cartTotal, paymentMethod, promotion);
        orderDAO.create(order);

        for (CartItem cartItem : cartItems) {
            OrderDetails detail = createOrderDetail(null, order, cartItem);
            orderDetailsDAO.create(detail);

            // Decrease stock
            Item item = cartItem.getItemId();
            int newStock = item.getStockQuantity() - cartItem.getQuantity();
            item.setStockQuantity(newStock);
            itemDAO.update(item);
            
            //clear cart
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

    private Orders createOrder(String orderId, UserData user, Double total, String paymentMethod, Promotion promotion) {
        Orders order = new Orders();
        order.setOrderId(orderId);
        order.setUserId(user);
        order.setTotalAmount(BigDecimal.valueOf(total));
        order.setPaymentMethod(paymentMethod);
        order.setStatus("packaging");
        order.setPromotionId(promotion);
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
