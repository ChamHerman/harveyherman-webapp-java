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
                    document.getElementById('userResultMessage').textContent = decodeURIComponent(messageParam);
                } catch (e) {
                    document.getElementById('userResultMessage').textContent = messageParam;
                }

                const modalElement = document.getElementById('userResultMessageModal');
                const messageModal = new bootstrap.Modal(modalElement);
                messageModal.show();

                // Clean the URL without the message parameter
                urlParams.delete('message');
                window.history.replaceState({}, document.title, window.location.pathname);
            }, 500); // 0.5 second delay
        }
    }

    // To show View User Modal
    const viewDataParam = urlParams.get('viewData');
    if (viewDataParam) {
        try {
            const viewDataObj = JSON.parse(decodeURIComponent(viewDataParam));
            console.log("Received viewData:", viewDataObj);
            if (viewDataObj.success) {
                document.getElementById('viewUserId').textContent = viewDataObj.userId;
                document.getElementById('viewFullName').textContent = viewDataObj.fullName;
                document.getElementById('viewEmail').textContent = viewDataObj.email;
                document.getElementById('viewContactNumber').textContent = viewDataObj.contactNumber;
                document.getElementById('viewAddress').textContent = viewDataObj.address;
                document.getElementById('viewBirthDate').textContent = viewDataObj.birthDate;
                document.getElementById('viewGender').textContent = viewDataObj.gender;
                document.getElementById('viewCreatedDate').textContent = viewDataObj.createdDate;
                document.getElementById('viewLoginId').textContent = viewDataObj.loginId;
                document.getElementById('viewUsername').textContent = viewDataObj.username;
                document.getElementById('viewChallengeQuestion').textContent = viewDataObj.challengeQuestion;
                document.getElementById('viewAnswer').textContent = viewDataObj.answer;
                document.getElementById('viewLastLogin').textContent = viewDataObj.lastLogin;
                
                const modal = new bootstrap.Modal(document.getElementById('viewUserModal'));
                modal.show();
            }
        } catch (e) {
            console.error("Error parsing viewData JSON:", e);
        }
        urlParams.delete('viewData');
        window.history.replaceState({}, document.title, window.location.pathname);
    }
};

// Function to view user details
function viewUser(userId) {
    var currentPath = window.location.pathname;
    console.log("viewUser clicked with userId: " + userId);

    if (currentPath.indexOf('/manager/') !== -1) {
        window.location.href = contextPath + "/manager/ViewUsersServlet?userId=" + userId;
    } else {
        window.location.href = contextPath + "/staff/ViewUsersServlet?userId=" + userId;
    }
}

// Function to navigate to edit user page
function editUser(userId) {
    console.log("editUser clicked with userId: " + userId);
    window.location.href = contextPath + "/manager/ap_edit_user.jsp?userId=" + userId;
}

// Function to navigate to add user page
function addUser() {
    console.log("addUser clicked");
    window.location.href = contextPath + "/manager/ap_add_user.jsp";
}

// Function to prepare delete modal with user ID
function deleteUser(userId) {
    console.log("deleteUser clicked with userId: " + userId);
    
    // Set the userId in the hidden field of the delete confirmation modal
    document.getElementById('deleteUserId').value = userId;
    
    // Show the delete confirmation modal
    const deleteModal = new bootstrap.Modal(document.getElementById('deleteUserModal'));
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
    
    // Handle add user button
    var addUserBtn = document.getElementById('addUserBtn');
    if (addUserBtn) {
        addUserBtn.addEventListener('click', function() {
            addUser();
        });
    }
    
    // Handle delete user form submission
    var deleteUserForm = document.getElementById('deleteUserForm');
    if (deleteUserForm) {
        deleteUserForm.addEventListener('submit', function(e) {
            // Show loading modal before submission
            const loadingModal = new bootstrap.Modal(document.getElementById('loadingModal'));
            loadingModal.show();
            
            // Hide delete modal
            const deleteModal = bootstrap.Modal.getInstance(document.getElementById('deleteUserModal'));
            if (deleteModal) {
                deleteModal.hide();
            }
            
            // Form will continue submission normally
        });
    }
    
    // Handle edit user form submission
    var editUserForm = document.getElementById('editUserForm');
    if (editUserForm) {
        editUserForm.addEventListener('submit', function(e) {
            // Show loading modal before submission
            const loadingModal = new bootstrap.Modal(document.getElementById('loadingModal'));
            loadingModal.show();
            // Form will continue submission normally
        });
    }
    
    // Handle add user form submission 
    var addUserForm = document.getElementById('addUserForm');
    if (addUserForm) {
        addUserForm.addEventListener('submit', function(e) {
            // Form validation is handled by the validateAddUserForm function
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