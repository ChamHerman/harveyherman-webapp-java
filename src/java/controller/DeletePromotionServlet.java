package controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import model.PromotionDAO;

@WebServlet("/DeletePromotionServlet")
public class DeletePromotionServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String promotionId = request.getParameter("promotionId");

        if (promotionId != null && !promotionId.trim().isEmpty()) {
            PromotionDAO promotionDAO = new PromotionDAO();
            boolean deleted = promotionDAO.deletePromotion(promotionId);

            if (deleted) {
                request.setAttribute("successMessage", "Promotion deleted successfully!");
            } else {
                request.setAttribute("errorMessage", "Failed to delete promotion. ID may not exist.");
            }
        } else {
            request.setAttribute("errorMessage", "Promotion ID is required.");
        }

        request.getRequestDispatcher("promotion.jsp").forward(request, response);
    }
}
