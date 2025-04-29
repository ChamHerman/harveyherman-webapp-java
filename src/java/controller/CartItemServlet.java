/**
 *
 * @author kaibin
 */
package controller;

import java.io.IOException;
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
import model.PromotionDAO;

@WebServlet(name = "CartItemServlet", urlPatterns = {"/user/CartItemServlet"})
public class CartItemServlet extends HttpServlet {

    @EJB
    private CartItemDAO cartItemDAO;
    @EJB
    private CartDAO cartDAO;
    @EJB
    private PromotionDAO promotionDAO;

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


    }

    //increase or decrease item
    private void handleUpdate(HttpServletRequest request, HttpServletResponse response, String cartItemId)
            throws IOException {
        int change = Integer.parseInt(request.getParameter("change"));
        CartItem cartItem = cartItemDAO.findById(cartItemId);
        int newQuantity = cartItem.getQuantity() + change;
        //valid quantity cannot less than 1
        if (newQuantity < 1) {
            newQuantity = 1;
        }

        cartItem.setQuantity(newQuantity);
        cartItem.setSubtotal(cartItem.getUnitPrice().multiply(BigDecimal.valueOf(newQuantity)));
        cartItemDAO.update(cartItem);

        updateCartTotalsAndRespond(request, response, cartItem);
    }

    //remove item
    private void handleRemove(HttpServletRequest request, HttpServletResponse response, String cartItemId)
            throws IOException {
        CartItem cartItem = cartItemDAO.findById(cartItemId);
        if (cartItem != null) {
            cartItemDAO.softDelete(cartItemId);
            updateCartTotalsAndRespond(request, response, cartItem);
        } else {
            response.setContentType("application/json");
            response.getWriter().write("{\"success\":false,\"message\":\"Item not found.\"}");
        }
    }

    private void updateCartTotalsAndRespond(HttpServletRequest request, HttpServletResponse response, CartItem cartItem) throws IOException {
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
        cart.setTotal(BigDecimal.valueOf(cartTotal));
        cartDAO.update(cart);

        //set session pass to check out page
        HttpSession session = request.getSession();
        session.setAttribute("cartItems", cartItems);
        session.setAttribute("cartSubtotal", cartSubtotal);
        session.setAttribute("deliveryFee", deliveryFee);
        session.setAttribute("cartTotal", cartTotal);
        session.setAttribute("cart", cart);

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

}
