/**
 *
 * @author herman
 */
package controller;

import java.io.IOException;
import javax.ejb.EJB;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import model.ItemDAO;
import model.Item;

@WebServlet("/user/details")
public class ItemDetailsServlet extends HttpServlet {

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
        String addToCartSuccessParam = request.getParameter("addToCartSuccess");

        if (itemId == null || itemId.trim().isEmpty()) {
            response.sendRedirect("errorPage.jsp");
            return;
        }

        Item item = itemDAO.getItemById(itemId);

        if (item == null) {
            request.setAttribute("error", "Item not found.");
        } else {
            request.setAttribute("item", item);
        }

        // Set the addToCartSuccess request attribute if present
        if ("true".equals(addToCartSuccessParam)) {
            request.setAttribute("addToCartSuccess", Boolean.TRUE);
        }

        RequestDispatcher dispatcher = request.getRequestDispatcher("/user/itemDetails.jsp");
        dispatcher.forward(request, response);
    }
}
