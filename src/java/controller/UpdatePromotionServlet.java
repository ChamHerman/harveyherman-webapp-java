/**
 *
 * @author kaisheng
 */
package controller;

import model.PromotionDAO;
import javax.ejb.EJB;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import javax.servlet.ServletException;
import java.io.IOException;
import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.util.Date;
import model.Promotion;

@WebServlet(name="UpdatePromotionServlet",urlPatterns={"/manager/UpdatePromotionServlet","/staff/UpdatePromotionServlet"})
public class UpdatePromotionServlet extends HttpServlet {
    @EJB
    private PromotionDAO promotionDAO;
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String servletPath = request.getServletPath();
        String contextPath = request.getContextPath();
        
        try {    
            // Trim the promotionId to remove any whitespace
            String promotionId = request.getParameter("promotionId").trim();
            String promotionCode = request.getParameter("promotionCode");
            // Status will be automatically determined based on dates
            BigDecimal discount = new BigDecimal(request.getParameter("discountValue"));
            BigDecimal minPurchase = request.getParameter("minimumPurchase").isEmpty() ? 
                null : new BigDecimal(request.getParameter("minimumPurchase"));
            String description = request.getParameter("description");

            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            Date startDate = request.getParameter("startDate").isEmpty() ? 
                null : sdf.parse(request.getParameter("startDate"));
            Date endDate = request.getParameter("endDate").isEmpty() ? 
                null : sdf.parse(request.getParameter("endDate"));

            // Create a Promotion object with the trimmed ID
            Promotion promotion = new Promotion(promotionId);
            promotion.setPromotionCode(promotionCode);
            // Status will be automatically determined in the DAO
            promotion.setDiscountValue(discount);
            promotion.setMinimumPurchase(minPurchase);
            promotion.setDescription(description);
            promotion.setStartDate(startDate);
            promotion.setEndDate(endDate);

            Promotion updatedPromotion = promotionDAO.updatePromotion(promotion);
            if (updatedPromotion != null) {
                request.setAttribute("successMessage", "Promotion updated successfully! ID: " + promotionId);
            } else {
                request.setAttribute("errorMessage", "Failed to update promotion. Promotion with ID " + promotionId + " not found.");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error updating promotion: " + e.getMessage());
        }
        
        if (servletPath.contains("/manager/")) {
            request.getRequestDispatcher("/manager/promotion.jsp").forward(request, response);
        } else if (servletPath.contains("/staff/")) {
            request.getRequestDispatcher("/staff/promotion.jsp").forward(request, response);
        }
    }
} 
