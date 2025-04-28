/**
 *
 * @author kaisheng
 */
package controller;

import model.Promotion;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.Date;
import java.util.List;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;

@WebServlet("/PromotionServlet")
public class PromotionServlet extends HttpServlet {

    @PersistenceContext(unitName = "HarveyHermanPU")
    private EntityManager em;

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<Promotion> promotions = em.createQuery("Promotion.findAll", Promotion.class).getResultList();

        Date today = new Date(); // Current system date

        em.getTransaction().begin();
        for (Promotion promo : promotions) {
            String currentStatus = promo.getStatus();
            if (promo.getEndDate() != null && promo.getEndDate().before(today)) {
                if (!"expired".equalsIgnoreCase(currentStatus)) {
                    promo.setStatus("expired");
                    em.merge(promo); // Update in DB
                }
            } else {
                if (!"active".equalsIgnoreCase(currentStatus)) {
                    promo.setStatus("active");
                    em.merge(promo); // Update in DB
                }
            }
        }
        em.getTransaction().commit();

        request.setAttribute("promotions", promotions);
        request.getRequestDispatcher("promotion.jsp").forward(request, response);
    }

}
