/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.math.BigDecimal;
import java.util.List;
import javax.ejb.EJB;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import model.Cart;
import model.CartDAO;
import model.CartItem;
import model.CartItemDAO;
import model.Promotion;

@WebServlet(name = "CartItemServlet", urlPatterns = {"/user/CartItemServlet"})
public class CartItemServlet extends HttpServlet {

    @EJB
    private CartItemDAO cartItemDAO;
    @EJB
    private CartDAO cartDAO;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        String cartItemId = request.getParameter("cartItemId");

        if ("update".equals(action)) {
            handleUpdate(request, response, cartItemId);
        } else if ("remove".equals(action)) {
            handleRemove(request, response, cartItemId);
        } else {
            response.setContentType("application/json");
            response.getWriter().write("{\"success\":false,\"message\":\"Invalid action.\"}");
        }

        if ("applyPromotion".equals(action)) {
            handleApplyPromotion(request, response);
            return;
        }
    }

    private void handleUpdate(HttpServletRequest request, HttpServletResponse response, String cartItemId)
            throws IOException {
        int change = Integer.parseInt(request.getParameter("change"));
        CartItem cartItem = cartItemDAO.findById(cartItemId);
        int newQuantity = cartItem.getQuantity() + change;
        if (newQuantity < 1) {
            newQuantity = 1;
        }

        cartItem.setQuantity(newQuantity);
        cartItem.setSubtotal(cartItem.getUnitPrice().multiply(BigDecimal.valueOf(newQuantity)));
        cartItemDAO.update(cartItem);

        updateCartTotalsAndRespond(response, cartItem);
    }

    private void handleRemove(HttpServletRequest request, HttpServletResponse response, String cartItemId)
            throws IOException {
        CartItem cartItem = cartItemDAO.findById(cartItemId);
        if (cartItem != null) {
            cartItemDAO.softDelete(cartItemId);
            updateCartTotalsAndRespond(response, cartItem);
        } else {
            response.setContentType("application/json");
            response.getWriter().write("{\"success\":false,\"message\":\"Item not found.\"}");
        }
    }

    private void updateCartTotalsAndRespond(HttpServletResponse response, CartItem cartItem) throws IOException {
        Cart cart = cartItem.getCartId();
        String cartId = cart.getCartId();
        List<CartItem> cartItems = cartItemDAO.getActiveCartItemsByCartId(cartId);

        double cartSubtotal = 0.0;
        for (CartItem item : cartItems) {
            cartSubtotal += item.getQuantity() * item.getUnitPrice().doubleValue();
        }
        double deliveryFee = 0.0;
        if (cartSubtotal >= 1000 || cartSubtotal == 0) {
            deliveryFee = 0.0;
        } else if (cartSubtotal < 1000) {
            deliveryFee = 25.0;
        }
        double cartTotal = cartSubtotal + deliveryFee;

        response.setContentType("application/json");
        response.getWriter().write("{"
                + "\"success\":true,"
                + "\"newQuantity\":" + cartItem.getQuantity() + ","
                + "\"newSubtotal\":" + cartItem.getSubtotal().doubleValue() + ","
                + "\"cartSubtotal\":" + cartSubtotal + ","
                + "\"deliveryFee\":" + deliveryFee + ","
                + "\"cartTotal\":" + cartTotal
                + "}");
    }

    private void handleApplyPromotion(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String promoCode = request.getParameter("promoCode");
        HttpSession session = request.getSession();
        String userId = (String) session.getAttribute("userId");

        // Get user's active cart and items
        Cart cart = cartDAO.getActiveCartByUserId(userId);
        List<CartItem> cartItems = cartItemDAO.getActiveCartItemsByCartId(cart.getCartId());

        double cartSubtotal = 0.0;
        for (CartItem item : cartItems) {
            cartSubtotal += item.getQuantity() * item.getUnitPrice().doubleValue();
        }

        double discount = 0.0;
        String message = "";
        boolean success = false;

        // Use CartDAO to find promotion
        Promotion promo = cartDAO.findPromotionByCode(promoCode);

        if (promo == null) {
            message = "Promotion code not found.";
        } else if (!"active".equals(promo.getStatus())) {
            message = "This promotion is not active.";
        } else {
            // Check date validity
            java.util.Date today = new java.util.Date();
            if ((promo.getStartDate() != null && today.before(promo.getStartDate()))
                    || (promo.getEndDate() != null && today.after(promo.getEndDate()))) {
                message = "This promotion is not valid at this time.";
            } else if (promo.getMinimumPurchase() != null && cartSubtotal < promo.getMinimumPurchase().doubleValue()) {
                message = "Minimum spend for this promotion is RM " + promo.getMinimumPurchase();
            } else {
                discount = promo.getDiscountValue().doubleValue();
                message = "Promotion applied! Discount: RM " + discount;
                success = true;
            }
        }

        // Delivery fee depends on subtotal (before discount)
        double deliveryFee = cartSubtotal >= 1000 ? 0.0 : 25.0;
        double cartTotal = cartSubtotal - discount + deliveryFee;

        response.setContentType("application/json");
        response.getWriter().write("{"
                + "\"success\":" + success + ","
                + "\"discount\":" + discount + ","
                + "\"cartSubtotal\":" + cartSubtotal + ","
                + "\"deliveryFee\":" + deliveryFee + ","
                + "\"cartTotal\":" + cartTotal + ","
                + "\"message\":\"" + message + "\""
                + "}");
    }

}