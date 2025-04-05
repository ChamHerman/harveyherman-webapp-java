// Function to filter items based on category, stock, and row count
function filterItems() {
    var category = document.getElementById("categoryFilter").value;
    var stock = document.getElementById("stockFilter").value;
    var rowCount = document.getElementById("rowCount").value;
    var search = document.getElementById("searchInput").value;

    fetch("FilterItemsServlet?category=" + encodeURIComponent(category)
            + "&stock=" + encodeURIComponent(stock)
            + "&rows=" + encodeURIComponent(rowCount)
            + "&search=" + encodeURIComponent(search))
            .then(response => {
                if (!response.ok) {
                    throw new Error("Network response was not ok: " + response.statusText);
                }
                return response.json();
            })
            .then(data => {
                console.log("AJAX response:", data);
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
document.addEventListener("DOMContentLoaded", function () {
    // Delete event delegation on table body
    document.querySelector(".item-table tbody").addEventListener("click", function (e) {
        if (e.target && e.target.classList.contains("delete-btn")) {
            var confirmDelete = confirm("Are you sure you want to delete this item?");
            if (confirmDelete) {
                var itemId = e.target.getAttribute("data-itemid");
                fetch("DeleteItemServlet", {
                    method: "POST",
                    headers: {
                        "Content-Type": "application/x-www-form-urlencoded"
                    },
                    body: "itemId=" + encodeURIComponent(itemId)
                })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        // Reload filtered items after deletion
                        filterItems();
                    } else {
                        alert("Delete failed: " + data.message);
                    }
                })
                .catch(error => console.error("Error:", error));
            }
        }
    });
    
    filterItems(); // Call once on page load

    // Event listeners for filtering
    document.getElementById("categoryFilter").addEventListener("change", filterItems);
    document.getElementById("stockFilter").addEventListener("change", filterItems);
    document.getElementById("rowCount").addEventListener("change", filterItems);
    document.getElementById("searchInput").addEventListener("keyup", filterItems);
});