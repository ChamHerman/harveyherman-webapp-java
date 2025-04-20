/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import model.Cart;
import model.CartItem;
import model.ItemDAO;
import model.Item;
import model.UserData;
import model.CartDAO;
import model.CartItemDAO;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import javax.ejb.EJB;
import java.io.IOException;
import java.io.PrintWriter;
import java.math.BigDecimal;
import java.sql.Timestamp;
import java.util.List;
import javax.servlet.ServletException;

/**
 *
 * @author user
 */
@WebServlet(name = "AddToCartServlet", urlPatterns = {"/user/AddToCartServlet"})
public class AddToCartServlet extends HttpServlet {

    @EJB
    private CartDAO cartDAO;
    private static final long serialVersionUID = 1L;
    @EJB
    private CartItemDAO cartItemDAO;
    @EJB
    private ItemDAO itemDAO;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        String userId = (String) session.getAttribute("userId"); // Set this at login!
        String itemId = request.getParameter("itemId");
        int quantity = Integer.parseInt(request.getParameter("quantity"));

        response.setContentType("application/json");
        PrintWriter out = response.getWriter();

        if (userId == null) {
            out.print("{\"success\":false,\"message\":\"Not logged in\"}");
            return;
        }

        Item item = itemDAO.getItemById(itemId);
        if (item == null) {
            out.print("{\"success\":false,\"message\":\"Item not found\"}");
            return;
        }

        Cart cart = cartDAO.getActiveCartByUserId(userId);
        List<CartItem> cartItems = cartItemDAO.getActiveCartItemsByCartId(cart.getCartId());
        request.setAttribute("cart", cart);
        request.setAttribute("cartItems", cartItems);
        if (cart == null) {
            cart = new Cart();
            cart.setUserId(new UserData(userId));
            cart.setCreatedDate(new Timestamp(System.currentTimeMillis()));
            cart.setDbstatus("active");
            cartDAO.create(cart);
        }

        CartItem cartItem = cartItemDAO.getActiveCartItem(cart.getCartId(), itemId);
        if (cartItem == null) {
            cartItem = new CartItem();
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

        out.print("{\"success\":true}");
    }

}