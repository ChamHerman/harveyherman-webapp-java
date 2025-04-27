document.addEventListener('DOMContentLoaded', function () {
    // Length validation for address (less than 1000 characters)
    var addressInput = document.getElementById('address');
    if (addressInput) {
        var addressErrorMsg = document.createElement('div');
        addressErrorMsg.style.color = 'red';
        addressErrorMsg.style.fontSize = '0.9em';
        addressErrorMsg.style.marginTop = '4px';
        addressErrorMsg.id = 'address-error-msg';
        addressInput.parentNode.insertBefore(addressErrorMsg, addressInput.nextSibling);

        addressInput.addEventListener('input', function () {
            if (addressInput.value.length >= 1000) {
                addressErrorMsg.textContent = "Address must be less than 1000 characters.";
                addressInput.style.borderColor = 'red';
            } else {
                addressErrorMsg.textContent = "";
                addressInput.style.borderColor = '';
            }
        });
    }

    // Length validation for fields (less than 255 characters)
    [
        {id: 'fullname', label: 'Full name'},
        {id: 'email', label: 'Email'},
        {id: 'username', label: 'Username'},
        {id: 'password', label: 'Password'},
        {id: 'answer', label: 'Answer'},
        {id: 'position', label: 'Position'}
    ].forEach(function (field) {
        var input = document.getElementById(field.id);
        if (input) {
            var errorMsg = document.createElement('div');
            errorMsg.style.color = 'red';
            errorMsg.style.fontSize = '0.9em';
            errorMsg.style.marginTop = '4px';
            errorMsg.id = field.id + '-length-error-msg';
            // Special handling for password field: insert after .password-field-container
            if (field.id === 'password') {
                var passwordContainer = input.closest('.password-field-container');
                if (passwordContainer) {
                    passwordContainer.parentNode.insertBefore(errorMsg, passwordContainer.nextSibling);
                } else {
                    input.parentNode.insertBefore(errorMsg, input.nextSibling);
                }
            } else {
                input.parentNode.insertBefore(errorMsg, input.nextSibling);
            }

            input.addEventListener('input', function () {
                if (input.value.length >= 255) {
                    errorMsg.textContent = field.label + " must be less than 255 characters.";
                    input.style.borderColor = 'red';
                } else {
                    errorMsg.textContent = "";
                    input.style.borderColor = '';
                }
            });
        }
    });

    // Email validation
    var emailInput = document.getElementById('email');
    if (emailInput) {
        var emailErrorMsg = document.createElement('div');
        emailErrorMsg.style.color = 'red';
        emailErrorMsg.style.fontSize = '0.9em';
        emailErrorMsg.style.marginTop = '4px';
        emailErrorMsg.id = 'email-error-msg';
        emailInput.parentNode.insertBefore(emailErrorMsg, emailInput.nextSibling);

        var allowedPattern = /^[a-z0-9@._+\-]+$/;
        var emailFormatPattern = /^[a-z0-9._+\-]+@[a-z0-9._+\-]+\.[a-z]{2,}$/;

        emailInput.addEventListener('input', function () {
            var email = emailInput.value;

            if (!allowedPattern.test(email)) {
                emailErrorMsg.textContent = "Only lowercase letters, numbers, and @ . _ - + are allowed.";
                emailInput.style.borderColor = 'red';
            } else if (!emailFormatPattern.test(email)) {
                emailErrorMsg.textContent = "Email format is invalid. It should be like xxxx@xxxx.xxx";
                emailInput.style.borderColor = 'red';
            } else {
                emailErrorMsg.textContent = "";
                emailInput.style.borderColor = '';
            }
        });
    }

    // Contact number validation
    var contactInput = document.getElementById('contactNumber');
    if (contactInput) {
        var contactErrorMsg = document.createElement('div');
        contactErrorMsg.style.color = 'red';
        contactErrorMsg.style.fontSize = '0.9em';
        contactErrorMsg.style.marginTop = '4px';
        contactErrorMsg.id = 'contact-error-msg';
        contactInput.parentNode.insertBefore(contactErrorMsg, contactInput.nextSibling);

        // Pattern: starts with 60, followed by 9 or 10 digits (total 11 or 12 digits)
        var contactPattern = /^60\d{9,10}$/;

        contactInput.addEventListener('input', function () {
            var contact = contactInput.value;

            if (!contactPattern.test(contact)) {
                contactErrorMsg.textContent = "Contact number must start with 60 and be 11 or 12 digits long.";
                contactInput.style.borderColor = 'red';
            } else {
                contactErrorMsg.textContent = "";
                contactInput.style.borderColor = '';
            }
        });
    }

    // Password validation
    ['password', 'newPassword'].forEach(function (id) {
        var passwordInput = document.getElementById(id);
        if (passwordInput) {
            var passwordErrorMsg = document.createElement('div');
            passwordErrorMsg.style.color = 'red';
            passwordErrorMsg.style.fontSize = '0.9em';
            passwordErrorMsg.style.marginTop = '4px';
            passwordErrorMsg.id = id + '-error-msg';

            // Insert error message after the password field container, not after the input
            var passwordContainer = passwordInput.closest('.password-field-container');
            if (passwordContainer) {
                passwordContainer.parentNode.insertBefore(passwordErrorMsg, passwordContainer.nextSibling);
            } else {
                // fallback: insert after input if container not found
                passwordInput.parentNode.insertBefore(passwordErrorMsg, passwordInput.nextSibling);
            }

            // At least 8 chars, one uppercase, one lowercase, one number, one symbol from !@#$%^&_.-+=
            var passwordPattern = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&_.\-+=]).{8,}$/;

            passwordInput.addEventListener('input', function () {
                var password = passwordInput.value;

                if (!passwordPattern.test(password)) {
                    passwordErrorMsg.textContent = "Password must be at least 8 characters and include uppercase, lowercase, number, and symbol (!@#$%^&_.-+=).";
                    passwordInput.style.borderColor = 'red';
                } else {
                    passwordErrorMsg.textContent = "";
                    passwordInput.style.borderColor = '';
                }
            });
        }
    });

    // Birth date validation: cannot be in the future
    var birthDateInput = document.getElementById('birthDate');
    if (birthDateInput) {
        var birthDateErrorMsg = document.createElement('div');
        birthDateErrorMsg.style.color = 'red';
        birthDateErrorMsg.style.fontSize = '0.9em';
        birthDateErrorMsg.style.marginTop = '4px';
        birthDateErrorMsg.id = 'birthDate-error-msg';
        birthDateInput.parentNode.insertBefore(birthDateErrorMsg, birthDateInput.nextSibling);

        birthDateInput.addEventListener('input', function () {
            var selectedDate = new Date(birthDateInput.value);
            var today = new Date();
            // Set time to 00:00:00 for accurate comparison
            today.setHours(0, 0, 0, 0);

            if (birthDateInput.value && selectedDate > today) {
                birthDateErrorMsg.textContent = "Birthdate cannot be in the future.";
                birthDateInput.style.borderColor = 'red';
            } else {
                birthDateErrorMsg.textContent = "";
                birthDateInput.style.borderColor = '';
            }
        });
    }

    // Prevent form submission if there are errors and focus the first error field
    var form = document.querySelector('form'); // or use document.getElementById('myForm');
    if (form) {
        form.addEventListener('submit', function (e) {
            var errorFields = [];
            // Check all error message divs for visible errors
            var errorMsgs = form.querySelectorAll('div[id$="-error-msg"], div[id$="-length-error-msg"]');
            errorMsgs.forEach(function (msg) {
                if (msg.textContent && msg.textContent.trim() !== "") {
                    // Find the related input
                    var relatedInput = null;
                    // Try to find the input before the error message
                    if (msg.previousElementSibling && msg.previousElementSibling.tagName === "INPUT") {
                        relatedInput = msg.previousElementSibling;
                    } else {
                        // For password, error is after .password-field-container
                        var container = msg.previousElementSibling;
                        if (container && container.classList && container.classList.contains('password-field-container')) {
                            relatedInput = container.querySelector('input');
                        }
                    }
                    if (relatedInput) {
                        errorFields.push(relatedInput);
                    }
                }
            });

            // Also check length constraints in case JS validation missed it
            var addressInput = document.getElementById('address');
            if (addressInput && addressInput.value.length >= 1000) {
                errorFields.push(addressInput);
            }
            [
                'fullname', 'email', 'username', 'password', 'answer', 'position'
            ].forEach(function (id) {
                var input = document.getElementById(id);
                if (input && input.value.length >= 255) {
                    errorFields.push(input);
                }
            });

            if (errorFields.length > 0) {
                e.preventDefault();
                // Focus the first field with error
                errorFields[0].focus();
            }
        });
    }
});