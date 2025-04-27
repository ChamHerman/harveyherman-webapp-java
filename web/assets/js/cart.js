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
                    document.getElementById('promoError').innerText = "";
                } else {
                    document.getElementById('promoError').innerText = data.message;
                }
            });
}

function toggleCardForm(show) {
    var cardInfo = document.getElementById('cardInfo');
    if (cardInfo) {
        cardInfo.style.display = show ? 'block' : 'none';
        // Set required attributes for card fields only if showing
        var requiredFields = ['cardHolder', 'cardNumber', 'expiryDate', 'cvv'];
        requiredFields.forEach(function(id) {
            var field = document.getElementById(id);
            if (field) field.required = show;
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
    if (isCartEmpty()) {
        document.getElementById('checkoutError').innerText = 'Your cart is empty. You cannot proceed to checkout.';
        return false;
    }
    document.getElementById('checkoutError').innerText = '';
    return true;
}

window.addEventListener('DOMContentLoaded', function () {
    // Disable checkout button if cart is empty on load
    var checkoutBtn = document.getElementById('checkoutBtn');
    if (checkoutBtn && isCartEmpty()) {
        checkoutBtn.disabled = true;
    }
});