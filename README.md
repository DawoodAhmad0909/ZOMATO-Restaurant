# ZOMATO Restaurant
## Overview 
This project involves the design and implementation of a relational database system for a restaurant, named ZR_db. The database is structured to handle essential operations including staff management, menu organization, customer data, table reservations, order processing, and inventory control. Using SQL, the system ensures efficient data storage, integrity, and retrieval for daily business needs. The schema includes several interrelated tables such as Staff, Menu_items, Customers, Reservations, and Orders, all tailored to support real-world scenarios typically encountered in restaurant management.
## Objectives 
#### 1. Database Design:
To create a normalized and relational database structure suitable for managing all aspects of restaurant operations.
#### 2. Data Integrity:
To enforce data consistency using appropriate constraints, primary and foreign keys, and unique identifiers.
#### 3. Efficient Querying:
To write SQL queries that enable quick access to relevant information such as reservations, menu details, customer activity, and staff roles.
#### 4. Operational Automation:
To simulate real-world workflows including order tracking, customer management, and inventory monitoring.
#### 5. Scalability & Extensibility:
To design the database in a way that it can be extended with new features like online ordering, delivery tracking, or loyalty programs.
## Creating Database 
``` sql
CREATE DATABASE ZR_db;
USE ZR_db;
```
## Creating Tables
### Table:Staff
``` sql
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
```
### Table:Menu_categories
``` sql
CREATE TABLE Menu_categories(
category_id   INT PRIMARY KEY,
category_name VARCHAR(50),
description   TEXT
);

SELECT * FROM Menu_categories;
```
### Table:Menu_items
``` sql
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
```
### Table:Customers
``` sql
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
```
### Table:Restaurant_tables
``` sql
CREATE TABLE Restaurant_tables(
table_id              INT PRIMARY KEY,
table_number          VARCHAR(5) NOT NULL,
capacity              INT,
location_description  TEXT,
is_available          BOOLEAN
);

SELECT * FROM Restaurant_tables;
```
### Table:Reservations
``` sql
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
```
### Table:Orders
``` sql
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
```
### Table:Order_items
``` sql
CREATE TABLE Order_items(
order_item_id     INT PRIMARY KEY,
order_id          INT,
item_id           INT,
quantity          INT,
special_requests  TEXT,
item_status       VARCHAR(25),
FOREIGN KEY (order_id) REFERENCES Orders(order_id),
FOREIGN KEY (item_id) REFERENCES Menu_items(item_id)
);

SELECT * FROM Order_items;
```
### Table:Inventory
``` sql
CREATE TABLE Inventory(
inventory_id     INT PRIMARY KEY,
item_name        VARCHAR(50),
category         VARCHAR(25),
quantity         FLOAT,
unit             VARCHAR(10),
last_restocked   DATE,
min_stock_level  FLOAT,
supplier         VARCHAR(100)
);

SELECT * FROM Inventory;
```

#### 1. List all menu items with their prices, sorted by price (highest to lowest).
``` sql
SELECT item_id,item_name,description,price FROM Menu_items
ORDER BY price DESC;
```
#### 2. Show all staff members with their positions and hire dates.
``` sql
SELECT staff_id,first_name,last_name,position,hire_date FROM Staff;
```
#### 3. Display all reservations for today's date.
``` sql
SELECT * FROM Reservations
WHERE reservation_date=DATE(NOW());
```
#### 4. Find all vegetarian menu items.
``` sql
SELECT * FROM Menu_items
WHERE is_vegetarian=TRUE;
```
#### 5. List all appetizers that take less than 15 minutes to prepare.
``` sql
SELECT mi.*,mc.category_name
FROM Menu_items mi
JOIN Menu_categories mc
ON mi.category_id=mc.category_id
WHERE mc.category_name='Appetizers' AND preparation_time<15;
```
#### 6. Show the count of menu items in each category.
``` sql
SELECT mc.category_name, COUNT(mi.item_id) AS Total_Items
FROM Menu_items mi
RIGHT JOIN Menu_categories mc
ON mi.category_id=mc.category_id
GROUP BY mc.category_name;
```
#### 7. Find customers who haven't made any reservations.
``` sql
SELECT c.customer_id,CONCAT(c.first_name,' ',c.last_name) AS Customer_id,COUNT(r.reservation_id) AS Number_of_Reservations
FROM Customers c
LEFT JOIN Reservations r
ON c.customer_id=r.customer_id
GROUP BY c.customer_id
HAVING Number_of_Reservations=0;
```
#### 8. List reservations with special requests (excluding NULL values).
``` sql
SELECT * FROM Reservations
WHERE special_requests IS NOT NULL;
```
#### 9. Show customers with more than 100 loyalty points.
``` sql
SELECT * FROM Customers
WHERE loyalty_points>100;
```
#### 10. Display all orders that are currently "In Progress".
``` sql
SELECT * FROM Orders
WHERE status='In Progress';
```
#### 11. Find tables that have been reserved more than 3 times.
``` sql
SELECT rt.table_id,rt.table_number,rt.capacity,COUNT(r.reservation_id) AS Number_of_Reservations
FROM Restaurant_tables rt
LEFT JOIN Reservations r
ON r.table_id=rt.table_id
GROUP BY rt.table_id
HAVING Number_of_Reservations>3;
```
#### 12. Show the total amount spent by each customer.
``` sql
SELECT c.customer_id,CONCAT(c.first_name,' ',c.last_name) AS Customer_id,SUM(o.total_amount) AS Total_Amount
FROM Customers c
LEFT JOIN Orders o
ON o.customer_id=c.customer_id
GROUP BY c.customer_id
ORDER BY c.customer_id;
```
#### 13. List all items in order #1 with their quantities and special requests.
``` sql
SELECT mi.*,oi.quantity,oi.special_requests
FROM Menu_items mi
JOIN Order_items oi
ON oi.item_id=mi.item_id
JOIN Orders o
ON o.order_id=oi.order_id
WHERE o.order_id=1;
```
#### 14. Find menu items that have never been ordered.
``` sql
SELECT mi.*,COUNT(o.order_id) AS Total_Orders
FROM Menu_items mi
LEFT JOIN Order_items oi
ON oi.item_id=mi.item_id
LEFT JOIN Orders o
ON o.order_id=oi.order_id
GROUP BY mi.item_id
HAVING Total_Orders=0;
```
## Conclusion
The ZR_db restaurant management system successfully demonstrates a practical and scalable solution for handling the key components of restaurant operations. By using SQL and a well-structured relational design, the system ensures reliable storage, consistency, and ease of access to data. With real-world-inspired queries and comprehensive table relationships, the database serves as a foundational model for more advanced restaurant management systems. This project lays the groundwork for integrating more features in the future, such as analytics, reporting, or mobile-based ordering solutions.



