document.addEventListener('DOMContentLoaded', function () {
    var popup = document.getElementById('index-popup');
    if (popup) {
        // Slide in
        setTimeout(function () {
            popup.classList.add('show');
        }, 100); // slight delay for transition

        // Slide out after 3 seconds
        setTimeout(function () {
            popup.classList.remove('show');
            popup.classList.add('hide');
        }, 3100);

        // Remove from DOM after animation
        setTimeout(function () {
            if (popup.parentNode) {
                popup.parentNode.removeChild(popup);
            }
        }, 3700);
    }
});
