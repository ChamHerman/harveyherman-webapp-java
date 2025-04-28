document.addEventListener('DOMContentLoaded', function () {
    // Helper to show/hide error and set border
    function setError(input, msg) {
        let errorDiv = input.nextElementSibling;
        if (!errorDiv || !errorDiv.classList.contains('input-error-msg')) {
            errorDiv = document.createElement('div');
            errorDiv.className = 'input-error-msg';
            errorDiv.style.color = 'red';
            errorDiv.style.fontSize = '0.9em';
            errorDiv.style.marginTop = '4px';
            input.parentNode.insertBefore(errorDiv, input.nextSibling);
        }
        errorDiv.textContent = msg || '';
        input.style.borderColor = msg ? 'red' : '';
    }

    // Validation functions
    function validateItemName(input) {
        if (input.value.length < 1) {
            setError(input, "Please enter an item name.");
            return false;
        } else if (input.value.length > 100) {
            setError(input, "Item name must be less than or equal to 100 characters.");
            return false;
        }
        setError(input, "");
        return true;
    }
    function validateDescription(input) {
        if (input.value.length > 1000) {
            setError(input, "Description must be less than or equal to 1000 characters.");
            return false;
        }
        setError(input, "");
        return true;
    }
    function validatePrice(input) {
        const price = parseFloat(input.value);
        if (isNaN(price) || price < 0.01) {
            setError(input, "Price must be 0.01 or above.");
            return false;
        } else if (price > 9999999.99) {
            setError(input, "Price must not more than 9999999.99.");
            return false;
        }
        setError(input, "");
        return true;
    }
    function validateStock(input) {
        const stock = parseInt(input.value, 10);
        if (isNaN(stock) || stock < 0) {
            setError(input, "Stock Quantity must be 0 or above.");
            return false;
        } else if (stock > 9999999) {
            setError(input, "Stock Quantity must not more than 9999999.");
            return false;
        }
        setError(input, "");
        return true;
    }
    function validateCategory(select, customInput) {
        if (select.value === "") {
            setError(select, "Please select a category.");
            return false;
        }
        setError(select, "");
        if (select.value === "Others") {
            if (customInput.value.trim() === "") {
                setError(customInput, "Please enter a custom category.");
                return false;
            }
            if (customInput.value.trim().length > 50) {
                setError(customInput, "Custom category must be less than or equal to 50 characters.");
                return false;
            }
            setError(customInput, "");
        } else {
            setError(customInput, "");
        }
        return true;
    }

    function validateImage(input, preview) {
        if (!input.files || input.files.length === 0) {
            setError(preview, "Please upload an image.");
            return false;
        }
        setError(preview, "");
        return true;
    }

    // Main validation function
    function validateAddForm() {
        const form = document.getElementById('addItemForm');
        if (!form)
            return true;
        const itemName = form.querySelector('[name="itemName"]');
        const description = form.querySelector('[name="description"]');
        const price = form.querySelector('[name="price"]');
        const stock = form.querySelector('[name="stockQuantity"]');
        const category = form.querySelector('[name="category"]');
        const customCategory = form.querySelector('[name="customCategory"]');
        const imageInput = form.querySelector('#addImageInput');
        const imagePreview = form.querySelector('#addItemImagePreview');
        let valid = true;
        valid &= validateItemName(itemName);
        valid &= validateDescription(description);
        valid &= validatePrice(price);
        valid &= validateStock(stock);
        valid &= validateCategory(category, customCategory);
        valid &= validateImage(imageInput, imagePreview);
        // Enable/disable button
        form.querySelector('button[type="submit"]').disabled = !valid;
        return !!valid;
    }

    // Listeners
    const form = document.getElementById('addItemForm');
    if (form) {
        const itemName = form.querySelector('[name="itemName"]');
        const description = form.querySelector('[name="description"]');
        const price = form.querySelector('[name="price"]');
        const stock = form.querySelector('[name="stockQuantity"]');
        const category = form.querySelector('[name="category"]');
        const customCategory = form.querySelector('[name="customCategory"]');
        const imageInput = form.querySelector('#addImageInput');
        [itemName, description, price, stock, category, customCategory, imageInput].forEach(function (el) {
            if (el) {
                el.addEventListener('input', validateAddForm);
                el.addEventListener('change', validateAddForm);
            }
        });
        // Initial validation
        validateAddForm();
    }

    // Main validation function for Edit form
    function validateEditForm() {
        const form = document.getElementById('editItemForm');
        if (!form)
            return true;
        const itemName = form.querySelector('[name="itemName"]');
        const description = form.querySelector('[name="description"]');
        const price = form.querySelector('[name="price"]');
        const stock = form.querySelector('[name="stockQuantity"]');
        const category = form.querySelector('[name="category"]');
        const customCategory = form.querySelector('[name="customCategory"]');
        let valid = true;
        valid &= validateItemName(itemName);
        valid &= validateDescription(description);
        valid &= validatePrice(price);
        valid &= validateStock(stock);
        valid &= validateCategory(category, customCategory);
        // Enable/disable button
        form.querySelector('button[type="submit"]').disabled = !valid;
        return !!valid;
    }

    // Listeners
    const editForm = document.getElementById('editItemForm');
    if (editForm) {
        const itemName = editForm.querySelector('[name="itemName"]');
        const description = editForm.querySelector('[name="description"]');
        const price = editForm.querySelector('[name="price"]');
        const stock = editForm.querySelector('[name="stockQuantity"]');
        const category = editForm.querySelector('[name="category"]');
        const customCategory = editForm.querySelector('[name="customCategory"]');
        [itemName, description, price, stock, category, customCategory].forEach(function (el) {
            if (el) {
                el.addEventListener('input', validateEditForm);
                el.addEventListener('change', validateEditForm);
            }
        });
        // Initial validation
        validateEditForm();
    }
});