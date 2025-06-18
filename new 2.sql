CREATE DATABASE ZR_db;
USE ZR_db;

CREATE TABLE Staff(
    staff_id       INT PRIMARY KEY,
    first_name     VARCHAR(25) NOT NULL,
    last_name      VARCHAR(25) NOT NULL,
    position       VARCHAR(50),
    hire_date      DATE,
    salary         DECIMAL(10,2) NOT NULL,
    contact_number VARCHAR(15) UNIQUE,
    email          TEXT
);

SELECT * FROM Staff;

INSERT INTO Staff VALUES
	(1, 'John', 'Smith', 'Manager', '2020-05-15', 5000.00, '555-0101', 'john.smith@restaurant.com'),
	(2, 'Maria', 'Garcia', 'Chef', '2021-02-10', 4500.00, '555-0102', 'maria.g@restaurant.com'),
	(3, 'David', 'Lee', 'Waiter', '2022-06-20', 2500.00, '555-0103', 'david.lee@restaurant.com'),
	(4, 'Sarah', 'Johnson', 'Cashier', '2022-01-05', 2200.00, '555-0104', 'sarah.j@restaurant.com'),
	(5, 'Michael', 'Brown', 'Host', '2023-03-12', 2000.00, '555-0105', 'michael.b@restaurant.com');

CREATE TABLE Menu_categories(
    category_id   INT PRIMARY KEY,
    category_name VARCHAR(50),
    description   TEXT
);

SELECT * FROM Menu_categories;

INSERT INTO Menu_categories VALUES
	(1, 'Appetizers', 'Small dishes served before the main course'),
	(2, 'Main Course', 'Primary dish of a meal'),
	(3, 'Desserts', 'Sweet course eaten at the end of a meal'),
	(4, 'Beverages', 'Drinks served with meals'),
	(5, 'Specials', 'Chef\'s special dishes for the day');

CREATE TABLE Menu_items (
    item_id          INT PRIMARY KEY,
    item_name        VARCHAR(50) NOT NULL,
    category_id      INT,
    description      TEXT,
    price            DECIMAL(10,2) NOT NULL,
    preparation_time INT,
    is_vegetarian    BOOLEAN,
    is_available     BOOLEAN,
    FOREIGN KEY (category_id) REFERENCES Menu_categories(category_id)
);

SELECT * FROM Menu_items;

INSERT INTO Menu_items VALUES
	(1, 'Bruschetta', 1, 'Toasted bread topped with tomatoes, garlic and basil', 8.99, 10, TRUE,NULL),
	(2, 'Chicken Wings', 1, 'Crispy fried chicken wings with choice of sauce', 12.99, 15, FALSE,NULL),
	(3, 'Grilled Salmon', 2, 'Fresh salmon fillet with lemon butter sauce', 24.99, 20, FALSE,NULL),
	(4, 'Vegetable Pasta', 2, 'Penne pasta with seasonal vegetables in cream sauce', 16.99, 15, TRUE,NULL),
	(5, 'Chocolate Lava Cake', 3, 'Warm chocolate cake with molten center and vanilla ice cream', 9.99, 10, TRUE,NULL),
	(6, 'Iced Tea', 4, 'Freshly brewed iced tea with lemon', 3.99, 5, TRUE,NULL),
	(7, 'Chef\'s Special Pizza', 5, 'Daily special pizza with seasonal toppings', 18.99, 25, FALSE,NULL);

CREATE TABLE Customers(
    customer_id    INT PRIMARY KEY,
    first_name     VARCHAR(25) NOT NULL,
    last_name      VARCHAR(25) NOT NULL,
    phone          VARCHAR(15) UNIQUE,
    email          TEXT,
    join_date      DATE,
    loyalty_points INT
);

SELECT * FROM Customers;

INSERT INTO Customers VALUES
	(1, 'Robert', 'Wilson', '555-0201', 'robert.w@email.com', '2023-01-15', 150),
	(2, 'Emily', 'Davis', '555-0202', 'emily.d@email.com', '2023-02-20', 75),
	(3, 'James', 'Miller', '555-0203', 'james.m@email.com', '2023-03-10', 200),
	(4, 'Jessica', 'Taylor', '555-0204', NULL, '2023-04-05', 50),
	(5, 'Daniel', 'Anderson', '555-0205', 'daniel.a@email.com', '2023-05-12', 300);

CREATE TABLE Restaurant_tables(
    table_id              INT PRIMARY KEY,
    table_number          VARCHAR(5) NOT NULL,
    capacity              INT,
    location_description  TEXT,
    is_available          BOOLEAN
);

SELECT * FROM Restaurant_tables;

INSERT INTO Restaurant_tables VALUES
	(1, 'T1', 2, 'Window side', TRUE),
	(2, 'T2', 4, 'Center', TRUE),
	(3, 'T3', 6, 'Private corner', TRUE),
	(4, 'T4', 2, 'Near entrance', TRUE),
	(5, 'T5', 8, 'VIP section', TRUE);

CREATE TABLE Reservations(
    reservation_id    INT PRIMARY KEY,
    customer_id       INT,
    table_id          INT,
    reservation_date  DATE,
    reservation_time  TIME,
    party_size        INT,
    special_requests  TEXT,
    status            VARCHAR(25),
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id),
    FOREIGN KEY (table_id) REFERENCES Restaurant_tables(table_id)
);

