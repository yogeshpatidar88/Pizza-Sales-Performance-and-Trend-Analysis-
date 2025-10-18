-- ================================================
-- 🍕 PIZZA SALES DATA ANALYSIS PROJECT (MySQL)
-- ================================================
-- Author : Roshan Saini
-- Purpose: Analyze pizza sales data and standardize pizza sizes
-- ================================================

-- ================================================
-- STEP 0: VIEW INITIAL DATA
-- ================================================
SELECT * FROM pizza_sales LIMIT 10;


-- ================================================
-- STEP 1: CLEAN AND STANDARDIZE DATA
-- ================================================

-- Disable safe updates temporarily (to allow UPDATEs)
SET SQL_SAFE_UPDATES = 0;

-- 1A. Standardize pizza_size values
UPDATE pizza_sales
SET pizza_size = CASE
    WHEN pizza_size = 'S' THEN 'Regular'
    WHEN pizza_size = 'M' THEN 'Medium'
    WHEN pizza_size = 'L' THEN 'Large'
    WHEN pizza_size = 'XL' THEN 'X-Large'
    WHEN pizza_size = 'XXL' THEN 'XX-Large'
    ELSE pizza_size
END;

-- Verify update
SELECT DISTINCT pizza_size FROM pizza_sales;

-- 1B. Add day name column (based on order_date)
UPDATE pizza_sales
SET order_day = DAYNAME(STR_TO_DATE(order_date, '%d-%m-%Y'));

-- Re-enable safe updates
SET SQL_SAFE_UPDATES = 1;

-- Check updates
SELECT order_date, order_day, pizza_size FROM pizza_sales LIMIT 10;


-- ================================================
-- STEP 2: KEY PERFORMANCE INDICATORS (KPIs)
-- ================================================

-- 2A. Total Revenue
CREATE TABLE total_revenue AS
SELECT 
    SUM(total_price) AS Total_Revenue
FROM pizza_sales;

SELECT * FROM total_revenue;

-- 2B. Average Order Value
CREATE TABLE avg_order_value AS
SELECT 
    (SUM(total_price) / COUNT(DISTINCT order_id)) AS Avg_Order_Value
FROM pizza_sales;

SELECT * FROM avg_order_value;

-- 2C. Total Pizzas Sold
CREATE TABLE total_pizzas_sold AS
SELECT 
    SUM(quantity) AS Total_Pizza_Sold
FROM pizza_sales;

SELECT * FROM total_pizzas_sold;

-- 2D. Total Orders
CREATE TABLE total_orders AS
SELECT 
    COUNT(DISTINCT order_id) AS Total_Orders
FROM pizza_sales;

SELECT * FROM total_orders;

-- 2E. Average Pizzas per Order
CREATE TABLE avg_pizzas_per_order AS
SELECT 
    CAST(SUM(quantity) / COUNT(DISTINCT order_id) AS DECIMAL(10,2)) AS Avg_Pizzas_per_Order
FROM pizza_sales;

SELECT * FROM avg_pizzas_per_order;


-- ================================================
-- STEP 3: SALES TRENDS ANALYSIS
-- ================================================

-- 3A. Daily Trend for Total Orders
CREATE TABLE daily_orders_trend AS
SELECT 
    DAYNAME(STR_TO_DATE(order_date, '%d-%m-%Y')) AS order_day,
    COUNT(DISTINCT order_id) AS total_orders
FROM pizza_sales
GROUP BY DAYNAME(STR_TO_DATE(order_date, '%d-%m-%Y'))
ORDER BY total_orders DESC;

SELECT * FROM daily_orders_trend;

-- 3B. Hourly Trend for Orders
CREATE TABLE hourly_orders_trend AS
SELECT 
    HOUR(order_time) AS order_hour,
    COUNT(DISTINCT order_id) AS total_orders
FROM pizza_sales
GROUP BY HOUR(order_time)
ORDER BY order_hour;

SELECT * FROM hourly_orders_trend;


-- ================================================
-- STEP 4: SALES DISTRIBUTION ANALYSIS
-- ================================================

