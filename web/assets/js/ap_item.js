/* global bootstrap */

// To show Item Result Message
window.onload = function () {
    // Define urlParams to retrieve query parameters
    const urlParams = new URLSearchParams(window.location.search);

    const messageParam = urlParams.get('message');
    if (messageParam) {
        // Show loading modal first
        const loadingModalElement = document.getElementById('loadingModal');
        const loadingModal = new bootstrap.Modal(loadingModalElement);
        loadingModal.show();

        setTimeout(function () {
            // Hide loading modal
            loadingModal.hide();

            // Prepare and show the result message modal
            try {
                const messageObj = JSON.parse(decodeURIComponent(messageParam));
                let formattedMessage = messageObj.message;
                if (messageObj.success) {
                    formattedMessage = "Success: " + formattedMessage;
                } else {
                    formattedMessage = "Error: " + formattedMessage;
                }
                document.getElementById('itemResultMessage').textContent = formattedMessage;
            } catch (e) {
                document.getElementById('itemResultMessage').textContent = decodeURIComponent(messageParam);
            }

            const modalElement = document.getElementById('itemResultMessageModal');
            const messageModal = new bootstrap.Modal(modalElement);
            messageModal.show();

            // Clean the URL without the message parameter
            urlParams.delete('message');
            window.history.replaceState({}, document.title, window.location.pathname);
        }, 500); // 0.5 second delay
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

document.addEventListener('DOMContentLoaded', function () {
    var clearSearch = document.getElementById('clearSearch');
    if (clearSearch) {
        clearSearch.addEventListener('click', function () {
            var searchInput = document.getElementById('searchInput');
            if (searchInput) {
                searchInput.value = '';
            }
        });
    }

    var addImageUploadArea = document.getElementById("addImageUploadArea");
    var addImageInput = document.getElementById("addImageInput");
    var addItemImagePreview = document.getElementById("addItemImagePreview");
    var addUploadOverlay = document.getElementById("addUploadOverlay");

    if (addImageUploadArea && addImageInput && addItemImagePreview && addUploadOverlay) {
        // Click area triggers file input
        addImageUploadArea.addEventListener("click", function () {
            addImageInput.click();
        });

        // Hover overlay
        addImageUploadArea.addEventListener("mouseenter", function () {
            addUploadOverlay.style.opacity = "1";
        });
        addImageUploadArea.addEventListener("mouseleave", function () {
            addUploadOverlay.style.opacity = "0";
        });

        // Preview new image
        addImageInput.addEventListener("change", function () {
            if (this.files && this.files[0]) {
                var reader = new FileReader();
                reader.onload = function (e) {
                    addItemImagePreview.src = e.target.result;
                };
                reader.readAsDataURL(this.files[0]);
            }
        });
    }

    var imageUploadArea = document.getElementById("imageUploadArea");
    var imageInput = document.getElementById("imageInput");
    var newImagePreview = document.getElementById("newItemImagePreview");
    var uploadHint = document.getElementById("uploadHint");

    if (imageUploadArea && imageInput && newImagePreview) {
        // Click area triggers file input
        imageUploadArea.addEventListener("click", function () {
            imageInput.click();
        });

        // Hover effect for hint
        imageUploadArea.addEventListener("mouseenter", function () {
            uploadHint.textContent = "Click to select a new image";
        });
        imageUploadArea.addEventListener("mouseleave", function () {
            uploadHint.textContent = "Click here to upload new image";
        });

        // Preview new image
        imageInput.addEventListener("change", function () {
            if (this.files && this.files[0]) {
                var reader = new FileReader();
                reader.onload = function (e) {
                    newImagePreview.src = e.target.result;
                    newImagePreview.style.opacity = "1";
                    uploadHint.textContent = "New image selected";
                };
                reader.readAsDataURL(this.files[0]);
            }
        });
    }

});

var deleteItemModal = document.getElementById('deleteItemModal');
deleteItemModal.addEventListener('show.bs.modal', function (event) {
    var button = event.relatedTarget;
    var itemId = button.getAttribute('data-itemid');
    document.getElementById('deleteModalItemId').value = itemId;
});

function viewItem(itemId) {
    var currentPath = window.location.pathname;
    console.log("viewItem clicked with itemId: " + itemId);

    if (currentPath.indexOf('/manager/') !== -1) {
        window.location.href = contextPath + "/manager/ViewItemsServlet?itemId=" + itemId;
        console.log("Redirect URL: " + contextPath + "/manager/ViewItemsServlet?itemId=" + itemId);
    } else {
        window.location.href = contextPath + "/staff/ViewItemsServlet?itemId=" + itemId;
        console.log("Redirect URL: " + contextPath + "/staff/ViewItemsServlet?itemId=" + itemId);
    }
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
    var imageInput = document.getElementById("addImageInput");
    if (!imageInput || imageInput.files.length === 0) {
        alert("Please upload an image.");
        return false;
    }

    return true;
}

// Function to validate edit existing item form before submission
function validateEditItemForm() {
    var priceElem = document.getElementById("price");
    var stockElem = document.getElementById("stockQuantity");
    var price = parseFloat(priceElem.value);
    var stockQuantity = parseInt(stockElem.value, 10);
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

    // In edit form, image is optional.
    return true;
}