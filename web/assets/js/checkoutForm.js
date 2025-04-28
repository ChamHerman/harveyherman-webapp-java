// Validate Delivery Details and Card Format
document.addEventListener('DOMContentLoaded', function () {
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
    
    // Length validation for address (less than 100 characters)
    var addressInput = document.getElementById('address');
    if (addressInput) {
        var addressErrorMsg = document.createElement('div');
        addressErrorMsg.style.color = 'red';
        addressErrorMsg.style.fontSize = '0.9em';
        addressErrorMsg.style.marginTop = '4px';
        addressErrorMsg.id = 'address-error-msg';
        addressInput.parentNode.insertBefore(addressErrorMsg, addressInput.nextSibling);

        addressInput.addEventListener('input', function () {
            if (addressInput.value.length >= 100) {
                addressErrorMsg.textContent = "Address must be less than 100 characters.";
                addressInput.style.borderColor = 'red';
            } else {
                addressErrorMsg.textContent = "";
                addressInput.style.borderColor = '';
            }
        });
    }
    
    
    // Card Number formatting
    const cardNumberInput = document.getElementById('cardNumber');
    if (cardNumberInput) {
        cardNumberInput.addEventListener('input', function (e) {
            let value = e.target.value.replace(/\D/g, ''); // Remove non-digits
            value = value.substring(0, 16); // Max 16 digits
            let formatted = '';
            for (let i = 0; i < value.length; i += 4) {
                if (i > 0)
                    formatted += '-';
                formatted += value.substring(i, i + 4);
            }
            e.target.value = formatted;
        });
        cardNumberInput.addEventListener('keypress', function (e) {
            if (!/\d/.test(e.key))
                e.preventDefault();
        });
    }

    // Expiry Date formatting
    const expiryInput = document.getElementById('expiryDate');
    if (expiryInput) {
        expiryInput.addEventListener('input', function (e) {
            let value = e.target.value.replace(/\D/g, ''); // Remove non-digits
            value = value.substring(0, 4); // Max 4 digits (MMYY)
            if (value.length > 2) {
                value = value.substring(0, 2) + '-' + value.substring(2);
            }
            e.target.value = value;
        });
        expiryInput.addEventListener('keypress', function (e) {
            if (!/\d/.test(e.key))
                e.preventDefault();
        });
    }

    // CVV formatting
    const cvvInput = document.getElementById('cvv');
    if (cvvInput) {
        cvvInput.addEventListener('input', function (e) {
            let value = e.target.value.replace(/\D/g, '');
            value = value.substring(0, 3);
            e.target.value = value;
        });
        cvvInput.addEventListener('keypress', function (e) {
            if (!/\d/.test(e.key))
                e.preventDefault();
        });
    }

    // Card Holder Name formatting (only letters and spaces)
    const cardHolderInput = document.getElementById('cardHolder');
    if (cardHolderInput) {
        cardHolderInput.addEventListener('input', function (e) {
            let value = e.target.value.replace(/[^a-zA-Z\s]/g, '');
            e.target.value = value;
        });
    }

    //Add validation on form submit
    const checkoutForm = document.getElementById('checkoutForm');
    if (checkoutForm) {
        checkoutForm.addEventListener('submit', function (e) {
            // Payment method validation
            const paymentMethods = checkoutForm.querySelectorAll('input[name="paymentMethod"]');
            let paymentSelected = false;
            paymentMethods.forEach(function (pm) {
                if (pm.checked) paymentSelected = true;
            });
            const paymentErrorDiv = document.getElementById('paymentError');
            if (!paymentSelected) {
                if (paymentErrorDiv) paymentErrorDiv.innerText = 'Please select a payment method.';
                e.preventDefault();
                return;
            } else {
                if (paymentErrorDiv) paymentErrorDiv.innerText = '';
            }
            const cardInfo = document.getElementById('cardInfo');
            if (cardInfo && cardInfo.style.display !== 'none') {
                const cardHolder = cardHolderInput.value.trim();
                const cardNumber = cardNumberInput.value.replace(/\D/g, '');
                const expiry = expiryInput.value;
                const cvv = cvvInput.value;
                let error = '';
                if (!cardHolder) {
                    error = 'Card holder name is required.';
                } else if (!/^[a-zA-Z\s]+$/.test(cardHolder)) {
                    error = 'Card holder name must only contain letters and spaces.';
                } else if (cardNumber.length !== 16) {
                    error = 'Card number must be 16 digits.';
                } else {
                    // Validate expiry date logic
                    const expiryMatch = expiry.match(/^(\d{2})-(\d{2})$/);
                    if (!expiryMatch) {
                        error = 'Expiry date must be in MM-YY format.';
                    } else {
                        const inputMonth = parseInt(expiryMatch[1], 10);
                        const inputYear = 2000 + parseInt(expiryMatch[2], 10);
                        const now = new Date();
                        const currentYear = now.getFullYear();
                        const currentMonth = now.getMonth() + 1; // JS months are 0-based

                        if (inputMonth < 1 || inputMonth > 12) {
                            error = 'Expiry month must be between 01 and 12.';
                        } else if (inputYear < currentYear) {
                            error = 'Card expired.';
                        } else if (inputYear > currentYear + 25) {
                            error = 'Year cannot be more than 25 years in the future.';
                        } else if (inputYear === currentYear && inputMonth < currentMonth) {
                            error = 'Card expired.';
                        }
                    }
                }
                //check ccv
                if (!error && cvv.length !== 3) {
                    error = 'CVV must be 3 digits.';
                }

                if (error) {
                    document.getElementById('cardError').innerText = error;
                    e.preventDefault();
                } else {
                    document.getElementById('cardError').innerText = '';
                }
            }
        });
    }
}); 