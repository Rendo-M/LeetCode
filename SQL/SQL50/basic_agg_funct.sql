-- 620. Not Boring Movies

-- Table: Cinema
-- +----------------+----------+
-- | Column Name    | Type     |
-- +----------------+----------+
-- | id             | int      |
-- | movie          | varchar  |
-- | description    | varchar  |
-- | rating         | float    |
-- +----------------+----------+
-- id is the primary key (column with unique values) for this table.
-- Each row contains information about the name of a movie, its genre, and its rating.
-- rating is a 2 decimal places float in the range [0, 10]

-- Write a solution to report the movies with an odd-numbered ID and a description that is not "boring".
-- Return the result table ordered by rating in descending order.

SELECT id, movie, description, rating
FROM Cinema
WHERE (description != 'boring') AND (id % 2 == 1)
ORDER BY rating DESC


-- 1251. Average Selling Price

-- Table: Prices
-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | product_id    | int     |
-- | start_date    | date    |
-- | end_date      | date    |
-- | price         | int     |
-- +---------------+---------+
-- (product_id, start_date, end_date) is the primary key (combination of columns with unique values) for this table.
-- Each row of this table indicates the price of the product_id in the period from start_date to end_date.
-- For each product_id there will be no two overlapping periods. That means there will be no two intersecting periods for the same product_id.
 
-- Table: UnitsSold
-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | product_id    | int     |
-- | purchase_date | date    |
-- | units         | int     |
-- +---------------+---------+
-- This table may contain duplicate rows.
-- Each row of this table indicates the date, units, and product_id of each product sold. 
 
-- Write a solution to find the average selling price for each product. average_price should be rounded to 2 decimal places.

SELECT product_id,  COALESCE(ROUND(SUM(price*units::NUMERIC)/SUM(units), 2), 0) as average_price
FROM Prices
LEFT JOIN UnitsSold
USING (product_id) 
WHERE (purchase_date BETWEEN start_date AND end_date) or (purchase_date is null)
GROUP BY product_id

-- a bit faster

SELECT p.product_id,  COALESCE(ROUND(SUM(price*units::NUMERIC)/SUM(units), 2), 0) as average_price
FROM Prices as p
LEFT JOIN UnitsSold as u
ON (p.product_id = u.product_id) AND (purchase_date BETWEEN start_date AND end_date)  
GROUP BY p.product_id


-- 1075. Project Employees I

-- Table: Project
-- +-------------+---------+
-- | Column Name | Type    |
-- +-------------+---------+
-- | project_id  | int     |
-- | employee_id | int     |
-- +-------------+---------+
-- (project_id, employee_id) is the primary key of this table.
-- employee_id is a foreign key to Employee table.
-- Each row of this table indicates that the employee with employee_id is working on the project with project_id.
 
-- Table: Employee
-- +------------------+---------+
-- | Column Name      | Type    |
-- +------------------+---------+
-- | employee_id      | int     |
-- | name             | varchar |
-- | experience_years | int     |
-- +------------------+---------+
-- employee_id is the primary key of this table. It's guaranteed that experience_years is not NULL.
-- Each row of this table contains information about one employee.

-- Write an SQL query that reports the average experience years of all the employees for each project, rounded to 2 digits.

SELECT project_id, AVG(experience_years) as average_years 
FROM Project
JOIN Employee
USING (employee_id) 
GROUP BY project_id


-- 1633. Percentage of Users Attended a Contest

-- Table: Users
-- +-------------+---------+
-- | Column Name | Type    |
-- +-------------+---------+
-- | user_id     | int     |
-- | user_name   | varchar |
-- +-------------+---------+
-- user_id is the primary key (column with unique values) for this table.
-- Each row of this table contains the name and the id of a user.

-- Table: Register
-- +-------------+---------+
-- | Column Name | Type    |
-- +-------------+---------+
-- | contest_id  | int     |
-- | user_id     | int     |
-- +-------------+---------+
-- (contest_id, user_id) is the primary key (combination of columns with unique values) for this table.
-- Each row of this table contains the id of a user and the contest they registered into.

-- Write a solution to find the percentage of the users registered in each contest rounded to two decimals.
-- Return the result table ordered by percentage in descending order. In case of a tie, order it by contest_id in ascending order.

SELECT  contest_id, 
        ROUND((100.0 * COUNT(user_id)) / (SELECT COUNT(user_id) FROM Users), 2) as percentage 
FROM Register 
GROUP BY contest_id
ORDER BY percentage DESC, contest_id 


-- 1211. Queries Quality and Percentage

-- Table: Queries
-- +-------------+---------+
-- | Column Name | Type    |
-- +-------------+---------+
-- | query_name  | varchar |
-- | result      | varchar |
-- | position    | int     |
-- | rating      | int     |
-- +-------------+---------+
-- This table may have duplicate rows.
-- This table contains information collected from some queries on a database.
-- The position column has a value from 1 to 500.
-- The rating column has a value from 1 to 5. Query with rating less than 3 is a poor query.

-- We define query quality as:
-- The average of the ratio between query rating and its position.
-- We also define poor query percentage as:
-- The percentage of all queries with rating less than 3.
-- Write a solution to find each query_name, the quality and poor_query_percentage.
-- Both quality and poor_query_percentage should be rounded to 2 decimal places.

SELECT  query_name, 
        ROUND(AVG(rating::NUMERIC / position), 2) as quality, 
        ROUND(100.0 * COUNT(rating) FILTER(WHERE rating < 3) / COUNT(rating), 2) as poor_query_percentage
FROM Queries
WHERE query_name is not null
GROUP BY query_name


-- 1193. Monthly Transactions I

-- Table: Transactions
-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | id            | int     |
-- | country       | varchar |
-- | state         | enum    |
-- | amount        | int     |
-- | trans_date    | date    |
-- +---------------+---------+
-- id is the primary key of this table.
-- The table has information about incoming transactions.
-- The state column is an enum of type ["approved", "declined"].
 
-- Write an SQL query to find for each month and country, 
-- the number of transactions and their total amount, 
-- the number of approved transactions and their total amount.

SELECT  DATE_TRUNC('month', trans_date) as month,
        country, 
        count(amount) as trans_count,
        count(amount)  FILTER(WHERE state = 'approved') as approved_count, 
        sum(amount) as trans_total_amount, 
        sum(amount) FILTER(WHERE state = 'approved') as approved_total_amount
FROM Transactions
GROUP BY country, month