package controller;

import model.OrderDetails;
import model.Item;

import javax.inject.Inject;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.time.LocalDate;
import java.util.*;
import java.time.LocalDate;
import java.time.ZoneId;
import java.util.Date;

@WebServlet("/topSales")
public class TopSalesServlet extends HttpServlet {

    @PersistenceContext(unitName = "HarveyHermanPU")
    private EntityManager em;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String startDateStr = request.getParameter("startDate");
        String endDateStr = request.getParameter("endDate");

        if (startDateStr == null || endDateStr == null || startDateStr.isEmpty() || endDateStr.isEmpty()) {
            request.setAttribute("errorReportSaleFormDate", "Please enter both start and end dates.");
            request.getRequestDispatcher("salesReport.jsp").forward(request, response);
            return;
        }

        // Parse the input strings into LocalDate
        LocalDate startDate = LocalDate.parse(startDateStr);
        LocalDate endDate = LocalDate.parse(endDateStr);

        // Convert LocalDate to Date
        Date startDateConverted = java.util.Date.from(startDate.atStartOfDay(ZoneId.systemDefault()).toInstant());
        Date endDateConverted = java.util.Date.from(endDate.atStartOfDay(ZoneId.systemDefault()).toInstant());

        // JPA query to get top 10 selling items by quantity in the date range
        List<Object[]> topSales = em.createQuery(
                "SELECT i.itemId, i.name, SUM(od.quantity) " +
                "FROM OrderDetails od " +
                "JOIN od.itemId i " +
                "JOIN od.orderId o " +
                "WHERE o.createdDate BETWEEN :startDate AND :endDate " +
                "GROUP BY i.itemId, i.name " +
                "ORDER BY SUM(od.quantity) DESC", Object[].class)
            .setParameter("startDate", startDateConverted)
            .setParameter("endDate", endDateConverted)
            .setMaxResults(10)
            .getResultList();

        // Add ranking numbers
        List<Object[]> rankedResults = new ArrayList<>();
        int rank = 1;
        for (Object[] row : topSales) {
            // Add rank as the first element in each array
            rankedResults.add(new Object[]{rank++, row[0], row[1], row[2]});
        }

        // Set the results to be forwarded to the JSP
        request.setAttribute("topSales", rankedResults);
        request.setAttribute("selectedStartDate", startDateStr);
        request.setAttribute("selectedEndDate", endDateStr);
        request.getRequestDispatcher("salesReport.jsp").forward(request, response);
    }
}

