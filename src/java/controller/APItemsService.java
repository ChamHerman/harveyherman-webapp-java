package controller;

import java.math.BigDecimal;
import java.util.List;

import model.ItemDAO;
import model.Item;

public class APItemsService {
	public String filterItems(String category, String stock, int rowCount) {
		ItemDAO itemDAO = new ItemDAO();

		List<Item> filteredItems = itemDAO.getFilteredItemsByCategoryAndStock(category, stock);
		List<Item> limitedItems = filteredItems.subList(0, Math.min(rowCount, filteredItems.size()));

		long totalItems = itemDAO.getTotalItemCount();
		long inStock = itemDAO.getInStockItemCount();
		long outOfStock = totalItems - inStock;
		long categories = itemDAO.getCategoryCount();

		StringBuilder tableHtml = new StringBuilder();
		for (Item item : limitedItems) {
			tableHtml.append("<tr>").append("<td><input type='checkbox'></td>").append("<td>").append(item.getName())
					.append("</td>").append("<td>").append(item.getCategory()).append("</td>").append("<td>")
					.append(item.getStockQuantity()).append("</td>").append("<td>RM ").append(item.getPrice())
					.append("</td>").append("<td><button>Edit</button> <button>View</button></td>").append("</tr>");
		}

		String jsonResponse = "{" + "\"itemTable\": \"" + tableHtml.toString().replace("\"", "\\\"") + "\","
				+ "\"totalItems\": " + totalItems + "," + "\"inStock\": " + inStock + "," + "\"outOfStock\": "
				+ outOfStock + "," + "\"categories\": " + categories + "}";
		return jsonResponse;
	}

	public String addItems(String itemName, String description, double price, int stockQuantity, String category,
			String imageUrl) {
		try {
			Item item = new Item();
			item.setItemId(null);
			item.setName(itemName);
			item.setDescription(description);
			item.setPrice(BigDecimal.valueOf(price));
			item.setStockQuantity(stockQuantity);
			item.setCategory(category);
			item.setImageUrl(imageUrl);

			ItemDAO itemDAO = new ItemDAO();
			itemDAO.create(item);

			return "{" + "\"success\": true," + "\"message\": \"Item added successfully.\"" + "}";
		} catch (Exception e) {
			e.printStackTrace();
			return "{" + "\"success\": false," + "\"message\": \"Error adding item: "
					+ e.getMessage().replace("\"", "\\\"") + "\"" + "}";
		}
	}

}
