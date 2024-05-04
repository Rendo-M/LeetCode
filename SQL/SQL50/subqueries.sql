-- 1978. Employees Whose Manager Left the Company

-- Table: Employees
-- +-------------+----------+
-- | Column Name | Type     |
-- +-------------+----------+
-- | employee_id | int      |
-- | name        | varchar  |
-- | manager_id  | int      |
-- | salary      | int      |
-- +-------------+----------+
-- In SQL, employee_id is the primary key for this table.
-- This table contains information about the employees, their salary, and the ID of their manager. 
-- Some employees do not have a manager (manager_id is null). 

-- Find the IDs of the employees whose salary is strictly less than $30000 and whose manager left the company. 
-- When a manager leaves the company, their information is deleted from the Employees table, 
-- but the reports still have their manager_id set to the manager that left.
-- Return the result table ordered by employee_id.

SELECT employee_id
FROM Employees
WHERE salary < 30000 AND manager_id NOT IN (SELECT employee_id FROM Employees)
ORDER BY employee_id


-- 626. Exchange Seats

-- Table: Seat
-- +-------------+---------+
-- | Column Name | Type    |
-- +-------------+---------+
-- | id          | int     |
-- | student     | varchar |
-- +-------------+---------+
-- id is the primary key (unique value) column for this table.
-- Each row of this table indicates the name and the ID of a student.
-- id is a continuous increment.
 
-- Write a solution to swap the seat id of every two consecutive students. 
-- If the number of students is odd, the id of the last student is not swapped.
-- Return the result table ordered by id in ascending order.

    (SELECT id+1 as id, student
    FROM Seat
    WHERE id % 2 = 1
    LIMIT (SELECT MAX(id)/2 FROM SEAT))
UNION
    SELECT id-1 as id, student
    FROM SEAT 
    WHERE id % 2 = 0
UNION
    (SELECT id, student
    FROM SEAT
    ORDER BY id DESC 
    LIMIT (SELECT MAX(id)%2 FROM SEAT))
ORDER BY id

-- or same but with CASE instead queries

SELECT
        CASE
            WHEN id = (SELECT MAX(id) FROM Seat) AND MOD(id, 2) = 1 
            THEN id
            WHEN MOD(id, 2) = 1
            THEN id + 1
            ELSE id - 1
        END AS id, 
        student 
FROM Seat 
ORDER BY id

-- coalesce to fix odd rows and window func

SELECT CASE 
            WHEN id % 2 = 1 
            THEN COALESCE(lead(id,1) over(order by id), id) 
            ELSE lag(id,1) over(order by id) END as ID, 
            student
FROM seat
Order by ID


-- 1341. Movie Rating

-- Table: Movies
-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | movie_id      | int     |
-- | title         | varchar |
-- +---------------+---------+
-- movie_id is the primary key (column with unique values) for this table.
-- title is the name of the movie.
 
-- Table: Users
-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | user_id       | int     |
-- | name          | varchar |
-- +---------------+---------+
-- user_id is the primary key (column with unique values) for this table.
 
-- Table: MovieRating
-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | movie_id      | int     |
-- | user_id       | int     |
-- | rating        | int     |
-- | created_at    | date    |
-- +---------------+---------+
-- (movie_id, user_id) is the primary key (column with unique values) for this table.
-- This table contains the rating of a movie by a user in their review.
-- created_at is the user's review date. 

-- Write a solution to:
-- Find the name of the user who has rated the greatest number of movies. 
-- In case of a tie, return the lexicographically smaller user name.
-- Find the movie name with the highest average rating in February 2020. 
-- In case of a tie, return the lexicographically smaller movie name.

(
SELECT name as results
FROM Users
    JOIN 
(
SELECT user_id, count(movie_id) as movies
FROM MovieRating
GROUP BY user_id)
    USING(user_id)
ORDER BY movies DESC, name
LIMIT 1
)
    UNION ALL
(
SELECT title
FROM Movies
    JOIN(
SELECT movie_id, AVG(rating) as rate
FROM  MovieRating
WHERE created_at BETWEEN '2020-02-01' AND '2020-02-29'
GROUP BY movie_id
)    
    USING(movie_id)
ORDER BY rate DESC, title
LIMIT 1
)

-- 1321. Restaurant Growth

-- Table: Customer
-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | customer_id   | int     |
-- | name          | varchar |
-- | visited_on    | date    |
-- | amount        | int     |
-- +---------------+---------+
-- In SQL,(customer_id, visited_on) is the primary key for this table.
-- This table contains data about customer transactions in a restaurant.
-- visited_on is the date on which the customer with ID (customer_id) has visited the restaurant.
-- amount is the total paid by a customer.

-- You are the restaurant owner and you want to analyze a possible expansion (there will be at least one customer every day).
-- Compute the moving average of how much the customer paid in a seven days window 
-- (i.e., current day + 6 days before). average_amount should be rounded to two decimal places.
-- Return the result table ordered by visited_on in ascending order.

WITH Total AS(
    SELECT visited_on, sum(amount) as amount 
    FROM Customer
    GROUP BY visited_on
    ORDER BY visited_on
)

SELECT  visited_on, 
        SUM(amount) OVER (ORDER BY visited_on ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) as amount,
        ROUND(AVG(amount) OVER (ORDER BY visited_on ROWS BETWEEN 6 PRECEDING AND CURRENT ROW), 2) as average_amount
FROM Total
LIMIT ALL OFFSET 6


