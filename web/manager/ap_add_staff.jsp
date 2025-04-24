<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Add Staff - Manager</title>
        <link href="<%= request.getContextPath()%>/assets/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">
        <link href="<%= request.getContextPath()%>/assets/css/style.css" rel="stylesheet">
        <link href="<%= request.getContextPath()%>/assets/css/ap_index.css" rel="stylesheet">
        <link href="<%= request.getContextPath()%>/assets/css/ap_staff.css" rel="stylesheet">
        <style>
            .card {
                margin-bottom: 20px;
                border-radius: 10px;
                box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.1);
            }
            .card-header {
                background-color: #4e73df;
                color: white;
                font-weight: bold;
                border-radius: 10px 10px 0 0;
            }
            .form-label {
                color: #000000 !important;
                font-weight: 600;
            }
            .form-label.required:after {
                content: ' *';
                color: red;
            }
            .btn-primary {
                background-color: #4e73df;
                border-color: #4e73df;
            }
            .btn-primary:hover {
                background-color: #2e59d9;
                border-color: #2e59d9;
            }
            .btn-secondary {
                background-color: #858796;
                border-color: #858796;
            }
            .btn-secondary:hover {
                background-color: #717384;
                border-color: #717384;
            }
        </style>
    </head>
    <body>
        <%@ include file="ap_sidebar.jsp" %>
        <div class="main-content flex-grow-1">
            <div class="container">
                <h2 class="mt-4 mb-4">Add New Staff</h2>
                
                <form id="addStaffForm" action="<%= request.getContextPath()%>/manager/AddStaffServlet" method="post">
                    <div class="card">
                        <div class="card-header">
                            <h5 class="mb-0">Staff Information</h5>
                        </div>
                        <div class="card-body">
                            <div class="row mb-3">
                                <div class="col-md-6">
                                    <label for="fullname" class="form-label required">Full Name</label>
                                    <input type="text" class="form-control" id="fullname" name="fullname" required>
                                </div>
                                <div class="col-md-6">
                                    <label for="email" class="form-label required">Email</label>
                                    <input type="email" class="form-control" id="email" name="email" required>
                                </div>
                            </div>
                            
                            <div class="row mb-3">
                                <div class="col-md-6">
                                    <label for="contactNumber" class="form-label required">Contact Number</label>
                                    <input type="text" class="form-control" id="contactNumber" name="contactNumber" required>
                                </div>
                                <div class="col-md-6">
                                    <label for="position" class="form-label required">Position</label>
                                    <input type="text" class="form-control" id="position" name="position" required>
                                </div>
                            </div>
                            
                            <div class="row mb-3">
                                <div class="col-md-6">
                                    <label for="gender" class="form-label required">Gender</label>
                                    <select class="form-select" id="gender" name="gender" required>
                                        <option value="">Select Gender</option>
                                        <option value="Male">Male</option>
                                        <option value="Female">Female</option>
                                        <option value="Other">Other</option>
                                    </select>
                                </div>
                                <div class="col-md-6">
                                    <label for="username" class="form-label required">Username</label>
                                    <input type="text" class="form-control" id="username" name="username" required>
                                </div>
                            </div>
                            
                            <div class="row mb-3">
                                <div class="col-md-12">
                                    <label for="address" class="form-label">Address</label>
                                    <textarea class="form-control" id="address" name="address" rows="3"></textarea>
                                </div>
                            </div>
                            
                            <div class="alert alert-info">
                                <i class="fas fa-info-circle me-2"></i>Default password will be set to "password"
                            </div>
                        </div>
                    </div>
                    
                    <div class="d-flex justify-content-end">
                        <a href="ap_staff.jsp" class="btn btn-secondary me-2">Cancel</a>
                        <button type="submit" class="btn btn-primary">Add Staff</button>
                    </div>
                </form>
            </div>
        </div>
        
        <!-- Loading Modal -->
        <div class="modal fade" id="loadingModal" tabindex="-1" data-bs-backdrop="static" data-bs-keyboard="false" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content">
                    <div class="modal-body text-center p-4">
                        <div class="spinner-border text-primary" role="status">
                            <span class="visually-hidden">Loading...</span>
                        </div>
                        <h5 class="mt-3">Processing...</h5>
                    </div>
                </div>
            </div>
        </div>
        
        <script src="<%= request.getContextPath()%>/assets/js/bootstrap.bundle.min.js"></script>
        <script>
            document.addEventListener('DOMContentLoaded', function() {
                const form = document.getElementById('addStaffForm');
                if (form) {
                    form.addEventListener('submit', function(e) {
                        // Show loading modal before submission
                        const loadingModal = new bootstrap.Modal(document.getElementById('loadingModal'));
                        loadingModal.show();
                    });
                }
            });
        </script>
    </body>
</html> 