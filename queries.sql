-- insert some values in users table
INSERT INTO "users" ("name", "email", "password_hash", "phone")
VALUES
('Ahmed Ali', 'ahmed@example.com', 'hashed_pass_1', '+201000000001'),
('Sara Mohamed', 'sara@example.com', 'hashed_pass_2', '+201000000002');

-- insert some values in category table
INSERT INTO "category" ("name")
VALUES
('Electronics'),
('Books');

-- insert some values in product table
INSERT INTO "product" ("name", "description", "price", "stock_quantity", "category_id")
VALUES
('iPhone 13', 'Apple smartphone', 15000, 10, 1),
('Samsung Charger', 'Fast charging adapter', 300, 50, 1),
('Database Design Book', 'Learn database design', 450, 20, 2);

INSERT INTO "orders" ("user_id")
VALUES (1); -- after this query you will find the price is 0 it will chage using trigger when i order the items

-- add some items to order
INSERT INTO "order_item" ("order_id", "product_id", "quantity", "price_at_purchase")
VALUES
(1, 1, 1, 15000),  -- 1 iPhone
(1, 2, 2, 300);    -- 2 Chargers
-- after this comman you can check the total_price in orders table using
SELECT * FROM "orders"; -- not you will found the value of the total_price = 15600 (1 * 15000 + 2 * 300)

-- also after these two queries you can check the quantity of the items using
SELECT "name", "stock_quantity" FROM "product"; -- you will find the number of stock_quantity decreased by 1 in iPhone 13 and 2 in Samsung Charger

-- check the values in user table
SELECT * FROM "users";

-- check the values in category table
SELECT * FROM "category";

-- check the values in product table
SELECT * FROM "product";

-- get order details with product names
SELECT
    "o"."id" AS "order_id",
    "u"."name" AS "user_name",
    "p"."name" AS "product_name",
    "oi"."quantity",
    "oi"."price_at_purchase"
FROM "orders" AS "o"
JOIN "users" AS "u" ON "o"."user_id" = "u"."id"
JOIN "order_item" AS "oi" ON "o"."id" = "oi"."order_id"
JOIN "product" AS "p" ON "oi"."product_id" = "p"."id";

-- get total revenue from all orders
SELECT SUM("total_price") AS "total_revenue" FROM "orders";
