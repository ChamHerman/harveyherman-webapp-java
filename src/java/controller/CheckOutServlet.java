/**
 *
 * @author kaibin
 */
package controller;

import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import model.Cart;
import model.CartItem;
import model.UserData;

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

        // Set as session attributes for checkout.jsp
        session.setAttribute("userData", userData);
        session.setAttribute("cart", cart);
        session.setAttribute("cartItems", cartItems);
        session.setAttribute("cartSubtotal", cartSubtotal);
        session.setAttribute("deliveryFee", deliveryFee);
        session.setAttribute("discount", discount);
        session.setAttribute("cartTotal", cartTotal);
        }
        catch (Exception e) {
            System.out.println("Error");
            e.printStackTrace();
            throw e;
        }

        // Forward to checkout.jsp
        response.sendRedirect("checkout.jsp");
    }

}