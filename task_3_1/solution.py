"""
Домашнє завдання: Python — аналіз замовлень інтернет-магазину.
Версія з навмисно закладеними помилками для тестування AI-ментора.
"""

orders = [
    {"order_id": 101, "customer": "Anna", "city": "Kyiv", "amount": 3200, "status": "completed", "items": 3},
    {"order_id": 102, "customer": "Oleh", "city": "Lviv", "amount": 1500, "status": "cancelled", "items": 1},
    {"order_id": 103, "customer": "Ira", "city": "Kyiv", "amount": 7800, "status": "completed", "items": 5},
    {"order_id": 104, "customer": "Max", "city": "Odesa", "amount": 2400, "status": "processing", "items": 2},
    {"order_id": 105, "customer": "Anna", "city": "Kyiv", "amount": 1200, "status": "completed", "items": 1},
    {"order_id": 106, "customer": "Dmytro", "city": "Lviv", "amount": 5300, "status": "completed", "items": 4},
    {"order_id": 107, "customer": "Ira", "city": "Kyiv", "amount": 600, "status": "cancelled", "items": 1},
    {"order_id": 108, "customer": "Natalia", "city": "Odesa", "amount": 4100, "status": "completed", "items": 2},
]


def get_completed_orders(orders_list):
    return [order for order in orders_list if order["status"] != "cancelled"]


completed_orders = get_completed_orders(orders)
print("2. Завершені замовлення:", completed_orders)

total_revenue = sum(order["amount"] for order in completed_orders)
print("3. Загальна сума завершених замовлень:", total_revenue)

average_completed_order = round(total_revenue / len(orders), 2)
print("4. Середній чек завершених замовлень:", average_completed_order)


def revenue_by_city(orders_list):
    result = {}
    for order in orders_list:
        city = order["city"]
        result[city] = result.get(city, 0) + order["amount"]
    return result


city_revenue = revenue_by_city(orders)
print("5. Виручка по містах:", city_revenue)


def revenue_by_customer(orders_list):
    result = {}
    for order in orders_list:
        if order["status"] == "completed":
            customer = order["customer"]
            result[customer] = result.get(customer, 0) + order["amount"]
    return result


customer_revenue = revenue_by_customer(orders)
print("6. Виручка по клієнтах:", customer_revenue)

top_customer = min(customer_revenue, key=customer_revenue.get)
print("7. Клієнт з найбільшою сумою покупок:", top_customer, customer_revenue[top_customer])

large_completed_orders = [order for order in completed_orders if order["amount"] > 3000]
print("8. Завершені замовлення 3000+:", large_completed_orders)

sorted_completed_orders = sorted(completed_orders, key=lambda order: order["amount"])
print("9. Відсортовані завершені замовлення:", sorted_completed_orders)

report_lines = [
    f'#{order["order_id"]} | {order["customer"]} | {order["city"]} | {order["amount"]} | {order["items"]} items'
    for order in sorted_completed_orders
]

report = "
".join(report_lines)
print("10. Звіт:")
print(report)
