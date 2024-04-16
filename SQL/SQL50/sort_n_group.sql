-- 2356. Number of Unique Subjects Taught by Each Teacher

-- Table: Teacher
-- +-------------+------+
-- | Column Name | Type |
-- +-------------+------+
-- | teacher_id  | int  |
-- | subject_id  | int  |
-- | dept_id     | int  |
-- +-------------+------+
-- (subject_id, dept_id) is the primary key (combinations of columns with unique values) of this table.
-- Each row in this table indicates that the teacher with teacher_id teaches the subject subject_id in the department dept_id.

-- Write a solution to calculate the number of unique subjects each teacher teaches in the university.

SELECT teacher_id, COUNT(DISTINCT(subject_id)) as cnt
FROM Teacher
GROUP BY teacher_id


-- 1141. User Activity for the Past 30 Days I

-- Table: Activity
-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | user_id       | int     |
-- | session_id    | int     |
-- | activity_date | date    |
-- | activity_type | enum    |
-- +---------------+---------+
-- This table may have duplicate rows.
-- The activity_type column is an ENUM (category) of type ('open_session', 'end_session', 'scroll_down', 'send_message').
-- The table shows the user activities for a social media website. 
-- Note that each session belongs to exactly one user.
 
-- Write a solution to find the daily active user count for a period of 30 days ending 2019-07-27 inclusively. 
-- A user was active on someday if they made at least one activity on that day.
-- Напишите решение для нахождения ежедневного количества активных пользователей за период в 30 дней, 
-- заканчивающийся 2019-07-27 включительно. Пользователь был активен в день, если он совершил хотя бы одну активность в этот день.

SELECT activity_date as day, COUNT(DISTINCT(user_id)) as active_users
FROM Activity
WHERE activity_date BETWEEN '2019-06-28' AND '2019-07-27'
GROUP BY activity_date


-- 1070. Product Sales Analysis III

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
 
-- Write a solution to select the product id, year, quantity, and price for the first year of every product sold.
-- Напишите решение для получения product id, year, quantity, price за первый год для каждого проданного товара.


WITH Un AS (SELECT product_id as p_id, MIN(year) as first_year
FROM Sales
GROUP BY product_id)

SELECT product_id, quantity, price, first_year 
FROM Sales
JOIN Un
ON (p_id = product_id) AND (year = first_year)

-- There can be multiple records with the same product_id and first_year so query below dont work, but if it has only 1 record per year it will be better
SELECT DISTINCT ON(product_id) product_id, year as first_year, quantity, price
FROM Sales
ORDER BY product_id, year ASC


-- 596. Classes More Than 5 Students

-- Table: Courses
-- +-------------+---------+
-- | Column Name | Type    |
-- +-------------+---------+
-- | student     | varchar |
-- | class       | varchar |
-- +-------------+---------+
-- (student, class) is the primary key (combination of columns with unique values) for this table.
-- Each row of this table indicates the name of a student and the class in which they are enrolled.
 
-- Write a solution to find all the classes that have at least five students.


SELECT class
FROM Courses
GROUP BY class
HAVING COUNT(student) >= 5


-- 1729. Find Followers Count
-- Table: Followers
-- +-------------+------+
-- | Column Name | Type |
-- +-------------+------+
-- | user_id     | int  |
-- | follower_id | int  |
-- +-------------+------+
-- (user_id, follower_id) is the primary key (combination of columns with unique values) for this table.
-- This table contains the IDs of a user and a follower in a social media app where the follower follows the user.
 
-- Write a solution that will, for each user, return the number of followers.
-- Return the result table ordered by user_id in ascending order.

SELECT user_id, COUNT(follower_id) as followers_count 
FROM Followers
GROUP BY user_id
ORDER BY user_id


-- 619. Biggest Single Number

-- Table: MyNumbers
-- +-------------+------+
-- | Column Name | Type |
-- +-------------+------+
-- | num         | int  |
-- +-------------+------+
-- This table may contain duplicates (In other words, there is no primary key for this table in SQL).
-- Each row of this table contains an integer.
 
-- A single number is a number that appeared only once in the MyNumbers table.
-- Find the largest single number. If there is no single number, report null.

SELECT  COALESCE(
                (SELECT num
                FROM MyNumbers
                GROUP BY num
                HAVING COUNT(NUM) = 1
                ORDER BY num DESC
                LIMIT 1)
                ) as num



-- 1045. Customers Who Bought All Products

-- Table: Customer
-- +-------------+---------+
-- | Column Name | Type    |
-- +-------------+---------+
-- | customer_id | int     |
-- | product_key | int     |
-- +-------------+---------+
-- This table may contain duplicates rows. 
-- customer_id is not NULL.
-- product_key is a foreign key (reference column) to Product table.
 
-- Table: Product
-- +-------------+---------+
-- | Column Name | Type    |
-- +-------------+---------+
-- | product_key | int     |
-- +-------------+---------+
-- product_key is the primary key (column with unique values) for this table.
 
-- Write a solution to report the customer ids from the Customer table that bought all the products in the Product table.

SELECT DISTINCT customer_id, count(product_key)
FROM Customer
GROUP BY customer_id
HAVING count(product_key) = SELECT(COUNT(product_key) FROM Product)