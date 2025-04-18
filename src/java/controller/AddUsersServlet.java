/**
 *
 * @author herman
 */

package controller;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;
import java.nio.file.Paths;
import java.io.*;
import java.math.BigDecimal;
import java.net.URLEncoder;
import java.util.Arrays;
import java.util.HashSet;
import java.util.Set;
import java.util.UUID;
import javax.ejb.EJB;
import model.Item;
import model.ItemDAO;

@WebServlet(name = "AddUsersServlet", urlPatterns = {"/manager/AddUsersServlet", "/staff/AddUsersServlet"})
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, maxFileSize = 1024 * 1024 * 10, maxRequestSize = 1024 * 1024 * 50)
public class AddUsersServlet extends HttpServlet {

    @EJB
    private ItemDAO itemDAO;
    private static final long serialVersionUID = 1L;

    // Helper method to send JSON-formatted response via redirect.
    private void sendJsonResponse(HttpServletRequest request, HttpServletResponse response, boolean success, String message)
            throws IOException {
        // Disable caching
        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        response.setHeader("Pragma", "no-cache");
        response.setDateHeader("Expires", 0);
        
        String servletPath = request.getServletPath();
        String contextPath = request.getContextPath();

        String json = "Success: " + success + ". Message: " + message.replace("\"", "\\\"");
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

        String itemName = request.getParameter("itemName");
        // Validate item name
        if (itemName == null || itemName.trim().isEmpty()) {
            sendJsonResponse(request, response, false, "Item name is required.");
            return;
        }

        if (itemName.length() > 100) {
            sendJsonResponse(request, response, false, "Item name must be less than 100 characters.");
            return;
        }

        String description = request.getParameter("description");
        // Validate description length (if provided)
        if (description != null && description.length() > 1000) {
            sendJsonResponse(request, response, false, "Description must be less than 1000 characters.");
            return;
        }

        double price = Double.parseDouble(request.getParameter("price"));
        int stockQuantity = Integer.parseInt(request.getParameter("stockQuantity"));
        // Validate numeric fields
        if (price < 0) {
            sendJsonResponse(request, response, false, "Price cannot be negative.");
            return;
        }
        if (stockQuantity < 0) {
            sendJsonResponse(request, response, false, "Stock quantity cannot be negative.");
            return;
        }

        String category = request.getParameter("category");
        if ("Others".equals(category)) {
            String customCategory = request.getParameter("customCategory");
            if (customCategory != null && !customCategory.trim().isEmpty()) {
                category = customCategory.trim();
            } else {
                sendJsonResponse(request, response, false, "Custom category not provided.");
                return;
            }
        }

        Part imagePart = request.getPart("image");
        String imageUrl = null;
        Set<String> allowedExtensions = new HashSet<>(Arrays.asList(".jpg", ".jpeg", ".png", ".webp", ".svg"));
        Set<String> allowedMimeTypes = new HashSet<>(Arrays.asList("image/jpeg", "image/png", "image/webp", "image/svg+xml"));

        if (imagePart != null && imagePart.getSize() > 0) {
            try {
                // Retrieve and sanitize the file name
                String originalFileName = Paths.get(imagePart.getSubmittedFileName()).getFileName().toString();
                String lowerFileName = originalFileName.toLowerCase();
                String mimeType = imagePart.getContentType();

                // Validate file type using allowed MIME types and extensions
                if (!allowedMimeTypes.contains(mimeType)) {
                    sendJsonResponse(request, response, false, "Unsupported MIME Type: " + mimeType + ". Only supported image/jpeg, image/png, image/webp, image/svg+xml");
                    return;
                }

                boolean validExtension = allowedExtensions.stream()
                        .anyMatch(lowerFileName::endsWith);

                if (!validExtension) {
                    sendJsonResponse(request, response, false, "Unsupported file extension for file: " + originalFileName + ". Only supported .jpg, .jpeg, .png, .webp, .svg");
                    return;
                }

                // Get extension
                String extension = originalFileName.substring(originalFileName.lastIndexOf("."));

                // Generate unique filename using UUID
                String uniqueFileName = UUID.randomUUID().toString() + extension;

                // Get the deployed path (e.g., C:\NetBeans\HarveyHerman\build\web)
                String deployedPath = getServletContext().getRealPath("");

                // Go up two directories to reach the project root
                File deployedDir = new File(deployedPath);

                File projectRoot = deployedDir.getParentFile().getParentFile(); // Back to C:\NetBeans\HarveyHerman

                // Now build path to web/assets/images
                File targetImageDir = new File(projectRoot, "web/assets/images");

                // Ensure directory exists
                if (!targetImageDir.exists()) {
                    targetImageDir.mkdirs();
                }

                // Final file path
                File fileToSave = new File(targetImageDir, uniqueFileName);

                // Copy file data with a buffered stream
                try (InputStream input = imagePart.getInputStream(); OutputStream out = new FileOutputStream(fileToSave)) {
                    byte[] buffer = new byte[1024];
                    int bytesRead;
                    while ((bytesRead = input.read(buffer)) != -1) {
                        out.write(buffer, 0, bytesRead);
                    }
                }

                // Set the relative path for storing in the database
                imageUrl = "images/" + uniqueFileName;
            } catch (IOException e) {
                sendJsonResponse(request, response, false, "Item's image failed to upload.");
                return;
            }
        }
        
        try {
            Item item = new Item();
            item.setItemId(null);
            item.setName(itemName);
            item.setDescription(description);
            item.setPrice(BigDecimal.valueOf(price));
            item.setStockQuantity(stockQuantity);
            item.setCategory(category);
            item.setImageUrl(imageUrl);

            itemDAO.create(item);
            
            sendJsonResponse(request, response, true, "Item added successfully.");
        } catch (IOException e) {
            sendJsonResponse(request, response, false, "Item failed to add.");
        }
    }

}
