/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
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


@WebServlet("/AddItemsServlet")
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, maxFileSize = 1024 * 1024 * 10, maxRequestSize = 1024 * 1024 * 50)
public class AddItemsServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

        @Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");

		String itemName = request.getParameter("itemName");
		// Validate item name
		if (itemName == null || itemName.trim().isEmpty()) {
			throw new ServletException("Item name is required.");
		}
		if (itemName.length() > 100) {
			throw new ServletException("Item name must be less than 100 characters.");
		}

		String description = request.getParameter("description");
		// Validate description length (if provided)
		if (description != null && description.length() > 1000) {
			throw new ServletException("Description must be less than 1000 characters.");
		}

		double price = Double.parseDouble(request.getParameter("price"));
		int stockQuantity = Integer.parseInt(request.getParameter("stockQuantity"));
		// Validate numeric fields
		if (price < 0) {
			throw new ServletException("Price cannot be negative.");
		}
		if (stockQuantity < 0) {
			throw new ServletException("Stock quantity cannot be negative.");
		}

		String category = request.getParameter("category");
		if ("Others".equals(category)) {
			String customCategory = request.getParameter("customCategory");
			if (customCategory != null && !customCategory.trim().isEmpty()) {
				category = customCategory.trim();
			} else {
				throw new ServletException("Custom category not provided.");
			}
		}

		Part imagePart = request.getPart("image");
		String imageUrl = null;

		if (imagePart != null && imagePart.getSize() > 0) {
			try {
				// Retrieve and sanitize the file name
				String fileName = Paths.get(imagePart.getSubmittedFileName()).getFileName().toString();
				String lowerFileName = fileName.toLowerCase();

				// Validate file extension (allow only jpg, jpeg, and png)
				if (!lowerFileName.endsWith(".jpg") && !lowerFileName.endsWith(".jpeg")
						&& !lowerFileName.endsWith(".png")) {
					throw new ServletException("Unsupported file type.");
				}

				// Resolve the absolute path for the upload directory using the servlet context
				String absolutePath = getServletContext().getRealPath("");
				if (absolutePath == null) {
					throw new ServletException("Could not get the context real path.");
				}
				String uploadDir = absolutePath + File.separator + "assets" + File.separator + "images";

				// Create the upload directory if it does not exist
				File uploadDirFile = new File(uploadDir);
				if (!uploadDirFile.exists() && !uploadDirFile.mkdirs()) {
					throw new ServletException("Failed to create upload directory.");
				}

				// Create the file path to store the image
				File fileToSave = new File(uploadDirFile, fileName);

				// Copy file data with a buffered stream
				try (InputStream input = imagePart.getInputStream();
						OutputStream out = new FileOutputStream(fileToSave)) {
					byte[] buffer = new byte[1024];
					int bytesRead;
					while ((bytesRead = input.read(buffer)) != -1) {
						out.write(buffer, 0, bytesRead);
					}
				}

				// Set the relative path for storing in the database
				imageUrl = "assets/images/" + fileName;
			} catch (Exception e) {
				e.printStackTrace();
				response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
				response.getWriter().write("{\"success\": false, \"message\": \"Error uploading image.\"}");
				return;
			}
		}

		APItemsService service = new APItemsService();
		String jsonResponse = service.addItems(itemName, description, price, stockQuantity, category, imageUrl);

		response.setContentType("application/json");
		response.getWriter().write(jsonResponse);
	}
}