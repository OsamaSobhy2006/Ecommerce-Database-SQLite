# Ecommerce Database (SQLite)

This project is a relational database design for a simple e-commerce system.
It was created as a final project for **CS50 Introduction to Databases and SQL**.

The database focuses on correct relational modeling, data integrity, and
realistic business logic implemented at the database level using constraints,
indexes, and triggers.

---

## Features

- Users, products, and categories
- Orders with multiple products (many-to-many via `order_item`)
- Addresses associated with users
- Payments associated with orders
- Constraints to ensure data integrity (PRIMARY KEY, FOREIGN KEY, UNIQUE, CHECK)
- Indexes to improve query performance
- Triggers to:
  - Automatically update order total price
  - Automatically reduce product stock
  - Automatically update order status after payment completion

---

## Database Schema

The database includes the following tables:

- `users`
- `category`
- `product`
- `orders`
- `order_item`
- `address`
- `payment`

---

## Triggers

The following triggers are implemented:

- **Order total calculation**  
  Updates `orders.total_price` when items are added to an order.

- **Stock management**  
  Reduces `product.stock_quantity` when an order item is inserted.

- **Payment status handling**  
  Updates the order status to `paid` when a payment is completed.

---

## How to Run

1. Open SQLite:
   ```bash
   sqlite3 ecommerce.db
2. .read schema.sql
3. .read queries.sql
