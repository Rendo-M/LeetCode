-- 1731. The Number of Employees Which Report to Each Employee

-- Table: Employees
-- +-------------+----------+
-- | Column Name | Type     |
-- +-------------+----------+
-- | employee_id | int      |
-- | name        | varchar  |
-- | reports_to  | int      |
-- | age         | int      |
-- +-------------+----------+
-- employee_id is the column with unique values for this table.
-- This table contains information about the employees and the id of the manager they report to. Some employees do not report to anyone (reports_to is null). 
 
-- For this problem, we will consider a manager an employee who has at least 1 other employee reporting to them.
-- Write a solution to report the ids and the names of all managers, the number of employees who report directly to them, 
-- and the average age of the reports rounded to the nearest integer.
-- Return the result table ordered by employee_id.
-- В этой задаче мы будем считать менеджером сотрудника, которому подчиняется хотя бы еще один сотрудник.

-- Напишите решение, позволяющее сообщать идентификаторы и имена всех менеджеров, количество сотрудников, которые подчиняются им
-- непосредственно, а также средний возраст подчиненных, округленный до ближайшего целого числа.
-- Возвращает таблицу результатов, упорядоченную по идентификатору сотрудника.

SELECT employee_id, name, count as reports_count,  ROUND(avg) as average_age 
FROM Employees
JOIN (  SELECT reports_to as rep, COUNT(employee_id), AVG(age)
        FROM Employees
        WHERE reports_to is not NULL
        GROUP BY reports_to)
ON (employee_id = rep)  
ORDER BY employee_id 



-- 1789. Primary Department for Each Employee

-- Table: Employee
-- +---------------+---------+
-- | Column Name   |  Type   |
-- +---------------+---------+
-- | employee_id   | int     |
-- | department_id | int     |
-- | primary_flag  | varchar |
-- +---------------+---------+
-- (employee_id, department_id) is the primary key (combination of columns with unique values) for this table.
-- employee_id is the id of the employee.
-- department_id is the id of the department to which the employee belongs.
-- primary_flag is an ENUM (category) of type ('Y', 'N'). If the flag is 'Y', the department 
-- is the primary department for the employee. If the flag is 'N', the department is not the primary.

-- Employees can belong to multiple departments. When the employee joins other departments, 
-- they need to decide which department is their primary department. 
-- Note that when an employee belongs to only one department, their primary column is 'N'.

-- Write a solution to report all the employees with their primary department. 
-- For employees who belong to one department, report their only department.

-- Сотрудники могут принадлежать к нескольким отделам. Когда сотрудник переходит в другие отделы, ему необходимо решить, 
-- какой отдел является для него основным. Обратите внимание, что если сотрудник принадлежит только к одному отделу, 
-- в колонке является ли отдел основным будет 'N'.
-- Напишите решение для создания отчета обо всех сотрудниках с указанием их основного отдела. 
-- Для сотрудников, которые принадлежат к одному отделу, выведите в отчет их единственный отдел.

SELECT employee_id, department_id
FROM Employee
WHERE primary_flag = 'Y'
UNION
SELECT employee_id, department_id
FROM Employee
WHERE employee_id in (SELECT employee_id FROM Employee GROUP BY employee_id HAVING COUNT(department_id) = 1)



-- 610. Triangle Judgement

-- Table: Triangle
-- +-------------+------+
-- | Column Name | Type |
-- +-------------+------+
-- | x           | int  |
-- | y           | int  |
-- | z           | int  |
-- +-------------+------+
-- In SQL, (x, y, z) is the primary key column for this table.
-- Each row of this table contains the lengths of three line segments.

-- Report for every three line segments whether they can form a triangle.

SELECT  x, y, z, 
        CASE
           WHEN x + y > z AND x + z > y AND y + z > x THEN 'Yes'
           ELSE 'No'
        END AS triangle
FROM Triangle   

-- how to found max/min from 3 values:
SELECT  x, y, z, 
        CASE
            WHEN (SELECT MIN(Col) FROM (VALUES (x+y), (y+z), (x+z)) AS X(Col)) > 
            (SELECT MAX(Col) FROM (VALUES (x), (y), (z)) AS Y(Col)) THEN 'Yes'
            ELSE 'No'
        END as triangle 
