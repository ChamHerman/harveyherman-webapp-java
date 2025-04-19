/**
 *
 * @author herman
 */
package controller;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.math.BigDecimal;
import java.net.URLEncoder;
import java.util.Arrays;
import java.util.HashSet;
import java.util.Set;
import java.util.UUID;
import javax.ejb.EJB;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;
import model.Item;
import model.ItemDAO;

@WebServlet(name = "EditItemsServlet", urlPatterns = {"/manager/EditItemsServlet", "/staff/EditItemsServlet"})
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, maxFileSize = 1024 * 1024 * 10, maxRequestSize = 1024 * 1024 * 50)
public class EditItemsServlet extends HttpServlet {

    @EJB
    private ItemDAO itemDAO;
    private static final long serialVersionUID = 1L;

    private void sendJsonResponse(HttpServletRequest request, HttpServletResponse response, boolean success, String message)
            throws IOException {
        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        response.setHeader("Pragma", "no-cache");
        response.setDateHeader("Expires", 0);

        // Determine which URL pattern was used
        String servletPath = request.getServletPath();
        String contextPath = request.getContextPath();
        String json;
        
        if (success) {
            json = "MESSAGE: " + message.replace("\"", "\\\"");
        } else {
            json = "ERROR: " + message.replace("\"", "\\\"");
        }
        
        String encodedMessage = URLEncoder.encode(json, "UTF-8");
        if (servletPath.contains("/manager/")) {
            response.sendRedirect(contextPath + "/manager/ap_item.jsp?message=" + encodedMessage);
        } else if (servletPath.contains("/staff/")) {
            response.sendRedirect(contextPath + "/staff/ap_item.jsp?message=" + encodedMessage);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        String itemId = request.getParameter("itemId");
        if (itemId == null || itemId.trim().isEmpty()) {
            sendJsonResponse(request, response, false, "Item ID is required.");
            return;
        }
        Item item = itemDAO.getItemById(itemId);
        if (item == null) {
            sendJsonResponse(request, response, false, "Item not found.");
            return;
        }

        String itemName = request.getParameter("itemName");
        if (itemName == null || itemName.trim().isEmpty() || itemName.length() > 100) {
            sendJsonResponse(request, response, false, "Invalid item name.");
            return;
        }
        item.setName(itemName);

        String description = request.getParameter("description");
        if (description != null && description.length() > 1000) {
            sendJsonResponse(request, response, false, "Description must be less than 1000 characters.");
            return;
        }
        item.setDescription(description);

        double price;
        try {
            price = Double.parseDouble(request.getParameter("price"));
        } catch (NumberFormatException ex) {
            sendJsonResponse(request, response, false, "Price must be a valid number.");
            return;
        }
        if (price < 1) {
            sendJsonResponse(request, response, false, "Price must be 1 or above.");
            return;
        }
        item.setPrice(BigDecimal.valueOf(price));

        int stockQuantity;
        try {
            stockQuantity = Integer.parseInt(request.getParameter("stockQuantity"));
        } catch (NumberFormatException ex) {
            sendJsonResponse(request, response, false, "Stock quantity must be a valid number.");
            return;
        }
        if (stockQuantity < 1) {
            sendJsonResponse(request, response, false, "Stock quantity must be 1 or above.");
            return;
        }
        item.setStockQuantity(stockQuantity);

        String category = request.getParameter("category");
        if (category == null || category.trim().isEmpty()) {
            sendJsonResponse(request, response, false, "Category is required.");
            return;
        }
        if ("Others".equals(category)) {
            String customCategory = request.getParameter("customCategory");
            if (customCategory != null && !customCategory.trim().isEmpty()) {
                category = customCategory.trim();
            } else {
                sendJsonResponse(request, response, false, "Custom category not provided.");
                return;
            }
        }
        item.setCategory(category);

        // Process new image upload if provided
        Part imagePart = request.getPart("image");
        if (imagePart != null && imagePart.getSize() > 0) {

            // Delete old image if exists
            if (item.getImageUrl() != null && !item.getImageUrl().isEmpty()) {
                // Extract filename from stored imageUrl (assumes format: images/filename)
                String oldFileName = item.getImageUrl().substring("images/".length());
                // Get the deployed path (e.g., C:\NetBeans\HarveyHerman\build\web)
                String deployedPath = getServletContext().getRealPath("");
                // Navigate back two directories to reach the project root (e.g., C:\NetBeans\HarveyHerman)
                File deployedDir = new File(deployedPath);
                File projectRoot = deployedDir.getParentFile().getParentFile();
                // Build the path to web/assets/images
                File targetImageDir = new File(projectRoot, "web/assets/images");
                // Construct file reference for deletion
                File oldImageFile = new File(targetImageDir, oldFileName);
                if (oldImageFile.exists() && !oldImageFile.delete()) {
                    sendJsonResponse(request, response, false, "Failed to delete previous image file.");
                    return;
                }
            }
            
            // Do the same thing in AddItemsServlet
            // Used for saving new item image into the correct folder
            Set<String> allowedExtensions = new HashSet<>(Arrays.asList(".jpg", ".jpeg", ".png", ".webp", ".svg"));
            Set<String> allowedMimeTypes = new HashSet<>(Arrays.asList(
                    "image/jpeg",
                    "image/png",
                    "image/webp",
                    "image/svg+xml"
            ));
            String originalFileName = imagePart.getSubmittedFileName();
            String lowerFileName = originalFileName.toLowerCase();
            String mimeType = imagePart.getContentType();
            if (!allowedMimeTypes.contains(mimeType)) {
                sendJsonResponse(request, response, false, "Unsupported MIME type: " + mimeType);
                return;
            }
            boolean validExtension = allowedExtensions.stream().anyMatch(lowerFileName::endsWith);
            if (!validExtension) {
                sendJsonResponse(request, response, false, "Unsupported file extension for file: " + originalFileName);
                return;
            }
            String extension = originalFileName.substring(originalFileName.lastIndexOf("."));
            String uniqueFileName = UUID.randomUUID().toString() + extension;
            String deployedPath = getServletContext().getRealPath("");
            File deployedDir = new File(deployedPath);
            File projectRoot = deployedDir.getParentFile().getParentFile();
            File targetImageDir = new File(projectRoot, "web/assets/images");
            if (!targetImageDir.exists()) {
                targetImageDir.mkdirs();
            }
            File fileToSave = new File(targetImageDir, uniqueFileName);
            try (InputStream input = imagePart.getInputStream(); OutputStream out = new FileOutputStream(fileToSave)) {
                byte[] buffer = new byte[1024];
                int bytesRead;
                while ((bytesRead = input.read(buffer)) != -1) {
                    out.write(buffer, 0, bytesRead);
                }
            }
            item.setImageUrl("images/" + uniqueFileName);
        }

        try {
            itemDAO.update(item);
            sendJsonResponse(request, response, true, "Item updated successfully.");
        } catch (IOException ex) {
            sendJsonResponse(request, response, true, "Item failed to update.");
        }
    }
}
