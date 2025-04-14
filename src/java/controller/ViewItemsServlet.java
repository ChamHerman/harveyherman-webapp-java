/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import java.io.IOException;
import java.net.URLEncoder;
import java.text.SimpleDateFormat;
import javax.ejb.EJB;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import model.Item;
import model.ItemDAO;

/**
 *
 * @author herman
 */
@WebServlet(name = "ViewItemsServlet", urlPatterns = {"/manager/ViewItemsServlet, /staff/ViewItemsServlet"})
public class ViewItemsServlet extends HttpServlet {
    
    @EJB
    private ItemDAO itemDAO;
    // Helper method to send JSON response via redirect
    
    private void sendJsonResponse(HttpServletRequest request, HttpServletResponse response, boolean success, String message, String viewData)
            throws IOException {
        String json;
        if (success && viewData != null) {
            json = viewData;
        } else {
            json = "{\"success\": " + success + ", \"message\": \"" + message.replace("\"", "\\\"") + "\"}";
        }
        String encodedMessage = URLEncoder.encode(json, "UTF-8");
        response.sendRedirect(request.getContextPath() + "/manager/ap_item.jsp?viewData=" + encodedMessage);
    }
   
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doPost(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String itemId = request.getParameter("itemId");
        if (itemId == null || itemId.trim().isEmpty()) {
            sendJsonResponse(request, response, false, "Item ID not provided.", null);
            return;
        }

        try {
            Item item = itemDAO.getItemById(itemId);
            if (item == null) {
                sendJsonResponse(request, response, false, "Item not found.", null);
                return;
            }
            // Format dates
            SimpleDateFormat sdf = new SimpleDateFormat("dd MMM yyyy HH:mm:ss");
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
        } catch (IOException e) {
            sendJsonResponse(request, response, false, "Error retrieving item: " + e.getMessage(), null);
        }
    }

}
