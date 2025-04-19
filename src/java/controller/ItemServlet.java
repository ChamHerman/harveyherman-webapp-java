/**
 *
 * @author herman
 */
package controller;

import java.io.IOException;
import java.util.List;
import javax.ejb.EJB;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import model.ItemDAO;
import model.Item;

@WebServlet("/user/item")
public class ItemServlet extends HttpServlet {

    @EJB
    private ItemDAO itemDAO;
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String search = request.getParameter("search");
        String[] selectedCategories = request.getParameterValues("category");
        String stock = request.getParameter("stock");
        String minPriceStr = request.getParameter("minPrice");
        String maxPriceStr = request.getParameter("maxPrice");
        String sortBy = request.getParameter("sortBy");
        String sortOrder = request.getParameter("sortOrder");
        Double minPrice = null;
        Double maxPrice = null;
        try { if (minPriceStr != null && !minPriceStr.isEmpty()) minPrice = Double.parseDouble(minPriceStr); } catch (Exception e) {}
        try { if (maxPriceStr != null && !maxPriceStr.isEmpty()) maxPrice = Double.parseDouble(maxPriceStr); } catch (Exception e) {}

        List<Item> filteredItems = itemDAO.getFilteredItemsAdvanced(search, selectedCategories, stock, minPrice, maxPrice, sortBy, sortOrder);
        List<String> allCategories = itemDAO.getAllCategories();
        request.setAttribute("items", filteredItems);
        request.setAttribute("categories", allCategories);
        RequestDispatcher dispatcher = request.getRequestDispatcher("/user/item.jsp");
        dispatcher.forward(request, response);
    }
}
