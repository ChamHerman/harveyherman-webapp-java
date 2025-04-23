//click add to cart button
function addToCart(itemId, quantity) {
    fetch('CartServlet', {
      method: 'POST',
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: `itemId=${encodeURIComponent(itemId)}&quantity=${encodeURIComponent(quantity)}`
    })
    .then(response => response.json())
    .then(data => {
      if (data.success) {
        alert('Added to cart!');
        
      } else {
        alert('Failed to add to cart: ' + data.message);
      }
    });
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
              document.getElementById('subtotal_' + cartItemId).innerText = data.newSubtotal;
              document.getElementById('cartSubtotal').innerText = data.cartSubtotal;
              document.getElementById('deliveryFee').innerText = data.deliveryFee;
              document.getElementById('cartTotal').innerText = data.cartTotal;
             
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
          } else {
              alert(data.message || 'Failed to remove item.');
          }
      });
  }
  //apply promotion with code
  function applyPromotion() {
      var promoCode = document.getElementById('promoCode').value;
      fetch('CartItemServlet', {
          method: 'POST',
          headers: {'Content-Type': 'application/x-www-form-urlencoded'},
          body: 'action=applyPromotion&promoCode=' + encodeURIComponent(promoCode)
      })
      .then(response => response.json())
      .then(data => {
          if (data.success) {
              document.getElementById('discount').innerText = data.discount;
              document.getElementById('cartSubtotal').innerText = data.cartSubtotal;
              document.getElementById('deliveryFee').innerText = data.deliveryFee;
              document.getElementById('cartTotal').innerText = data.cartTotal;
              document.getElementById('promoError').innerText = "";
          } else {
              document.getElementById('promoError').innerText = data.message;
          }
      });
  }
  
  //show credit and debit card information modal
function toggleCardForm(show) {
    document.getElementById('cardInfo').style.display = show ? 'block' : 'none';
    // Set required only if card is selected
    document.querySelectorAll('#cardInfo input').forEach(function(input) {
        input.required = show;
    });
}
window.onload = function() {
    var debit = document.getElementById('debit');
    var credit = document.getElementById('credit');
    toggleCardForm((debit && debit.checked) || (credit && credit.checked));
};