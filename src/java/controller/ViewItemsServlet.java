/**
 *
 * @author herman
 */
package controller;

import java.io.IOException;
import java.net.URLEncoder;
import java.text.SimpleDateFormat;
import java.util.TimeZone;
import javax.ejb.EJB;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import model.Item;
import model.ItemDAO;

@WebServlet(name = "ViewItemsServlet", urlPatterns = {"/manager/ViewItemsServlet", "/staff/ViewItemsServlet"})
public class ViewItemsServlet extends HttpServlet {

    @EJB
    private ItemDAO itemDAO;
    private static final long serialVersionUID = 1L;

    private void sendJsonResponse(HttpServletRequest request, HttpServletResponse response, boolean success, String message, String viewData)
            throws IOException {
        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        response.setHeader("Pragma", "no-cache");
        response.setDateHeader("Expires", 0);

        // Determine which URL pattern was used
        String servletPath = request.getServletPath();
        String contextPath = request.getContextPath();
        String json;
        String encodedMessage;
        if (success && viewData != null) {
            json = viewData;
            encodedMessage = URLEncoder.encode(json, "UTF-8");
            if (servletPath.contains("/manager/")) {
                response.sendRedirect(contextPath + "/manager/ap_item.jsp?viewData=" + encodedMessage);
            } else if (servletPath.contains("/staff/")) {
                response.sendRedirect(contextPath + "/staff/ap_item.jsp?viewData=" + encodedMessage);
            }
        } else {
            json = "Error: " + message.replace("\"", "\\\"");
            encodedMessage = URLEncoder.encode(json, "UTF-8");
            if (servletPath.contains("/manager/")) {
                response.sendRedirect(contextPath + "/manager/ap_item.jsp?message=" + encodedMessage);
            } else if (servletPath.contains("/staff/")) {
                response.sendRedirect(contextPath + "/staff/ap_item.jsp?message=" + encodedMessage);
            }
        }

    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doPost(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String itemId = request.getParameter("itemId");
            if (itemId == null || itemId.trim().isEmpty()) {
                sendJsonResponse(request, response, false, "Item ID not provided.", null);
                return;
            }

            Item item = itemDAO.getItemById(itemId);
            if (item == null) {
                sendJsonResponse(request, response, false, "Item not found.", null);
                return;
            }
            // Format dates
            SimpleDateFormat sdf = new SimpleDateFormat("dd MMM yyyy HH:mm:ss");
            sdf.setTimeZone(TimeZone.getDefault());
            String createdDate = (item.getCreatedDate() != null) ? sdf.format(item.getCreatedDate()) : "";
            String updatedDate = (item.getUpdatedDate() != null) ? sdf.format(item.getUpdatedDate()) : "";
            // Build a JSON string with necessary fields.
            StringBuilder sb = new StringBuilder();
            sb.append("{");
            sb.append("\"success\": true,");
            sb.append("\"itemId\": \"").append(item.getItemId()).append("\",");
            sb.append("\"name\": \"").append(item.getName().replace("\"", "\\\"")).append("\",");
            sb.append("\"description\": \"").append((item.getDescription() != null ? item.getDescription().replace("\"", "\\\"") : "")).append("\",");
            sb.append("\"price\": \"RM ").append(String.format("%.2f", item.getPrice())).append("\",");
            sb.append("\"stockQuantity\": \"").append(item.getStockQuantity()).append("\",");
            sb.append("\"category\": \"").append(item.getCategory() != null ? item.getCategory().replace("\"", "\\\"") : "").append("\",");
            sb.append("\"createdDate\": \"").append(createdDate).append("\",");
            sb.append("\"updatedDate\": \"").append(updatedDate).append("\",");
            sb.append("\"imageUrl\": \"").append(item.getImageUrl() != null ? item.getImageUrl().replace("\"", "\\\"") : "").append("\"");
            sb.append("}");
            sendJsonResponse(request, response, true, null, sb.toString());
        } catch (Exception ex) {
            ex.printStackTrace();
            sendJsonResponse(request, response, false, "Error retrieving item: " + ex.getMessage(), null);
        }
    }

}
