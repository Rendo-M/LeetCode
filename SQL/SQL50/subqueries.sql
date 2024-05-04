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