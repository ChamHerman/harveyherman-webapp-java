function validateForm() {
            const fullname = document.getElementById("fullname").value.trim();
            const email = document.getElementById("email").value.trim();
            const contactNumber = document.getElementById("contact_number").value.trim();
            const address = document.getElementById("address").value.trim();
            const birthDate = document.getElementById("birth_date").value.trim();
            const username = document.getElementById("username").value.trim();
            const password = document.getElementById("password").value.trim();

            if (!fullname || !email || !contactNumber || !address || !birthDate || !username || !password) {
                alert("All fields are required!");
                return false;
            }

            if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) {
                alert("Invalid email format!");
                return false;
            }

            if (password.length < 8) {
                alert("Password must be at least 8 characters!");
                return false;
            }

            return true;
        }