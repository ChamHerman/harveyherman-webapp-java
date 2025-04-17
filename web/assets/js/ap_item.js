/* global bootstrap */

// To show Item Result Message
window.onload = function () {
    // Define urlParams to retrieve query parameters
    const urlParams = new URLSearchParams(window.location.search);
    
    const messageParam = urlParams.get('message');
    if (messageParam) {
        try {
            const messageObj = JSON.parse(decodeURIComponent(messageParam));
            let formattedMessage = messageObj.message;
            // Optionally add a prefix based on success flag
            if (messageObj.success) {
                formattedMessage = "Success: " + formattedMessage;
            } else {
                formattedMessage = "Error: " + formattedMessage;
            }
            document.getElementById('itemResultMessage').textContent = formattedMessage;
        } catch (e) {
            // Fallback: show plain text if JSON parsing fails
            document.getElementById('itemResultMessage').textContent = decodeURIComponent(messageParam);
        }
        
        // Show the message modal
        const modalElement = document.getElementById('itemResultMessageModal');
        const messageModal = new bootstrap.Modal(modalElement);
        messageModal.show();

        // Clean the URL without the message parameter
        urlParams.delete('message');
        window.history.replaceState({}, document.title, window.location.pathname);
    }
    
    // To show View Item Modal
    const viewDataParam = urlParams.get('viewData');
    if (viewDataParam) {
        try {
            const viewDataObj = JSON.parse(decodeURIComponent(viewDataParam));
            console.log("Received viewData:", viewDataObj);
            if (viewDataObj.success) {
                document.getElementById('viewItemId').textContent = viewDataObj.itemId;
                document.getElementById('viewItemName').textContent = viewDataObj.name;
                document.getElementById('viewItemDescription').textContent = viewDataObj.description;
                document.getElementById('viewItemPrice').textContent = viewDataObj.price;
                document.getElementById('viewItemStock').textContent = viewDataObj.stockQuantity;
                document.getElementById('viewItemCategory').textContent = viewDataObj.category;
                document.getElementById('viewItemCreatedDate').textContent = viewDataObj.createdDate;
                document.getElementById('viewItemUpdatedDate').textContent = viewDataObj.updatedDate;
                if (viewDataObj.imageUrl && viewDataObj.imageUrl !== "") {
                    var imgPath = contextPath + "/assets/" + viewDataObj.imageUrl;
                    // console.log("Debug image path: ", imgPath); - use for debug
                    document.getElementById('viewItemImage').src = imgPath;
                    document.getElementById('viewItemImageUrl').textContent = viewDataObj.imageUrl;
                }
                const modal = new bootstrap.Modal(document.getElementById('viewItemModal'));
                modal.show();
            }
        } catch (e) {
            console.error("Error parsing viewData JSON:", e);
        }
        urlParams.delete('viewData');
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

function viewItem(itemId) {
    console.log("viewItem clicked with itemId: " + itemId);
    console.log("Redirect URL: " + contextPath + "/manager/ViewItemsServlet?itemId=" + itemId);
    window.location.href = contextPath + "/manager/ViewItemsServlet?itemId=" + itemId;
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

// Function to validate add new item form before submission
function validateAddItemForm() {
    var price = parseFloat(document.getElementById("price").value);
    var stockQuantity = parseInt(document.getElementById("stockQuantity").value, 10);
    var maxPrice = 9999999.00;
    var maxStock = 9999999;
    
    if (isNaN(price) || price < 1) {
        alert("Price must be 1 or above.");
        return false;
    }

    if (price > maxPrice) {
        alert("Price must not exceed " + maxPrice + ".");
        return false;
    }

    if (isNaN(stockQuantity) || stockQuantity < 1) {
        alert("Stock Quantity must be 1 or above.");
        return false;
    }

    if (stockQuantity > maxStock) {
        alert("Stock Quantity must not exceed " + maxStock + ".");
        return false;
    }

    var categorySelect = document.getElementById("category");
    if (categorySelect.value === "" || (categorySelect.value === "Others" && document.getElementById("customCategory").value.trim() === "")) {
        alert("Please select a category or enter a custom category if 'Others' is selected.");
        return false;
    }
    
    // Validate that an image is uploaded
    var imageInput = document.getElementById("image");
    if (imageInput.files.length === 0) {
        alert("Please upload an image.");
        return false;
    }
    
    return true;
}