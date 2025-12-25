select * from pizzas
select * from pizza_types
select * from order_details
select * from orders

use SqlProjectPizzaSales

--Basic:
--Retrieve the total number of orders placed.
select count(order_id) as TotalOrder from orders



--Calculate the total revenue generated from pizza sales.
select round(sum(p.price*od.quantity),2) as totalRevenue from pizzas as p 
join order_details as od on p.pizza_id = od.pizza_id



--Identify the highest-priced pizza.
select name,round(price,2) as price from pizza_types 
join pizzas on pizza_types.pizza_type_id = pizzas.pizza_type_id
where price = (select max(price) from pizzas)
--order by price desc


--Identify the most common pizza size ordered.
with ctes as (
select p.size,
sum(od.quantity) as totalPizzaOrdered
from order_details as od
join pizzas as p on p.pizza_id = od.pizza_id
group by p.size
)

select top 1 size from ctes
order by totalPizzaOrdered desc



--List the top 5 most ordered pizza types along with their quantities.
select top 5 p.pizza_type_id,pt.name,
sum(od.quantity) as totalPizzaOrdered
from order_details as od
join pizzas as p on p.pizza_id = od.pizza_id
join pizza_types as pt on pt.pizza_type_id = p.pizza_type_id
group by p.pizza_type_id,pt.name
order by  sum(od.quantity) desc



--Intermediate:
--Join the necessary tables to find the total quantity of each pizza category ordered.
select category ,sum(quantity) as totalQuantity from pizza_types as pt
join pizzas as p on p.pizza_type_id = pt.pizza_type_id
join order_details as od on od.pizza_id = p.pizza_id
group by category
order by  category



--Determine the distribution of orders by hour of the day.
select datepart(hour,time) as orderHour, count(*) as totalOrder, sum(quantity) as TotalQuantity from orders as o
join order_details as od on o.order_id = od.order_id
group by datepart(hour,time)
order by count(*) desc



--Join relevant tables to find the category-wise distribution of pizzas.
 select category ,count(*) as totalQuantity from pizza_types as pt
join pizzas as p on p.pizza_type_id = pt.pizza_type_id
join order_details as od on od.pizza_id = p.pizza_id
group by category
order by  category


--Group the orders by date and calculate the average number of pizzas ordered per day.
select avg(dailyPizza) as avgPizzaPerDay from (
select date as day ,sum(quantity) as dailyPizza from order_details as od
join orders as o on od.order_id = o.order_id
group by date
) as daily_Order_pizza



--Determine the top 3 most ordered pizza types based on revenue.
select top 3 pt.pizza_type_id , pt.name, sum(p.price*od.quantity) as revenue from pizzas as p
join pizza_types as pt on p.pizza_type_id = pt.pizza_type_id
join order_details as od on p.pizza_id = od.pizza_id
group by pt.pizza_type_id , pt.name
order by sum(p.price*od.quantity) desc


--Advanced:
--Calculate the percentage contribution of each pizza type to total revenue.
select pt.category, 
round((sum(p.price*od.quantity)/(select sum(p.price*od.quantity) from pizzas as p
join order_details as od on od.pizza_id = p.pizza_id))*100,2)as totalPercen from pizzas as p
join order_details as od on od.pizza_id = p.pizza_id
join pizza_types as pt on p.pizza_type_id = pt.pizza_type_id
group by pt.category
order by sum(p.price*od.quantity) desc



--Analyze the cumulative revenue generated over time.
select o.date ,sum(p.price*od.quantity) as totalRevenue,  
sum(sum(p.price*od.quantity))over(order by o.date)  as cumulativeRevenue from pizzas as p
join order_details as od on od.pizza_id = p.pizza_id
join orders as o on od.order_id = o.order_id
group by o.date
order by o.date


--Determine the top 3 most ordered pizza types based on revenue for each pizza category.
select category,
       pizzaTypesName,
       totalRevenue
from
( select pt.category, 
       pt.name as pizzaTypesName,
       round(sum(p.price*od.quantity),2) as totalRevenue, 
       DENSE_RANK()over(partition by pt.category order by sum(p.price*od.quantity) desc) as ranks
from pizzas as p
join order_details as od on od.pizza_id = p.pizza_id
join pizza_types as pt on p.pizza_type_id = pt.pizza_type_id
group by pt.category,pt.name ) as totalReven
where ranks <= 3
