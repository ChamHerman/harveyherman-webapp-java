package controller;

import java.io.IOException;
import java.util.List;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import model.ItemDAO;
import model.Item;

@WebServlet("/item")
public class ItemServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String search = request.getParameter("search");
        String[] selectedCategories = request.getParameterValues("category");

        ItemDAO itemDAO = new ItemDAO();
        List<Item> filteredItems = itemDAO.getFilteredItems(search, selectedCategories);
        
        List<String> allCategories = itemDAO.getAllCategories();

        request.setAttribute("items", filteredItems);
        request.setAttribute("categories", allCategories);

        RequestDispatcher dispatcher = request.getRequestDispatcher("item.jsp");
        dispatcher.forward(request, response);
    }
}