FROM Triangle



-- 180. Consecutive Numbers

-- Table: Logs
-- +-------------+---------+
-- | Column Name | Type    |
-- +-------------+---------+
-- | id          | int     |
-- | num         | varchar |
-- +-------------+---------+
-- In SQL, id is the primary key for this table.
-- id is an autoincrement column.
 
-- Find all numbers that appear at least three times consecutively.

SELECT DISTINCT num as ConsecutiveNums 
FROM(
SELECT num, id,
       LEAD(num) over (order by id), 
       LEAD(num, 2) over (order by id) as lead2,
       LEAD(id, 2) over (order by id) as lead_id
FROM Logs)
WHERE num = lead and num = lead2 and id = lead_id-2

--  btw for nonconsecutive numbers solution much easier:

SELECT DISTINCT num
FROM Logs
GROUP BY num
HAVING COUNT(num) >= 3



-- 1164. Product Price at a Given Date

-- Table: Products
-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | product_id    | int     |
-- | new_price     | int     |
-- | change_date   | date    |
-- +---------------+---------+
-- (product_id, change_date) is the primary key (combination of columns with unique values) of this table.
-- Each row of this table indicates that the price of some product was changed to a new price at some date.
 
-- Write a solution to find the prices of all products on 2019-08-16. Assume the price of all products before any change is 10.

(SELECT DISTINCT ON(product_id) product_id, new_price as price
FROM Products
WHERE change_date <= '2019-08-16'
ORDER BY product_id, change_date DESC)
UNION
SELECT product_id, 10 as price
FROM Products
GROUP BY product_id
HAVING min(change_date) > '2019-08-16'



-- 1204. Last Person to Fit in the Bus

-- Table: Queue
-- +-------------+---------+
-- | Column Name | Type    |
-- +-------------+---------+
-- | person_id   | int     |
-- | person_name | varchar |
-- | weight      | int     |
-- | turn        | int     |
-- +-------------+---------+
-- person_id column contains unique values.
-- This table has the information about all people waiting for a bus.
-- The person_id and turn columns will contain all numbers from 1 to n, where n is the number of rows in the table.
-- turn determines the order of which the people will board the bus, where turn=1 denotes the first person to board and turn=n denotes the last person to board.
-- weight is the weight of the person in kilograms.
 
-- There is a queue of people waiting to board a bus. 
-- However, the bus has a weight limit of 1000 kilograms, so there may be some people who cannot board.

-- Write a solution to find the person_name of the last person that can fit on the bus 
-- without exceeding the weight limit. 
-- The test cases are generated such that the first person does not exceed the weight limit.

SELECT person_name
FROM 
(SELECT person_name, weight, turn,  sum(weight) OVER (ORDER BY turn) as entered
FROM Queue)
WHERE entered <= 1000
ORDER BY entered DESC
LIMIT 1



-- 1907. Count Salary Categories

-- Table: Accounts
-- +-------------+------+
-- | Column Name | Type |
-- +-------------+------+
-- | account_id  | int  |
-- | income      | int  |
-- +-------------+------+
-- account_id is the primary key (column with unique values) for this table.
-- Each row contains information about the monthly income for one bank account.
 
-- Write a solution to calculate the number of bank accounts for each salary category. The salary categories are:
-- "Low Salary": All the salaries strictly less than $20000.
-- "Average Salary": All the salaries in the inclusive range [$20000, $50000].
-- "High Salary": All the salaries strictly greater than $50000.
-- The result table must contain all three categories. If there are no accounts in a category, return 0.

SELECT   'Low Salary' as category, COUNT(account_id) as accounts_count 
FROM Accounts
WHERE income < 20000 
    UNION
SELECT   'High Salary' as category, COUNT(account_id) as accounts_count 
FROM Accounts
WHERE income > 50000 
    UNION
SELECT   'Average Salary' as category, COUNT(account_id) as accounts_count 
FROM Accounts
WHERE income BETWEEN 20000 AND 50000 


