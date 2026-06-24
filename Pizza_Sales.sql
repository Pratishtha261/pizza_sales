--CREATING TABLES
CREATE TABLE orders(
order_id INT PRIMARY KEY,
order_date DATE,
order_time TIME
);

CREATE TABLE order_details(
order_details_id INT PRIMARY KEY,
order_id INT REFERENCES orders(order_id),	
pizza_id VARCHAR(100),	
quantity INT
);

CREATE TABLE pizza_types(
pizza_type_id VARCHAR(50) PRIMARY KEY,
pizza_name VARCHAR(100),
category VARCHAR(100),	
ingredients TEXT
);

CREATE TABLE pizzas(
pizza_id VARCHAR(100) PRIMARY KEY,	
pizza_type_id VARCHAR(50) REFERENCES pizza_types(pizza_type_id),
pizza_size VARCHAR(10),	
price NUMERIC(10,2)
);

--INSERTING CSV FILES
--ORDERS TABLE
COPY Books(Book_ID, Title, Author, Genre, Published_Year, Price, Stock) 
FROM 'C:\Users\user\Desktop\Pizza Sales SQL Project\pizza_sales\orders.csv'
CSV HEADER; 

--ORDER_DETAILS TABLE
COPY Books(Book_ID, Title, Author, Genre, Published_Year, Price, Stock) 
FROM 'C:\Users\user\Desktop\Pizza Sales SQL Project\pizza_sales\order_details.csv'
CSV HEADER; 

--PIZZA_TYPES TABLE
COPY Books(Book_ID, Title, Author, Genre, Published_Year, Price, Stock) 
FROM 'C:\Users\user\Desktop\Pizza Sales SQL Project\pizza_sales\pizza_types.csv'
CSV HEADER; 

--PIZZAS TABLE
COPY Books(Book_ID, Title, Author, Genre, Published_Year, Price, Stock) 
FROM 'C:\Users\user\Desktop\Pizza Sales SQL Project\pizza_sales\pizzas.csv'
CSV HEADER; 

SELECT * FROM orders;
SELECT * FROM order_details;
SELECT * FROM pizza_types;
SELECT * FROM pizzas;


--BASIC QUERIES

--RETRIEVE THE TOTAL NUMBER OF ORDERS PLACED
SELECT COUNT(order_id) AS total_order_placed
FROM orders;

--CALCULATE THE TOTAL REVENUE GENERATED FROM PIZZA SALES
SELECT SUM(od.quantity * p.price) AS total_Sales FROM
order_details od
JOIN
pizzas p
ON p.pizza_id=od.pizza_id;

--IDENTIFY THE HIGHEST-PRICED PIZZA
SELECT pt.pizza_name,p.price FROM 
pizza_types pt
JOIN 
pizzas p
ON p.pizza_type_id = pt.pizza_type_id
ORDER BY p.price DESC
LIMIT 1;

--IDENTIFY THE MOST COMMON PIZZA SIZE ORDERED
SELECT p.pizza_size,COUNT(od.order_Details_id) AS order_count
FROM pizzas p
JOIN
order_Details od
ON p.pizza_id=od.pizza_id
GROUP BY p.pizza_size
ORDER BY order_Count DESC
limit 1;

--LIST THE TOP 5 MOST ORDERED PIZZA TYPES ALONG WITH THEIR QUANTITIES
SELECT pt.pizza_name, SUM(od.quantity) AS order_Count
FROM pizza_types pt
JOIN
pizzas p
ON 
pt.pizza_type_id = p.pizza_type_id
JOIN
order_Details od
ON
od.pizza_id=p.pizza_id
GROUP BY pt.pizza_name
ORDER BY order_Count DESC
LIMIT 5;


--INTERMEDIATE QUERIES

