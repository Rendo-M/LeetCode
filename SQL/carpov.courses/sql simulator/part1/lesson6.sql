-- ГРУППИРОВКА ДАННЫХ
-- 1. Задание:
-- С помощью оператора GROUP BY посчитайте количество курьеров мужского и женского пола в таблице couriers.
-- Новую колонку с числом курьеров назовите couriers_count.
-- Результат отсортируйте по этой колонке по возрастанию.
-- Поля в результирующей таблице: sex, couriers_count
SELECT sex,
       count(courier_id) as couriers_count
FROM   couriers
GROUP BY sex
ORDER BY couriers_count


-- 2. Задание:
-- Посчитайте количество созданных и отменённых заказов в таблице user_actions.
-- Новую колонку с числом заказов назовите orders_count.
-- Результат отсортируйте по числу заказов по возрастанию.
-- Поля в результирующей таблице: action, orders_count
SELECT action,
       count(action) as orders_count
FROM   user_actions
GROUP BY action
ORDER BY orders_count


-- 3. Задание:
-- Используя группировку и функцию DATE_TRUNC, приведите все даты к началу месяца и посчитайте, сколько заказов 
-- было сделано в каждом из них.
-- Расчёты проведите по таблице orders. Колонку с усечённой датой назовите month, колонку с количеством заказов — orders_count.
-- Результат отсортируйте по месяцам — по возрастанию.
-- Поля в результирующей таблице: month, orders_count
SELECT date_trunc('month', creation_time) as month,
       count(order_id) as orders_count
FROM   orders
GROUP BY month
ORDER BY month


-- 4. Задание:
-- Используя группировку и функцию DATE_TRUNC, приведите все даты к началу месяца и посчитайте, 
-- сколько заказов было сделано и сколько было отменено в каждом из них.
-- В этот раз расчёты проведите по таблице user_actions. Колонку с усечённой датой назовите month, 
-- колонку с количеством заказов — orders_count.
-- Результат отсортируйте сначала по месяцам — по возрастанию, затем по типу действия — тоже по возрастанию.
-- Поля в результирующей таблице: month, action, orders_count
SELECT action,
       date_trunc('month', time) as month,
       count(order_id) as orders_count
FROM   user_actions
GROUP BY action, month
ORDER BY month, action


-- 5. Задание:
-- По данным в таблице users посчитайте максимальный порядковый номер месяца среди всех порядковых номеров месяцев рождения пользователей сервиса. 
-- С помощью группировки проведите расчёты отдельно в двух группах — для пользователей мужского и женского пола.
-- Новую колонку с максимальным номером месяца рождения в группах назовите max_month. 
-- Преобразуйте значения в новой колонке в формат INTEGER, чтобы порядковый номер был выражен целым числом.
-- Результат отсортируйте по колонке с полом пользователей.
-- Поля в результирующей таблице: sex, max_month
SELECT sex, MAX(DATE_PART('month',birth_date))::VARCHAR as max_month
FROM users 
GROUP BY sex
ORDER BY sex

-- 6. Задание:
-- По данным в таблице users посчитайте порядковый номер месяца рождения самого молодого пользователя сервиса. 
-- С помощью группировки проведите расчёты отдельно в двух группах — для пользователей мужского и женского пола.
-- Новую колонку с максимальным номером месяца рождения в группах назовите max_month. 
-- Преобразуйте значения в новой колонке в формат INTEGER, чтобы порядковый номер был выражен целым числом.
-- Результат отсортируйте по колонке с полом пользователей.
-- Поля в результирующей таблице: sex, max_month
SELECT sex,
       date_part('month', max(birth_date))::varchar as max_month
FROM   users
GROUP BY sex
ORDER BY sex


-- 7. Задание:
-- Посчитайте максимальный возраст пользователей мужского и женского пола в таблице users. 
-- Возраст измерьте числом полных лет.
-- Новую колонку с возрастом назовите max_age. Преобразуйте значения в новой колонке в формат INTEGER, \чтобы возраст был выражен целым числом.
-- Результат отсортируйте по новой колонке по возрастанию возраста.
-- Поля в результирующей таблице: sex, max_age
SELECT sex,
       date_part('year', age(current_date, min(birth_date)))::int as max_age
