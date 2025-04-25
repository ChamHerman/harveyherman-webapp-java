//delete
var deleteOrderId = '';
function confirmDeleteOrder(orderId) {
    deleteOrderId = orderId;
    document.getElementById('orderToDelete').textContent = orderId;
    // Show the modal using Bootstrap
    var deleteModalEl = document.getElementById('deleteOrderModal');
    var deleteModal = new bootstrap.Modal(deleteModalEl);
    deleteModal.show();
}

document.getElementById('confirmDeleteOrder').addEventListener('click', function () {
    // Redirect to DeleteOrderServlet with orderId parameter
    window.location.href = 'DeleteOrderServlet?orderId=' + deleteOrderId;
});

////add order
//document.getElementById('addOrderForm').addEventListener('submit', function(e) {
//  const userId = document.getElementById('userId').value.trim();
//  const promotionId = document.getElementById('promotionId').value.trim();
//  const errorDiv = document.getElementById('addOrderError');
//  errorDiv.classList.add('d-none');
//  errorDiv.textContent = '';
//
//  if (!/^U\d{3}$/.test(userId)) {
//    e.preventDefault();
//    errorDiv.textContent = 'User ID must be in format U??? (e.g. U001)';
//    errorDiv.classList.remove('d-none');
//    return;
//  }
//  if (promotionId && !/^P\d{3}$/.test(promotionId)) {
//    e.preventDefault();
//    errorDiv.textContent = 'Promotion ID must be in format P??? (e.g. P001)';
//    errorDiv.classList.remove('d-none');
//    return;
//  }
//});

//view  order
function viewOrder(orderId) {
    fetch('OrderDetailsServlet?orderId=' + encodeURIComponent(orderId))
            .then(response => response.json())
            .then(data => {
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
              <th>Item ID</th>
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
            <td>${detail.itemId}</td>
            <td>${detail.quantity}</td>
            <td>${detail.pricePerItem.toFixed(2)}</td>
            <td>${subtotal.toFixed(2)}</td>
          </tr>
        `;
                });
                // Last row: total amount from orders table
                html += `
          <tr>
            <td colspan="3" class="text-end"><strong>Total Amount:</strong></td>
            <td><strong>RM ${parseFloat(data.totalAmount).toFixed(2)}</strong></td>
          </tr>
        </tbody>
      </table>
      `;
                document.getElementById('orderDetailsBody').innerHTML = html;
                var modal = new bootstrap.Modal(document.getElementById('orderDetailsModal'));
                modal.show();
            });
}

////search item by status
//document.getElementById('searchButton').addEventListener('click', function (e) {
//    e.preventDefault(); // Prevent form submit
//    const status = document.getElementById('statusSelect').value;
//
//    fetch(`FilterOrderServlet?status=${encodeURIComponent(status)}`)
//            .then(response => response.json())
//            .then(data => {
//                const tableBody = document.getElementById('statusOrdersTableBody');
//                tableBody.innerHTML = '';
//
//                if (data.length === 0 || !data[0].orderId) {
//                    tableBody.innerHTML = '<tr><td colspan="5" class="text-center">No orders found.</td></tr>';
//                } else {
//                    data.forEach(order => {
//                        const row = `
//                        <tr>
//                            <td>${order.orderId}</td>
//                            <td>${order.user}</td>
//                            <td>RM ${parseFloat(order.totalAmount).toFixed(2)}</td>
//                            <td>${order.status}</td>
//                            <td>${order.createdDate}</td>
//                        </tr>
//                    `;
//                        tableBody.insertAdjacentHTML('beforeend', row);
//                    });
//                }
//
//                const modal = new bootstrap.Modal(document.getElementById('statusOrdersModal'));
//                modal.show();
//            })
//            .catch(error => {
//                const tableBody = document.getElementById('statusOrdersTableBody');
//                tableBody.innerHTML = '<tr><td colspan="5" class="text-center text-danger">Error fetching orders.</td></tr>';
//                const modal = new bootstrap.Modal(document.getElementById('statusOrdersModal'));
//                modal.show();
//            });
//});

//ask user confirm to edit
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