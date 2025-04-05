// File: src/main/java/com/harveyherman/controller/FilterItemsServlet.java
package controller;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import javax.ejb.EJB;
import model.Item;
import model.ItemDAO;

@WebServlet("/FilterItemsServlet")
public class FilterItemsServlet extends HttpServlet {

    @EJB
    private ItemDAO itemDAO;
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String category = request.getParameter("category");
        String stock = request.getParameter("stock");
        int rowCount = Integer.parseInt(request.getParameter("rows"));

        String jsonResponse = filterItems(category, stock, rowCount);

        response.setContentType("application/json");
        response.getWriter().write(jsonResponse);
    }

    public String filterItems(String category, String stock, int rowCount) {

        List<Item> filteredItems = itemDAO.getFilteredItemsByCategoryAndStock(category, stock);
        List<Item> limitedItems = filteredItems.subList(0, Math.min(rowCount, filteredItems.size()));

        long totalItems = itemDAO.getTotalItemCount();
        long inStock = itemDAO.getInStockItemCount();
        long outOfStock = totalItems - inStock;
        long categories = itemDAO.getCategoryCount();

        StringBuilder tableHtml = new StringBuilder();
        for (Item item : limitedItems) {
            tableHtml.append("<tr>").append("<td><input type='checkbox'></td>").append("<td>").append(item.getName())
                    .append("</td>").append("<td>").append(item.getCategory()).append("</td>").append("<td>")
                    .append(item.getStockQuantity()).append("</td>").append("<td>RM ").append(item.getPrice())
                    .append("</td>").append("<td><button>Edit</button> <button>View</button></td>").append("</tr>");
        }

        String jsonResponse = "{" + "\"itemTable\": \"" + tableHtml.toString().replace("\"", "\\\"") + "\","
                + "\"totalItems\": " + totalItems + "," + "\"inStock\": " + inStock + "," + "\"outOfStock\": "
                + outOfStock + "," + "\"categories\": " + categories + "}";
        return jsonResponse;
    }
}
