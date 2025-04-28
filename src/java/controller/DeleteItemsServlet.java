/**
 *
 * @author herman
 */
package controller;

import java.io.File;
import javax.ejb.EJB;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.net.URLEncoder;
import model.Item;
import model.ItemDAO;

@WebServlet("/manager/DeleteItemsServlet")
public class DeleteItemsServlet extends HttpServlet {

    @EJB
    private ItemDAO itemDAO;
    private static final long serialVersionUID = 1L;

    private void sendJsonResponse(HttpServletRequest request, HttpServletResponse response, boolean success, String message)
            throws IOException {
        // Disable caching
        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        response.setHeader("Pragma", "no-cache");
        response.setDateHeader("Expires", 0);

        String contextPath = request.getContextPath();
        String json;

        if (success) {
            json = "Message: " + message.replace("\"", "\\\"");
        } else {
            json = "Error: " + message.replace("\"", "\\\"");
        }

        String encodedMessage = URLEncoder.encode(json, "UTF-8");
        response.sendRedirect(contextPath + "/manager/ap_item.jsp?message=" + encodedMessage);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String itemId = request.getParameter("itemId");
            if (itemId == null || itemId.trim().isEmpty()) {
                sendJsonResponse(request, response, false, "Item ID not provided.");
                return;
            }

            Item item = itemDAO.getItemById(itemId);
            if (item != null && item.getImageUrl() != null && !item.getImageUrl().isEmpty()) {
                // Extract filename from the stored imageUrl (assumes format: images/filename)
                String fileName = item.getImageUrl().substring("images/".length());
                // Get the deployed path (e.g., C:\NetBeans\HarveyHerman\build\web)
                String deployedPath = getServletContext().getRealPath("");
                File deployedDir = new File(deployedPath);
                // Navigate back two directories to reach the project root (e.g., C:\NetBeans\HarveyHerman)
                File projectRoot = deployedDir.getParentFile().getParentFile();
                // Build the path to \web\assets\images
                File targetImageDir = new File(projectRoot, "web/assets/images");
                // Construct the file reference
                File imageFile = new File(targetImageDir, fileName);
                if (imageFile.exists() && !imageFile.delete()) {
                    throw new ServletException("Failed to delete image file. Path: " + imageFile.getAbsolutePath());
                }
            }
            // Soft delete item
            itemDAO.delete(itemId);
            sendJsonResponse(request, response, true, "Item deleted successfully.");
        } catch (Exception ex) {
            ex.printStackTrace();
            sendJsonResponse(request, response, false, "Item failed to delete. Exception: " + ex.getMessage());
        }
    }
}
