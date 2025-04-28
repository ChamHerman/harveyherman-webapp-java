/**
 *
 * @author kaibin
 */
package controller;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Timestamp;
import java.util.List;
import javax.ejb.EJB;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import model.*;

@WebServlet(name = "CartServlet", urlPatterns = {"/user/CartServlet"})
public class CartServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    @EJB
    private CartDAO cartDAO;
    @EJB
    private CartItemDAO cartItemDAO;
    @EJB
    private ItemDAO itemDAO;
    @EJB
    private PromotionDAO promotionDAO;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loggedInUser") == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        UserData userData = (UserData) session.getAttribute("loggedInUser");
        String userId = userData.getUserId();
        Cart cart = cartDAO.getActiveCartByUserId(userId);
        List<CartItem> cartItems = (cart != null) ? cartItemDAO.getActiveCartItemsByCartId(cart.getCartId()) : null;
        double cartSubtotal = 0.0;
        if (cartItems != null) {
            for (CartItem item : cartItems) {
                cartSubtotal += item.getQuantity() * item.getUnitPrice().doubleValue();
            }
        }
        double deliveryFee = (cartSubtotal >= 1000 || cartSubtotal == 0) ? 0.0 : 25.0;
        double discount = 0.0;
        double cartTotal = cartSubtotal + deliveryFee - discount;
        session.setAttribute("cartSubtotal", cartSubtotal);
        session.setAttribute("deliveryFee", deliveryFee);
        session.setAttribute("discount", discount);
        session.setAttribute("cartTotal", cartTotal);
        session.setAttribute("cartItems", cartItems);
        session.setAttribute("cart", cart);
        response.sendRedirect("cart.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        if (session.getAttribute("loggedInUser") == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        String action = request.getParameter("action");
        if ("applyPromotion".equals(action)) {
            handleApplyPromotion(request, response);
            return;
        }
        UserData userData = (UserData) session.getAttribute("loggedInUser");
        String userId = userData.getUserId();
        String itemId = request.getParameter("itemId");
        int quantity = Integer.parseInt(request.getParameter("quantity"));

        Item item = itemDAO.getItemById(itemId);
        int stock = item.getStockQuantity();
        Cart cart = cartDAO.getActiveCartByUserId(userId);
        CartItem cartItem = cartItemDAO.getAnyCartItem(cart.getCartId(), itemId); // get any status
        int cartQuantity = (cartItem != null && "active".equalsIgnoreCase(cartItem.getDbstatus())) ? cartItem.getQuantity() : 0;
        int totalQuantity = cartQuantity + quantity;
        if (totalQuantity > stock) {
            request.setAttribute("error", "Cannot add to cart: total quantity exceeds available stock (" + stock + ").");
            request.setAttribute("item", item);
            request.getRequestDispatcher("itemDetails.jsp").forward(request, response);
            return;
        }
        if (cartItem == null) {
            // New cart item
            cartItem = new CartItem();
            cartItem.setCartItemId(null);
            cartItem.setCartId(cart);
            cartItem.setItemId(item);
            cartItem.setQuantity(quantity);
            cartItem.setUnitPrice(item.getPrice());
            cartItem.setSubtotal(item.getPrice().multiply(BigDecimal.valueOf(quantity)));
            cartItem.setDbstatus("active");
            cartItemDAO.create(cartItem);
        } else if ("active".equalsIgnoreCase(cartItem.getDbstatus())) {
            // Already in cart and active: add to existing quantity
            cartItem.setQuantity(cartItem.getQuantity() + quantity);
            cartItem.setSubtotal(item.getPrice().multiply(BigDecimal.valueOf(cartItem.getQuantity())));
            cartItemDAO.update(cartItem);
        } else {
            // Was deleted: reactivate and replace quantity
            cartItem.setDbstatus("active");
            cartItem.setQuantity(quantity); // replace with new one
            cartItem.setUnitPrice(item.getPrice());
            cartItem.setSubtotal(item.getPrice().multiply(BigDecimal.valueOf(quantity)));
            cartItemDAO.update(cartItem);
        }
        updateCartTotal(cart, cartItemDAO);
        response.sendRedirect(request.getContextPath() + "/user/CartServlet");
    }

    private void updateCartTotal(Cart cart, CartItemDAO cartItemDAO) {
        List<CartItem> cartItems = cartItemDAO.getActiveCartItemsByCartId(cart.getCartId());
        BigDecimal cartTotal = BigDecimal.ZERO;
        for (CartItem ci : cartItems) {
            cartTotal = cartTotal.add(ci.getSubtotal());
        }
        cart.setTotal(cartTotal);
        cartDAO.update(cart);
    }

    private void handleApplyPromotion(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession();
        String userId = ((model.UserData) session.getAttribute("loggedInUser")).getUserId();
        String promoCode = request.getParameter("promoCode");
        Cart cart = cartDAO.getActiveCartByUserId(userId);
        List<CartItem> cartItems = cartItemDAO.getActiveCartItemsByCartId(cart.getCartId());
        double cartSubtotal = 0.0;
        for (CartItem item : cartItems) {
            cartSubtotal += item.getQuantity() * item.getUnitPrice().doubleValue();
        }
        double discount = 0.0;
        String message = "";
        boolean success = false;
        Promotion promo = promotionDAO.findByPromotionCode(promoCode);
        if (promo == null) {
            message = "Promotion code not found.";
        } else if (!"active".equalsIgnoreCase(promo.getStatus())) {
            message = "This promotion is not active.";
        } else {
            java.util.Date today = new java.util.Date();
            if ((promo.getStartDate() != null && today.before(promo.getStartDate()))
                    || (promo.getEndDate() != null && today.after(promo.getEndDate()))) {
                message = "This promotion is not valid at this time.";
            } else if (promo.getMinimumPurchase() != null && cartSubtotal < promo.getMinimumPurchase().doubleValue()) {
                message = "Minimum spend for this promotion is RM " + promo.getMinimumPurchase();
            } else {
                discount = cartSubtotal * (promo.getDiscountValue().doubleValue() / 100.0);
                message = "Promotion applied! Discount: " + promo.getDiscountValue().doubleValue() + "%";
                success = true;
                session.setAttribute("appliedPromotionCode", promo.getPromotionCode());
            }
        }
        double deliveryFee = cartSubtotal >= 1000 ? 0.0 : 25.0;
        double cartTotal = cartSubtotal - discount + deliveryFee;
        session.setAttribute("discount", discount);
        session.setAttribute("cartSubtotal", cartSubtotal);
        session.setAttribute("deliveryFee", deliveryFee);
        session.setAttribute("cartTotal", cartTotal);
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
