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
});
