-- Домашнє завдання: SQL — аналітичні запити для онлайн-магазину
-- Версія: правильне виконання

-- 1. Усі клієнти з міста Kyiv
SELECT customer_id, full_name, city, registered_at
FROM customers
WHERE city = 'Kyiv';

-- 2. Товари з ціною більше 1000, відсортовані за спаданням ціни
SELECT product_id, product_name, price, in_stock
FROM products
WHERE price > 1000
ORDER BY price DESC;

-- 3. Усі замовлення зі статусом completed
SELECT order_id, customer_id, order_date, status
FROM orders
WHERE status = 'completed';

-- 4. Кількість клієнтів у кожному місті
SELECT city, COUNT(*) AS customer_count
FROM customers
GROUP BY city
ORDER BY customer_count DESC;

-- 5. Загальна кількість товарів у наявності по кожній категорії
SELECT c.category_name, SUM(p.in_stock) AS total_in_stock
FROM categories AS c
JOIN products AS p ON p.category_id = c.category_id
GROUP BY c.category_id, c.category_name
ORDER BY total_in_stock DESC;

-- 6. Назва товару, назва категорії та ціна товару
SELECT p.product_name, c.category_name, p.price
FROM products AS p
JOIN categories AS c ON p.category_id = c.category_id
ORDER BY c.category_name, p.product_name;

-- 7. Усі замовлення разом з іменем клієнта
SELECT o.order_id, o.order_date, o.status, c.full_name
FROM orders AS o
JOIN customers AS c ON o.customer_id = c.customer_id
ORDER BY o.order_date DESC;

-- 8. Загальна сума кожного замовлення
SELECT o.order_id, SUM(oi.quantity * oi.unit_price) AS order_total
FROM orders AS o
JOIN order_items AS oi ON oi.order_id = o.order_id
GROUP BY o.order_id
ORDER BY order_total DESC;

-- 9. Замовлення, сума яких більша за 5000
SELECT o.order_id, SUM(oi.quantity * oi.unit_price) AS order_total
FROM orders AS o
JOIN order_items AS oi ON oi.order_id = o.order_id
GROUP BY o.order_id
HAVING SUM(oi.quantity * oi.unit_price) > 5000
ORDER BY order_total DESC;

-- 10. Загальна сума продажів по кожному клієнту
SELECT c.customer_id, c.full_name, SUM(oi.quantity * oi.unit_price) AS total_spent
FROM customers AS c
JOIN orders AS o ON o.customer_id = c.customer_id
JOIN order_items AS oi ON oi.order_id = o.order_id
WHERE o.status = 'completed'
GROUP BY c.customer_id, c.full_name
ORDER BY total_spent DESC;

-- 11. Клієнти, які ще не зробили жодного замовлення
SELECT c.customer_id, c.full_name, c.city
FROM customers AS c
LEFT JOIN orders AS o ON o.customer_id = c.customer_id
WHERE o.order_id IS NULL;

-- 12. Товари, які жодного разу не були продані
SELECT p.product_id, p.product_name, p.price
FROM products AS p
LEFT JOIN order_items AS oi ON oi.product_id = p.product_id
WHERE oi.order_item_id IS NULL;

-- 13. Топ-3 товари за кількістю проданих одиниць
SELECT p.product_id, p.product_name, SUM(oi.quantity) AS total_sold
FROM products AS p
JOIN order_items AS oi ON oi.product_id = p.product_id
JOIN orders AS o ON o.order_id = oi.order_id
WHERE o.status = 'completed'
GROUP BY p.product_id, p.product_name
ORDER BY total_sold DESC
LIMIT 3;

-- 14. Середній чек тільки для completed-замовлень
WITH order_totals AS (
    SELECT o.order_id, SUM(oi.quantity * oi.unit_price) AS order_total
    FROM orders AS o
    JOIN order_items AS oi ON oi.order_id = o.order_id
    WHERE o.status = 'completed'
    GROUP BY o.order_id
)
SELECT ROUND(AVG(order_total), 2) AS average_completed_order_total
FROM order_totals;

-- 15. Категорії, у яких середня ціна товарів більша за 1500
SELECT c.category_id, c.category_name, ROUND(AVG(p.price), 2) AS average_price
FROM categories AS c
JOIN products AS p ON p.category_id = c.category_id
GROUP BY c.category_id, c.category_name
HAVING AVG(p.price) > 1500
ORDER BY average_price DESC;

-- 16. Дата останнього замовлення для кожного клієнта
SELECT c.customer_id, c.full_name, MAX(o.order_date) AS last_order_date
FROM customers AS c
LEFT JOIN orders AS o ON o.customer_id = c.customer_id
GROUP BY c.customer_id, c.full_name
ORDER BY last_order_date DESC;

-- 17. Замовлення за 2024 рік
SELECT order_id, customer_id, order_date, status
FROM orders
WHERE order_date >= DATE '2024-01-01'
  AND order_date < DATE '2025-01-01'
ORDER BY order_date;

-- 18. Клієнти, які мають більше ніж 2 завершені замовлення
SELECT c.customer_id, c.full_name, COUNT(o.order_id) AS completed_orders_count
FROM customers AS c
JOIN orders AS o ON o.customer_id = c.customer_id
WHERE o.status = 'completed'
GROUP BY c.customer_id, c.full_name
HAVING COUNT(o.order_id) > 2
ORDER BY completed_orders_count DESC;

-- 19. Частка кожного товару від загальної виручки у відсотках
WITH product_revenue AS (
    SELECT p.product_id, p.product_name, SUM(oi.quantity * oi.unit_price) AS revenue
    FROM products AS p
    JOIN order_items AS oi ON oi.product_id = p.product_id
    JOIN orders AS o ON o.order_id = oi.order_id
    WHERE o.status = 'completed'
    GROUP BY p.product_id, p.product_name
)
SELECT product_id, product_name, revenue,
       ROUND(revenue * 100.0 / SUM(revenue) OVER (), 2) AS revenue_share_percent
FROM product_revenue
ORDER BY revenue_share_percent DESC;

-- 20. Рейтинг клієнтів за сумою покупок
WITH customer_revenue AS (
    SELECT c.customer_id, c.full_name, SUM(oi.quantity * oi.unit_price) AS total_spent
    FROM customers AS c
    JOIN orders AS o ON o.customer_id = c.customer_id
    JOIN order_items AS oi ON oi.order_id = o.order_id
    WHERE o.status = 'completed'
    GROUP BY c.customer_id, c.full_name
)
SELECT customer_id, full_name, total_spent,
       RANK() OVER (ORDER BY total_spent DESC) AS customer_rank
FROM customer_revenue
ORDER BY customer_rank;
