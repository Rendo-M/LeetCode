-- ПОДЗАПРОСЫ
-- 2. Задание:
-- Используя данные из таблицы user_actions, рассчитайте среднее число заказов всех пользователей нашего сервиса.
-- Для этого сначала в подзапросе посчитайте, сколько заказов сделал каждый пользователь, 
-- а затем обратитесь к результату подзапроса в блоке FROM и уже в основном запросе усредните 
-- количество заказов по всем пользователям.
-- Полученное среднее число заказов всех пользователей округлите до двух знаков после запятой. 
-- Колонку с этим значением назовите orders_avg.
-- Поле в результирующей таблице: orders_avg
SELECT round(sum(counter) / count(user_id), 2) as orders_avg
FROM   (SELECT user_id,
               count(distinct order_id) as counter
        FROM   user_actions
        GROUP BY user_id) as sub_querry
        

-- 3. Задание:
-- Повторите запрос из предыдущего задания, но теперь вместо подзапроса используйте оператор WITH и табличное выражение.
-- Условия задачи те же: используя данные из таблицы user_actions, рассчитайте среднее число заказов всех пользователей.
-- Полученное среднее число заказов округлите до двух знаков после запятой. Колонку с этим значением назовите orders_avg.
with sub_querry as (SELECT user_id,
                           count(distinct order_id) as counter
                    FROM   user_actions
                    GROUP BY user_id)
SELECT round(sum(counter) / count(user_id), 2) as orders_avg
FROM   sub_querry


-- 4. Задание:
-- Выведите из таблицы products информацию о всех товарах кроме самого дешёвого.
-- Результат отсортируйте по убыванию id товара.
-- Поля в результирующей таблице: product_id, name, price
with subquary as (SELECT min(price)
                  FROM   products)
SELECT product_id,
       name,
       price
FROM   products
WHERE  price != (SELECT min(price)
                 FROM   products)
ORDER BY product_id desc


-- 5. Задание:
-- Выведите информацию о товарах в таблице products, цена на которые превышает среднюю цену всех товаров на 20 рублей и более. 
-- Результат отсортируйте по убыванию id товара.
-- Поля в результирующей таблице: product_id, name, price
SELECT product_id,
       name,
       price
FROM   products
WHERE  price > 20 + (SELECT avg(price)
                     FROM   products)
ORDER BY product_id desc


-- 6. Задание:
-- Посчитайте количество уникальных клиентов в таблице user_actions, сделавших за последнюю неделю хотя бы один заказ.
-- Полученную колонку с числом клиентов назовите users_count. В качестве текущей даты, от которой откладывать неделю, 
-- используйте последнюю дату в той же таблице user_actions.
-- Поле в результирующей таблице: users_count
SELECT count(distinct user_id) as users_count
FROM   user_actions
WHERE  time >= (SELECT max(time)
                FROM   user_actions) - interval '1 week'


-- 7. Задание:
-- С помощью функции AGE и агрегирующей функции снова определите возраст самого молодого курьера мужского пола в таблице couriers, 
-- но в этот раз при расчётах в качестве первой даты используйте последнюю дату из таблицы courier_actions.
-- Чтобы получить именно дату, перед применением функции AGE переведите последнюю дату из таблицы courier_actions в формат DATE, 
-- как мы делали в этом задании.
-- Возраст курьера измерьте количеством лет, месяцев и дней и переведите его в тип VARCHAR. 
-- Полученную колонку со значением возраста назовите min_age.
-- Поле в результирующей таблице: min_age
SELECT cast(date_trunc('day', age((SELECT max(time)
                                   FROM   courier_actions), max(birth_date):: date)) as varchar) as min_age
FROM   couriers
WHERE  (sex = 'male')


-- 8. Задание:
-- Из таблицы user_actions с помощью подзапроса или табличного выражения отберите все заказы, 
-- которые не были отменены пользователями.
-- Выведите колонку с id этих заказов. Результат запроса отсортируйте по возрастанию id заказа.
-- Добавьте в запрос оператор LIMIT и выведите только первые 1000 строк результирующей таблицы.
-- SELECT order_id
FROM   user_actions
WHERE  order_id not in (SELECT order_id
                        FROM   user_actions
                        WHERE  action = 'cancel_order')
ORDER BY order_id limit 1000


