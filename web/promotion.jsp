<%-- 
    Document   : promotion
    Created on : Apr 6, 2025, 9:44:15 PM
    Author     : User
--%>

<%@ page import="java.util.List" %>
<%@ page import="model.Promotion" %>
<%@ page import="model.PromotionDAO" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Manage Promotions</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</head>
<body class="container mt-4">
    <h2 class="text-center text-primary">Manage Promotions</h2>
    <%
	    String successMessage = (String) request.getAttribute("successMessage");
	    String errorMessage = (String) request.getAttribute("errorMessage");
	%>
	
	<% if (successMessage != null) { %>
	    <div class="alert alert-success"><%= successMessage %></div>
	<% } %>
	
	<% if (errorMessage != null) { %>
	    <div class="alert alert-danger"><%= errorMessage %></div>
	<% } %>
   
        <table class="table table-striped table-bordered">
        	<thead class="table-dark">
	            <tr>
	                <th>ID</th>
	                <th>Code</th>
	                <th>Discount</th>
	                <th>Status</th>
	                <th>Min Purchase</th>
	                <th>Description</th>
	                <th>Start Date</th>
	                <th>End Date</th>
	            </tr>
            </thead>
            <tbody>
            <%
                List<Promotion> promotions = (List<Promotion>) request.getAttribute("promotions");
            	if (promotions != null && !promotions.isEmpty()) {
                for (Promotion promo : promotions) {
            %>
                <tr>
                    <td><%= promo.getPromotionId() %></td>
                    <td><%= promo.getPromotionCode() %></td>
                    <td><%= promo.getDiscountValue() %></td>
                    <td><%= promo.getStatus()%></td>
                    <td><%= promo.getMinimumPurchase() %></td>
                    <td><%= promo.getDescription() %>
                    <td><%= promo.getStartDate() %></td>
                    <td><%= promo.getEndDate() %></td>
                </tr>
            <%
                }
            	} else {
            %>
            <tr><td colspan="7" class="text-center text-danger">No promotions available.</td></tr>
            <% } %>
            
            </tbody>
        </table>
    <%
        }
    %>
    <div class="d-flex justify-content-center gap-3 mt-3">
	    <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addPromotionModal">
	        Add Promotion
	    </button>
	    <button type="button" class="btn btn-danger" data-bs-toggle="modal" data-bs-target="#deletePromotionModal">
	        Delete Promotion
	    </button>
	    <a href="dashboard.jsp" class="btn btn-secondary">Back to Dashboard</a>
	</div>
    
    <!-- Delete Promotion Modal -->
	<div class="modal fade" id="deletePromotionModal" tabindex="-1" aria-labelledby="deletePromotionModalLabel" aria-hidden="true">
	    <div class="modal-dialog">
	        <div class="modal-content">
	            <div class="modal-header">
	                <h5 class="modal-title" id="deletePromotionModalLabel">Delete Promotion</h5>
	                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
	            </div>
	            <div class="modal-body">
	                <form action="DeletePromotionServlet" method="post">
	                    <div class="mb-3">
	                        <label for="deletePromotionId" class="form-label">Promotion ID</label>
	                        <input type="text" class="form-control" id="deletePromotionId" name="promotionId" required>
	                        <small class="text-danger" id="deleteError" style="display: none;">Promotion ID is required.</small>
	                    </div>
	                    <button type="submit" id="deletePromotionBtn" class="btn btn-danger w-100">Delete Promotion</button>
	                </form>
	            </div>
	        </div>
	    </div>
	</div>
	
    <!-- Add Promotion Modal -->
    <div class="modal fade" id="addPromotionModal" tabindex="-1" aria-labelledby="addPromotionModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="addPromotionModalLabel">Add Promotion</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <form action="AddPromotionServlet" method="post">
	                    <div class="mb-3">
	                        <label for="promotionId" class="form-label">Promotion ID</label>
	                        <input type="text" class="form-control" id="promotionId" name="promotionId" value="<%=0 %>" readonly>
	                    </div>
                        <div class="mb-3">
                            <label for="promotionCode" class="form-label">Promotion Code</label>
                            <input type="text" class="form-control" id="promotionCode" name="promotionCode" required>
                        </div>
                        <div class="mb-3">
                            <select name="status">
                                <option value="active">Active</option>
                            </select>
                        </div>
                        <div class="mb-3">
                            <label for="discountValue" class="form-label">Discount Value (%)</label>
                            <input type="number" class="form-control" id="discountValue" name="discountValue" required>
                        </div>
                        <div class="mb-3">
                            <label for="minimumPurchase" class="form-label">Minimum Purchase</label>
                            <input type="number" class="form-control" id="minimumPurchase" name="minimumPurchase" required>
                        </div>
                         <div class="mb-3">
                            <label for="description" class="form-label">Description</label> <!-- ADDED DESCRIPTION FIELD -->
                            <textarea class="form-control" id="description" name="description" rows="3" required></textarea>
                        </div>
                        <div class="mb-3">
                            <label for="startDate" class="form-label">Start Date</label>
                            <input type="date" class="form-control" id="startDate" name="startDate" required>
                        </div>
                        <div class="mb-3">
                            <label for="endDate" class="form-label">End Date</label>
                            <input type="date" class="form-control" id="endDate" name="endDate" required>
                        </div>
                        <button type="submit" id="savePromotionBtn" class="btn btn-success w-100">Save Promotion</button>
                    </form>
                </div>
            </div>
        </div>
    </div>
    
    <script>
        document.addEventListener("DOMContentLoaded", function () {
            const saveButton = document.querySelector("#savePromotionBtn");
            const inputs = document.querySelectorAll("#addPromotionModal input, #addPromotionModal textarea");

            function validateForm() {
                let isValid = true;
                inputs.forEach(input => {
                    if (input.value.trim() === "") {
                        isValid = false;
                    }
                });
                saveButton.disabled = !isValid;
            }

            inputs.forEach(input => {
                input.addEventListener("input", validateForm);
            });

            //validation page
            validateForm();
        });
        
    document.addEventListener("DOMContentLoaded", function () {
        const saveButton = document.querySelector("#savePromotionBtn");
        const startDateInput = document.querySelector("#startDate");
        const endDateInput = document.querySelector("#endDate");
        const errorMessage = document.createElement("p");
        const discountInput = document.querySelector("#discountValue");
        const minPurchaseInput = document.querySelector("#minimumPurchase");
        const inputs = document.querySelectorAll("#addPromotionModal input, #addPromotionModal textarea");
        errorMessage.classList.add("text-danger", "mt-2");

        function validateDates() {
            let today = new Date().toISOString().split("T")[0]; // Get today's date in yyyy-MM-dd format
            let startDate = startDateInput.value;
            let endDate = endDateInput.value;

            // delete error msg
            errorMessage.innerText = "";
            endDateInput.classList.remove("is-invalid");

            if (endDate && endDate < today) {
                errorMessage.innerText = "End date cannot be in the past.";
                endDateInput.classList.add("is-invalid");
            } else if (startDate && endDate && endDate < startDate) {
                errorMessage.innerText = "End date cannot be before the start date.";
                endDateInput.classList.add("is-invalid");
            }

            // Append error msg
            if (errorMessage.innerText) {
                endDateInput.parentNode.appendChild(errorMessage);
                saveButton.disabled = true;
            } else {
                saveButton.disabled = false;
            }
        }
        
        function createErrorMessage(input, message) {
            let errorElement = input.nextElementSibling;
            if (!errorElement || !errorElement.classList.contains("text-danger")) {
                errorElement = document.createElement("p");
                errorElement.classList.add("text-danger", "mt-1");
                input.parentNode.appendChild(errorElement);
            }
            errorElement.innerText = message;
            input.classList.add("is-invalid");
        }

        function clearErrorMessage(input) {
            let errorElement = input.nextElementSibling;
            if (errorElement && errorElement.classList.contains("text-danger")) {
                errorElement.remove();
            }
            input.classList.remove("is-invalid");
        }

        function validateForm() {
            let isValid = true;
            
            inputs.forEach(input => {
                if (input.value.trim() === "") {
                    createErrorMessage(input, "This field is required.");
                    isValid = false;
                } else {
                    clearErrorMessage(input);
                }
            });
            
            if (parseFloat(discountInput.value) < 0) {
                createErrorMessage(discountInput, "Discount value cannot be negative.");
                isValid = false;
            } else {
                clearErrorMessage(discountInput);
            }
            
            if (parseFloat(minPurchaseInput.value) < 0) {
                createErrorMessage(minPurchaseInput, "Minimum purchase cannot be negative.");
                isValid = false;
            } else {
                clearErrorMessage(minPurchaseInput);
            }
            
            inputs.forEach(input => {
                if (input.value.trim() === "") {
                    isValid = false;
                }
            });

            saveButton.disabled = !isValid;
        }

        inputs.forEach(input => input.addEventListener("input", validateForm));
        startDateInput.addEventListener("change", validateDates);
        endDateInput.addEventListener("change", validateDates);
        validateForm();
    });
    
    document.addEventListener("DOMContentLoaded", function () {
        const deleteButton = document.querySelector("#deletePromotionBtn");
        const deleteInput = document.querySelector("#deletePromotionId");
        const deleteError = document.querySelector("#deleteError");

        function validateDelete() {
            if (deleteInput.value.trim() === "") {
                deleteError.style.display = "block";
                deleteButton.disabled = true;
            } else {
                deleteError.style.display = "none";
                deleteButton.disabled = false;
            }
        }

        deleteInput.addEventListener("input", validateDelete);
        validateDelete();
    });
</script>
    
</body>
</html>
