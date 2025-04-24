/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import java.io.IOException;
import java.io.PrintWriter;
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
import model.UserData;
import model.UserDataDAO;

/**
 *
 * @author user
 */
@WebServlet(name = "CheckOutServlet", urlPatterns = {"/user/CheckOutServlet"})
public class CheckOutServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try{
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loggedInUser") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // Get user and cart info from session
        UserData userData = (UserData) session.getAttribute("loggedInUser");
        Cart cart = (Cart) session.getAttribute("cart");
        List<CartItem> cartItems = (List<CartItem>) session.getAttribute("cartItems");
        Double cartSubtotal = (Double) session.getAttribute("cartSubtotal");
        Double deliveryFee = (Double) session.getAttribute("deliveryFee");
        Double discount = (Double) session.getAttribute("discount");
        Double cartTotal = (Double) session.getAttribute("cartTotal");

        // Set as request attributes for checkout.jsp
        request.setAttribute("userData", userData);
        request.setAttribute("cart", cart);
        request.setAttribute("cartItems", cartItems);
        request.setAttribute("cartSubtotal", cartSubtotal);
        request.setAttribute("deliveryFee", deliveryFee);
        request.setAttribute("discount", discount);
        request.setAttribute("cartTotal", cartTotal);
        }
        catch (Exception e) {
            System.out.println("Error");
            e.printStackTrace();
            throw e;
        }

        // Forward to checkout.jsp
        request.getRequestDispatcher("checkout.jsp").forward(request, response);
    }

//    // Show the checkout page with all data
//    private void processCheckoutPage(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//        HttpSession session = request.getSession();
//        String userId = (String) session.getAttribute("userId");
//
//        // Get user info using CartDAO
//        UserData user = userDataDAO.findByUserId(userId);
//
//        // Get cart and cart items
//        Cart cart = cartDAO.getActiveCartByUserId(userId);
//        List<CartItem> cartItems = cartItemDAO.getActiveCartItemsByCartId(cart.getCartId());
//
//        // Calculate totals
//        double cartSubtotal = 0.0;
//        String paymentMethod = request.getParameter("paymentMethod");
//        for (CartItem item : cartItems) {
//            cartSubtotal += item.getQuantity() * item.getUnitPrice().doubleValue();
//        }
//        double deliveryFee = cartSubtotal >= 1000 ? 0.0 : 25.0;
//        double discount = 0.0; // If you have promotion, get from session or recalculate
//        double cartTotal = cartSubtotal - discount + deliveryFee;
//
//        // Set as request attributes
//        request.setAttribute("user", user);
//        request.setAttribute("cartItems", cartItems);
//        request.setAttribute("cartSubtotal", cartSubtotal);
//        request.setAttribute("deliveryFee", deliveryFee);
//        request.setAttribute("discount", discount);
//        request.setAttribute("cartTotal", cartTotal);
//        request.setAttribute("selectedPayment", paymentMethod);
//        
//        request.getRequestDispatcher("checkout.jsp").forward(request, response);
//    }
//    private void processPlaceOrder(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//        // 1. Get all form data (billing, payment, etc.)
//        // 2. Validate and process payment if needed
//        // 3. Save order and order details to DB
//        // 4. Clear cart, etc.
//        // 5. Redirect to thank you page
//
//        // Example:
//        // String paymentMethod = request.getParameter("paymentMethod");
//        // ... your order creation logic here ...
//        response.sendRedirect("thankyou.html");
//    }
}
