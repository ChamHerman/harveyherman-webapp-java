/**
 *
 * @author herman
 */
package controller;

import model.StaffData;
import model.StaffDataDAO;
import javax.ejb.EJB;
import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.*;
import java.io.IOException;

@WebFilter(urlPatterns = {"/manager/*", "/staff/*"})
public class StaffNameFilter implements Filter {
    
    @EJB
    private StaffDataDAO staffDataDAO;

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        HttpSession session = req.getSession(false);
        String staffId = null;
        if (session != null) {
            staffId = (String) session.getAttribute("staffId");
            if (staffId == null) {
                staffId = (String) session.getAttribute("managerId");
            }
        }
        String staffName = "Profile";
        if (staffId != null) {
            StaffData staffData = staffDataDAO.findByStaffId(staffId);
            if (staffData != null) {
                staffName = staffData.getFullname();
            }
        }
        request.setAttribute("staffName", staffName);
        chain.doFilter(request, response);
    }
}
