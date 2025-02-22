CREATE DATABASE Food_Order;

use Food_Order;

-- Admin Table
CREATE TABLE Admins (
    admin_id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(255) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE,
    phone VARCHAR(20)
);

-- Restaurants Table
CREATE TABLE Restaurants (
    restaurant_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    address VARCHAR(255),
    cuisine VARCHAR(255),
    rating DECIMAL(3, 2),
    phone VARCHAR(20),
    opening_time TIME,
    closing_time TIME,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Users Table
CREATE TABLE Users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(255) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE,
    phone VARCHAR(20),
    address VARCHAR(255),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Dishes Table with categories
CREATE TABLE Dishes (
    dish_id INT PRIMARY KEY AUTO_INCREMENT,
    restaurant_id INT,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    price DECIMAL(10, 2),
    category VARCHAR(50),  -- New field to categorize dishes (e.g., Appetizers, Main Course, Desserts)
    FOREIGN KEY (restaurant_id) REFERENCES Restaurants(restaurant_id)
);

-- Orders Table
CREATE TABLE Orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    restaurant_id INT,
    order_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    total_amount DECIMAL(10, 2),
    status VARCHAR(50) DEFAULT 'Pending', -- Pending, Confirmed, Shipped, Delivered, Cancelled
    payment_id INT,
    delivery_id INT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (restaurant_id) REFERENCES Restaurants(restaurant_id)
);

-- Order_Items Table
CREATE TABLE Order_Items (
    order_item_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT,
    dish_id INT,
    quantity INT,
    FOREIGN KEY (order_id) REFERENCES Orders(order_id),
    FOREIGN KEY (dish_id) REFERENCES Dishes(dish_id)
);

-- Reviews Table
CREATE TABLE Reviews (
    review_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    restaurant_id INT,
    dish_id INT,
    rating INT,
    comment TEXT,
    review_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (restaurant_id) REFERENCES Restaurants(restaurant_id),
    FOREIGN KEY (dish_id) REFERENCES Dishes(dish_id)
);

-- Payment Table
CREATE TABLE Payment (
    payment_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    amount DECIMAL(10, 2),
    payment_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    payment_method VARCHAR(50), -- Credit Card, Debit Card, UPI, etc.
    transaction_id VARCHAR(255)
);

-- Delivery_Personnel Table
CREATE TABLE Delivery_Personnel (
    delivery_person_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255),
    phone VARCHAR(20),
    vehicle_type VARCHAR(50)
);

-- Delivery Table
CREATE TABLE Delivery (
    delivery_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT,
    delivery_person_id INT,
    delivery_address VARCHAR(255),
    delivery_time DATETIME,
    status VARCHAR(50) DEFAULT 'Pending', -- Pending, Picked Up, On the Way, Delivered
    FOREIGN KEY (order_id) REFERENCES Orders(order_id),
    FOREIGN KEY (delivery_person_id) REFERENCES Delivery_Personnel(delivery_person_id)
);

ALTER TABLE Orders ADD FOREIGN KEY (payment_id) REFERENCES Payment(payment_id);
ALTER TABLE Orders ADD FOREIGN KEY (delivery_id) REFERENCES Delivery(delivery_id);

-- Offers Table (for Discounts/Promotions)
CREATE TABLE Offers (
    offer_id INT PRIMARY KEY AUTO_INCREMENT,
    restaurant_id INT,
    offer_description TEXT,
    discount_percentage DECIMAL(5, 2),
    start_date DATETIME,
    end_date DATETIME,
    FOREIGN KEY (restaurant_id) REFERENCES Restaurants(restaurant_id)
);

-- Order_History Table (for tracking past orders)
CREATE TABLE Order_History (
    history_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    order_id INT,
    order_time DATETIME,
    total_amount DECIMAL(10, 2),
    status VARCHAR(50),
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (order_id) REFERENCES Orders(order_id)
);

-- Inserting Records

-- Restaurants
INSERT INTO Restaurants (name, address, cuisine, rating, phone, opening_time, closing_time) VALUES
('Vedant', '123 Main St', 'Indian', 4.5, '123-456-7890', '10:00:00', '22:00:00'),
('Pizza delight', '456 Oak Ave', 'Italian', 4.2, '987-654-3210', '11:00:00', '23:00:00'),
('Jo', '789 Pine Ln', 'Japanese', 4.8, '555-123-4567', '12:00:00', '21:00:00');

