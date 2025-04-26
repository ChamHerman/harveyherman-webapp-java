document.addEventListener('DOMContentLoaded', function () {
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
});