-- 9. Задание:
-- Используя данные из таблицы user_actions, рассчитайте, сколько заказов сделал каждый пользователь 
-- и отразите это в столбце orders_count.
-- В отдельном столбце orders_avg напротив каждого пользователя укажите среднее число заказов всех пользователей, 
-- округлив его до двух знаков после запятой.
-- Также для каждого пользователя посчитайте отклонение числа заказов от среднего значения. 
-- Отклонение считайте так: число заказов «минус» округлённое среднее значение. Колонку с отклонением назовите orders_diff.
-- Результат отсортируйте по возрастанию id пользователя. 
-- Добавьте в запрос оператор LIMIT и выведите только первые 1000 строк результирующей таблицы.
-- Поля в результирующей таблице: user_id, orders_count, orders_avg, orders_diff
with sub_quarry as(SELECT round(sum(counter) / count(user_id), 2) as orders_avg FROM(SELECT user_id,
                                                                                                               count(distinct order_id) as counter
                                                                                                        FROM   user_actions
                                                                                                        GROUP BY user_id) as q)
SELECT user_id,
       count(user_id) as orders_count,
       (SELECT *
 FROM   sub_quarry), count(user_id) - (SELECT*
                                      FROM   sub_quarry) as orders_diff
FROM   user_actions
WHERE  action = 'create_order'
GROUP BY user_id
ORDER BY user_id limit 1000


-- 10. Задание:
-- Назначьте скидку 15% на товары, цена которых превышает среднюю цену на все товары на 50 и более рублей, 
-- а также скидку 10% на товары, цена которых ниже средней на 50 и более рублей. 
-- Цену остальных товаров внутри диапазона (среднее - 50; среднее + 50) оставьте без изменений. 
-- При расчёте средней цены, округлите её до двух знаков после запятой.
-- Выведите информацию о всех товарах с указанием старой и новой цены. Колонку с новой ценой назовите new_price.
-- Результат отсортируйте сначала по убыванию прежней цены в колонке price, затем по возрастанию id товара.
-- Поля в результирующей таблице: product_id, name, price, new_price
with avg_price as (SELECT round(avg(price), 2)
                   FROM   products)
SELECT product_id,
       name,
       price,
       case when price - (SELECT *
                   FROM   avg_price) >= 50 then price * 0.85 when price - (SELECT *
                                                        FROM   avg_price) <= -50 then price * 0.9 else price end as new_price
FROM   products
ORDER BY price desc, product_id


-- 11. Задание:
-- Выясните, есть ли в таблице courier_actions такие заказы, которые были приняты курьерами, но не были созданы пользователями. 
-- Посчитайте количество таких заказов.
-- Колонку с числом заказов назовите orders_count.
-- Поле в результирующей таблице: orders_count
SELECT count(order_id) filter (WHERE order_id not in (SELECT order_id
                                                      FROM   user_actions
                                                      WHERE  action = 'create_order')) as orders_count
FROM   courier_actions


-- 12. Задание:
-- Выясните, есть ли в таблице courier_actions такие заказы, которые были приняты курьерами, 
-- но не были доставлены пользователям. Посчитайте количество таких заказов.
-- Колонку с числом заказов назовите orders_count.
-- Поле в результирующей таблице: orders_count
SELECT count(order_id) filter (WHERE order_id not in (SELECT order_id
                                                      FROM   courier_actions
                                                      WHERE  action = 'deliver_order')) as orders_count
FROM   courier_actions


-- 13. Задание:
-- Определите количество отменённых заказов в таблице courier_actions и выясните, есть ли в этой таблице такие заказы, 
-- которые были отменены пользователями, но при этом всё равно были доставлены. Посчитайте количество таких заказов.
-- Колонку с отменёнными заказами назовите orders_canceled. 
-- Колонку с отменёнными, но доставленными заказами назовите orders_canceled_and_delivered. 
-- Поля в результирующей таблице: orders_canceled, orders_canceled_and_delivered
SELECT count(order_id) filter (WHERE order_id in (SELECT order_id
                                                  FROM   user_actions
                                                  WHERE  action = 'cancel_order')) as orders_canceled, 
        (SELECT count(order_id) filter (WHERE order_id in ( SELECT order_id 
                                                            FROM user_actions
                                                            WHERE  action = 'cancel_order'))
        FROM   courier_actions
        WHERE  action = 'deliver_order') as orders_canceled_and_delivered
FROM   courier_actions


