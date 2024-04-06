-- 1757. Recyclable and Low Fat Products

-- Table: Products
-- +-------------+---------+
-- | Column Name | Type    |
-- +-------------+---------+
-- | product_id  | int     |
-- | low_fats    | enum    |
-- | recyclable  | enum    |
-- +-------------+---------+
-- product_id is the primary key (column with unique values) for this table.
-- low_fats is an ENUM (category) of type ('Y', 'N') where 'Y' means this product is low fat and 'N' means it is not.
-- recyclable is an ENUM (category) of types ('Y', 'N') where 'Y' means this product is recyclable and 'N' means it is not.
 
-- Write a solution to find the ids of products that are both low fat and recyclable.

SELECT product_id
FROM Products
WHERE low_fats = 'Y' AND recyclable = 'Y'


-- 584. Find Customer Referee

-- Table: Customer
-- +-------------+---------+
-- | Column Name | Type    |
-- +-------------+---------+
-- | id          | int     |
-- | name        | varchar |
-- | referee_id  | int     |
-- +-------------+---------+
-- In SQL, id is the primary key column for this table.
-- Each row of this table indicates the id of a customer, their name, and the id of the customer who referred them.

-- Find the names of the customer that are not referred by the customer with id = 2.

SELECT name
FROM Customer
WHERE referee_id != 2 OR referee_id is null


-- 595. Big Countries

-- Table: World
-- +-------------+---------+
-- | Column Name | Type    |
-- +-------------+---------+
-- | name        | varchar |
-- | continent   | varchar |
-- | area        | int     |
-- | population  | int     |
-- | gdp         | bigint  |
-- +-------------+---------+
-- name is the primary key (column with unique values) for this table.
-- Each row of this table gives information about the name of a country, the continent to which it belongs, its area, the population, and its GDP value.

-- A country is big if:
-- it has an area of at least three million (i.e., 3000000 km2), or
-- it has a population of at least twenty-five million (i.e., 25000000).
-- Write a solution to find the name, population, and area of the big countries.

SELECT name, population, area
FROM World
WHERE population >= 25000000 OR area >= 3000000


-- 1148. Article Views I
-- Table: Views

-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | article_id    | int     |
-- | author_id     | int     |
-- | viewer_id     | int     |
-- | view_date     | date    |
-- +---------------+---------+
-- There is no primary key (column with unique values) for this table, the table may have duplicate rows.
-- Each row of this table indicates that some viewer viewed an article (written by some author) on some date. 
-- Note that equal author_id and viewer_id indicate the same person.

-- Write a solution to find all the authors that viewed at least one of their own articles.
-- Return the result table sorted by id in ascending order.

SELECT DISTINCT author_id as id
FROM Views
WHERE author_id = viewer_id
ORDER BY id


-- 1683. Invalid Tweets

-- Table: Tweets
-- +----------------+---------+
-- | Column Name    | Type    |
-- +----------------+---------+
-- | tweet_id       | int     |
-- | content        | varchar |
-- +----------------+---------+
-- tweet_id is the primary key (column with unique values) for this table.
-- This table contains all the tweets in a social media app.

-- Write a solution to find the IDs of the invalid tweets. 
-- The tweet is invalid if the number of characters used in the content of the tweet is strictly greater than 15.

SELECT tweet_id
FROM Tweets
WHERE LENGTH(content) > 15


-- 1068. Product Sales Analysis I

-- Table: Sales
-- +-------------+-------+
-- | Column Name | Type  |
-- +-------------+-------+
-- | sale_id     | int   |
-- | product_id  | int   |
-- | year        | int   |
-- | quantity    | int   |
-- | price       | int   |
-- +-------------+-------+
-- (sale_id, year) is the primary key (combination of columns with unique values) of this table.
-- product_id is a foreign key (reference column) to Product table.
-- Each row of this table shows a sale on the product product_id in a certain year.
-- Note that the price is per unit.

-- Table: Product
-- +--------------+---------+
-- | Column Name  | Type    |
-- +--------------+---------+
-- | product_id   | int     |
-- | product_name | varchar |
-- +--------------+---------+
-- product_id is the primary key (column with unique values) of this table.
-- Each row of this table indicates the product name of each product.
 
-- Write a solution to report the product_name, year, and price for each sale_id in the Sales table.

