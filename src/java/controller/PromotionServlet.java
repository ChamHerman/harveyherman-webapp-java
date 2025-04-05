package controller;

import model.PromotionDAO;
import model.Promotion;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/promotion")
public class PromotionServlet extends HttpServlet {
    private PromotionDAO promotionDAO;

    @Override
    public void init() {
        promotionDAO = new PromotionDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<Promotion> promotions = promotionDAO.getAllPromotions();
        request.setAttribute("promotions", promotions);
        request.getRequestDispatcher("promotion.jsp").forward(request, response);
    }
} 