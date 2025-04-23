-- Host: localhost    Database: harveyhermandb
-- Server version	8.4.4

DROP DATABASE IF EXISTS harveyhermandb;
CREATE DATABASE harveyhermandb;

USE harveyhermandb;

-- UserData: Stores customer information
CREATE TABLE UserData (
    user_id VARCHAR(255) PRIMARY KEY,
    fullname VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL,
    contact_number VARCHAR(255) NOT NULL,
    address TEXT,
    birth_date DATE,
	gender VARCHAR(255) NOT NULL,
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- UserLogin: Stores customer login credentials
CREATE TABLE UserLogin (
    login_id VARCHAR(255) PRIMARY KEY,
    user_id VARCHAR(255) UNIQUE,
	answer VARCHAR(255) NOT NULL,
	challenge_question VARCHAR(255) NOT NULL,
    username VARCHAR(255) NOT NULL,
    password VARCHAR(255) NOT NULL,
    last_login TIMESTAMP DEFAULT NULL,
    FOREIGN KEY (user_id) REFERENCES UserData(user_id) ON DELETE CASCADE
);

-- Item: Stores product information
CREATE TABLE Item (
    item_id VARCHAR(255) PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    price DECIMAL(25,2) NOT NULL,
    stock_quantity INT NOT NULL DEFAULT 0,
    category VARCHAR(255),
    image_url VARCHAR(255),
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Promotion: Stores promotional codes and discounts
CREATE TABLE Promotion (
    promotion_id VARCHAR(255) PRIMARY KEY,
    promotion_code VARCHAR(255) NOT NULL,
    discount_value DECIMAL(25,2) NOT NULL,
    status ENUM('active', 'expired') NOT NULL,
    minimum_purchase DECIMAL(25,2),
    description TEXT,
    start_date DATE,
    end_date DATE
);

-- Orders: Tracks customer orders
CREATE TABLE Orders (
    order_id VARCHAR(255) PRIMARY KEY,
    user_id VARCHAR(255) NOT NULL,
    total_amount DECIMAL(25,2) NOT NULL,
    payment_method ENUM('cash', 'debit_card', 'credit_card', 'e-wallet') NOT NULL,
    status ENUM('packaging', 'shipping', 'delivery', 'delivered') DEFAULT 'packaging',
    promotion_id VARCHAR(255) DEFAULT NULL,
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES UserData(user_id) ON DELETE CASCADE,
    FOREIGN KEY (promotion_id) REFERENCES Promotion(promotion_id) ON DELETE SET NULL
);

-- OrderDetails: Tracks items in each order
CREATE TABLE OrderDetails (
    detail_id VARCHAR(255) PRIMARY KEY,
    order_id VARCHAR(255) NOT NULL,
    item_id VARCHAR(255) NOT NULL,
    quantity INT NOT NULL,
    price_per_item DECIMAL(25,2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES Orders(order_id) ON DELETE CASCADE,
    FOREIGN KEY (item_id) REFERENCES Item(item_id) ON DELETE CASCADE
);

-- Delivery: Stores delivery information for orders
CREATE TABLE Delivery (
    delivery_id VARCHAR(255) PRIMARY KEY,
    order_id VARCHAR(255) NOT NULL,
	receiver_name VARCHAR(255) NOT NULL,
	receiver_contact VARCHAR(255) NOT NULL,
    receiver_address TEXT NOT NULL,
	delivered_date TIMESTAMP NULL,
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (order_id) REFERENCES Orders(order_id) ON DELETE CASCADE
);

-- Cart: Stores customer cart information
CREATE TABLE Cart (
    cart_id VARCHAR(255) PRIMARY KEY,
    total DECIMAL(25,2) NOT NULL DEFAULT 0.00,
    user_id VARCHAR(255) NOT NULL,
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES UserData(user_id) ON DELETE CASCADE
);

-- Cart_Item: Tracks items in a cart
CREATE TABLE Cart_Item (
    cart_item_id VARCHAR(255) PRIMARY KEY,
    quantity INT NOT NULL,
    unit_price DECIMAL(25,2) NOT NULL,
    subtotal DECIMAL(25,2) NOT NULL,
    cart_id VARCHAR(255) NOT NULL,
    item_id VARCHAR(255) NOT NULL,
    FOREIGN KEY (cart_id) REFERENCES Cart(cart_id) ON DELETE CASCADE,
    FOREIGN KEY (item_id) REFERENCES Item(item_id) ON DELETE CASCADE
);

-- Payment: Tracks payment information
CREATE TABLE Payment (
    payment_id VARCHAR(255) PRIMARY KEY,
    payment_status ENUM('pending', 'completed', 'failed') NOT NULL,
    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    payment_method ENUM('cash', 'debit_card', 'credit_card', 'e-wallet') NOT NULL,
    order_id VARCHAR(255) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES Orders(order_id) ON DELETE CASCADE
);

-- StaffData: Stores staff personal information
CREATE TABLE StaffData (
    staff_id VARCHAR(255) PRIMARY KEY,
    fullname VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL,
    contact_number VARCHAR(255),
    address TEXT,
    position VARCHAR(255) NOT NULL,
	gender VARCHAR(255) NOT NULL,
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- StaffLogin: Stores admin portal login information
CREATE TABLE StaffLogin (
    login_id VARCHAR(255) PRIMARY KEY,
    username VARCHAR(255) NOT NULL,
    password VARCHAR(255) NOT NULL,
    last_login TIMESTAMP DEFAULT NULL,
    role ENUM('staff', 'manager') NOT NULL,
	staff_id VARCHAR(255) UNIQUE,
    FOREIGN KEY (staff_id) REFERENCES StaffData(staff_id) ON DELETE CASCADE
);

-- Report: Stores sales reports
CREATE TABLE Report (
    report_id VARCHAR(255) PRIMARY KEY,
    report_date DATE NOT NULL,
    report_type VARCHAR(255) NOT NULL,
    total_sales DECIMAL(25,2) DEFAULT 0.00,
    description TEXT
);

ALTER TABLE UserData ADD COLUMN dbstatus ENUM('active', 'deleted') DEFAULT 'active';
ALTER TABLE UserLogin ADD COLUMN dbstatus ENUM('active', 'deleted') DEFAULT 'active';
ALTER TABLE Item ADD COLUMN dbstatus ENUM('active', 'deleted') DEFAULT 'active';
ALTER TABLE Promotion ADD COLUMN dbstatus ENUM('active', 'deleted') DEFAULT 'active';
ALTER TABLE Orders ADD COLUMN dbstatus ENUM('active', 'deleted') DEFAULT 'active';
ALTER TABLE OrderDetails ADD COLUMN dbstatus ENUM('active', 'deleted') DEFAULT 'active';
ALTER TABLE Delivery ADD COLUMN dbstatus ENUM('active', 'deleted') DEFAULT 'active';
ALTER TABLE Cart ADD COLUMN dbstatus ENUM('active', 'deleted') DEFAULT 'active';
ALTER TABLE Cart_Item ADD COLUMN dbstatus ENUM('active', 'deleted') DEFAULT 'active';
ALTER TABLE Payment ADD COLUMN dbstatus ENUM('active', 'deleted') DEFAULT 'active';
ALTER TABLE StaffData ADD COLUMN dbstatus ENUM('active', 'deleted') DEFAULT 'active';
ALTER TABLE StaffLogin ADD COLUMN dbstatus ENUM('active', 'deleted') DEFAULT 'active';
ALTER TABLE Report ADD COLUMN dbstatus ENUM('active', 'deleted') DEFAULT 'active';