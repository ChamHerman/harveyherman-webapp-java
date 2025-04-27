/**
 *
 * @author kaibin
 */
package controller;

import java.io.IOException;
import java.math.BigDecimal;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.sql.Timestamp;
import java.util.List;
import javax.ejb.EJB;
import model.Cart;
import model.CartItem;
import model.CartItemDAO;
import model.Delivery;
import model.OrderDAO;
import model.Orders;
import model.DeliveryDAO;
import model.Item;
import model.ItemDAO;
import model.OrderDetails;
import model.OrderDetailsDAO;
import model.Promotion;
import model.PromotionDAO;
import model.UserData;

@WebServlet(name = "AddOrderServlet", urlPatterns = { "/manager/AddOrderServlet", "/staff/AddOrderServlet",
        "/user/AddOrderServlet" })
public class AddOrderServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @EJB
    private OrderDAO orderDAO;
    @EJB
    private DeliveryDAO deliveryDAO;
    @EJB
    private CartItemDAO cartItemDAO;
    @EJB
    private OrderDetailsDAO orderDetailsDAO;
    @EJB
    private ItemDAO itemDAO;
    @EJB
    private PromotionDAO promotionDAO;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            HttpSession session = request.getSession(false);
            if (session == null || session.getAttribute("loggedInUser") == null) {
                response.sendRedirect("login.jsp");
                return;
            }

            UserData user = (UserData) session.getAttribute("loggedInUser");
            Cart cart = (Cart) session.getAttribute("cart");
            List<CartItem> cartItems = (List<CartItem>) session.getAttribute("cartItems");
            Double cartTotal = (Double) session.getAttribute("cartTotal");

            // Validate cart and cart items
            if (cart == null || cartItems == null || cartItems.isEmpty() || cartTotal == null || cartTotal <= 0) {
                request.setAttribute("error", "Your cart is empty or invalid.");
                request.getRequestDispatcher("/user/CheckOutServlet").forward(request, response);
                return;
            }

            // Get delivery info from form
            String receiverName = request.getParameter("receiverName");
            String receiverContact = request.getParameter("receiverContact");
            String receiverAddress = request.getParameter("receiverAddress");
            String paymentMethod = request.getParameter("paymentMethod");
            String promoCode = (String) session.getAttribute("appliedPromotionCode");
            Promotion promotion = null;
            if (promoCode != null) {
                promotion = promotionDAO.findByPromotionCode(promoCode);
            }

            // Validate delivery info
            if (receiverName == null || receiverName.trim().isEmpty()
                    || receiverContact == null || receiverContact.trim().isEmpty()
                    || receiverAddress == null || receiverAddress.trim().isEmpty()) {
                request.setAttribute("error", "Please fill in all delivery details.");
                request.getRequestDispatcher("/user/CheckOutServlet").forward(request, response);
                return;
            }

            // Validate payment method
            if (paymentMethod == null || paymentMethod.trim().isEmpty()) {
                request.setAttribute("error", "Please select a payment method.");
                request.getRequestDispatcher("/user/CheckOutServlet").forward(request, response);
                return;
            }

            // Create and save Order
            Orders order = createOrder(user, cartTotal, paymentMethod, promotion);
            orderDAO.create(order);

            // Create and save Delivery
            Delivery delivery = createDelivery(receiverName, receiverContact, receiverAddress, order);
            deliveryDAO.create(delivery);

            // Create and save OrderDetails for each cart item
            for (CartItem cartItem : cartItems) {
                OrderDetails detail = createOrderDetail(order, cartItem);
                orderDetailsDAO.create(detail);

                // Decrease stock
                Item item = cartItem.getItemId();
                int newStock = item.getStockQuantity() - cartItem.getQuantity();
                item.setStockQuantity(newStock);
                itemDAO.update(item);

                cartItemDAO.softDelete(cartItem.getCartItemId());
            }

            // Clear cart from session
            session.removeAttribute("cart");
            session.removeAttribute("cartItems");
            session.removeAttribute("cartSubtotal");
            session.removeAttribute("deliveryFee");
            session.removeAttribute("discount");
            session.removeAttribute("cartTotal");

            response.sendRedirect("thankyou.jsp");
        } catch (Exception ex) {
            ex.printStackTrace();
            request.setAttribute("error", "An unexpected error occurred. Please try again.");
            request.getRequestDispatcher("/user/CheckOutServlet").forward(request, response);
        }

    }

    private Orders createOrder(UserData user, Double total, String paymentMethod, Promotion promotion) {
        Orders order = new Orders();
        order.setUserId(user);
        order.setTotalAmount(BigDecimal.valueOf(total));
        order.setPaymentMethod(paymentMethod);
        order.setStatus("packaging");
        order.setPromotionId(promotion);
        order.setCreatedDate(new Timestamp(System.currentTimeMillis()));
        order.setDbstatus("active");
        return order;
    }

    private OrderDetails createOrderDetail(Orders order, CartItem cartItem) {
        OrderDetails detail = new OrderDetails();
        detail.setOrderId(order);
        detail.setItemId(cartItem.getItemId());
        detail.setQuantity(cartItem.getQuantity());
        detail.setPricePerItem(cartItem.getUnitPrice());
        detail.setDbstatus("active");
        return detail;
    }

    private Delivery createDelivery(String receiverName, String receiverContact, String receiverAddress, Orders order) {
        Delivery delivery = new Delivery();
        delivery.setReceiverName(receiverName);
        delivery.setReceiverContact(receiverContact);
        delivery.setReceiverAddress(receiverAddress);
        delivery.setDbstatus("active");
        delivery.setOrderId(order);
        return delivery;
    }

}