-- 602. Friend Requests II: Who Has the Most Friends

-- Table: RequestAccepted
-- +----------------+---------+
-- | Column Name    | Type    |
-- +----------------+---------+
-- | requester_id   | int     |
-- | accepter_id    | int     |
-- | accept_date    | date    |
-- +----------------+---------+
-- (requester_id, accepter_id) is the primary key (combination of columns with unique values) for this table.
-- This table contains the ID of the user who sent the request, the ID of the user who received the request, 
-- and the date when the request was accepted.

-- Write a solution to find the people who have the most friends and the most friends number.

WITH 
    res_cte AS (
                (SELECT requester_id as id
                FROM RequestAccepted)
            UNION ALL
                (SELECT accepter_id
                FROM RequestAccepted))


SELECT id,  COUNT(id) as num
FROM res_cte
GROUP BY id
ORDER BY COUNT(id) DESC
LIMIT 1


-- 585. Investments in 2016
 
-- Table: Insurance
-- +-------------+-------+
-- | Column Name | Type  |
-- +-------------+-------+
-- | pid         | int   |
-- | tiv_2015    | float |
-- | tiv_2016    | float |
-- | lat         | float |
-- | lon         | float |
-- +-------------+-------+
-- pid is the primary key (column with unique values) for this table.
-- Each row of this table contains information about one policy where:
-- pid is the policyholder's policy ID.
-- tiv_2015 is the total investment value in 2015 and tiv_2016 is the total investment value in 2016.
-- lat is the latitude of the policy holder's city. It's guaranteed that lat is not NULL.
-- -- lon is the longitude of the policy holder's city. It's guaranteed that lon is not NULL.

-- Write a solution to report the sum of all total investment values in 2016 tiv_2016, for all policyholders who:
-- 1. have the same tiv_2015 value as one or more other policyholders, and
-- 2. are not located in the same city as any other policyholder (i.e., the (lat, lon) attribute pairs must be unique).
-- Round tiv_2016 to two decimal places.

-- Каждая строка этой таблицы содержит информацию об одном полисе:
-- pid - идентификатор полиса страхователя.
-- tiv_2015 - общая стоимость инвестиций в 2015 году, tiv_2016 - общая стоимость инвестиций в 2016 году.
-- lat - широта города держателя полиса. Гарантируется, что lat не является NULL.
-- lon - долгота города держателя полиса. Гарантируется, что lon не является NULL.

-- Напишите решение для отчета о сумме всех общих инвестиционных ценностей в 2016 году tiv_2016 для всех страхователей, которые:
-- 1. имеют такое же значение tiv_2015, как и один или несколько других страхователей, и
-- 2. не находятся в том же городе, что и любой другой страхователь (т. е. пары атрибутов (lat, lon) должны быть уникальными).
-- Округлите tiv_2016 до двух знаков после запятой.

SELECT (SUM(tiv_2016)::NUMERIC) as tiv_2016
FROM (
        SELECT pid, tiv_2015, tiv_2016
        FROM Insurance
        WHERE (lat, lon) IN (   
                            SELECT lat, lon 
                            FROM Insurance
                            GROUP BY lat, lon
                            HAVING count(pid) = 1
                            )
    )
WHERE tiv_2015 IN   (
                    SELECT DISTINCT tiv_2015
                    FROM Insurance
                    GROUP BY tiv_2015
                    HAVING COUNT(pid) > 1
                    )

-- this one more readable:
WITH
unique_cte AS (
    SELECT pid, tiv_2015, tiv_2016
    FROM Insurance
    WHERE (lat, lon) IN
    (SELECT lat, lon 
    FROM Insurance
    GROUP BY lat, lon
    HAVING count(pid) = 1)),

same_cte AS (
    SELECT DISTINCT tiv_2015
    FROM Insurance
    GROUP BY tiv_2015
    HAVING COUNT(pid) > 1)

SELECT ROUND(sum(tiv_2016)::NUMERIC, 2) as tiv_2016
FROM unique_cte
WHERE tiv_2015 IN (SELECT * FROM same_cte) 



-- 185. Department Top Three Salaries

-- Table: Employee
-- +--------------+---------+
-- | Column Name  | Type    |
-- +--------------+---------+
-- | id           | int     |
-- | name         | varchar |
-- | salary       | int     |
-- | departmentId | int     |
-- +--------------+---------+
-- id is the primary key (column with unique values) for this table.
-- departmentId is a foreign key (reference column) of the ID from the Department table.
-- Each row of this table indicates the ID, name, and salary of an employee. It also contains the ID of their department.

-- Table: Department
-- +-------------+---------+
-- | Column Name | Type    |
-- +-------------+---------+
-- | id          | int     |
-- | name        | varchar |
-- +-------------+---------+
-- id is the primary key (column with unique values) for this table.
-- Each row of this table indicates the ID of a department and its name.
 
-- A company's executives are interested in seeing who earns the most money in each of the company's departments. 
-- A high earner in a department is an employee who has a salary in the top three unique salaries for that department.
-- Write a solution to find the employees who are high earners in each of the departments.

WITH Salary_CTE AS (SELECT 
        
        Employee.name as Employee,
        salary,
        departmentId,
        DENSE_RANK() OVER ( PARTITION BY departmentId ORDER BY salary DESC) as rank
FROM Employee)

SELECT Department.name as Department, Employee, Salary
FROM Salary_CTE
JOIN Department
ON Department.id = departmentId AND rank <= 3