--JOIN THE NECESSARY TABLES TO FIND THE TOTAL QUANTITY OF EACH PIZZA CATEGORY ORDERED
SELECT pt.category, SUM(od.quantity) AS total_quantity
FROM
pizza_types pt
JOIN
pizzas p
ON pt.pizza_type_id = p.pizza_type_id
JOIN 
order_details od
ON p.pizza_id = od.pizza_id
GROUP BY pt.category
ORDER BY total_quantity DESC;

--DETERMINE THE DISTRIBUTION OF ORDERS BY HOUR OF THE DAY
SELECT EXTRACT (HOUR from order_time) AS order_hour,
COUNT(order_id) AS total_orders
FROM orders
GROUP BY order_hour
ORDER BY order_hour;

--JOIN RELEVANT TABLES TO FIND THE CATEGORY-WISE DISTRIBUTION OF PIZZAS
SELECT pt.category, COUNT(p.pizza_id) AS category_distribution
FROM
pizzas p
JOIN 
pizza_types pt
ON pt.pizza_type_id = p.pizza_type_id
GROUP BY pt.category
ORDER BY category_distribution DESC;

--GROUP THE ORDERS BY DATE AND CALCULATE THE AVERAGE NUMBER OF PIZZAS ORDERED PER DAY
SELECT 
ROUND(AVG(total_pizzas),2) AS avg_pizzas_per_day
FROM
(
    SELECT 
    o.order_date,
    SUM(od.quantity) AS total_pizzas
    FROM orders o
    JOIN order_details od
    ON o.order_id = od.order_id
    GROUP BY o.order_date
) AS daily_orders;

--DETERMINE THE TOP 3 MOST ORDERED PIZZA TYPES BASED ON REVENUE
SELECT pt.pizza_name, SUM(p.price * od.quantity) AS revenue
FROM pizza_types pt
JOIN pizzas p
ON pt.pizza_type_id = p.pizza_type_id
JOIN order_details od
ON p.pizza_id = od.pizza_id
GROUP BY pt.pizza_name
ORDER BY revenue DESC
LIMIT 3;


--Adanvanced Queries

--CALCULATE THE PERCENTAGE CONTRIBUTION OF EACH PIZZA TYPE TO TOTAL REVENUE
SELECT pt.pizza_name,
ROUND(
    SUM(p.price * od.quantity) * 100 / (SELECT SUM(p2.price * od2.quantity)
FROM pizzas p2
JOIN order_details od2
ON p2.pizza_id = od2.pizza_id),2) AS revenue_percentage
FROM pizza_types pt
JOIN pizzas p
ON pt.pizza_type_id = p.pizza_type_id
JOIN order_details od
ON p.pizza_id = od.pizza_id
GROUP BY pt.pizza_name
ORDER BY revenue_percentage DESC;

--ANALYZE THE CUMULATIVE REVENUE GENERATED OVER TIME REVENUE
SELECT order_date, SUM(daily_revenue) OVER (ORDER BY order_date) AS cumulative_revenue
FROM
(
    SELECT 
    o.order_date,
    SUM(p.price * od.quantity) AS daily_revenue
    FROM orders o
    JOIN order_details od
    ON o.order_id = od.order_id
    JOIN pizzas p
    ON od.pizza_id = p.pizza_id
    GROUP BY o.order_date
) AS sales;

--DETERMINE THE TOP 3 MOST ORDERED PIZZA TYPES BASED ON REVENUE FOR EACH PIZZA CATEGORY
SELECT * FROM
(
    SELECT 
    pt.category,
    pt.pizza_name,
    SUM(p.price * od.quantity) AS revenue,
    RANK() OVER(
        PARTITION BY pt.category
        ORDER BY SUM(p.price * od.quantity) DESC
    ) AS rank
FROM pizza_types pt
JOIN pizzas p
ON pt.pizza_type_id = p.pizza_type_id
JOIN order_details od
ON p.pizza_id = od.pizza_id
GROUP BY pt.category, pt.pizza_name
) AS ranked_pizzas
WHERE rank <= 3;
