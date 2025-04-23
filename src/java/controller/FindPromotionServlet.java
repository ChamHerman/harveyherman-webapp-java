/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import java.io.IOException;
import java.io.PrintWriter;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import model.Promotion;
import model.PromotionDAO;
import javax.ejb.EJB;

/**
 *
 * @author User
 */
@WebServlet(name="FindPromotionServlet",urlPatterns={"/manager/FindPromotionServlet","/staff/FindPromotionServlet"})
public class FindPromotionServlet extends HttpServlet {

    @EJB
    private PromotionDAO promotionDAO;
    
    // Remove the direct EntityManager usage
    // @PersistenceContext(unitName = "HarveyHermanPU")
    // private EntityManager em;

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