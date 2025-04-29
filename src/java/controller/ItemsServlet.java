/**
 *
 * @author herman
 */
package controller;

import model.Item;
import model.ItemDAO;

import javax.ejb.EJB;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.*;

@WebServlet("/user/items")
public class ItemsServlet extends HttpServlet {

    @EJB
    private ItemDAO itemDAO;
    private static final int ITEMS_PER_PAGE = 16;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Get filter parameters
        String search = request.getParameter("search");
        String[] categories = request.getParameterValues("category");
        String stock = request.getParameter("stock");
        String minPrice = request.getParameter("minPrice");
        String maxPrice = request.getParameter("maxPrice");
        String sortBy = request.getParameter("sortBy");
        String sortOrder = request.getParameter("sortOrder");
        String pageParam = request.getParameter("page");
        int currentPage = 1;
        if (pageParam != null) {
            try {
                currentPage = Integer.parseInt(pageParam);
            } catch (NumberFormatException e) {
                currentPage = 1;
            }
        }
        if (sortBy == null) {
            sortBy = "createdDate";
        }
        if (sortOrder == null) {
            sortOrder = "asc";
        }

        // Get all items
        List<Item> items = itemDAO.getAll();
        if (items == null) {
            items = new ArrayList<>();
        }

        // Filter by search
        if (search != null && !search.trim().isEmpty()) {
            String searchLower = search.toLowerCase();
            Iterator<Item> it = items.iterator();
            while (it.hasNext()) {
                Item i = it.next();
                if (i.getName() == null || !i.getName().toLowerCase().contains(searchLower)) {
                    it.remove();
                }
            }
        }
        // Filter by categories
        if (categories != null && categories.length > 0) {
            Set<String> catSet = new HashSet<>(Arrays.asList(categories));
            Iterator<Item> it = items.iterator();
            while (it.hasNext()) {
                Item i = it.next();
                if (i.getCategory() == null || !catSet.contains(i.getCategory())) {
                    it.remove();
                }
            }
        }
        // Filter by stock
        if (stock != null && !"All".equals(stock)) {
            Iterator<Item> it = items.iterator();
            if ("InStock".equals(stock)) {
                while (it.hasNext()) {
                    Item i = it.next();
                    if (i.getStockQuantity() <= 0) {
                        it.remove();
                    }
                }
            } else if ("OutOfStock".equals(stock)) {
                while (it.hasNext()) {
                    Item i = it.next();
                    if (i.getStockQuantity() > 0) {
                        it.remove();
                    }
                }
            }
        }
        // Filter by price range
        if (minPrice != null && !minPrice.isEmpty()) {
            try {
                double min = Double.parseDouble(minPrice);
                Iterator<Item> it = items.iterator();
                while (it.hasNext()) {
                    Item i = it.next();
                    if (i.getPrice() == null || i.getPrice().doubleValue() < min) {
                        it.remove();
                    }
                }
            } catch (NumberFormatException e) {
                /* ignore */ }
        }
        if (maxPrice != null && !maxPrice.isEmpty()) {
            try {
                double max = Double.parseDouble(maxPrice);
                Iterator<Item> it = items.iterator();
                while (it.hasNext()) {
                    Item i = it.next();
                    if (i.getPrice() == null || i.getPrice().doubleValue() > max) {
                        it.remove();
                    }
                }
            } catch (NumberFormatException e) {
                /* ignore */ }
        }

        // Sorting logic
        List<Item> itemsToShow = new ArrayList<>();
        if ("topSelling".equals(sortBy)) {
            List<String> topSellingIds = itemDAO.getTopSellingItemIds(50);
            Set<String> added = new HashSet<>();
            for (String id : topSellingIds) {
                for (Item i : items) {
                    if (i.getItemId().equals(id)) {
                        itemsToShow.add(i);
                        added.add(id);
                        break;
                    }
                }
            }
            List<Item> unsold = new ArrayList<>();
            for (Item i : items) {
                if (!added.contains(i.getItemId())) {
                    unsold.add(i);
                }
            }
            unsold.sort((a, b) -> {
                if (a.getStockQuantity() > 0 && b.getStockQuantity() <= 0) {
                    return -1;
                }
                if (a.getStockQuantity() <= 0 && b.getStockQuantity() > 0) {
                    return 1;
                }
                if (a.getCreatedDate() == null && b.getCreatedDate() == null) {
                    return 0;
                }
                if (a.getCreatedDate() == null) {
                    return 1;
                }
                if (b.getCreatedDate() == null) {
                    return -1;
                }
                return b.getCreatedDate().compareTo(a.getCreatedDate());
            });
            itemsToShow.addAll(unsold);
        } else {
            // Default: sort by in-stock first, then by selected sort
            final String sortByFinal = sortBy;
            Collections.sort(items, (Item a, Item b) -> {
                // In-stock first
                if (a.getStockQuantity() > 0 && b.getStockQuantity() <= 0) {
                    return -1;
                }
                if (a.getStockQuantity() <= 0 && b.getStockQuantity() > 0) {
                    return 1;
                }
                // Then by sortBy
                if ("name".equals(sortByFinal)) {
                    return a.getName().compareToIgnoreCase(b.getName());
                } else if ("price".equals(sortByFinal)) {
                    return a.getPrice().compareTo(b.getPrice());
                } else { // createdDate or default
                    if (a.getCreatedDate() == null && b.getCreatedDate() == null) {
                        return 0;
                    }
                    if (a.getCreatedDate() == null) {
                        return 1;
                    }
                    if (b.getCreatedDate() == null) {
                        return -1;
                    }
                    return b.getCreatedDate().compareTo(a.getCreatedDate());
                }
            });
            if ("desc".equals(sortOrder)) {
                Collections.reverse(items);
            }
            itemsToShow = items;
        }

        // Pagination
        int totalItems = itemsToShow.size();
        int totalPages = (int) Math.ceil((double) totalItems / ITEMS_PER_PAGE);
        int startIdx = (currentPage - 1) * ITEMS_PER_PAGE;
        int endIdx = Math.min(startIdx + ITEMS_PER_PAGE, totalItems);
        List<Item> pagedItems = (startIdx < endIdx) ? itemsToShow.subList(startIdx, endIdx) : new ArrayList<>();

        // Set attributes for JSP
        request.setAttribute("pagedItems", pagedItems);
        request.setAttribute("currentPage", currentPage);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalItems", totalItems);
        // Also pass filters back
        request.setAttribute("search", search);
        request.setAttribute("categories", categories);
        request.setAttribute("stock", stock);
        request.setAttribute("minPrice", minPrice);
        request.setAttribute("maxPrice", maxPrice);
        request.setAttribute("sortBy", sortBy);
        request.setAttribute("sortOrder", sortOrder);
        // Pass all categories
        List<String> allCategories = itemDAO.getAllCategories();
        request.setAttribute("allCategories", allCategories);
        // Forward to JSP
        request.getRequestDispatcher("/user/item.jsp").forward(request, response);
    }
}
