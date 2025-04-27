// Card formatting and validation

document.addEventListener('DOMContentLoaded', function () {
    // Card Number formatting
    const cardNumberInput = document.getElementById('cardNumber');
    if (cardNumberInput) {
        cardNumberInput.addEventListener('input', function (e) {
            let value = e.target.value.replace(/\D/g, ''); // Remove non-digits
            value = value.substring(0, 16); // Max 16 digits
            let formatted = '';
            for (let i = 0; i < value.length; i += 4) {
                if (i > 0) formatted += '-';
                formatted += value.substring(i, i + 4);
            }
            e.target.value = formatted;
        });
        cardNumberInput.addEventListener('keypress', function (e) {
            if (!/\d/.test(e.key)) e.preventDefault();
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
            if (!/\d/.test(e.key)) e.preventDefault();
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
            if (!/\d/.test(e.key)) e.preventDefault();
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

    // Optional: Add validation on form submit
    const checkoutForm = document.getElementById('checkoutForm');
    if (checkoutForm) {
        checkoutForm.addEventListener('submit', function (e) {
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
                } else if (!/^\d{2}-\d{2}$/.test(expiry)) {
                    error = 'Expiry date must be in MM-YY format.';
                } else if (cvv.length !== 3) {
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