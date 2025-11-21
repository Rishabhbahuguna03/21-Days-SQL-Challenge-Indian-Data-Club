/* Phase 1: Foundation & Inspection */

/* 1. Install IDC_Pizza.dump as IDC_Pizza server.*/
/* 2. List all unique pizza categories (`DISTINCT`).*/
SELECT DISTINCT(category) FROM pizza_types;
/* 3. Display `pizza_type_id`, `name`, and ingredients, replacing NULL ingredients with `"Missing Data"`. Show first 5 rows.*/
SELECT 
    pizza_type_id,
    name,
    COALESCE(ingredients, 'Missing Data') AS ingredients
FROM pizza_types
LIMIT 5;
/* 4. Check for pizzas missing a price (`IS NULL`).*/
SELECT 
    pizza_id,
    price
FROM pizzas
WHERE price IS NULL;

/* Phase 2: Filtering & Exploration */

/* 1. Orders placed on `'2015-01-01'` (`SELECT` + `WHERE`).*/
SELECT * FROM orders WHERE date = '2015-01-01';
/* 2. List pizzas with `price` descending.*/
SELECT DISTINCT(pizza_id),price FROM pizzas ORDER BY price DESC;
/* 3. Pizzas sold in sizes `'L'` or `'XL'`.*/
SELECT pizza_id,size FROM pizzas WHERE size = 'L' OR size = 'XL';
/* 4. Pizzas priced between $15.00 and $17.00.*/
SELECT pizza_id,price FROM pizzas WHERE price BETWEEN 15.00 AND 17.00;
/* 5. Pizzas with `"Chicken"` in the name.*/
SELECT 
    pizza_type_id,
    name
FROM pizza_types
WHERE name LIKE '%Chicken%';
/* 6. Orders on `'2015-02-15'` or placed after 8 PM.*/
SELECT 
    order_id,
    date,
    time
FROM orders
WHERE date = '2015-02-15'
   OR time > '20:00:00';

/* Phase 3: Sales Performance */

/* 1. Total quantity of pizzas sold (`SUM`). */
SELECT SUM(quantity) as total_sold FROM order_details;
/* Average pizza price (`AVG`). */
SELECT ROUND(AVG(price)) AS avg_price FROM pizzas;
/* Total order value per order (`JOIN`, `SUM`, `GROUP BY`). */
SELECT 
    o.order_id,
    SUM(od.quantity * p.price) AS total_order_value
FROM orders o
JOIN order_details od 
    ON o.order_id = od.order_id
JOIN pizzas p 
    ON od.pizza_id = p.pizza_id
GROUP BY o.order_id
ORDER BY o.order_id DESC;
/* Total quantity sold per pizza category (`JOIN`, `GROUP BY`). */
SELECT 
    pt.category,
    SUM(od.quantity) AS total_quantity_sold
FROM order_details od
JOIN pizzas p 
    ON od.pizza_id = p.pizza_id
JOIN pizza_types pt 
    ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.category
ORDER BY total_quantity_sold DESC;

/* Categories with more than 5,000 pizzas sold (`HAVING`). */
SELECT 
    pt.category,
    SUM(od.quantity) AS total_quantity_sold
FROM order_details od
JOIN pizzas p 
    ON od.pizza_id = p.pizza_id
JOIN pizza_types pt 
    ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.category
HAVING SUM(od.quantity) > 5000
ORDER BY total_quantity_sold DESC;

/* Pizzas never ordered (`LEFT/RIGHT JOIN`). */
SELECT 
    p.pizza_id,
    p.pizza_type_id,
    p.price
FROM pizzas p
LEFT JOIN order_details od
    ON p.pizza_id = od.pizza_id
WHERE od.pizza_id IS NULL;
/* Price differences between different sizes of the same pizza (`SELF JOIN`). */
SELECT 
    p0.pizza_type_id,
    p0.pizza_id AS pizza_small,
    p0.size AS size_small,
    p0.price AS price_small,
    p1.pizza_id AS pizza_large,
    p1.size AS size_large,
    p1.price AS price_large,
    (p1.price - p0.price) AS price_difference
FROM pizzas p0
JOIN pizzas p1
    ON p0.pizza_type_id = p1.pizza_type_id
   AND p0.size <> p1.size
ORDER BY p0.pizza_type_id, price_difference DESC;
