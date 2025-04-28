document.addEventListener("DOMContentLoaded", function () {

    var path = window.location.pathname.split("/").pop().split("?")[0];

    // Map page names to their corresponding sidebar link IDs.
    var pageMap = {
        "index.jsp": "index-link",
        "items": "shop-link",
        "about.jsp": "about-link",
        "services.jsp": "services-link",
        "contact.jsp": "contact-link"
    };

    var link = document.getElementById(pageMap[path]);
    if (link) {
        link.parentElement.classList.add("active");
    }
});
