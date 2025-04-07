/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
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

@WebServlet("/AddPromotion")
public class AddPromotionServlet extends HttpServlet {

    @EJB
    private PromotionDAO promotionDAO;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            String code = request.getParameter("promotionCode");
            BigDecimal discount = new BigDecimal(request.getParameter("discountValue"));
            String status = request.getParameter("status");
            BigDecimal minPurchase = request.getParameter("minimumPurchase").isEmpty() ? null : new BigDecimal(request.getParameter("minimumPurchase"));
            String desc = request.getParameter("description");
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            Date startDate = request.getParameter("startDate").isEmpty() ? null : sdf.parse(request.getParameter("startDate"));
            Date endDate = request.getParameter("endDate").isEmpty() ? null : sdf.parse(request.getParameter("endDate"));

            Promotion promo = new Promotion();
            promo.setPromotionCode(code);
            promo.setDiscountValue(discount);
            promo.setStatus(status);
            promo.setMinimumPurchase(minPurchase);
            promo.setDescription(desc);
            promo.setStartDate(startDate);
            promo.setEndDate(endDate);

            promotionDAO.addPromotion(promo);
        } catch (Exception e) {
            e.printStackTrace();
        }

        response.sendRedirect("ManagePromotions");
    }
}

