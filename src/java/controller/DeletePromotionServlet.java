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

@WebServlet(name="DeletePromotionServlet",urlPatterns={"/manager/DeletePromotionServlet","/staff/DeletePromotionServlet"})
public class DeletePromotionServlet extends HttpServlet {
    
    @EJB
    private PromotionDAO promotionDAO;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String servletPath = request.getServletPath();
        String contextPath = request.getContextPath();
        
        String id = request.getParameter("promotionId");
        boolean yes = promotionDAO.deletePromotion(id);
        
        if (yes) {
            request.setAttribute("successMessage", "Promotion deleted successfully! ID:"+id);
        } else {
            request.setAttribute("errorMessage", "Failed to delete promotion. ID may not exist.");
        }
        
        if (servletPath.contains("/manager/")) {
            request.getRequestDispatcher("/manager/promotion.jsp?message=Promotion has been deleted").forward(request, response);
        } else if (servletPath.contains("/staff/")) {
            request.getRequestDispatcher("/staff/promotion.jsp?message=Promotion has been deleted").forward(request, response);
        }
    }
}
