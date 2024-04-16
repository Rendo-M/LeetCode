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

-- 1193. Ежемесячные транзакции I

-- Таблица: Transactions
-- +---------------+---------+
-- | Название столбца | Тип     |
-- +---------------+---------+
-- | id            | int     |
-- | country       | varchar |
-- | state         | enum    |
-- | amount        | int     |
-- | trans_date    | date    |
-- +---------------+---------+
-- id - первичный ключ этой таблицы.
-- Таблица содержит информацию о входящих транзакциях.
-- Столбец state является перечислением типа ["approved", "declined"].

-- Напишите SQL-запрос, чтобы найти для каждого месяца и страны количество транзакций и их общую сумму, количество одобренных транзакций и их общую сумму.


-- Date_trunc can be removed and ORDER not necessarily 
SELECT  to_char(DATE_TRUNC('month', trans_date), 'yyyy-mm') as month,
        country, 
        count(amount) as trans_count,
        count(amount)  FILTER(WHERE state = 'approved') as approved_count, 
        sum(amount) as trans_total_amount, 
        COALESCE(sum(amount) FILTER(WHERE state = 'approved'), 0) as approved_total_amount
FROM Transactions
GROUP BY country, month
ORDER BY month


-- 1174. Immediate Food Delivery II

-- Table: Delivery
-- +-----------------------------+---------+
-- | Column Name                 | Type    |
-- +-----------------------------+---------+
-- | delivery_id                 | int     |
-- | customer_id                 | int     |
-- | order_date                  | date    |
-- | customer_pref_delivery_date | date    |
-- +-----------------------------+---------+
-- delivery_id is the column of unique values of this table.
-- The table holds information about food delivery to customers that make orders at some date 
-- and specify a preferred delivery date (on the same order date or after it).
 
-- If the customer's preferred delivery date is the same as the order date, then the order is called immediate; 
-- otherwise, it is called scheduled.
-- The first order of a customer is the order with the earliest order date that the customer made. 
-- It is guaranteed that a customer has precisely one first order.
-- Write a solution to find the percentage of immediate orders in the first orders of all customers, rounded to 2 decimal places.

-- 1174 Немедленная доставка еды II

-- Таблица: Delivery
-- +-----------------------------+---------+
-- | Название столбца            | Тип     |
-- +-----------------------------+---------+
-- | delivery_id                 | int     |
-- | customer_id                 | int     |
-- | order_date                  | date    |
-- | customer_pref_delivery_date | date    |
-- +-----------------------------+---------+
-- delivery_id - столбец с уникальными значениями в этой таблице.
-- Таблица содержит информацию о доставке еды клиентам, которые делают заказы в определенную дату 
-- и указывают предпочтительную дату доставки (в ту же дату заказа или после нее).

-- Если предпочтительная дата доставки клиента совпадает с датой заказа, то такой заказ называется немедленным; 
-- в противном случае он называется запланированным.
-- Первый заказ клиента - это заказ с самой ранней датой заказа, сделанный клиентом. 
-- Гарантируется, что у клиента есть ровно один первый заказ.

-- Напишите решение, чтобы найти процент немедленных заказов среди первых заказов всех клиентов, 
-- округленный до 2 десятичных знаков.

WITH first as (SELECT customer_id, min(order_date)
FROM Delivery
GROUP BY customer_id)

SELECT 
        ROUND(
        100.0 * (
                SELECT COUNT(customer_pref_delivery_date) 
                FROM first
                JOIN Delivery
                ON (first.customer_id=Delivery.customer_id)and(min = order_date)
                WHERE customer_pref_delivery_date = order_date
                ) 
        /       (
                SELECT COUNT(*) 
                FROM first
                )
        , 2) as immediate_percentage 


-- 550. Game Play Analysis IV

-- Table: Activity
-- +--------------+---------+
-- | Column Name  | Type    |
-- +--------------+---------+
-- | player_id    | int     |
-- | device_id    | int     |
-- | event_date   | date    |
-- | games_played | int     |
-- +--------------+---------+
-- (player_id, event_date) is the primary key (combination of columns with unique values) of this table.
-- This table shows the activity of players of some games.
-- Each row is a record of a player who logged in and played a number of games (possibly 0) 
-- before logging out on someday using some device.

-- (player_id, event_date) - первичный ключ (комбинация столбцов с уникальными значениями) этой таблицы.
-- Эта таблица показывает активность игроков в некоторых играх.
-- Каждая строка представляет собой запись об игроке, который вошел в систему, сыграл определенное количество игр (возможно, 0)
-- и вышел из системы в какой-то день, используя некоторое устройство.

-- Write a solution to report the fraction of players that logged in again on the day after the day they first logged in, 
-- rounded to 2 decimal places. In other words, you need to count the number of players that logged in for at least two 
-- consecutive days starting from their first login date, then divide that number by the total number of players.

-- Напишите решение, чтобы сообщить долю игроков, которые вошли в систему снова на следующий день после своего первого входа,
-- округленную до 2 десятичных знаков. Другими словами, вам нужно подсчитать количество игроков, которые вошли в систему 
-- хотя бы два последовательных дня, начиная с их первой даты входа, затем разделить это число на общее количество игроков.

WITH first as (SELECT player_id, min(event_date)
FROM Activity
GROUP BY player_id)

SELECT  ROUND( 
                (SELECT COUNT(first.player_id)
                FROM first
                JOIN Activity
                ON (first.player_id = Activity.player_id) and (min + INTERVAL '1 DAY') = event_date)
                /
                (SELECT COUNT(player_id)
                FROM FIRST)::NUMERIC, 2
                ) 
        as fraction 

