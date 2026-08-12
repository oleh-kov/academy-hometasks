-- Практична робота: SQL та PostgreSQL у Docker
-- Повністю правильне виконання

DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS customers;

-- Завдання 2
CREATE TABLE customers (
    customer_id INTEGER PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    city VARCHAR(80) NOT NULL
);

CREATE TABLE orders (
    order_id INTEGER PRIMARY KEY,
    customer_id INTEGER NOT NULL,
    order_date DATE NOT NULL,
    amount NUMERIC(10, 2) NOT NULL CHECK (amount > 0),
    status VARCHAR(20) NOT NULL CHECK (status IN ('new', 'paid', 'cancelled')),
    CONSTRAINT fk_orders_customer
        FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id)
);

-- Завдання 3
INSERT INTO customers (customer_id, full_name, city) VALUES
(1, 'Іван Петренко', 'Київ'),
(2, 'Олена Коваль', 'Львів'),
(3, 'Андрій Бондар', 'Одеса'),
(4, 'Марія Шевченко', 'Дніпро'),
(5, 'Наталія Мельник', 'Харків');

INSERT INTO orders (order_id, customer_id, order_date, amount, status) VALUES
(101, 1, '2026-07-01', 1200.00, 'paid'),
(102, 1, '2026-07-05', 350.50, 'new'),
(103, 2, '2026-07-02', 800.00, 'paid'),
(104, 2, '2026-07-10', 150.00, 'cancelled'),
(105, 3, '2026-07-03', 2200.00, 'paid'),
(106, 3, '2026-07-11', 450.00, 'new'),
(107, 4, '2026-07-04', 980.00, 'paid'),
(108, 4, '2026-07-12', 300.00, 'new');

-- Завдання 4
SELECT
    o.order_id,
    c.full_name,
    o.order_date,
    o.amount
FROM orders AS o
JOIN customers AS c
    ON c.customer_id = o.customer_id
WHERE o.status = 'paid'
ORDER BY o.amount DESC;

-- Завдання 5
SELECT
    c.customer_id,
    c.full_name,
    COUNT(o.order_id) AS orders_count,
    SUM(o.amount) AS total_amount
FROM customers AS c
JOIN orders AS o
    ON o.customer_id = c.customer_id
GROUP BY
    c.customer_id,
    c.full_name
ORDER BY total_amount DESC;

-- Завдання 6
SELECT
    c.customer_id,
    c.full_name,
    c.city
FROM customers AS c
LEFT JOIN orders AS o
    ON o.customer_id = c.customer_id
WHERE o.order_id IS NULL;
