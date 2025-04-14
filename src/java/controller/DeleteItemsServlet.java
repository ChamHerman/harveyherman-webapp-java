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

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doPost(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String itemId = request.getParameter("itemId");
        String message;
        try {
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
                    throw new ServletException("Failed to delete image file: " + imageFile.getAbsolutePath());
                }
            }
            itemDAO.delete(itemId);
            message = "Item deleted successfully.";
            String encodedMessage = URLEncoder.encode(message, "UTF-8");
            response.sendRedirect(request.getContextPath() + "/manager/ap_item.jsp?message=" + encodedMessage);
        } catch (IOException | ServletException ex) {
            message = "Item failed to delete.";
            String encodedMessage = URLEncoder.encode(message, "UTF-8");
            response.sendRedirect(request.getContextPath() + "/manager/ap_item.jsp?message=" + encodedMessage);
            //request.setAttribute("errorMessage", "Error deleting item: " + ex.getMessage());
            //request.getRequestDispatcher(request.getContextPath() + "/manager/error.jsp").forward(request, response);
        }
    }
}
