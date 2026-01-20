-- create table users
CREATE TABLE "users" (
    "id" INTEGER,
    "name" TEXT NOT NULL,
    "email" TEXT NOT NULL UNIQUE,
    "password_hash" TEXT NOT NULL,
    "phone" TEXT NOT NULL UNIQUE,
    "created_at" DATETIME DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY("id")
);

-- create table product
CREATE TABLE "product" (
    "id" INTEGER,
    "name" TEXT NOT NULL,
    "description" TEXT,
    "price" REAL NOT NULL CHECK("price" > 0),
    "category_id" INTEGER NOT NULL,
    "stock_quantity" INTEGER NOT NULL CHECK("stock_quantity" >= 0),
    PRIMARY KEY("id"),
    FOREIGN KEY("category_id") REFERENCES "category"("id")
);

-- create table category
CREATE TABLE "category" (
    "id" INTEGER,
    "name" TEXT NOT NULL UNIQUE,
    PRIMARY KEY("id")
);

-- create table orders
CREATE TABLE "orders" (
    "id" INTEGER,
    "user_id" INTEGER NOT NULL,
    "total_price" REAL DEFAULT 0 CHECK("total_price" >= 0),
    "status" TEXT NOT NULL DEFAULT 'pending'
    CHECK("status" IN ("pending", "paid", "shipped", "delivered", "cancelled")),
    "created_at" DATETIME DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY("id"),
    FOREIGN KEY("user_id") REFERENCES "users"("id")
);

-- create table order_item
CREATE TABLE "order_item" (
    "order_id" INTEGER NOT NULL,
    "product_id" INTEGER NOT NULL,
    "quantity" INTEGER NOT NULL CHECK("quantity" > 0),
    "price_at_purchase" REAL NOT NULL CHECK("price_at_purchase" > 0),
    PRIMARY KEY("order_id", "product_id"),
    FOREIGN KEY("order_id") REFERENCES "orders"("id") ON DELETE CASCADE,
    FOREIGN KEY("product_id") REFERENCES "product"("id")
);

-- create table address
CREATE TABLE "address" (
    "id" INTEGER,
    "user_id" INTEGER NOT NULL,
    "city" TEXT NOT NULL,
    "country" TEXT NOT NULL,
    "street" TEXT NOT NULL,
    "building" TEXT NOT NULL,
    "postal_code" TEXT NOT NULL,
    PRIMARY KEY("id"),
    FOREIGN KEY("user_id") REFERENCES "users"("id") ON DELETE CASCADE
);

-- create table payment
CREATE TABLE "payment" (
    "id" INTEGER,
    "order_id" INTEGER NOT NULL UNIQUE,
    "method" TEXT NOT NULL,
    "amount" REAL NOT NULL CHECK("amount" > 0),
    "status" TEXT NOT NULL
    CHECK("status" IN ("pending", "completed", "failed")),
    "paid_at" DATETIME,
    PRIMARY KEY("id"),
    FOREIGN KEY("order_id") REFERENCES "orders"("id") ON DELETE CASCADE
);

-- create indexes for tables
CREATE INDEX "idx_product_category" ON "product"("category_id");
CREATE INDEX "idx_orders_user" ON "orders"("user_id");
CREATE INDEX "idx_order_item_order" ON "order_item"("order_id");
CREATE INDEX "idx_order_item_product" ON "order_item"("product_id");
CREATE INDEX "idx_address_user" ON "address"("user_id");


-- create trigger to calculate the total price
CREATE TRIGGER "trg_update_order_total"
AFTER INSERT ON "order_item"
BEGIN
  UPDATE "orders"
  SET "total_price" = (
    SELECT SUM("quantity" * "price_at_purchase")
    FROM "order_item"
    WHERE "order_id" = NEW."order_id"
  )
  WHERE "id" = NEW."order_id";
END;

-- create trigger to update the stock value after order
CREATE TRIGGER "trg_reduce_stock"
AFTER INSERT ON "order_item"
BEGIN
  UPDATE "product"
  SET "stock_quantity" = "stock_quantity" - NEW."quantity"
  WHERE "id" = NEW."product_id";
END;

-- change the status of the order
CREATE TRIGGER "trg_payment_completed"
AFTER UPDATE OF "status" ON "payment"
WHEN NEW."status" = 'completed'
BEGIN
    UPDATE "orders"
    SET "status" = 'paid'
    WHERE "id" = NEW."order_id";
END;
