/**
 *
 * @author kaisheng
 */
package controller;

import model.ReportDAO;
import javax.ejb.EJB;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import javax.servlet.ServletException;
import java.io.IOException;

@WebServlet(name="DeleteReportServlet",urlPatterns={"/manager/DeleteReportServlet"})
public class DeleteReportServlet extends HttpServlet {

    @EJB
    private ReportDAO reportDAO;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String servletPath = request.getServletPath();
        String contextPath = request.getContextPath();
        
        String id = request.getParameter("reportId");
        boolean yes = reportDAO.deleteReport(id);
        
        if (yes) {
            request.setAttribute("successMessage", "Report deleted successfully! ID:"+id);
        } else {
            request.setAttribute("errorMessage", "Failed to delete report. ID may not exist.");
        }
        
        if (servletPath.contains("/manager/")) {
            request.getRequestDispatcher("/manager/viewHistoryReport.jsp?message=Report has been deleted").forward(request, response);
        }
    }
}
