# Pizza Sales SQL Project

## Project Overview

The Pizza Sales SQL Project is a PostgreSQL-based database project designed to analyze pizza sales data and customer ordering patterns.

This project demonstrates SQL concepts such as:

* Table creation
* Data import using CSV files
* Joins
* Aggregate functions
* Window functions
* Revenue analysis
* Sales trend analysis

The project helps in understanding business insights from pizza sales data using SQL queries.

---

## Objectives

* Create a relational database for pizza sales data
* Store order, pizza, and category information
* Analyze sales performance and revenue
* Identify top-selling pizzas and categories
* Practice SQL joins, grouping, filtering, and analytical queries

---

## Skills Demonstrated

* SQL
* PostgreSQL
* Database Design
* Data Analysis
* Joins
* Aggregate Functions
* Window Functions
* Query Optimization

---

## Project Files

* Pizza_Sales.sql
* orders.csv
* order_details.csv
* pizza_types.csv
* pizzas.csv
* README.md

---

## Technologies Used

* PostgreSQL
* SQL
* Git
* GitHub

---

## Database Tables

### 1. Orders Table

Stores customer order details.

| Column Name | Data Type       |
| ----------- | --------------- |
| order_id    | INT PRIMARY KEY |
| order_date  | DATE            |
| order_time  | TIME            |

---

### 2. Order Details Table

Stores pizza quantity details for each order.

| Column Name      | Data Type       |
| ---------------- | --------------- |
| order_details_id | INT PRIMARY KEY |
| order_id         | INT             |
| pizza_id         | VARCHAR(100)    |
| quantity         | INT             |

---

### 3. Pizza Types Table

Stores pizza category and ingredient information.

| Column Name   | Data Type               |
| ------------- | ----------------------- |
| pizza_type_id | VARCHAR(50) PRIMARY KEY |
| pizza_name    | VARCHAR(100)            |
| category      | VARCHAR(100)            |
| ingredients   | TEXT                    |

---

### 4. Pizzas Table

Stores pizza size and pricing information.

| Column Name   | Data Type                |
| ------------- | ------------------------ |
| pizza_id      | VARCHAR(100) PRIMARY KEY |
| pizza_type_id | VARCHAR(50)              |
| pizza_size    | VARCHAR(10)              |
| price         | NUMERIC(10,2)            |

---

## Table Creation Queries

### Orders Table

```sql id="vjlwmx"
CREATE TABLE orders(
    order_id INT PRIMARY KEY,
    order_date DATE,
    order_time TIME
);
```

### Order Details Table

```sql id="gb8tnl"
CREATE TABLE order_details(
    order_details_id INT PRIMARY KEY,
    order_id INT REFERENCES orders(order_id),
    pizza_id VARCHAR(100),
    quantity INT
);
```

### Pizza Types Table

```sql id="cbq6ml"
CREATE TABLE pizza_types(
    pizza_type_id VARCHAR(50) PRIMARY KEY,
    pizza_name VARCHAR(100),
    category VARCHAR(100),
    ingredients TEXT
);
```

### Pizzas Table

```sql id="pl5fw6"
CREATE TABLE pizzas(
    pizza_id VARCHAR(100) PRIMARY KEY,
    pizza_type_id VARCHAR(50) REFERENCES pizza_types(pizza_type_id),
    pizza_size VARCHAR(10),
    price NUMERIC(10,2)
);
```

---

## Data Import

CSV files were imported into PostgreSQL tables using the COPY command.

Imported datasets:

* orders.csv
* order_details.csv
* pizza_types.csv
* pizzas.csv

---

## Basic SQL Queries

The following operations were performed:

* Retrieve total number of orders
* Calculate total revenue
* Identify highest-priced pizza
* Find most common pizza size ordered
* List top 5 most ordered pizzas

---

## Intermediate SQL Queries

The project also includes:

* Category-wise quantity analysis
* Hourly order distribution
* Category-wise pizza distribution
* Average pizzas ordered per day
* Top pizzas based on revenue

---

## Advanced SQL Queries

Advanced SQL concepts implemented:

* Percentage contribution to revenue
* Cumulative revenue analysis
* Ranking pizzas category-wise using window functions
* Revenue trend analysis

---

## Key Learnings

* Learned relational database design
* Practiced SQL joins and aggregate functions
* Worked with CSV data import in PostgreSQL
* Improved analytical query writing skills
* Understood sales and revenue analysis using SQL
* Applied window functions and ranking techniques

---

## Conclusion

This project demonstrates practical implementation of SQL concepts including:

* Table creation
* Data import
* Filtering
* Joins
* Grouping
* Aggregation
* Revenue analysis
* Window functions
* Business insights generation

using PostgreSQL.