-- 14. Задание:
-- По таблицам courier_actions и user_actions снова определите число недоставленных заказов и среди них посчитайте 
-- количество отменённых заказов и количество заказов, которые не были отменены (и соответственно, пока ещё не были доставлены).
-- Колонку с недоставленными заказами назовите orders_undelivered, колонку с отменёнными заказами назовите orders_canceled, 
-- колонку с заказами «в пути» назовите orders_in_process.
-- Поля в результирующей таблице: orders_undelivered, orders_canceled, orders_in_process
SELECT  count(order_id) filter (WHERE   order_id in         (SELECT order_id
                                                            FROM   user_actions
                                                            WHERE  action = 'cancel_order')) as orders_canceled, 
        count(order_id) filter (WHERE   order_id not in (SELECT order_id
                                                            FROM   courier_actions
                                                            WHERE  action = 'deliver_order')) as orders_undelivered, 
        count(order_id) filter(WHERE    order_id not in     (SELECT order_id
                                                            FROM   user_actions
                                                            WHERE  action = 'cancel_order')
                                        and order_id not in (SELECT order_id
                                                            FROM   courier_actions
                                                            WHERE  action = 'deliver_order')) as orders_in_process
FROM   orders

-- 15. Задание:
-- Отберите из таблицы users пользователей мужского пола, которые старше всех пользователей женского пола.
-- Выведите две колонки: id пользователя и дату рождения. Результат отсортируйте по возрастанию id пользователя.
-- -- Поля в результирующей таблице: user_id, birth_date
SELECT user_id,
       birth_date
FROM   users
WHERE  sex = 'male'
   and birth_date < (SELECT min(birth_date)
                  FROM   users
                  WHERE  sex = 'female')
ORDER BY user_id


-- -- 16. Задание:
-- Выведите id и содержимое 100 последних доставленных заказов из таблицы orders.
-- Содержимым заказов считаются списки с id входящих в заказ товаров. Результат отсортируйте по возрастанию id заказа.
-- Поля в результирующей таблице: order_id, product_ids
with delivered as(SELECT order_id
                  FROM   courier_actions
                  WHERE  action = 'deliver_order'
                  ORDER BY time desc limit 100)
SELECT order_id,
       product_ids
FROM   orders
WHERE  order_id in (SELECT *
                    FROM   delivered)
ORDER BY order_id

-- 17. Задание:
-- Из таблицы couriers выведите всю информацию о курьерах, которые в сентябре 2022 года доставили 30 и более заказов.
-- Результат отсортируйте по возрастанию id курьера.
-- Поля в результирующей таблице: courier_id, birth_date, sex
with sub_quarry as (SELECT courier_id
                    FROM   (SELECT courier_id,
                                   count(order_id) as total
                            FROM   courier_actions
                            WHERE  (action = 'deliver_order')
                               and (time between '2022-09-01'
                               and '2022-09-30')
                            GROUP BY courier_id
                            ORDER BY total desc) as count_orders
                    WHERE  total > 29)
SELECT courier_id,
       birth_date,
       sex
FROM   couriers
WHERE  courier_id in (SELECT *
                      FROM   sub_quarry)
ORDER BY courier_id


-- 18. Задание:
-- Рассчитайте средний размер заказов, отменённых пользователями мужского пола.
-- Средний размер заказа округлите до трёх знаков после запятой. Колонку со значением назовите avg_order_size.
-- Поле в результирующей таблице: avg_order_size
SELECT round(avg(array_length(product_ids, 1)), 3) as avg_order_size
FROM   orders
WHERE  order_id in (SELECT order_id
                    FROM   user_actions
                    WHERE  action = 'cancel_order'
                       and user_id in (SELECT user_id
                                    FROM   users
                                    WHERE  sex = 'male'))

-- 19. Задание:
-- Посчитайте возраст каждого пользователя в таблице users.
-- Возраст измерьте числом полных лет, как мы делали в прошлых уроках. 
-- Возраст считайте относительно последней даты в таблице user_actions.
-- Для тех пользователей, у которых в таблице users не указана дата рождения, 
-- укажите среднее значение возраста всех остальных пользователей, округлённое до целого числа.
-- Колонку с возрастом назовите age. В результат включите колонки с id пользователя и возрастом. 
-- Отсортируйте полученный результат по возрастанию id пользователя.
-- Поля в результирующей таблице: user_id, age
with avg_age as (SELECT date_trunc('year', avg(age((SELECT max(time)
                                                    FROM   user_actions), birth_date))) as ages
                 FROM   users)
SELECT date_part('year', coalesce(date_trunc('year', age((  SELECT max(time)
                                                            FROM   user_actions), birth_date)), 
                                                          ( SELECT ages
                                                            FROM   avg_age)))::int as age, user_id
FROM   users
ORDER BY user_id


