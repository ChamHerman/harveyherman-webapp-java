package controller;

import model.PromotionDAO;
import javax.ejb.EJB;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;
import model.Promotion;

@WebServlet("/ManagePromotions")
public class PromotionServlet extends HttpServlet {

    @EJB
    private PromotionDAO promotionDAO;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Promotion> promotions = promotionDAO.getAllPromotions();
        request.setAttribute("promotions", promotions);
        request.getRequestDispatcher("promotion.jsp").forward(request, response);
    }
}
