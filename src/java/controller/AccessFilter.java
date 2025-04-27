/**
 *
 * @author weikang
 */
package controller;

import java.io.IOException;
import java.util.Arrays;
import java.util.List;
import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import model.StaffData;
import model.UserData;

@WebFilter(filterName = "AccessFilter", urlPatterns = {"/*"})
public class AccessFilter implements Filter {

    private FilterConfig filterConfig = null;

    // Define paths that should be excluded from authentication checks
    private final List<String> publicPaths = Arrays.asList(
            "/staff/ap_login.jsp",
            "/staff/StaffLoginServlet",
            "/user/about.jsp",
            "/user/challengeQuestion.jsp",
            "/user/contact.jsp",
            "/user/footer.jsp",
            "/user/head.jsp",
            "/user/header.jsp",
            "/user/index.jsp",
            "/user/item.jsp",
            "/user/itemDetails.jsp",
            "/user/login.jsp",
            "/user/register.jsp",
            "/user/resetPassword.jsp",
            "/user/services.jsp",
            "/user/details",
            "/user/ResetPasswordServlet",
            "/user/UserLoginServlet",
            "/user/UserRegisterServlet",
            "/user/VerifyChallengeServlet",
            "/user/privacyPolicy.jsp",
            "/user/termsConditions.jsp"
    );

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpSession session = httpRequest.getSession(false);

        String contextPath = httpRequest.getContextPath();
        String requestURI = httpRequest.getRequestURI();
        String relativePath = requestURI.substring(contextPath.length());

        // Check if the current path should be publicly accessible
        if (isPublicPath(relativePath)) {
            // Allow access to public resources without authentication
            chain.doFilter(request, response);
            return;
        }

        if (relativePath.startsWith("/manager/")) {
            boolean isLoggedInAsManager = false;

            if (session != null) {
                StaffData managerData = (StaffData) session.getAttribute("loggedInManager");
                if (managerData != null) {
                    isLoggedInAsManager = true;
                }
            }

            if (!isLoggedInAsManager) {
                httpResponse.sendRedirect(contextPath + "/staff/ap_login.jsp");
                return;
            }
        }

        if (relativePath.startsWith("/staff/")) {
            boolean isLoggedInAsStaff = false;

            if (session != null) {
                StaffData staffData = (StaffData) session.getAttribute("loggedInStaff");
                if (staffData != null) {
                    isLoggedInAsStaff = true;
                }
            }

            if (!isLoggedInAsStaff) {
                httpResponse.sendRedirect(contextPath + "/staff/ap_login.jsp");
                return;
            }
        }

        if (relativePath.startsWith("/user/")) {
            boolean isLoggedInAsUser = false;

            if (session != null) {
                UserData userData = (UserData) session.getAttribute("loggedInUser");
                if (userData != null) {
                    isLoggedInAsUser = true;
                }
            }

            if (!isLoggedInAsUser) {
                httpResponse.sendRedirect(contextPath + "/user/login.jsp");
                return;
            }
        }

        chain.doFilter(request, response);
    }

    /**
     * Check if the requested path should be publicly accessible
     *
     * @param path The relative path to check
     * @return true if the path should be accessible without authentication
     */
    private boolean isPublicPath(String path) {
        // First check exact matches
        if (publicPaths.contains(path)) {
            return true;
        }

        // Then check if the path starts with any of our public path prefixes
        for (String publicPath : publicPaths) {
            if (publicPath.endsWith("/") && path.startsWith(publicPath)) {
                return true;
            }
        }

        return false;
    }

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        this.filterConfig = filterConfig;
    }

    @Override
    public void destroy() {
        filterConfig = null;
    }
}
