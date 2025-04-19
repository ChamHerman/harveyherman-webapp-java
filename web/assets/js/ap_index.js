
document.addEventListener("DOMContentLoaded", function () {
    // Get the current page filename from the URL and remove any query parameters.
    var path = window.location.pathname.split("/").pop().split("?")[0];

    // Map page names to their corresponding sidebar link IDs.
    var pageMap = {
        "ap_index.jsp": "dashboard-link",
        "ap_item.jsp": "item-management-link",
        "ap_order.jsp": "order-management-link",
        "ap_user.jsp": "user-management-link"
    };

    // Highlight the active link if mapping exists.
    if (pageMap[path]) {
        document.getElementById(pageMap[path]).classList.add("active");
    }

    // Dark Mode Toggle Functionality.
    const toggleButton = document.getElementById("theme-toggle");
    const body = document.body;

    // Apply dark mode if it was previously set.
    if (localStorage.getItem("theme") === "dark") {
        body.classList.add("dark-mode");
        toggleButton.textContent = "☀️";
    }

    // Toggle dark mode on button click and store preference.
    toggleButton.addEventListener("click", function () {
        body.classList.toggle("dark-mode");
        if (body.classList.contains("dark-mode")) {
            localStorage.setItem("theme", "dark");
            toggleButton.textContent = "☀️";
        } else {
            localStorage.setItem("theme", "light");
            toggleButton.textContent = "🌙";
        }
    });
});
