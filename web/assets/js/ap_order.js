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

document.getElementById('confirmDeleteOrder').addEventListener('click', function() {
    // Redirect to DeleteOrderServlet with orderId parameter
    window.location.href = 'DeleteOrderServlet?orderId=' + deleteOrderId;
});


//search
document.getElementById('searchButton').addEventListener('click', function () {
    const status = document.getElementById('statusSelect').value;

    if (status) {
        fetch(`FilterOrder  Servlet?status=${encodeURIComponent(status)}`)
            .then(response => response.json())
            .then(data => {
                const tableBody = document.getElementById('statusOrdersTableBody');
                tableBody.innerHTML = '';

                data.orders.forEach(order => {
                    const row = `
                        <tr>
                            <td>${order.orderId}</td>
                            <td>${order.user}</td>
                            <td>RM ${order.totalAmount}</td>
                            <td>${order.status}</td>
                            <td>${order.createdDate}</td>
                        </tr>
                    `;
                    tableBody.insertAdjacentHTML('beforeend', row);
                });

                const modal = new bootstrap.Modal(document.getElementById('statusOrdersModal'));
                modal.show();
            })
            .catch(error => console.error('Error fetching orders:', error));
    }
});

function showOrderDetails(orderData) {
    // Assuming you have modal elements with these IDs
    document.getElementById('orderId').textContent = orderData.orderId;
    document.getElementById('user').textContent = orderData.user;
    document.getElementById('totalAmount').textContent = `RM ${orderData.totalAmount.toFixed(2)}`;
    document.getElementById('status').textContent = orderData.status;
    document.getElementById('createdDate').textContent = orderData.createdDate;

    // Show the modal (using Bootstrap's modal API)
    const modal = new bootstrap.Modal(document.getElementById('orderDetailsModal'));
    modal.show();
}