FROM   users
GROUP BY sex
ORDER BY max_age
-- или так
SELECT sex,
       date_part('year', max(age(birth_date)))::integer as max_age
FROM   users
GROUP BY sex
ORDER BY max_age

-- 8. Задание:
-- Разбейте пользователей из таблицы users на группы по возрасту (возраст по-прежнему измеряем числом полных лет) 
-- и посчитайте количество пользователей каждого возраста.
-- Колонку с возрастом назовите age, а колонку с числом пользователей — users_count. 
-- Преобразуйте значения в колонке с возрастом в формат INTEGER, чтобы возраст был выражен целым числом.
-- Результат отсортируйте по колонке с возрастом по возрастанию.
-- Поля в результирующей таблице: age, users_count
SELECT date_part('year', age(birth_date)) as age,
       count(user_id) as users_count
FROM   users
GROUP BY age
ORDER BY age


-- 9. Задание:
-- Разбейте пользователей из таблицы users на группы по возрасту (возраст по-прежнему измеряем числом полных лет) и 
-- посчитайте количество пользователей каждого возраста.
-- Колонку с возрастом назовите age, а колонку с числом пользователей — users_count. 
-- Преобразуйте значения в колонке с возрастом в формат INTEGER, чтобы возраст был выражен целым числом.
-- Результат отсортируйте по колонке с возрастом по возрастанию.
-- Поля в результирующей таблице: age, users_count
SELECT sex,
       date_part('year', age(birth_date))::int as age,
       count(user_id) as users_count
FROM   users
WHERE  birth_date::varchar != ''
GROUP BY sex, age
ORDER BY age, sex


-- 10. Задание:
-- Посчитайте количество товаров в каждом заказе, примените к этим значениям группировку и рассчитайте количество заказов 
-- в каждой группе за неделю с 29 августа по 4 сентября 2022 года включительно. Для расчётов используйте данные из таблицы orders.
-- Выведите две колонки: размер заказа и число заказов такого размера за указанный период. 
-- Колонки назовите соответственно order_size и orders_count.
-- Результат отсортируйте по возрастанию размера заказа.
-- Поля в результирующей таблице: order_size, orders_count
SELECT array_length(product_ids, 1) as order_size,
       count(order_id) as orders_count
FROM   orders
WHERE creation_time BETWEEN '2022-08-29' AND '2022-09-05'
GROUP BY order_size
ORDER BY order_size


-- 11. Задание:
-- Посчитайте количество товаров в каждом заказе, примените к этим значениям группировку и рассчитайте количество заказов 
-- в каждой группе. Учитывайте только заказы, оформленные по будням. 
-- В результат включите только те размеры заказов, общее число которых превышает 2000. 
-- Для расчётов используйте данные из таблицы orders.
-- Выведите две колонки: размер заказа и число заказов такого размера. Колонки назовите соответственно order_size и orders_count.
-- Результат отсортируйте по возрастанию размера заказа.
-- Поля в результирующей таблице: order_size, orders_count
-- Когда решите эту задачу, вернитесь к одной из предыдущих и подумайте, могли бы мы ещё каким-то способом сделать так, 
-- чтобы в результат не попала группа с NULL значениями. 
-- Можете самостоятельно написать ещё один запрос и попробовать сдать его в качестве альтернативного решения.
SELECT array_length(product_ids, 1) as order_size,
       count(order_id) as orders_count
FROM   orders
WHERE  date_part('isodow', creation_time) < 6
GROUP BY order_size having count(order_id) > 2000
ORDER BY order_size
-- или так
SELECT array_length(product_ids, 1) as order_size,
       count(order_id) as orders_count
FROM   orders
WHERE  to_char(creation_time, 'Dy') not in ('Sat', 'Sun')
GROUP BY order_size having count(order_id) > 2000
ORDER BY order_size


