//delete modal
var deleteOrderId = '';
function confirmDeleteOrder(orderId) {
    deleteOrderId = orderId;
    document.getElementById('orderToDelete').textContent = orderId;
    // Show the modal using Bootstrap
    var deleteModalEl = document.getElementById('deleteOrderModal');
    var deleteModal = new bootstrap.Modal(deleteModalEl);
    deleteModal.show();
}

//confirm delete
document.getElementById('confirmDeleteOrder').addEventListener('click', function () {
    // Redirect to DeleteOrderServlet with orderId parameter
    fetch('DeleteOrderServlet', {
        method: 'POST',
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: 'orderId=' + encodeURIComponent(deleteOrderId)
    }).then(() => {
        window.location.reload(); // or redirect as needed
    });
});

//clear filter button
document.querySelector('button[name="clearFilter"]').addEventListener('click', function (e) {
    // Set the dropdown to "All" before submitting
    document.getElementById('statusSelect').value = '';
});

//view  order
function viewOrder(orderId) {
    fetch('OrderDetailsServlet', {
        method: 'POST',
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: 'orderId=' + encodeURIComponent(orderId)
    })
            .then(response => response.json())
            .then(data => {
                let subtotal = data.subtotal;
                let delivery = data.delivery;
                let total = data.totalAmount;
                let discount = subtotal + delivery - total;
                
                let html = `
        <div><strong>Order ID:</strong> ${data.orderId}</div>
        <div><strong>User ID:</strong> ${data.userId}</div>
        <div><strong>Status:</strong> ${data.status}</div>
        <div><strong>Payment Method:</strong> ${data.paymentMethod.replace('_', ' ').replace(/\b\w/g, l => l.toUpperCase())}</div>
        <div><strong>Created Date:</strong> ${data.createdDate}</div>
        <hr>
        <h6>Order Items:</h6>
        <table class="table table-bordered">
          <thead>
            <tr>
              <th>Item Name</th>
              <th>Quantity</th>
              <th>Price Per Item</th>
              <th>Subtotal</th>
            </tr>
          </thead>
          <tbody>
      `;
                data.orderDetails.forEach(detail => {
                    let subtotal = detail.quantity * detail.pricePerItem;
                    html += `
          <tr>
            <td>${detail.itemName}</td>
            <td>${detail.quantity}</td>
            <td>${detail.pricePerItem.toFixed(2)}</td>
            <td>${subtotal.toFixed(2)}</td>
          </tr>
        `;
                });
                // Add subtotal, delivery, discount, and total rows
                html += `
          <tr>
            <td colspan="3" class="text-end"><strong>Subtotal:</strong></td>
            <td><strong>RM ${subtotal.toFixed(2)}</strong></td>
          </tr>
          <tr>
            <td colspan="3" class="text-end"><strong>Delivery Fee:</strong></td>
            <td><strong>RM ${delivery.toFixed(2)}</strong></td>
          </tr>
          <tr>
            <td colspan="3" class="text-end"><strong>Discount:</strong></td>
            <td><strong>RM ${discount.toFixed(2)}</strong></td>
          </tr>
          <tr>
            <td colspan="3" class="text-end"><strong>Total Amount:</strong></td>
            <td><strong>RM ${total.toFixed(2)}</strong></td>
          </tr>
        </tbody>
      </table>
      `;
                document.getElementById('orderDetailsBody').innerHTML = html;
                var modal = new bootstrap.Modal(document.getElementById('orderDetailsModal'));
                modal.show();
            });
}

//ask user confirm to edit modal
let pendingForm = null;
function confirmStatusChange(form, orderId) {
    const oldStatus = form.oldStatus.value;
    const newStatus = form.status.value;
    if (oldStatus === newStatus)
        return false; // No change, no need to submit

    pendingForm = form;
    document.getElementById('confirmStatusModalBody').innerHTML =
            `Are you sure you want to change the status of order <b>${orderId}</b> from <b>${oldStatus}</b> to <b>${newStatus}</b>?`;
    var modal = new bootstrap.Modal(document.getElementById('confirmStatusModal'));
    modal.show();
    return false; // Prevent form submit until confirmed
}

//edit order status
document.addEventListener('DOMContentLoaded', function () {
    document.getElementById('confirmStatusBtn').onclick = function () {
        if (pendingForm) {
            pendingForm.submit();
            pendingForm = null;
            var modal = bootstrap.Modal.getInstance(document.getElementById('confirmStatusModal'));
            modal.hide();
        }
    };
});