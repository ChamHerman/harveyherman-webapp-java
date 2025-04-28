/**
 *
 * @author kaisheng
 */
package controller;

import java.io.IOException;
import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.util.Date;
import javax.ejb.EJB;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import model.Report;
import model.ReportDAO;

@WebServlet(name="AddReportServlet",urlPatterns={"/manager/AddReportServlet"})//,"/staff/AddReportServlet"
public class AddReportServlet extends HttpServlet {
    @EJB
    private ReportDAO reportDAO;
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String servletPath = request.getServletPath();
        String contextPath = request.getContextPath();

        try {
            String id=request.getParameter("reportID");
            
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            Date reportDate = request.getParameter("reportDate").isEmpty() ? null : sdf.parse(request.getParameter("reportDate"));
            
            String reportType = request.getParameter("reportType");
            BigDecimal sales = new BigDecimal(request.getParameter("totalSalesDisplay"));
            String desc = request.getParameter("description");
            String dbstatus="active";

            Report report = new Report();
            report.setReportId(id);
            report.setReportDate(reportDate);
            report.setReportType(reportType);
            report.setTotalSales(sales);
            report.setDescription(desc);
            report.setDbstatus(dbstatus);

            reportDAO.addReport(report);
            
            if (!id.equals(null)) {
                request.setAttribute("successMessage", "Report added successfully! ID: "+ id);
            } else {
                request.setAttribute("errorMessage", "Failed to add Report.");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        if (servletPath.contains("/manager/")) {
            request.getRequestDispatcher("/manager/generatingReport.jsp?message=Report has been added").forward(request, response);
        } //else if (servletPath.contains("/staff/")) {
          //  response.sendRedirect(contextPath + "/staff/generatingReport.jsp?message=Report has been added");
        //}
    }
}