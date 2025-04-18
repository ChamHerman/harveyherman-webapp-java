DROP DATABASE IF EXISTS harveyhermandb;
CREATE DATABASE harveyhermandb;
USE harveyhermandb;

-- UserData: Stores customer information
CREATE TABLE UserData (
    user_id VARCHAR(10) PRIMARY KEY,
    fullname VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    contact_number VARCHAR(20),
    address TEXT,
    birth_date DATE,
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- UserLogin: Stores customer login credentials
CREATE TABLE UserLogin (
    login_id VARCHAR(10) PRIMARY KEY,
    user_id VARCHAR(10) UNIQUE,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    last_login TIMESTAMP DEFAULT NULL,
    FOREIGN KEY (user_id) REFERENCES UserData(user_id) ON DELETE CASCADE
);


-- Item: Stores product information
CREATE TABLE Item (
    item_id VARCHAR(10) PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    price DECIMAL(10,2) NOT NULL,
    stock_quantity INT NOT NULL DEFAULT 0,
    category VARCHAR(50),
    image_url VARCHAR(255),
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Promotion: Stores promotional codes and discounts
CREATE TABLE Promotion (
    promotion_id VARCHAR(10) PRIMARY KEY,
    promotion_code VARCHAR(50) NOT NULL UNIQUE,
    discount_value DECIMAL(10,2) NOT NULL,
    status ENUM('active', 'expired') NOT NULL,
    minimum_purchase DECIMAL(10,2),
    description TEXT,
    start_date DATE,
    end_date DATE
);


-- Orders: Tracks customer orders
CREATE TABLE Orders (
    order_id VARCHAR(10) PRIMARY KEY,
    user_id VARCHAR(10) NOT NULL,
    total_amount DECIMAL(10,2) NOT NULL,
    payment_method ENUM('cash', 'debit_card', 'credit_card', 'e-wallet') NOT NULL,
    status ENUM('pending', 'packaging', 'shipping', 'delivered') DEFAULT 'pending',
    promotion_id VARCHAR(10) DEFAULT NULL,
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES UserData(user_id) ON DELETE CASCADE,
    FOREIGN KEY (promotion_id) REFERENCES Promotion(promotion_id) ON DELETE SET NULL
);

-- OrderDetails: Tracks items in each order
CREATE TABLE OrderDetails (
    detail_id VARCHAR(10) PRIMARY KEY,
    order_id VARCHAR(10) NOT NULL,
    item_id VARCHAR(10) NOT NULL,
    quantity INT NOT NULL,
    price_per_item DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES Orders(order_id) ON DELETE CASCADE,
    FOREIGN KEY (item_id) REFERENCES Item(item_id) ON DELETE CASCADE
);

-- Delivery: Stores delivery information for orders
CREATE TABLE Delivery (
    delivery_id VARCHAR(10) PRIMARY KEY,
    order_id VARCHAR(10) NOT NULL,
    shipping_address TEXT NOT NULL,
    shipping_status ENUM('pending', 'shipped', 'delivered') DEFAULT 'pending',
    expected_date DATE,
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    delivered_date TIMESTAMP NULL,
    FOREIGN KEY (order_id) REFERENCES Orders(order_id) ON DELETE CASCADE
);

-- Cart: Stores customer cart information
CREATE TABLE Cart (
    cart_id VARCHAR(10) PRIMARY KEY,
    total DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    user_id VARCHAR(10) NOT NULL,
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES UserData(user_id) ON DELETE CASCADE
);

-- Cart_Item: Tracks items in a cart
CREATE TABLE Cart_Item (
    cart_item_id VARCHAR(10) PRIMARY KEY,
    quantity INT NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    subtotal DECIMAL(10,2) NOT NULL,
    cart_id VARCHAR(10) NOT NULL,
    item_id VARCHAR(10) NOT NULL,
    FOREIGN KEY (cart_id) REFERENCES Cart(cart_id) ON DELETE CASCADE,
    FOREIGN KEY (item_id) REFERENCES Item(item_id) ON DELETE CASCADE
);


-- Payment: Tracks payment information
CREATE TABLE Payment (
    payment_id VARCHAR(10) PRIMARY KEY,
    payment_status ENUM('pending', 'completed', 'failed') NOT NULL,
    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    payment_method ENUM('cash', 'debit_card', 'credit_card', 'e-wallet') NOT NULL,
    order_id VARCHAR(10) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES Orders(order_id) ON DELETE CASCADE
);


-- StaffData: Stores staff personal information
CREATE TABLE StaffData (
    staff_id VARCHAR(10) PRIMARY KEY,
    fullname VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    contact_number VARCHAR(20),
    address TEXT,
    position ENUM('staff', 'manager') NOT NULL,
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- APLogin: Stores admin portal login information
CREATE TABLE APLogin (
    ap_id VARCHAR(10) PRIMARY KEY,
    staff_id VARCHAR(10) UNIQUE,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    last_login TIMESTAMP DEFAULT NULL,
    position ENUM('staff', 'manager') NOT NULL,
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (staff_id) REFERENCES StaffData(staff_id) ON DELETE CASCADE
);

-- Report: Stores system reports
CREATE TABLE Report (
    report_id VARCHAR(10) PRIMARY KEY,
    report_date DATE NOT NULL,
    report_type VARCHAR(50) NOT NULL,
    total_sales DECIMAL(10,2) DEFAULT 0.00,
    description TEXT
);

-- Review_Rating: Stores product reviews
CREATE TABLE Review_Rating (
    review_id VARCHAR(10) PRIMARY KEY,
    review_date DATE NOT NULL,
    review_grade INT CHECK (review_grade BETWEEN 1 AND 5),
    comment TEXT,
    user_id VARCHAR(10) NOT NULL,
    item_id VARCHAR(10) NOT NULL,
    FOREIGN KEY (user_id) REFERENCES UserData(user_id) ON DELETE CASCADE,
    FOREIGN KEY (item_id) REFERENCES Item(item_id) ON DELETE CASCADE
);

