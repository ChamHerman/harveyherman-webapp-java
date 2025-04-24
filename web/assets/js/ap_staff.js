window.onload = function () {
    // Define urlParams to retrieve query parameters
    const urlParams = new URLSearchParams(window.location.search);

    const messageParam = urlParams.get('message');
    if (messageParam) {
        // Show loading modal first
        const loadingModalElement = document.getElementById('loadingModal');
        if (loadingModalElement) {
            const loadingModal = new bootstrap.Modal(loadingModalElement);
            loadingModal.show();

            setTimeout(function () {
                // Hide loading modal
                loadingModal.hide();

                // Prepare and show the result message modal
                try {
                    document.getElementById('staffResultMessage').textContent = decodeURIComponent(messageParam);
                } catch (e) {
                    document.getElementById('staffResultMessage').textContent = messageParam;
                }

                const modalElement = document.getElementById('staffResultMessageModal');
                const messageModal = new bootstrap.Modal(modalElement);
                messageModal.show();

                // Clean the URL without the message parameter
                urlParams.delete('message');
                window.history.replaceState({}, document.title, window.location.pathname);
            }, 500); // 0.5 second delay
        }
    }

    // To show View Staff Modal
    const viewDataParam = urlParams.get('viewData');
    if (viewDataParam) {
        try {
            const viewDataObj = JSON.parse(decodeURIComponent(viewDataParam));
            console.log("Received viewData:", viewDataObj);
            if (viewDataObj.success) {
                document.getElementById('viewStaffId').textContent = viewDataObj.staffId;
                document.getElementById('viewFullName').textContent = viewDataObj.fullName;
                document.getElementById('viewEmail').textContent = viewDataObj.email;
                document.getElementById('viewContactNumber').textContent = viewDataObj.contactNumber;
                document.getElementById('viewAddress').textContent = viewDataObj.address;
                document.getElementById('viewPosition').textContent = viewDataObj.position;
                document.getElementById('viewGender').textContent = viewDataObj.gender;
                document.getElementById('viewCreatedDate').textContent = viewDataObj.createdDate;
                document.getElementById('viewLoginId').textContent = viewDataObj.loginId;
                document.getElementById('viewUsername').textContent = viewDataObj.username;
                document.getElementById('viewPassword').textContent = viewDataObj.password;
                document.getElementById('viewRole').textContent = viewDataObj.role;
                document.getElementById('viewLastLogin').textContent = viewDataObj.lastLogin;
                
                const modal = new bootstrap.Modal(document.getElementById('viewStaffModal'));
                modal.show();
            }
        } catch (e) {
            console.error("Error parsing viewData JSON:", e);
        }
        urlParams.delete('viewData');
        window.history.replaceState({}, document.title, window.location.pathname);
    }
};

// Function to view staff details
function viewStaff(staffId) {
    var currentPath = window.location.pathname;
    console.log("viewStaff clicked with staffId: " + staffId);

    if (currentPath.indexOf('/manager/') !== -1) {
        window.location.href = contextPath + "/manager/ViewStaffServlet?staffId=" + staffId;
    } else {
        window.location.href = contextPath + "/staff/ViewStaffServlet?staffId=" + staffId;
    }
}

// Function to navigate to view-only staff details page
function viewStaffDetails(staffId) {
    var currentPath = window.location.pathname;
    console.log("viewStaffDetails clicked with staffId: " + staffId);

    if (currentPath.indexOf('/manager/') !== -1) {
        window.location.href = contextPath + "/manager/ViewStaffDetailServlet?staffId=" + staffId;
    } else {
        window.location.href = contextPath + "/staff/ViewStaffDetailServlet?staffId=" + staffId;
    }
}

// Function to navigate to edit staff page
function editStaff(staffId) {
    console.log("editStaff clicked with staffId: " + staffId);
    window.location.href = contextPath + "/manager/ap_edit_staff.jsp?staffId=" + staffId;
}

// Function to navigate to add staff page
function addStaff() {
    console.log("addStaff clicked");
    window.location.href = contextPath + "/manager/ap_add_staff.jsp";
}

// Function to prepare delete modal with staff ID
function deleteStaff(staffId) {
    console.log("deleteStaff clicked with staffId: " + staffId);
    
    // Set the staffId in the hidden field of the delete confirmation modal
    document.getElementById('deleteStaffId').value = staffId;
    
    // Show the delete confirmation modal
    const deleteModal = new bootstrap.Modal(document.getElementById('deleteStaffModal'));
    deleteModal.show();
}

// For search functionality
document.addEventListener('DOMContentLoaded', function () {
    var clearSearch = document.getElementById('clearSearch');
    if (clearSearch) {
        clearSearch.addEventListener('click', function () {
            var searchInput = document.getElementById('searchInput');
            if (searchInput) {
                searchInput.value = '';
            }
        });
    }
    
    // Handle add staff button
    var addStaffBtn = document.getElementById('addStaffBtn');
    if (addStaffBtn) {
        addStaffBtn.addEventListener('click', function() {
            addStaff();
        });
    }
    
    // Handle delete staff form submission
    var deleteStaffForm = document.getElementById('deleteStaffForm');
    if (deleteStaffForm) {
        deleteStaffForm.addEventListener('submit', function(e) {
            // Show loading modal before submission
            const loadingModal = new bootstrap.Modal(document.getElementById('loadingModal'));
            loadingModal.show();
            
            // Hide delete modal
            const deleteModal = bootstrap.Modal.getInstance(document.getElementById('deleteStaffModal'));
            if (deleteModal) {
                deleteModal.hide();
            }
            
            // Form will continue submission normally
        });
    }
    
    // Handle edit staff form submission
    var editStaffForm = document.getElementById('editStaffForm');
    if (editStaffForm) {
        editStaffForm.addEventListener('submit', function(e) {
            // Show loading modal before submission
            const loadingModal = new bootstrap.Modal(document.getElementById('loadingModal'));
            loadingModal.show();
            // Form will continue submission normally
        });
    }
    
    // Handle add staff form submission 
    var addStaffForm = document.getElementById('addStaffForm');
    if (addStaffForm) {
        addStaffForm.addEventListener('submit', function(e) {
            // Form validation is handled by the validateAddStaffForm function
        });
    }
    
    // Handle reset password form submission
    var resetPasswordForm = document.getElementById('resetPasswordForm');
    if (resetPasswordForm) {
        resetPasswordForm.addEventListener('submit', function(e) {
            // Show loading modal before submission
            const loadingModal = new bootstrap.Modal(document.getElementById('loadingModal'));
            loadingModal.show();
            
            // Hide reset password modal
            const resetModal = bootstrap.Modal.getInstance(document.getElementById('resetPasswordModal'));
            if (resetModal) {
                resetModal.hide();
            }
            
            // Form will continue submission normally
        });
    }
}); 