package controller;

import java.io.IOException;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import model.ItemDAO;
import model.Item;

@WebServlet("/details")
public class ItemDetailsServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String itemId = request.getParameter("itemId");

		if (itemId == null || itemId.trim().isEmpty()) {
			response.sendRedirect("errorPage.jsp");
			return;
		}

		ItemDAO itemDAO = new ItemDAO();
		Item item = itemDAO.getItemById(itemId);

		if (item == null) {
			request.setAttribute("error", "Item not found.");
		} else {
			request.setAttribute("item", item);

			// Load reviews
			// ReviewDAO reviewDAO = new ReviewDAO();
			// List<Object[]> reviews = reviewDAO.getReviewsByItemId(itemId);
			// request.setAttribute("reviews", reviews);
		}

		RequestDispatcher dispatcher = request.getRequestDispatcher("itemDetails.jsp");
		dispatcher.forward(request, response);
	}
}
