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

@WebServlet("/DeletePromotion")
public class DeletePromotionServlet extends HttpServlet {

    @EJB
    private PromotionDAO promotionDAO;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String promotionId = request.getParameter("promotionId");
        if (promotionId != null && !promotionId.isEmpty()) {
            promotionDAO.deletePromotion(promotionId);
        }
        response.sendRedirect("ManagePromotions");
    }
}
