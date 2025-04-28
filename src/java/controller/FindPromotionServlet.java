/**
 *
 * @author kaisheng
 */
package controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import model.Promotion;
import model.PromotionDAO;
import javax.ejb.EJB;

@WebServlet(name="FindPromotionServlet",urlPatterns={"/manager/FindPromotionServlet","/staff/FindPromotionServlet"})
public class FindPromotionServlet extends HttpServlet {

    @EJB
    private PromotionDAO promotionDAO;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String servletPath = request.getServletPath();
        String contextPath = request.getContextPath();
        
        String promotionId = request.getParameter("promotionId");

        try {
            // Use the PromotionDAO to find the promotion
            Promotion promotion = null;
            for (Promotion p : promotionDAO.getAllPromotions()) {
                if (p.getPromotionId().equals(promotionId)) {
                    promotion = p;
                    break;
                }
            }
            
            if (promotion != null) {
                request.setAttribute("editPromotion", promotion);
            } else {
                request.setAttribute("error", "Promotion ID not found.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Failed to fetch promotion: " + e.getMessage());
        }

        if (servletPath.contains("/manager/")) {
            request.getRequestDispatcher("/manager/promotion.jsp").forward(request, response);
        } else if (servletPath.contains("/staff/")) {
            request.getRequestDispatcher("/staff/promotion.jsp").forward(request, response);
        }
    }
}