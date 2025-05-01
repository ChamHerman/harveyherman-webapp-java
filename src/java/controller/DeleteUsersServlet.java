/**
 *
 * @author weikang
 */
package controller;

import javax.ejb.EJB;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.net.URLEncoder;
import javax.servlet.http.HttpSession;
import model.UserData;
import model.UserDataDAO;
import model.UserLogin;
import model.UserLoginDAO;

@WebServlet("/manager/DeleteUsersServlet")
public class DeleteUsersServlet extends HttpServlet {

    @EJB
    private UserDataDAO userDataDAO;

    @EJB
    private UserLoginDAO userLoginDAO;

    private static final long serialVersionUID = 1L;

    private void sendJsonResponse(HttpServletRequest request, HttpServletResponse response, boolean success, String message)
            throws IOException {
        // Disable caching
        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        response.setHeader("Pragma", "no-cache");
        response.setDateHeader("Expires", 0);

        String contextPath = request.getContextPath();
        String json;

        if (success) {
            json = "Message: " + message.replace("\"", "\\\"");
        } else {
            json = "Error: " + message.replace("\"", "\\\"");
        }

        String encodedMessage = URLEncoder.encode(json, "UTF-8");
        response.sendRedirect(contextPath + "/manager/ap_user.jsp?message=" + encodedMessage);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String userId = request.getParameter("userId");
            if (userId == null || userId.trim().isEmpty()) {
                sendJsonResponse(request, response, false, "User ID not provided.");
                return;
            }

            // Get user data to verify it exists
            UserData userData = userDataDAO.findByUserId(userId);
            if (userData == null) {
                sendJsonResponse(request, response, false, "User not found.");
                return;
            }

            UserLogin userLogin = userLoginDAO.findByUserId(userId);

            if (userLogin != null) {
                userLoginDAO.delete(userLogin.getLoginId());
            }
            userDataDAO.delete(userId);

            // Force user to logout if deleted account is currently logged in
            HttpSession session = request.getSession();
            if ((session.getAttribute("loggedInUser") != null)) {
                UserData currentLoginUser = (UserData) session.getAttribute("loggedInUser");
                if (currentLoginUser.getUserId().equals(userData.getUserId())) {
                    session.removeAttribute("loggedInUser");

                    // Remove set session attributes when log out.
                    // viewOrders's
                    session.removeAttribute("loggedInUserOrders");
                    session.removeAttribute("orderDetailsMap");
                    session.removeAttribute("orderDeliveryMap");
                    // AddOrderServlet
                    session.removeAttribute("filteredOrders");
                    // CartItemServlet
                    session.removeAttribute("cart");
                    session.removeAttribute("cartItems");
                    session.removeAttribute("cartSubtotal");
                    session.removeAttribute("deliveryFee");
                    session.removeAttribute("discount");
                    session.removeAttribute("cartTotal");
                    // CartServlet
                    session.removeAttribute("discountPercent");
                    session.removeAttribute("appliedPromotionCode");
                    session.removeAttribute("discount");
                    session.removeAttribute("cartSubtotal");
                    session.removeAttribute("deliveryFee");
                    session.removeAttribute("cartTotal");
                    // CheckoutServlet
                    session.removeAttribute("userData");
                    session.removeAttribute("cart");
                    session.removeAttribute("cartItems");
                    session.removeAttribute("cartSubtotal");
                    session.removeAttribute("deliveryFee");
                    session.removeAttribute("discount");
                    session.removeAttribute("cartTotal");
                }
            }

            sendJsonResponse(request, response, true, "User deleted successfully.");
        } catch (Exception ex) {
            ex.printStackTrace();
            sendJsonResponse(request, response, false, "User failed to delete. Exception: " + ex.getMessage());
        }
    }
}
