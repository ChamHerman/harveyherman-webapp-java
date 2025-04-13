window.onload = function () {
    // Define urlParams to retrieve query parameters
    const urlParams = new URLSearchParams(window.location.search);
    const message = urlParams.get('message');
    if (message) {
        // Set the message into the modal's body
        document.getElementById('deleteSuccessMessage').textContent = message;
        // Initialize and show the Bootstrap modal
        const modalElement = document.getElementById('deleteSuccessModal');
        const deleteSuccessModal = new bootstrap.Modal(modalElement);
        deleteSuccessModal.show();

        // Clean the URL without the message parameter
        urlParams.delete('message');
        window.history.replaceState({}, document.title, window.location.pathname);
    }
};


document.getElementById('clearSearch').addEventListener('click', function () {
    document.getElementById('searchInput').value = '';
});

var deleteItemId;
var deleteItemModal = document.getElementById('deleteItemModal');
deleteItemModal.addEventListener('show.bs.modal', function (event) {
    var button = event.relatedTarget;
    deleteItemId = button.getAttribute('data-itemid');
});

document.getElementById('confirmDelete').addEventListener('click', function () {
    window.location.href = contextPath + '/manager/DeleteItemsServlet?itemId=' + deleteItemId;
});

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

// Validate the add item form before submission
function validateAddItemForm() {
    var price = parseFloat(document.getElementById("price").value);
    var stockQuantity = parseInt(document.getElementById("stockQuantity").value, 10);
    if (price < 1) {
        alert("Price must be 1 or above.");
        return false;
    }
    if (stockQuantity < 1) {
        alert("Stock Quantity must be 1 or above.");
        return false;
    }

    var categorySelect = document.getElementById("category");
    if (categorySelect.value === "" || (categorySelect.value === "Others" && document.getElementById("customCategory").value.trim() === "")) {
        alert("Please select a category or enter a custom category if 'Others' is selected.");
        return false;
    }
    return true;
}
