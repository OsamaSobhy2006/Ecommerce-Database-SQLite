# Design Document

By Osama Sobhy

Video overview: <https://youtu.be/kWS25ILD3Go?si=3syM94HissYNpGZJ>

## Scope

In this section you should answer the following questions:

* What is the purpose of your database?
The purpose of this database is to model the core backend data of a simple e-commerce system.
It is designed to manage users, products, categories, orders, and order items while ensuring data integrity, correctness, and realistic business behavior such as stock management and order total calculation.

* Which people, places, things, etc. are you including in the scope of your database?
The database includes the following real-world entities:
Users who place orders
Categories to organize products
Products that can be purchased
Orders created by users
Order items that represent products inside an order

The database supports:
Creating users and products
Categorizing products
Creating orders for users
Adding multiple products to a single order
Automatically updating order totals and product stock using triggers

* Which people, places, things, etc. are *outside* the scope of your database?
The following are intentionally outside the scope of this database:
Payment processing
Shipping and delivery addresses
Shopping carts
Product reviews
Refunds and returns
User authentication logic (handled at application level)
These features can be added later but are not required for the core database functionality.

## Functional Requirements

In this section you should answer the following questions:

* What should a user be able to do with your database?
Using this database, a user (or application) can:
Create and manage users
Create product categories
Add products with prices and stock quantities
Place orders for users
Add multiple products to an order
Automatically calculate the total price of an order
Automatically reduce product stock when items are ordered
Query orders, products, and user information

* What's beyond the scope of what a user should be able to do with your database?
The database does not:
Handle payments or payment validation
Track shipping status or delivery addresses
Prevent users from ordering more than available stock at the application level
Handle refunds or returns
Manage user login sessions
These behaviors are better handled by application logic or additional tables.

## Representation

### Entities

In this section you should answer the following questions:

* Which entities will you choose to represent in your database?
users, product, category, orders and order_item

* What attributes will those entities have?
* Why did you choose the types you did?
* Why did you choose the constraints you did?
Users
Attributes
id
name
email
password_hash
phone
created_at

Why these types
INTEGER for id to use SQLite’s rowid auto-increment behavior
TEXT for name, email, and phone because they are not used in calculations
TEXT for password_hash since hashed passwords are strings
DATETIME for created_at to track user registration time

Why these constraints
PRIMARY KEY on id ensures each user is uniquely identifiable
UNIQUE on email and phone prevents duplicate user accounts
NOT NULL ensures required user data always exists

Category
Attributes
id
name

Why these types
INTEGER for id as a unique identifier
TEXT for name since category names are textual labels

Why these constraints
PRIMARY KEY ensures each category is uniquely identifiable
UNIQUE on name prevents duplicate categories such as repeated “Electronics”

Product
Attributes
id
name
description
price
stock_quantity
category_id

Why these types
INTEGER for identifiers and foreign keys
TEXT for name and description
REAL for price to allow decimal values
INTEGER for stock_quantity since stock is a whole number

Why these constraints
CHECK (price > 0) prevents invalid product prices
CHECK (stock_quantity >= 0) prevents negative stock
FOREIGN KEY (category_id) enforces valid category assignment
NOT NULL ensures required product data exists

Orders
Attributes
id
user_id
total_price
status
created_at

Why these types
INTEGER for identifiers and foreign keys
REAL for total_price to support monetary values
TEXT for status since SQLite does not support ENUM
DATETIME for created_at

Why these constraints
DEFAULT 0 for total_price allows orders to be created before items are added
CHECK on status restricts values to valid order states
FOREIGN KEY (user_id) ensures every order belongs to a valid user
NOT NULL prevents incomplete orders

Order Item
Attributes
order_id
product_id
quantity
price_at_purchase

Why these types
INTEGER for foreign keys and quantity
REAL for price_at_purchase to preserve the product price at order time

Why these constraints
Composite PRIMARY KEY (order_id, product_id) prevents duplicate products in the same order
CHECK (quantity > 0) prevents meaningless order items
CHECK (price_at_purchase > 0) prevents invalid prices
FOREIGN KEY constraints enforce valid orders and products
ON DELETE CASCADE ensures order items are removed when an order is deleted

Why These Design Choices
The chosen data types and constraints ensure:
Data integrity at the database level
Prevention of invalid or inconsistent data
Accurate historical order records
Realistic behavior for an e-commerce system
These decisions reduce reliance on application-level validation and make the database robust and reliable.

### Relationships

In this section you should include your entity relationship diagram and describe the relationships between the entities in your database.
One user → many orders
One category → many products
One order → many order items
One product → many order items
The many-to-many relationship between orders and products is resolved using the order_item table.

## Optimizations

In this section you should answer the following questions:

* Which optimizations (e.g., indexes, views) did you create? Why?
Indexes
Indexes were created on:
Foreign key columns (user_id, category_id, order_id, product_id)
Reason
Improves performance for JOIN operations and frequent queries

Triggers
Two triggers were implemented:
Update order total
Automatically recalculates orders.total_price when items are added
Reduce product stock
Automatically decreases product.stock_quantity when an order item is inserted
Reason
Ensures data consistency
Prevents manual calculation errors
Reflects real e-commerce behavior

## Limitations

In this section you should answer the following questions:

* What are the limitations of your design?
The database does not handle payments or refunds
No address or shipping data is stored
Product stock validation (preventing negative stock) is not enforced at the trigger level
Order status changes are not restricted by workflow rules

* What might your database not be able to represent very well?
Complex order lifecycles (returns, refunds)
Multiple shipments per order
Partial payments
User permissions or roles
These limitations are acceptable for the scope of this project and can be addressed with additional tables and application logic.