SELECT product_name, year, price 
FROM Sales
JOIN Product
USING (product_id)


-- 1581. Customer Who Visited but Did Not Make Any Transactions

-- Table: Visits
-- +-------------+---------+
-- | Column Name | Type    |
-- +-------------+---------+
-- | visit_id    | int     |
-- | customer_id | int     |
-- +-------------+---------+
-- visit_id is the column with unique values for this table.
-- This table contains information about the customers who visited the mall.
 
-- Table: Transactions
-- +----------------+---------+
-- | Column Name    | Type    |
-- +----------------+---------+
-- | transaction_id | int     |
-- | visit_id       | int     |
-- | amount         | int     |
-- +----------------+---------+
-- transaction_id is column with unique values for this table.
-- This table contains information about the transactions made during the visit_id.
 
-- Write a solution to find the IDs of the users who visited without making any transactions 
-- and the number of times they made these types of visits.

SELECT customer_id, count(visit_id) as count_no_trans
FROM visits
LEFT JOIN transactions
USING (visit_id) 
WHERE transaction_id IS NULL
GROUP BY customer_id

-- THIS WORKS TOO
SELECT  customer_id, count(visit_id) as count_no_trans
FROM visits
JOIN(
SELECT visit_id 
FROM visits
EXCEPT 
SELECT visit_id
FROM transactions)
USING (visit_id)
GROUP BY customer_id


-- 197. Rising Temperature

-- Table: Weather
-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | id            | int     |
-- | recordDate    | date    |
-- | temperature   | int     |
-- +---------------+---------+
-- id is the column with unique values for this table.
-- There are no different rows with the same recordDate.
-- This table contains information about the temperature on a certain day.
 
-- Write a solution to find all dates' Id with higher temperatures compared to its previous dates (yesterday).

SELECT w1.id
FROM Weather AS w1
JOIN Weather AS w2
ON w1.recordDate = (w2.recordDate + INTERVAL '1 DAY') 
WHERE w1.temperature > w2.temperature

-- another one

SELECT w1.id
FROM Weather AS w1, Weather AS w2
WHERE (w1.temperature > w2.temperature) and  (w1.recordDate - w2.recordDate = 1)


-- 1661. Average Time of Process per Machine

-- Table: Activity
-- +----------------+---------+
-- | Column Name    | Type    |
-- +----------------+---------+
-- | machine_id     | int     |
-- | process_id     | int     |
-- | activity_type  | enum    |
-- | timestamp      | float   |
-- +----------------+---------+
-- The table shows the user activities for a factory website.
-- (machine_id, process_id, activity_type) is the primary key (combination of columns with unique values) of this table.
-- machine_id is the ID of a machine.
-- process_id is the ID of a process running on the machine with ID machine_id.
-- activity_type is an ENUM (category) of type ('start', 'end').
-- timestamp is a float representing the current time in seconds.
-- 'start' means the machine starts the process at the given timestamp and 'end' means the machine ends the process at the given timestamp.
-- The 'start' timestamp will always be before the 'end' timestamp for every (machine_id, process_id) pair.

-- There is a factory website that has several machines each running the same number of processes. Write a solution to find the average time each machine takes to complete a process.
-- The time to complete a process is the 'end' timestamp minus the 'start' timestamp. The average time is calculated by the total time to complete every process on the machine divided by the number of processes that were run.

-- The resulting table should have the machine_id along with the average time as processing_time, which should be rounded to 3 decimal places.

SELECT a1.machine_id, ROUND(AVG(a2.timestamp - a1.timestamp)::numeric, 3)  processing_time
FROM Activity as a1, Activity as a2
WHERE   (a1.activity_type = 'start') 
        AND (a2.activity_type = 'end')
        AND (a1.process_id = a2.process_id) 
        AND (a1.machine_id = a2.machine_id)
GROUP BY a1.machine_id

-- with join and filter

SELECT  a1.machine_id, 
        ROUND(AVG(a2.timestamp - a1.timestamp) 
        FILTER  (WHERE  (a2.activity_type = 'end') 
                        AND (a1.activity_type = 'start'))::numeric, 3) 
        AS processing_time 
FROM Activity as a1 
JOIN Activity as a2
ON (a1.process_id = a2.process_id) AND (a1.machine_id = a2.machine_id)
GROUP BY a1.machine_id