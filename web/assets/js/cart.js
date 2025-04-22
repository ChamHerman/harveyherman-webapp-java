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
        // Optionally update cart icon/mini-cart here
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
      var cardModal = new bootstrap.Modal(document.getElementById('cardModal'));
      if (show) {
          cardModal.show();
          document.getElementById('cardInfo').style.display = show ? 'block' : 'none';
      } else {
          cardModal.hide();
          document.getElementById('cardInfo').style.display = show ? 'block' : 'none';
      }
  }
  
  
  // On page load, show card info if card is selected
  window.onload = function() {
    var cardSelected = document.getElementById('debit').checked || document.getElementById('credit').checked;
    toggleCardForm(cardSelected);
  };