-- 12. Задание:
-- По данным из таблицы user_actions определите пять пользователей, сделавших в августе 2022 года наибольшее количество заказов.
-- Выведите две колонки — id пользователей и число оформленных ими заказов. 
-- Колонку с числом оформленных заказов назовите created_orders.
-- Результат отсортируйте сначала по убыванию числа заказов, сделанных пятью пользователями, 
-- затем по возрастанию id этих пользователей.
-- Поля в результирующей таблице: user_id, created_orders
SELECT user_id,
       count(order_id) filter(WHERE action = 'create_order') as created_orders
FROM   user_actions
WHERE  time between '2022-08-01'
   and '2022-09-01'
GROUP BY user_id
ORDER BY created_orders desc, user_id limit 5


-- 13. Задание:
-- А теперь по данным таблицы courier_actions определите курьеров, которые в сентябре 2022 года доставили только по одному заказу.
-- В этот раз выведите всего одну колонку с id курьеров. Колонку с числом заказов в результат включать не нужно.
-- Результат отсортируйте по возрастанию id курьера.
-- Поле в результирующей таблице: courier_id
SELECT courier_id
FROM   courier_actions
WHERE  (action = 'deliver_order')
   and (time between '2022-09-01'
   and '2022-09-30')
GROUP BY courier_id having count(order_id) = 1
ORDER BY courier_id


-- 14. Задание:
-- Из таблицы user_actions отберите пользователей, у которых последний заказ был создан до 8 сентября 2022 года.
-- Выведите только их id, дату создания заказа выводить не нужно.
-- Результат отсортируйте по возрастанию id пользователя.
-- Поле в результирующей таблице: user_id
SELECT user_id
FROM   user_actions
WHERE action = 'create_order'
GROUP BY user_id having max(time) <= '2022-09-08'
ORDER BY user_id


-- 15. Задание:
-- Разбейте заказы из таблицы orders на 3 группы в зависимости от количества товаров, попавших в заказ:
-- * Малый (от 1 до 3 товаров);
-- * Средний (от 4 до 6 товаров);
-- * Большой (7 и более товаров).
-- Посчитайте число заказов, попавших в каждую группу. Группы назовите соответственно «Малый», «Средний», «Большой» (без кавычек).
-- Выведите наименования групп и число товаров в них. Колонку с наименованием групп назовите order_size, а колонку с числом заказов —
-- orders_count.
-- Отсортируйте полученную таблицу по колонке с числом заказов по возрастанию.
-- Поля в результирующей таблице: order_size, orders_count
SELECT case when array_length(product_ids, 1) < 4 then 'Малый'
            when array_length(product_ids, 1) > 6 then 'Большой'
            else 'Средний' end as order_size,
       count(*) as orders_count
FROM   orders
GROUP BY order_size
ORDER BY orders_count


-- 16. Задание:
-- Разбейте пользователей из таблицы users на 4 возрастные группы:
-- * от 18 до 24 лет;
-- * от 25 до 29 лет;
-- * от 30 до 35 лет;
-- * старше 36.
-- Посчитайте число пользователей, попавших в каждую возрастную группу.
-- Группы назовите соответственно «18-24», «25-29», «30-35», «36+» (без кавычек).
-- В расчётах не учитывайте пользователей, у которых не указана дата рождения. 
-- Как и в прошлых задачах, в качестве возраста учитывайте число полных лет.
-- Выведите наименования групп и число пользователей в них. 
-- Колонку с наименованием групп назовите group_age, а колонку с числом пользователей — users_count.
-- Отсортируйте полученную таблицу по колонке с наименованием групп по возрастанию.
-- Поля в результирующей таблице: group_age, users_count
SELECT case when date_part('year', age(birth_date)) between 18 and
                 24 then '18-24'
            when date_part('year', age(birth_date)) between 25 and
                 29 then '25-29'
            when date_part('year', age(birth_date)) between 30 and
                 35 then '30-35'
            else '36+' end as group_age,
       count(distinct user_id) as users_count
