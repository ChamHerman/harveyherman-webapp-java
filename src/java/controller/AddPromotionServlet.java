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

@WebServlet(name="AddPromotionServlet",urlPatterns={"/manager/AddPromotionServlet","/staff/AddPromotionServlet"})
public class AddPromotionServlet extends HttpServlet {

    @EJB
    private PromotionDAO promotionDAO;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String servletPath = request.getServletPath();
        String contextPath = request.getContextPath();

        try {
            String id=request.getParameter("promotionId");
            String code = request.getParameter("promotionCode");
            BigDecimal discount = new BigDecimal(request.getParameter("discountValue"));
            String status = request.getParameter("promotionActive");
            BigDecimal minPurchase = request.getParameter("minimumPurchase").isEmpty() ? null : new BigDecimal(request.getParameter("minimumPurchase"));
            String desc = request.getParameter("description");
            
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            Date startDate = request.getParameter("startDate").isEmpty() ? null : sdf.parse(request.getParameter("startDate"));
            Date endDate = request.getParameter("endDate").isEmpty() ? null : sdf.parse(request.getParameter("endDate"));
            
            String dbstatus="active";
            Promotion existingPromo = promotionDAO.findByPromotionCode(code);
            if (existingPromo != null) {
                request.setAttribute("errorMessage", "Promotion Code: " + code + " has been used.");
                if (servletPath.contains("/manager/")) {
                    request.getRequestDispatcher("/manager/promotion.jsp").forward(request, response);
                } else {
                    request.getRequestDispatcher("/staff/promotion.jsp").forward(request, response);
                }
                return;
            }

            Promotion promo = new Promotion();
            promo.setPromotionId(id);
            promo.setPromotionCode(code);
            promo.setDiscountValue(discount);
            promo.setStatus(status);
            promo.setMinimumPurchase(minPurchase);
            promo.setDescription(desc);
            promo.setStartDate(startDate);
            promo.setEndDate(endDate);
            promo.setDbstatus(dbstatus);

            promotionDAO.addPromotion(promo);
            if (!id.equals(null)) {
                request.setAttribute("successMessage", "Promotion added successfully! ID: "+ id);
            } else {
                request.setAttribute("errorMessage", "Failed to add promotion.");
            }
       // request.getRequestDispatcher("promotion.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
        }

        if (servletPath.contains("/manager/")) {
            request.getRequestDispatcher("/manager/promotion.jsp?message=Promotion has been added").forward(request, response);
        } else if (servletPath.contains("/staff/")) {
            request.getRequestDispatcher("/staff/promotion.jsp?message=Promotion has been added").forward(request, response);
        }
    }
}