-- 20. Задание:
-- Для каждого заказа, в котором больше 5 товаров, рассчитайте время, затраченное на его доставку. 
-- В результат включите id заказа, время принятия заказа курьером, время доставки заказа и время, затраченное на доставку. 
-- Новые колонки назовите соответственно time_accepted, time_delivered и delivery_time.
-- В расчётах учитывайте только неотменённые заказы. Время, затраченное на доставку, выразите в минутах, 
-- округлив значения до целого числа. Результат отсортируйте по возрастанию id заказа.
-- Поля в результирующей таблице: order_id, time_accepted, time_delivered и delivery_time
SELECT order_id,
       max(time) as time_delivered,
       min(time) as time_accepted,
       round(date_part('epoch', max(time) - min(time))/60)::int as delivery_time
FROM   courier_actions
WHERE  order_id not in (SELECT order_id
                        FROM   user_actions
                        WHERE  action = 'cancel_order')
   and order_id in (SELECT order_id
                 FROM   orders
                 WHERE  array_length(product_ids, 1) > 5)
GROUP BY order_id
ORDER BY order_id


-- 21. Задание:
-- Для каждой даты в таблице user_actions посчитайте количество первых заказов, совершённых пользователями.
-- Первыми заказами будем считать заказы, которые пользователи сделали в нашем сервисе впервые. 
-- В расчётах учитывайте только неотменённые заказы.
-- В результат включите две колонки: дату и количество первых заказов в эту дату. Колонку с датами назовите date, 
-- а колонку с первыми заказами — first_orders.
-- Результат отсортируйте по возрастанию даты.
-- Поля в результирующей таблице: date, first_orders
with first_orders_cte as(SELECT user_id,
                                min(time) as time
                         FROM   user_actions
                         WHERE  order_id not in (SELECT order_id
                                                 FROM   user_actions
                                                 WHERE  action = 'cancel_order')
                         GROUP BY user_id)
SELECT time::date as date,
       count(user_id) as first_orders
FROM   first_orders_cte
GROUP BY date
ORDER BY date


-- 22. Задание:
-- Выберите все колонки из таблицы orders и дополнительно в качестве последней колонки укажите функцию unnest, 
-- применённую к колонке product_ids. Эту последнюю колонку назовите product_id. Больше ничего с данными делать не нужно.
-- Добавьте в запрос оператор LIMIT и выведите только первые 100 записей результирующей таблицы.
-- Поля в результирующей таблице: creation_time, order_id, product_ids, product_id
-- Посмотрите на результат работы функции unnest и постарайтесь разобраться, что произошло с исходной таблицей.
SELECT creation_time,
       order_id,
       product_ids,
       unnest(product_ids) as product_id
FROM   orders limit 100


-- 23. Задание:
-- Используя функцию unnest, определите 10 самых популярных товаров в таблице orders.
-- Самыми популярными товарами будем считать те, которые встречались в заказах чаще всего. 
-- Если товар встречается в одном заказе несколько раз (когда было куплено несколько единиц товара), 
-- это тоже учитывается при подсчёте. Учитывайте только неотменённые заказы.
-- Выведите id товаров и то, сколько раз они встречались в заказах (то есть сколько раз были куплены). 
-- Новую колонку с количеством покупок товаров назовите times_purchased.
-- Результат отсортируйте по возрастанию id товара.
-- Поля в результирующей таблице: product_id, times_purchased
with orders_cte as (SELECT product_id,
                           count(product_id) as times_purchased
                    FROM   (SELECT unnest(product_ids) as product_id
                            FROM   orders
                            WHERE  order_id not in (SELECT order_id
                                                    FROM   user_actions
                                                    WHERE  action = 'cancel_order')) as unnested
                    GROUP BY product_id
                    ORDER BY times_purchased desc limit 10)
SELECT *
FROM   orders_cte
ORDER BY product_id

-- 24. Задание:
-- Из таблицы orders выведите id и содержимое заказов, которые включают хотя бы один из пяти самых дорогих товаров, 
-- доступных в нашем сервисе.
-- Результат отсортируйте по возрастанию id заказа.
-- Поля в результирующей таблице: order_id, product_ids

with    prod_orders as((SELECT  order_id,
                                unnest(product_ids) as product_id
                         FROM   orders)), 

        top_prod as((SELECT     product_id
                    FROM   products
                    ORDER BY price desc limit 5))

SELECT order_id,
       product_ids
FROM   orders
WHERE  order_id in (SELECT DISTINCT order_id
                    FROM   prod_orders
                    WHERE  product_id in (SELECT *
                                          FROM   top_prod))
ORDER BY order_id