-- 4A. % of Sales by Pizza Category
CREATE TABLE sales_by_category AS
SELECT 
    pizza_category,
    CAST(SUM(total_price) AS DECIMAL(10,2)) AS total_revenue,
    CAST(SUM(total_price) * 100 / (SELECT SUM(total_price) FROM pizza_sales) AS DECIMAL(10,2)) AS PCT
FROM pizza_sales
GROUP BY pizza_category
ORDER BY total_revenue DESC;

SELECT * FROM sales_by_category;

-- 4B. % of Sales by Pizza Size
CREATE TABLE sales_by_size AS
SELECT 
    pizza_size,
    CAST(SUM(total_price) AS DECIMAL(10,2)) AS total_revenue,
    CAST(SUM(total_price) * 100 / (SELECT SUM(total_price) FROM pizza_sales) AS DECIMAL(10,2)) AS PCT
FROM pizza_sales
GROUP BY pizza_size
ORDER BY total_revenue DESC;

SELECT * FROM sales_by_size;


-- ================================================
-- STEP 5: CATEGORY-WISE PERFORMANCE
-- ================================================

-- 5A. Total Pizzas Sold by Category (for February)
CREATE TABLE feb_pizzas_by_category AS
SELECT 
    pizza_category,
    SUM(quantity) AS Total_Quantity_Sold
FROM pizza_sales
WHERE MONTH(STR_TO_DATE(order_date, '%d-%m-%Y')) = 2
GROUP BY pizza_category
ORDER BY Total_Quantity_Sold DESC;

SELECT * FROM feb_pizzas_by_category;


-- ================================================
-- STEP 6: BEST & WORST SELLERS
-- ================================================

-- 6A. Top 5 Best Sellers by Total Pizzas Sold
CREATE TABLE top_5_best_sellers AS
SELECT 
    pizza_name,
    SUM(quantity) AS Total_Pizza_Sold
FROM pizza_sales
GROUP BY pizza_name
ORDER BY Total_Pizza_Sold DESC
LIMIT 5;

SELECT * FROM top_5_best_sellers;

-- 6B. Bottom 5 Best Sellers by Total Pizzas Sold
CREATE TABLE bottom_5_best_sellers AS
SELECT 
    pizza_name,
    SUM(quantity) AS Total_Pizza_Sold
FROM pizza_sales
GROUP BY pizza_name
ORDER BY Total_Pizza_Sold ASC
LIMIT 5;

SELECT * FROM bottom_5_best_sellers;


-- ================================================
-- STEP 7: REVENUE-BASED INSIGHTS
-- ================================================

-- 7A. Revenue by Day of the Week
CREATE TABLE revenue_by_day AS
SELECT 
    order_day,
    SUM(total_price) AS total_revenue
FROM pizza_sales
GROUP BY order_day
ORDER BY total_revenue DESC;

SELECT * FROM revenue_by_day;

-- 7B. Revenue by Hour
CREATE TABLE revenue_by_hour AS
SELECT 
    HOUR(order_time) AS order_hour,
    SUM(total_price) AS total_revenue
FROM pizza_sales
GROUP BY order_hour
ORDER BY order_hour;

SELECT * FROM revenue_by_hour;

-- 7C. Average Order Value by Day
CREATE TABLE avg_order_value_by_day AS
SELECT 
    order_day,
    SUM(total_price)/COUNT(DISTINCT order_id) AS avg_order_value
FROM pizza_sales
GROUP BY order_day
ORDER BY avg_order_value DESC;

SELECT * FROM avg_order_value_by_day;


-- ================================================
-- STEP 8: MONTHLY SALES TREND
-- ================================================

CREATE TABLE monthly_sales_trend AS
SELECT 
    MONTH(STR_TO_DATE(order_date, '%d-%m-%Y')) AS month,
    SUM(total_price) AS total_revenue,
    SUM(quantity) AS total_pizzas_sold
FROM pizza_sales
GROUP BY month
ORDER BY month;

SELECT * FROM monthly_sales_trend;


-- ================================================
-- ✅ END OF SCRIPT
-- ================================================
