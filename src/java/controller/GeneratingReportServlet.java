/**
 *
 * @author kaisheng
 */
package controller;

import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.*;
import java.time.LocalDate;
import java.time.ZoneId;
import java.util.Date;

@WebServlet(name="GeneratingReportServlet",urlPatterns={"/manager/GeneratingReportServlet"})
public class GeneratingReportServlet extends HttpServlet {
    
    @PersistenceContext(unitName = "HarveyHermanPU")
    private EntityManager em;
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String servletPath = request.getServletPath();
        String contextPath = request.getContextPath();
       
        String startDateStr = request.getParameter("startDateR");
        String endDateStr = request.getParameter("endDateR");
        String reportType= request.getParameter("reportType");
        
        if(reportType.equals("day")){
            reportType="Daily Sales";
        }else if(reportType.equals("month")){
            reportType="Monthly Sales";
        }else if(reportType.equals("year")){
            reportType="Yearly Sales";
        }
        
        if (startDateStr == null || endDateStr == null || startDateStr.isEmpty() || endDateStr.isEmpty()) {
            request.setAttribute("errorReportSaleFormDate", "Please enter both start and end dates.");
            request.getRequestDispatcher(request.getContextPath() + "/manager/generatingReport.jsp").forward(request, response);
            return;
        }
        LocalDate lastDate =LocalDate.parse(endDateStr);
        LocalDate startDate = LocalDate.parse(startDateStr);
        LocalDate endDate = LocalDate.parse(endDateStr).plusDays(1);
        
        if(reportType.equals("Daily Sales")){
            lastDate = LocalDate.parse(endDateStr).minusDays(1);
        }else if(reportType.equals("Monthly Sales")){
            lastDate = LocalDate.parse(endDateStr).minusMonths(1);
        }else if(reportType.equals("Yearly Sales")){
            lastDate = LocalDate.parse(endDateStr).minusYears(1);
        }
       
        Date lastDateConverted = java.util.Date.from(lastDate.atStartOfDay(ZoneId.systemDefault()).toInstant());
        Date startDateConverted = java.util.Date.from(startDate.atStartOfDay(ZoneId.systemDefault()).toInstant());
        Date endDateConverted = java.util.Date.from(endDate.atStartOfDay(ZoneId.systemDefault()).toInstant());
        
        List<Object[]> query = em.createQuery(
                "SELECT i.itemId, i.name, i.price, SUM(od.quantity), SUM(od.quantity * i.price) " +
                "FROM OrderDetails od " +
                "JOIN od.itemId i " +
                "JOIN od.orderId o " +
                "WHERE o.createdDate BETWEEN :startDateR AND :endDateR " +
                "GROUP BY i.itemId, i.name, i.price " +
                "ORDER BY i.itemId", Object[].class)
                .setParameter("startDateR", startDateConverted)
                .setParameter("endDateR", endDateConverted)
                .getResultList();
        List<Object[]> reportResults = new ArrayList<>();
        
        int no = 1;
        for (Object[] row : query) {
            // Add rank as the first element in each array
            reportResults.add(new Object[]{no++, row[0], row[1], row[2],row[3],row[4]});
        }
        
        request.setAttribute("reportSales",reportResults);
        request.setAttribute("reportType",reportType);
        request.setAttribute("selectedStartDateR", startDateStr);
        request.setAttribute("selectedEndDateR", endDateStr);
        request.getRequestDispatcher("generatingReport.jsp").forward(request, response);
        
        if (servletPath.contains("/manager/")) {
            request.getRequestDispatcher("/manager/generatingReport.jsp").forward(request, response);
        }
    }
}