-- Users
INSERT INTO Users (username, password, email, phone, address) VALUES
('Rohan Thite', 'password123', 'rohan.thite@example.com', '111-222-3333', 'Bharti vidhyapeeth'),
('saurabh Thombare', 'secure456', 'saurabh.thombare@example.com', '444-555-6666', 'chinchwad'),
('Adesh lawande', 'secure456', 'aadesh.lawande@example.com', '444-555-6666', 'Warje'),
('Pratik Mali', 'secure456', 'pratik.mali@example.com', '444-555-6666', 'Vishrant Wadi'),
('Grish Joshi', 'secure456', 'girish.joshi@example.com', '444-555-6666', 'Uttamanagar');

-- Dishes
INSERT INTO Dishes (restaurant_id, name, description, price, category) VALUES
(1, 'Butter Chicken', 'Creamy tomato-based curry', 12.99, 'Main Course'),
(1, 'Vegetable Biryani', 'Fragrant rice with vegetables', 9.99, 'Main Course'),
(2, 'Margherita Pizza', 'Classic tomato and mozzarella', 10.99, 'Main Course'),
(2, 'Pepperoni Pizza', 'Pizza with pepperoni slices', 11.99, 'Main Course'),
(3, 'Salmon Sushi', 'Fresh salmon nigiri', 15.99, 'Appetizers'),
(3, 'Tempura Udon', 'Udon noodles with tempura', 13.99, 'Main Course');

-- Orders
INSERT INTO Orders (user_id, restaurant_id, total_amount, status) VALUES
(1, 1, 22.98, 'Confirmed'),
(2, 2, 10.99, 'Pending');

-- Order_Items
INSERT INTO Order_Items (order_id, dish_id, quantity) VALUES
(1, 1, 1),
(1, 2, 1),
(2, 3, 1);

-- Reviews
INSERT INTO Reviews (user_id, restaurant_id, dish_id, rating, comment) VALUES
(1, 1, 1, 5, 'Excellent butter chicken!'),
(2, 2, 3, 4, 'Good pizza.');

-- Payment
INSERT INTO Payment (user_id, amount, payment_method, transaction_id) VALUES
(1, 22.98, 'Credit Card', 'TXN12345'),
(2, 10.99, 'UPI', 'TXN67890');

-- Delivery_Personnel
INSERT INTO Delivery_Personnel (name, phone, vehicle_type) VALUES
('Alice Johnson', '123-987-6543', 'Bike'),
('Bob Williams', '456-321-7890', 'Scooter');

-- Delivery
INSERT INTO Delivery (order_id, delivery_person_id, delivery_address, status) VALUES
(1, 1, '10 Elm St', 'Picked Up'),
(2, 2, '20 Maple Ave', 'Pending');

-- Offers
INSERT INTO Offers (restaurant_id, offer_description, discount_percentage, start_date, end_date) VALUES
(1, '20% off on Butter Chicken', 20.00, '2025-02-01', '2025-02-28'),
(2, 'Buy 1 Get 1 Free on Pizzas', 50.00, '2025-02-01', '2025-02-28');

-- Tracking Order History
INSERT INTO Order_History (user_id, order_id, order_time, total_amount, status) VALUES
(1, 1, '2025-02-19 14:30:00', 22.98, 'Confirmed'),
(2, 2, '2025-02-20 16:00:00', 10.99, 'Pending');

-- Example Queries

-- Get Top-Rated Restaurants by Cuisine
SELECT r.name, r.cuisine, AVG(rev.rating) AS average_rating
FROM Restaurants r
JOIN Reviews rev ON r.restaurant_id = rev.restaurant_id
GROUP BY r.restaurant_id, r.name, r.cuisine
ORDER BY average_rating DESC;

-- Get Most Popular Dishes
SELECT d.name, COUNT(*) AS order_count
FROM Dishes d
JOIN Order_Items oi ON d.dish_id = oi.dish_id
GROUP BY d.dish_id, d.name
ORDER BY order_count DESC
LIMIT 10;

select * from reviews;

SELECT * FROM Admins;

SELECT * FROM Restaurants;

SELECT * FROM Users;

SELECT * FROM Dishes;


SELECT * FROM Orders;

SELECT * FROM Order_Items;

SELECT * FROM Payment;

SELECT * FROM Delivery;

SELECT * FROM Order_History;

SELECT * FROM Orders WHERE status = 'Pending';

INSERT INTO Admins (username, password, email, phone) VALUES
('admin', 'root12345', 'admin1@foodorder.com', '123-456-7890');

