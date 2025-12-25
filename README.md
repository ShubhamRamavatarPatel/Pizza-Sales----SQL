# 🍕 Pizza Sales Analysis using SQL

## 📌 Project Overview
This project focuses on analyzing pizza sales data using SQL to extract meaningful business insights. 
The analysis helps understand sales performance, customer ordering behavior, revenue trends, and top-performing pizzas.

## 🛠 Tools & Technologies
- SQL Server (SSMS)
- SQL (CTEs, Joins, Window Functions, Aggregations)
- GitHub

## 📊 Dataset Information
The dataset contains the following tables:
- `orders` – order details with order dates
- `order_details` – quantity of pizzas per order
- `pizzas` – pizza sizes and prices
- `pizza_types` – pizza names and categories

## 🔍 Key Analysis Performed
- Total revenue calculation
- Daily and cumulative revenue analysis
- Top-selling pizzas by revenue
- Top 3 pizzas by revenue in each category
- Revenue contribution by pizza category
- Order trends over time

## 📈 Sample Query
```sql
SELECT 
    o.date,
    SUM(p.price * od.quantity) AS total_revenue,
    SUM(SUM(p.price * od.quantity)) 
        OVER (ORDER BY o.date) AS cumulative_revenue
FROM pizzas p
JOIN order_details od ON p.pizza_id = od.pizza_id
JOIN orders o ON od.order_id = o.order_id
GROUP BY o.date
ORDER BY o.date;
