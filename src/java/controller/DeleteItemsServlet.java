
package controller;

import javax.ejb.EJB;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import model.ItemDAO;

@WebServlet("/DeleteItemServlet")
public class DeleteItemServlet extends HttpServlet {
    
    @EJB
    private ItemDAO itemDAO;
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String itemId = request.getParameter("itemId");
        boolean success = false;
        String message;
        try {
            itemDAO.delete(itemId);
            success = true;
            message = "Item deleted successfully.";
        } catch (Exception ex) {
            message = "Error deleting item: " + ex.getMessage();
        }
        response.setContentType("application/json");
        response.getWriter().write("{\"success\": " + success + ", \"message\": \"" + message.replace("\"", "\\\"") + "\"}");
    }
}
