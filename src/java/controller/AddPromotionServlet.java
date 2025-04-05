package controller;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import model.PromotionDAO;
import model.Promotion;
import model.PromotionStatus;

@WebServlet("/AddPromotionServlet")
public class AddPromotionServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            String promotionCode = request.getParameter("promotionCode");
            double discountValue = Double.parseDouble(request.getParameter("discountValue"));
            double minimumPurchase = Double.parseDouble(request.getParameter("minimumPurchase"));
            String description = request.getParameter("description");

            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            Date startDate = sdf.parse(request.getParameter("startDate"));
            Date endDate = sdf.parse(request.getParameter("endDate"));

            PromotionStatus status = PromotionStatus.active;

            Promotion newPromotion = new Promotion();
            newPromotion.setPromotionCode(promotionCode);
            newPromotion.setDiscountValue(BigDecimal.valueOf(discountValue));
            newPromotion.setMinimumPurchase(BigDecimal.valueOf(minimumPurchase));
            newPromotion.setDescription(description);
            newPromotion.setStartDate(startDate);
            newPromotion.setEndDate(endDate);
            newPromotion.setStatus(status);

            PromotionDAO promotionDAO = new PromotionDAO();
            String generatedId = promotionDAO.addPromotion(newPromotion); // Get the auto-generated ID

            if (!generatedId.equals(null)) {
                request.setAttribute("successMessage", "Promotion added successfully! ID: "+ generatedId);
            } else {
                request.setAttribute("errorMessage", "Failed to add promotion.");
            }

        } catch (NumberFormatException e) {
            e.printStackTrace(); // Log error
            request.setAttribute("errorMessage", "Invalid number format: " + e.getMessage());
        } catch (ParseException e) {
            e.printStackTrace(); // Log error
            request.setAttribute("errorMessage", "Invalid date format: " + e.getMessage());
        } catch (SQLException e) {
            e.printStackTrace(); // Log error
            request.setAttribute("errorMessage", "Database error: " + e.getMessage());
        } catch (Exception e) {
            e.printStackTrace(); // Log error
            request.setAttribute("errorMessage", "Unexpected error: " + e.getMessage());
        }
        request.getRequestDispatcher("promotion.jsp").forward(request, response);
    }
}