SELECT * FROM Reservations;

INSERT INTO Reservations VALUES
	(1, 1, 3, '2023-06-15', '19:00:00', 5, 'Anniversary celebration', 'Completed'),
	(2, 2, 2, '2023-06-16', '18:30:00', 3, 'Vegetarian options needed', 'Confirmed'),
	(3, 3, 5, '2023-06-17', '20:00:00', 7, NULL, 'Confirmed'),
	(4, 4, 1, '2023-06-15', '12:30:00', 2, 'High chair needed', 'Completed'),
	(5, 5, 4, '2023-06-18', '13:00:00', 2, NULL, 'Confirmed');

CREATE TABLE Orders(
    order_id        INT PRIMARY KEY,
    table_id        INT,
    customer_id     INT,
    staff_id        INT,
    order_date      DATETIME,
    status          VARCHAR(25),
    total_amount    DECIMAL(10,2),
    payment_status  VARCHAR(25),
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id),
    FOREIGN KEY (table_id) REFERENCES Restaurant_tables(table_id),
    FOREIGN KEY (staff_id) REFERENCES Staff(staff_id)
);

SELECT * FROM Orders;

INSERT INTO Orders VALUES
	(1, 3, 1, 3, '2023-06-15 19:05:00', 'Completed', 142.92, 'Paid'),
	(2, 2, 2, 3, '2023-06-16 18:35:00', 'In Progress', 68.95, 'Partially Paid'),
	(3, 5, 3, 4, '2023-06-17 20:05:00', 'Pending', 210.85, 'Unpaid'),
	(4, 1, 4, 3, '2023-06-15 12:35:00', 'Completed', 32.97, 'Paid'),
	(5, 4, 5, 4, '2023-06-18 13:05:00', 'Pending', 45.96, 'Unpaid');
	
-- 1. List all menu items with their prices, sorted by price (highest to lowest).
SELECT item_id,item_name,description,price FROM Menu_items
ORDER BY price DESC;

-- 2. Show all staff members with their positions and hire dates.
SELECT staff_id,first_name,last_name,position,hire_date FROM Staff;

-- 3. Display all reservations for today's date.
SELECT * FROM Reservations
WHERE reservation_date=DATE(NOW());

-- 4. Find all vegetarian menu items.
SELECT * FROM Menu_items 
WHERE is_vegetarian=TRUE;

-- 5. List all appetizers that take less than 15 minutes to prepare.
SELECT mi.*,mc.category_name
FROM Menu_items mi
JOIN Menu_categories mc
ON mi.category_id=mc.category_id
WHERE mc.category_name='Appetizers' AND preparation_time<15;

-- 6. Show the count of menu items in each category.
SELECT mc.category_name, COUNT(mi.item_id) AS Total_Items
FROM Menu_items mi
RIGHT JOIN Menu_categories mc
ON mi.category_id=mc.category_id
GROUP BY mc.category_name;

-- 7. Find customers who haven't made any reservations.
SELECT c.customer_id,CONCAT(c.first_name,' ',c.last_name) AS Customer_id,COUNT(r.reservation_id) AS Number_of_Reservations
FROM Customers c
LEFT JOIN Reservations r 
ON c.customer_id=r.customer_id
GROUP BY c.customer_id
HAVING Number_of_Reservations IS NULL;

-- 8. List reservations with special requests (excluding NULL values).
SELECT * FROM Reservations
WHERE special_requests IS NULL;

-- 9. Show customers with more than 100 loyalty points.
SELECT * FROM Customers
WHERE loyalty_points>100;

-- 10. Display all orders that are currently "In Progress".
SELECT * FROM Orders
WHERE status='In Progress';

-- 11. Find tables that have been reserved more than 3 times.
SELECT rt.table_id,rt.table_number,rt.capacity,COUNT(r.reservation_id) AS Number_of_Reservations
FROM Restaurant_tables rt
LEFT JOIN Reservations r
ON r.table_id=rt.table_id
GROUP BY rt.table_id
HAVING Number_of_Reservations>3;

-- 12. Show the total amount spent by each customer.
SELECT c.customer_id,CONCAT(c.first_name,' ',c.last_name) AS Customer_id,SUM(o.total_amount) AS Total_Amount
FROM Customers c
LEFT JOIN Orders o
ON o.customer_id=c.customer_id
GROUP BY c.customer_id
ORDER BY c.customer_id;

-- 13. List all items in order #1 with their quantities and special requests.
SELECT mi.*, r.special_requests
FROM Menu_items mi 
LEFT JOIN Restaurant_tables rt 
ON mi.is_available=rt.is_available
JOIN Reservations r
ON r.table_id=rt.table_id
GROUP BY mi.item_id;

-- 14. Find menu items that have never been ordered.
SELECT mi.* , COUNT(o.order_id) AS Total_Orders
FROM Menu_items mi
LEFT JOIN Restaurant_tables rt 
ON mi.is_available=rt.is_available
LEFT JOIN Orders o
ON o.table_id=rt.table_id
GROUP BY mi.item_id
HAVING Total_Orders=0;