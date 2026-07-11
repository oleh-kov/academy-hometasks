-- Домашнє завдання: SQL — аналіз підписок онлайн-сервісу
-- Версія з навмисно закладеними помилками для тестування AI-ментора

-- 1. Усі користувачі з України
SELECT
    user_id,
    full_name,
    country,
    registered_at
FROM users
WHERE country = 'Ukraine';


-- 2. Активні підписки з іменем користувача та назвою тарифу
SELECT
    s.subscription_id,
    u.full_name,
    p.plan_name,
    s.started_at,
    s.status
FROM subscriptions AS s
JOIN users AS u
    ON u.user_id = s.user_id
JOIN plans AS p
    ON p.plan_id = s.plan_id;


-- 3. Кількість активних підписок по кожному тарифному плану
SELECT
    p.plan_name,
    COUNT(s.subscription_id) AS active_subscriptions
FROM plans AS p
LEFT JOIN subscriptions AS s
    ON s.plan_id = p.plan_id
WHERE s.status = 'active'
GROUP BY p.plan_name
ORDER BY active_subscriptions DESC;


-- 4. Сума успішних платежів по кожному користувачу
SELECT
    u.user_id,
    u.full_name,
    SUM(pay.amount) AS total_paid
FROM users AS u
JOIN subscriptions AS s
    ON s.user_id = u.user_id
JOIN payments AS pay
    ON pay.subscription_id = s.subscription_id
GROUP BY u.user_id, u.full_name
ORDER BY total_paid DESC;


-- 5. Користувачі, які зареєструвалися у 2024 році
SELECT
    user_id,
    full_name,
    country,
    registered_at
FROM users
WHERE registered_at >= DATE '2024-01-01'
  AND registered_at < DATE '2025-01-01';


-- 6. Користувачі з активною підпискою, але без жодного успішного платежу
SELECT
    u.user_id,
    u.full_name,
    s.subscription_id
FROM users AS u
JOIN subscriptions AS s
    ON s.user_id = u.user_id
LEFT JOIN payments AS pay
    ON pay.subscription_id = s.subscription_id
WHERE s.status = 'active'
  AND pay.payment_id IS NULL;


-- 7. MRR як сума monthly_price активних підписок
SELECT
    SUM(p.monthly_price) AS mrr
FROM subscriptions AS s
JOIN plans AS p
    ON p.plan_id = s.plan_id
WHERE s.status != 'cancelled';


-- 8. Середній успішний платіж по кожному тарифу
SELECT
    p.plan_name,
    ROUND(AVG(pay.amount), 2) AS average_paid_payment
FROM plans AS p
JOIN subscriptions AS s
    ON s.plan_id = p.plan_id
JOIN payments AS pay
    ON pay.subscription_id = s.subscription_id
WHERE pay.status = 'paid'
GROUP BY p.plan_name
ORDER BY average_paid_payment DESC;


-- 9. Топ-5 користувачів за сумою успішних платежів
SELECT
    u.user_id,
    u.full_name,
    SUM(pay.amount) AS total_paid
FROM users AS u
JOIN subscriptions AS s
    ON s.user_id = u.user_id
JOIN payments AS pay
    ON pay.subscription_id = s.subscription_id
WHERE pay.status = 'paid'
GROUP BY u.user_id, u.full_name
ORDER BY total_paid ASC
LIMIT 5;


-- 10. Кількість користувачів і сума успішних платежів по країнах
SELECT
    u.country,
    COUNT(u.user_id) AS users_count,
    SUM(pay.amount) AS total_paid
FROM users AS u
LEFT JOIN subscriptions AS s
    ON s.user_id = u.user_id
LEFT JOIN payments AS pay
    ON pay.subscription_id = s.subscription_id
   AND pay.status = 'paid'
GROUP BY u.country
ORDER BY total_paid DESC;


-- 11. Користувачі, у яких останній успішний платіж був більше ніж 30 днів тому
SELECT
    u.user_id,
    u.full_name,
    MAX(pay.payment_date) AS last_paid_at
FROM users AS u
JOIN subscriptions AS s
    ON s.user_id = u.user_id
JOIN payments AS pay
    ON pay.subscription_id = s.subscription_id
WHERE pay.status = 'paid'
GROUP BY u.user_id, u.full_name
HAVING MAX(pay.payment_date) < CURRENT_DATE - INTERVAL '30 days'
ORDER BY last_paid_at;


-- 12. Рейтинг тарифних планів за сумою успішних платежів
WITH plan_revenue AS (
    SELECT
        p.plan_id,
        p.plan_name,
        SUM(pay.amount) AS total_paid
    FROM plans AS p
    JOIN subscriptions AS s
        ON s.plan_id = p.plan_id
    JOIN payments AS pay
        ON pay.subscription_id = s.subscription_id
    WHERE pay.status = 'paid'
    GROUP BY p.plan_id, p.plan_name
)
SELECT
    plan_id,
    plan_name,
    total_paid,
    ROW_NUMBER() OVER (ORDER BY total_paid DESC) AS plan_rank
FROM plan_revenue
ORDER BY plan_rank;
