// Function to filter items based on category, stock, and row count
function filterItems() {
	var category = document.getElementById("categoryFilter").value;
	var stock = document.getElementById("stockFilter").value;
	var rowCount = document.getElementById("rowCount").value;

	fetch("FilterItemsServlet?category=" + encodeURIComponent(category) + "&stock=" + encodeURIComponent(stock) + "&rows=" + encodeURIComponent(rowCount))
		.then(response => response.json())
		.then(data => {
			// Update the item table
			document.querySelector(".item-table tbody").innerHTML = data.itemTable;

			// Update summary statistics
			document.querySelector(".summary-box:nth-child(1)").textContent = "Total Items: " + data.totalItems;
			document.querySelector(".summary-box:nth-child(2)").textContent = "In Stock: " + data.inStock;
			document.querySelector(".summary-box:nth-child(3)").textContent = "Out of Stock: " + data.outOfStock;
			document.querySelector(".summary-box:nth-child(4)").textContent = "Categories: " + data.categories;
		})
		.catch(error => console.error('Error:', error));
}

// Function to toggle the display of custom category field when "Others" is selected
function toggleCustomCategory() {
	var categorySelect = document.getElementById("category");
	var customCategoryDiv = document.getElementById("customCategoryDiv");
	if (categorySelect.value === "Others") {
		customCategoryDiv.style.display = "block";
	} else {
		customCategoryDiv.style.display = "none";
		document.getElementById("customCategory").value = "";
	}
}

// Function to validate the add item form before submission
function validateAddItemForm() {
	var price = parseFloat(document.getElementById("price").value);
	var stockQuantity = parseInt(document.getElementById("stockQuantity").value, 10);
	if (price < 0) {
		alert("Price must be 0 or above.");
		return false;
	}
	if (stockQuantity < 0) {
		alert("Stock Quantity must be 0 or above.");
		return false;
	}

	var categorySelect = document.getElementById("category");
	if (categorySelect.value === "" || (categorySelect.value === "Others" && document.getElementById("customCategory").value.trim() === "")) {
		alert("Please select a category or enter a custom category if 'Others' is selected.");
		return false;
	}
	return true;
}

// Ensure the filtering happens on page load and on filter change
document.addEventListener("DOMContentLoaded", function() {
	filterItems(); // Call once on page load

	// Add event listeners for filtering
	document.getElementById("categoryFilter").addEventListener("change", filterItems);
	document.getElementById("stockFilter").addEventListener("change", filterItems);
	document.getElementById("rowCount").addEventListener("change", filterItems);
});
