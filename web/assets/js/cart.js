//valid quantity cannot more than stock
function increaseQuantity(itemId, currentQty, stock) {
    var qtySpan = document.getElementById('qty_' + itemId);
    var latestQty = qtySpan ? parseInt(qtySpan.innerText) : currentQty;
    if (latestQty + 1 > stock) {
        // Show modal
        $('#stockModal').modal('show');
        return false;
    }
    updateQuantity(itemId, +1);
}

//AJAX update quantity
function updateQuantity(cartItemId, change) {
    fetch('CartItemServlet', {
        method: 'POST',
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: 'action=update&cartItemId=' + encodeURIComponent(cartItemId) + '&change=' + change
    })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    document.getElementById('qty_' + cartItemId).innerText = data.newQuantity;
                    document.getElementById('subtotal_' + cartItemId).innerText = data.newSubtotal.toFixed(2);
                    document.getElementById('cartSubtotal').innerText = data.cartSubtotal.toFixed(2);
                    document.getElementById('deliveryFee').innerText = data.deliveryFee.toFixed(2);
                    document.getElementById('cartTotal').innerText = data.cartTotal.toFixed(2);
                    
                    // Check if there's an applied promotion
                    var promoCode = document.getElementById('promoCode').value;
                    if (promoCode) {
                        // Revalidate the promotion with new cart total
                        fetch('CartServlet', {
                            method: 'POST',
                            headers: {'Content-Type': 'application/x-www-form-urlencoded'},
                            body: 'action=applyPromotion&promoCode=' + encodeURIComponent(promoCode)
                        })
                        .then(response => response.json())
                        .then(promoData => {
                            if (!promoData.success) {
                                // If promotion is no longer valid, clear the promo code and message
                                document.getElementById('promoCode').value = '';
                                document.getElementById('promoMsg').innerText = promoData.message;
                                document.getElementById('promoMsg').className = 'text-danger';
                            }
                            // Update the discount amount regardless
                            document.getElementById('discount').innerText = Number(promoData.discount).toFixed(2);
                            document.getElementById('cartTotal').innerText = Number(promoData.cartTotal).toFixed(2);
                        });
                    }
                    
                    // Validate checkout after quantity update
                    validateCheckout();
                } else {
                    alert(data.message || 'Failed to update cart.');
                }
            });
}

//remove cart item
function removeCartItem(cartItemId) {
    fetch('CartItemServlet', {
        method: 'POST',
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: 'action=remove&cartItemId=' + encodeURIComponent(cartItemId)
    })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    document.getElementById('cartItem_' + cartItemId).remove();
                    document.getElementById('cartSubtotal').innerText = data.cartSubtotal;
                    document.getElementById('deliveryFee').innerText = data.deliveryFee;
                    document.getElementById('cartTotal').innerText = data.cartTotal;

                    // Check if there are any cart items left
                    var cartTableBody = document.querySelector('.site-blocks-table tbody');
                    if (cartTableBody && cartTableBody.children.length === 0) {
                        cartTableBody.innerHTML = '<tr><td colspan="6">Your cart is empty.</td></tr>';
                        document.getElementById('cartSubtotal').innerText = '0.00';
                        document.getElementById('deliveryFee').innerText = '0.00';
                        document.getElementById('cartTotal').innerText = '0.00';
                        document.getElementById('discount').innerText = '0.00';
                    }
                    
                    // Validate checkout after removing item
                    validateCheckout();
                } else {
                    alert(data.message || 'Failed to remove item.');
                }
            });
}
//apply promotion with code
function applyPromotion() {
    var promoCode = document.getElementById('promoCode').value;
    fetch('CartServlet', {
        method: 'POST',
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: 'action=applyPromotion&promoCode=' + encodeURIComponent(promoCode)
    })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    document.getElementById('discount').innerText = Number(data.discount).toFixed(2);
                    document.getElementById('cartSubtotal').innerText = Number(data.cartSubtotal).toFixed(2);
                    document.getElementById('deliveryFee').innerText = Number(data.deliveryFee).toFixed(2);
                    document.getElementById('cartTotal').innerText = Number(data.cartTotal).toFixed(2);
                    document.getElementById('promoMsg').innerText = data.message;
                    document.getElementById('promoMsg').className = 'text-success';
                } else {
                    document.getElementById('promoMsg').innerText = data.message;
                    document.getElementById('promoMsg').className = 'text-danger';
                    document.getElementById('discount').innerText = '0.00';
                }
            });
}

function toggleCardForm(show) {
    var cardInfo = document.getElementById('cardInfo');
    if (cardInfo) {
        cardInfo.style.display = show ? 'block' : 'none';
        // Set required attributes for card fields only if showing
        var requiredFields = ['cardHolder', 'cardNumber', 'expiryDate', 'cvv'];
        requiredFields.forEach(function (id) {
            var field = document.getElementById(id);
            if (field)
                field.required = show;
        });
    }
}

// Prevent checkout if cart is empty
function isCartEmpty() {
    var cartTableBody = document.querySelector('.site-blocks-table tbody');
    if (!cartTableBody)
        return true;
    return cartTableBody.innerText.trim().includes('Your cart is empty.');
}

function validateCheckout() {
    let cartItems = document.querySelectorAll('tr[id^="cartItem_"]');
    let hasError = false;
    let errorMessage = '';
    let checkoutBtn = document.getElementById('checkoutBtn');

    // If no items in cart, disable checkout button
    if (cartItems.length === 0) {
        if (checkoutBtn) {
            checkoutBtn.disabled = true;
        }
        return false;
    }

    cartItems.forEach(item => {
        let cartItemId = item.id.split('_')[1];
        let quantity = parseInt(document.getElementById('qty_' + cartItemId).textContent);
        let stockLimit = parseInt(item.getAttribute('data-stock'));
        
        if (quantity > stockLimit) {
            hasError = true;
            let itemName = item.querySelector('td:nth-child(3)').textContent.trim();
            errorMessage += `Not enough stock for ${itemName}. Available: ${stockLimit} <br>`;
        }
    });

    if (hasError) {
        document.getElementById('checkoutError').innerHTML = errorMessage;
        if (checkoutBtn) {
            checkoutBtn.disabled = true;
        }
        return false;
    }

    // If we get here, there are no stock errors
    document.getElementById('checkoutError').innerHTML = '';
    if (checkoutBtn) {
        checkoutBtn.disabled = false;
    }
    return true;
}

window.addEventListener('DOMContentLoaded', function () {
    // Disable checkout button if cart is empty on load
    var checkoutBtn = document.getElementById('checkoutBtn');
    if (checkoutBtn && isCartEmpty()) {
        checkoutBtn.disabled = true;
    }
});
