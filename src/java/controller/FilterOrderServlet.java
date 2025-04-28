/**
 *
 * @author kaibin
 */
package controller;

import java.io.IOException;
import java.util.List;
import javax.ejb.EJB;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import model.OrderDAO;
import model.Orders;

@WebServlet(name = "FilterOrderServlet", urlPatterns = {"/manager/FilterOrderServlet", "/staff/FilterOrderServlet"})
public class FilterOrderServlet extends HttpServlet {

    @EJB
    private OrderDAO orderDAO;
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String status = request.getParameter("status");
        HttpSession session = request.getSession();
        // Store filter in session
        session.setAttribute("orderStatusFilter", status);
        // Clear filter if requested
        if ("1".equals(request.getParameter("clearFilter"))) {
            session.removeAttribute("orderStatusFilter");
//            session.removeAttribute("filteredOrders");
            session.setAttribute("filteredOrders", orderDAO.getAllOrders());
        }
        List<Orders> filteredOrders = filterOrdersByStatus(status);
        session.setAttribute("filteredOrders", filteredOrders);
        String servletPath = request.getServletPath();
        if (servletPath.contains("/manager/")) {
            response.sendRedirect(request.getContextPath() + "/manager/ap_order.jsp");
        } else if (servletPath.contains("/staff/")) {
            response.sendRedirect(request.getContextPath() + "/staff/ap_order.jsp");
        }
    }

    private List<Orders> filterOrdersByStatus(String status) {
        if (status == null || status.isEmpty()) {
            return orderDAO.getAllOrders();
        } else {
            return orderDAO.filterOrderByStatus(status);
        }
    }
}
