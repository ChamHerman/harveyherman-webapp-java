package controller;

import model.ItemDAO;
import model.Item;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import javax.ejb.EJB;

@WebServlet("/viewItem")
public class ViewItemServlet extends HttpServlet {

    @EJB
    private ItemDAO itemDAO;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<Item> item = itemDAO.getAll();
        request.setAttribute("item", item);
        request.getRequestDispatcher("viewItem.jsp").forward(request, response);
    }
}