FROM   users
WHERE  birth_date :: varchar != ''
GROUP BY group_age
ORDER BY group_age


-- 17. Задание:
-- По данным из таблицы orders рассчитайте средний размер заказа по выходным и будням.
-- Группу с выходными днями (суббота и воскресенье) назовите «weekend», 
-- а группу с будними днями (с понедельника по пятницу) — «weekdays» (без кавычек).
-- В результат включите две колонки: колонку с группами назовите week_part, а колонку со средним размером заказа — avg_order_size. 
-- Средний размер заказа округлите до двух знаков после запятой.
-- Результат отсортируйте по колонке со средним размером заказа — по возрастанию.
-- Поля в результирующей таблице: week_part, avg_order_size
SELECT case when date_part('isodow', creation_time) < 6 then 'weekdays'
            else 'weekend' end as week_part,
       round(avg(array_length(product_ids, 1)), 2) as avg_order_size
FROM   orders
GROUP BY week_part
ORDER BY avg_order_size


-- 18. Задание:
-- Для каждого пользователя в таблице user_actions посчитайте общее количество оформленных заказов и долю отменённых заказов.
-- Новые колонки назовите соответственно orders_count и cancel_rate. 
-- Колонку с долей отменённых заказов округлите до двух знаков после запятой.
-- В результат включите только тех пользователей, которые оформили больше трёх заказов 
-- и у которых показатель cancel_rate составляет не менее 0.5.
-- Результат отсортируйте по возрастанию id пользователя.
-- Поля в результирующей таблице: user_id, orders_count, cancel_rate
SELECT  user_id,
        count(action) filter (WHERE action = 'create_order') as orders_count,
        round(count(action) filter(WHERE action = 'cancel_order') / cast(count(action) filter (WHERE action = 'create_order') as decimal) ,
             2) as cancel_rate
FROM   user_actions
GROUP BY user_id
HAVING count(action) filter (WHERE action = 'create_order') > 3 and count(action) filter(WHERE action = 'cancel_order') / cast(count(action) filter (WHERE action = 'create_order') as decimal) >= 0.5
ORDER BY user_id


-- 19. Задание:
-- Для каждого дня недели в таблице user_actions посчитайте:
-- Общее количество оформленных заказов.
-- Общее количество отменённых заказов.
-- Общее количество неотменённых заказов (т.е. доставленных).
-- Долю неотменённых заказов в общем числе заказов (success rate).
-- Новые колонки назовите соответственно created_orders, canceled_orders, actual_orders и success_rate. 
-- Колонку с долей неотменённых заказов округлите до трёх знаков после запятой.
-- Все расчёты проводите за период с 24 августа по 6 сентября 2022 года включительно, 
-- чтобы во временной интервал попало равное количество разных дней недели.
-- Группы сформируйте следующим образом: выделите день недели из даты с помощью функции to_char с параметром 'Dy', 
-- также выделите порядковый номер дня недели с помощью функции DATE_PART с параметром 'isodow'. 
-- Далее сгруппируйте данные по двум полям и проведите все необходимые расчёты.
-- В результате должна получиться группировка по двум колонкам: с порядковым номером дней недели и их сокращёнными наименованиями.
-- Результат отсортируйте по возрастанию порядкового номера дня недели.
-- Поля в результирующей таблице: weekday_number, weekday, created_orders, canceled_orders, actual_orders, success_rate
SELECT   
        DATE_PART('isodow', time)::INTEGER as weekday_number,
        TO_CHAR(time, 'Dy') AS weekday,
        count(action) filter(where action='create_order') as created_orders,
        count(action) filter(where action='cancel_order') as canceled_orders,   
        count(action) filter(where action='create_order') - count(action) filter(where action='cancel_order') as actual_orders,
        round((count(action) filter(where action='create_order') - count(action) filter(where action='cancel_order'))::NUMERIC/count(action) filter(where action='create_order'), 3) AS success_rate
        
FROM   user_actions
WHERE time BETWEEN '2022-08-24' AND '2022-09-07'
GROUP BY weekday, weekday_number
ORDER BY weekday_number