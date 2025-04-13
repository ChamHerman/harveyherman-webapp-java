
package controller;

import javax.ejb.EJB;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.net.URLEncoder;
import model.ItemDAO;

@WebServlet("/manager/DeleteItemsServlet")
public class DeleteItemsServlet extends HttpServlet {
    
    @EJB
    private ItemDAO itemDAO;
    private static final long serialVersionUID = 1L;
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doPost(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String itemId = request.getParameter("itemId");
        try {
            itemDAO.delete(itemId);
            String message = "Item deleted successfully";
            String encodedMessage = URLEncoder.encode(message, "UTF-8");
            response.sendRedirect(request.getContextPath() + "/manager/ap_item.jsp?message=" + encodedMessage);
        } catch (Exception ex) {
            // Set error attribute and forward to an error page.
            request.setAttribute("errorMessage", "Error deleting item: " + ex.getMessage());
            request.getRequestDispatcher(request.getContextPath() + "/manager/error.jsp").forward(request, response);
        }
    }
}
