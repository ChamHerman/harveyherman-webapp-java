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
    private UserDataDAO userDataDAO;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            HttpSession session = request.getSession();
            String userId = (String) session.getAttribute("userId");
            if (session.getAttribute("userId") == null) {
                response.sendRedirect("login.jsp");
                return;
            }

            Cart cart = cartDAO.getActiveCartByUserId(userId);
            if (cart == null) {
                request.setAttribute("cartItems", null);
                request.setAttribute("cartSubtotal", 0.0);
                request.setAttribute("deliveryFee", 0.0);
                request.setAttribute("discount", 0.0);
                request.setAttribute("cartTotal", 0.0);
                request.getRequestDispatcher("cart.jsp").forward(request, response);
                return;
            }

            List<CartItem> cartItems = cartItemDAO.getActiveCartItemsByCartId(cart.getCartId());

            double cartSubtotal = 0.0;
            for (CartItem item : cartItems) {
                cartSubtotal += item.getQuantity() * item.getUnitPrice().doubleValue();
            }

            double deliveryFee = (cartSubtotal >= 1000 || cartSubtotal == 0) ? 0.0 : 25.0;
            double discount = 0.0;
            double cartTotal = cartSubtotal + deliveryFee - discount;

            request.setAttribute("cart", cart);
            request.setAttribute("cartItems", cartItems);
            request.setAttribute("cartSubtotal", cartSubtotal);
            request.setAttribute("deliveryFee", deliveryFee);
            request.setAttribute("discount", discount);
            request.setAttribute("cartTotal", cartTotal);
        } catch (Exception e) {
            System.out.println("Error");
            e.printStackTrace();
            throw e;
        }

        request.getRequestDispatcher("cart.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        String userId = (String) session.getAttribute("userId");
        String itemId = request.getParameter("itemId");
        int quantity = Integer.parseInt(request.getParameter("quantity"));

        if (userId == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        Item item = itemDAO.getItemById(itemId);
        if (item == null) {
            //redirect to an error   page send error msg
            response.sendRedirect("itemDetails.jsp?itemId=" + itemId + "&error=notfound");
            return;
        }

        Cart cart = cartDAO.getActiveCartByUserId(userId);
        if (cart == null) {
            cart = new Cart();
            cart.setUserId(userDataDAO.findByUserId(userId));
            cart.setCreatedDate(new Timestamp(System.currentTimeMillis()));
            cart.setDbstatus("active");
            cartDAO.create(cart);
        }
        CartItem cartItem = cartItemDAO.getActiveCartItem(cart.getCartId(), itemId);
        if (cartItem == null) {
            cartItem = new CartItem();
            cartItem.setCartItemId(null);
            cartItem.setCartId(cart);
            cartItem.setItemId(item);
            cartItem.setQuantity(quantity);
            cartItem.setUnitPrice(item.getPrice());
            cartItem.setSubtotal(item.getPrice().multiply(BigDecimal.valueOf(quantity)));
            cartItem.setDbstatus("active");
            cartItemDAO.create(cartItem);
        } else {
            cartItem.setQuantity(cartItem.getQuantity() + quantity);
            cartItem.setSubtotal(cartItem.getUnitPrice().multiply(BigDecimal.valueOf(cartItem.getQuantity())));
            cartItemDAO.update(cartItem);
        }

        response.sendRedirect(request.getContextPath() + "/user/CartServlet");
    }
}
