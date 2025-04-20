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
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import model.*;

/**
 *
 * @author user
 */
@WebServlet(name = "CartServlet", urlPatterns = {"/user/CartServlet"})
public class CartServlet extends HttpServlet {
    

    @EJB
    private CartDAO cartDAO;
    private static final long serialVersionUID = 1L;
    @EJB
    private CartItemDAO cartItemDAO;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
       HttpSession session = request.getSession();
        if (session.getAttribute("userId") == null) {
            session.setAttribute("userId", "U003"); // Use a real user_id from your DB!
        }
        String userId = (String) session.getAttribute("userId");

        Cart cart = cartDAO.getActiveCartByUserId(userId);
        System.out.println("Cart: " + cart);
        if (cart == null) {
            //use to debug
             System.out.println("No cart found for userId: " + userId);
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
        
        double deliveryFee = 0.0;
        if(cartSubtotal >= 1000 || cartSubtotal == 0){
            deliveryFee = 0.0;
        }else if(cartSubtotal < 1000){
            deliveryFee = 25.0;
        }
            
        
        double discount = 0.0;
        double cartTotal = cartSubtotal + deliveryFee - discount;
        
        request.setAttribute("cart", cart);
        request.setAttribute("cartItems", cartItems);
        request.setAttribute("cartSubtotal", cartSubtotal);
        request.setAttribute("deliveryFee", deliveryFee);
        request.setAttribute("discount", discount);
        request.setAttribute("cartTotal", cartTotal);

        request.getRequestDispatcher("cart.jsp").forward(request, response);
    }

}