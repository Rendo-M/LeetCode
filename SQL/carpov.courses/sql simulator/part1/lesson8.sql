-- JOIN
-- 2. Задание:
-- Объедините таблицы user_actions и users по ключу user_id. В результат включите две колонки с user_id из обеих таблиц. 
-- Эти две колонки назовите соответственно user_id_left и user_id_right. 
-- Также в результат включите колонки order_id, time, action, sex, birth_date. 
-- Отсортируйте получившуюся таблицу по возрастанию id пользователя (в любой из двух колонок с id).
-- Поля в результирующей таблице: user_id_left, user_id_right,  order_id, time, action, sex, birth_date
SELECT user_actions.user_id as user_id_left,
       users.user_id as user_id_right,
       order_id,
       time,
       action,
       sex,
       birth_date
FROM   user_actions join users
        ON user_actions.user_id = users.user_id
ORDER BY user_id_right


-- 3. Задание:
-- А теперь попробуйте немного переписать запрос из прошлого задания и посчитать количество уникальных id в объединённой таблице. 
-- То есть снова объедините таблицы, но в этот раз просто посчитайте уникальные user_id в одной из колонок с id. 
-- Выведите это количество в качестве результата. Колонку с посчитанным значением назовите users_count.
-- Поле в результирующей таблице: users_count
-- После того как решите задачу, сравните полученное значение с количеством уникальных пользователей в таблицах 
-- users и user_actions, которое мы посчитали на прошлом шаге. С каким значением оно совпадает?
SELECT count(distinct user_id) as users_count
FROM   user_actions join users using (user_id)


-- 4. Задание:
-- С помощью LEFT JOIN объедините таблицы user_actions и users по ключу user_id. Обратите внимание на порядок таблиц — 
-- слева users_actions, справа users. В результат включите две колонки с user_id из обеих таблиц. 
-- Эти две колонки назовите соответственно user_id_left и user_id_right. 
-- Также в результат включите колонки order_id, time, action, sex, birth_date. 
-- Отсортируйте получившуюся таблицу по возрастанию id пользователя (в колонке из левой таблицы).
-- Поля в результирующей таблице: user_id_left, user_id_right,  order_id, time, action, sex, birth_date
SELECT a.user_id as user_id_left,
       b.user_id as user_id_right,
       order_id,
       time,
       action,
       sex,
       birth_date
FROM   user_actions a
    LEFT JOIN users b using (user_id)
ORDER BY user_id_left


-- 5. Задание:
-- Теперь снова попробуйте немного переписать запрос из прошлого задания и посчитайте количество уникальных id в колонке user_id, 
-- пришедшей из левой таблицы user_actions. Выведите это количество в качестве результата. 
-- Колонку с посчитанным значением назовите users_count.
-- Поле в результирующей таблице: users_count
SELECT count(distinct a.user_id) as users_count
FROM   user_actions a
    LEFT JOIN users b using (user_id)


-- 6. Задание:
-- -- Возьмите запрос из задания 3, где вы объединяли таблицы user_actions и users с помощью LEFT JOIN, 
-- добавьте к запросу оператор WHERE и исключите NULL значения в колонке user_id из правой таблицы. 
-- Включите в результат все те же колонки и отсортируйте получившуюся таблицу по возрастанию id пользователя 
-- в колонке из левой таблицы.
-- Поля в результирующей таблице: user_id_left, user_id_right,  order_id, time, action, sex, birth_date
SELECT user_actions.user_id as user_id_left,
       users.user_id as user_id_right,
       order_id,
       time,
       action,
       sex,
       birth_date
FROM   user_actions
    LEFT JOIN users
        ON user_actions.user_id = users.user_id
WHERE  users.user_id is not null
ORDER BY user_id_left


-- 7. Задание:
-- С помощью FULL JOIN объедините по ключу birth_date таблицы, полученные в результате вышеуказанных запросов 
-- (то есть объедините друг с другом два подзапроса). Не нужно изменять их, просто добавьте нужный JOIN.
-- В результат включите две колонки с birth_date из обеих таблиц. Эти две колонки назовите соответственно 
-- users_birth_date и couriers_birth_date. Также включите в результат колонки с числом пользователей и курьеров — 
-- users_count и couriers_count.
-- Отсортируйте получившуюся таблицу сначала по колонке users_birth_date по возрастанию, затем по колонке couriers_birth_date — 
-- тоже по возрастанию.
-- Поля в результирующей таблице: users_birth_date, users_count,  couriers_birth_date, couriers_count
SELECT t1.birth_date as users_birth_date,
       t2.birth_date as couriers_birth_date,
       users_count,
       couriers_count
FROM   (SELECT birth_date,
               count(user_id) as users_count
        FROM   users
        WHERE  birth_date is not null
        GROUP BY birth_date) as t1 full
    OUTER JOIN (SELECT birth_date,
                       count(courier_id) as couriers_count
                FROM   couriers
                WHERE  birth_date is not null
                GROUP BY birth_date) as t2 using (birth_date)
ORDER BY users_birth_date, couriers_birth_date


-- 8. Задача:
-- Объедините два следующих запроса друг с другом так, чтобы на выходе получился набор уникальных дат из таблиц users и couriers:
-- SELECT birth_date
-- FROM users
-- WHERE birth_date IS NOT NULL

-- SELECT birth_date
-- FROM couriers
-- WHERE birth_date IS NOT NULL
-- Поместите в подзапрос полученный после объединения набор дат и посчитайте их количество. 
-- Колонку с числом дат назовите dates_count.
-- Поле в результирующей таблице: dates_count
SELECT count(birth_date) as dates_count
FROM   (SELECT birth_date
        FROM   users
        WHERE  birth_date is not null
        UNION
SELECT birth_date
        FROM   couriers
        WHERE  birth_date is not null) as t


-- 9. Задание:
-- Из таблицы users отберите id первых 100 пользователей 
-- (просто выберите первые 100 записей, используя простой LIMIT) и с помощью CROSS JOIN объедините их со всеми 
-- наименованиями товаров из таблицы products. Выведите две колонки — id пользователя и наименование товара. 
-- Результат отсортируйте сначала по возрастанию id пользователя, затем по имени товара — тоже по возрастанию.
-- Поля в результирующей таблице: user_id, name
SELECT user_id,
       name
FROM   products cross join (SELECT user_id
                            FROM   users limit 100) as t1
ORDER BY user_id, name


-- 10. Задание:
-- Для начала объедините таблицы user_actions и orders — это вы уже умеете делать. 
-- В качестве ключа используйте поле order_id. Выведите id пользователей и заказов, а также список товаров в заказе. 
-- Отсортируйте таблицу по id пользователя по возрастанию, затем по id заказа — тоже по возрастанию.
-- Добавьте в запрос оператор LIMIT и выведите только первые 1000 строк результирующей таблицы.
-- Поля в результирующей таблице: user_id, order_id, product_ids
SELECT u_a.order_id as order_id,
       user_id,
       product_ids
FROM   orders join user_actions as u_a using (order_id)
ORDER BY user_id, order_id limit 1000


-- 11. Задание:
-- Снова объедините таблицы user_actions и orders, но теперь оставьте только уникальные неотменённые заказы 
-- (мы делали похожий запрос на прошлом уроке). Остальные условия задачи те же: вывести id пользователей и заказов, 
-- а также список товаров в заказе. Отсортируйте таблицу по id пользователя по возрастанию, 
-- затем по id заказа — тоже по возрастанию.
-- Добавьте в запрос оператор LIMIT и выведите только первые 1000 строк результирующей таблицы.
-- Поля в результирующей таблице: user_id, order_id, product_ids
SELECT u_a.order_id as order_id,
       user_id,
       product_ids
FROM   orders join (SELECT *
                    FROM   user_actions
                    WHERE  order_id not in (SELECT order_id
                                            FROM   user_actions
                                            WHERE  action = 'cancel_order')) as u_a using (order_id)
ORDER BY user_id, order_id limit 1000


-- 12. Задание:
-- Используя запрос из предыдущего задания, посчитайте, сколько в среднем товаров заказывает каждый пользователь. 
-- Выведите id пользователя и среднее количество товаров в заказе. Среднее значение округлите до двух знаков после запятой. 
-- Колонку посчитанными значениями назовите avg_order_size. 
-- Результат выполнения запроса отсортируйте по возрастанию id пользователя. 
-- Добавьте в запрос оператор LIMIT и выведите только первые 1000 строк результирующей таблицы.
-- Поля в результирующей таблице: user_id, avg_order_size
SELECT user_id,
       round(avg(array_length(product_ids, 1)), 2) as avg_order_size
FROM   (SELECT u_a.order_id as order_id,
               user_id,
               product_ids
        FROM   orders join (SELECT *
                            FROM   user_actions
                            WHERE  order_id not in (SELECT order_id
                                                    FROM   user_actions
                                                    WHERE  action = 'cancel_order')) as u_a using (order_id)) as t1
GROUP BY user_id
ORDER BY user_id limit 1000


-- 13. Задание:
-- Для начала к таблице с заказами (orders) примените функцию unnest, как мы делали в прошлом уроке. 
-- Колонку с id товаров назовите product_id. Затем к образовавшейся расширенной таблице по ключу product_id 
-- добавьте информацию о ценах на товары (из таблицы products). Должна получиться таблица с заказами, 
-- товарами внутри каждого заказа и ценами на эти товары. Выведите колонки с id заказа, id товара и ценой товара. 
-- Результат отсортируйте сначала по возрастанию id заказа, затем по возрастанию id товара.
-- Добавьте в запрос оператор LIMIT и выведите только первые 1000 строк результирующей таблицы.
-- Поля в результирующей таблице: order_id, product_id, price
SELECT order_id,
       t1.product_id,
       price
FROM   (SELECT unnest(product_ids) as product_id,
               order_id
        FROM   orders) as t1 join products using (product_id)
ORDER BY order_id, product_id limit 1000


-- 14. Задание:
-- Используя запрос из предыдущего задания, рассчитайте суммарную стоимость каждого заказа. 
-- Выведите колонки с id заказов и их стоимостью. Колонку со стоимостью заказа назовите order_price. 
-- Результат отсортируйте по возрастанию id заказа.
-- Добавьте в запрос оператор LIMIT и выведите только первые 1000 строк результирующей таблицы.
-- Поля в результирующей таблице: order_id, order_price
SELECT order_id,
       sum(price) as order_price
FROM   (SELECT unnest(product_ids) as product_id,
               order_id
        FROM   orders) as t1 join products using (product_id)
GROUP BY order_id
ORDER BY order_id limit 1000


-- 15. Задача:
-- Объедините запрос из предыдущего задания с частью запроса, который вы составили в задаче 11, 
-- то есть объедините запрос со стоимостью заказов с запросом, в котором вы считали размер каждого заказа из таблицы user_actions.
-- На основе объединённой таблицы для каждого пользователя рассчитайте следующие показатели:
-- * общее число заказов — колонку назовите orders_count
-- * среднее количество товаров в заказе — avg_order_size
-- * суммарную стоимость всех покупок — sum_order_value
-- * среднюю стоимость заказа — avg_order_value
-- * минимальную стоимость заказа — min_order_value
-- * максимальную стоимость заказа — max_order_value
-- * Полученный результат отсортируйте по возрастанию id пользователя.
-- Добавьте в запрос оператор LIMIT и выведите только первые 1000 строк результирующей таблицы.
-- Помните, что в расчётах мы по-прежнему учитываем только неотменённые заказы. 
-- При расчёте средних значений, округляйте их до двух знаков после запятой.
-- Поля в результирующей таблице: 
-- user_id, orders_count, avg_order_size, sum_order_value, avg_order_value, min_order_value, max_order_value
SELECT user_id,
       count(distinct t2.order_id) as orders_count,
       round(avg(order_size), 2) as avg_order_size,
       sum(order_value) as sum_order_value,
       round(avg(order_value), 2) as avg_order_value,
       min(order_value) as min_order_value,
       max(order_value) as max_order_value
FROM   (SELECT order_id,
               sum(price) as order_value
        FROM   (SELECT unnest(product_ids) as product_id,
                       order_id
                FROM   orders) as t1 join products using (product_id)
        GROUP BY order_id) as t2 join (SELECT user_id,
                                      order_id,
                                      array_length(product_ids, 1) as order_size
                               FROM   (SELECT u_a.order_id as order_id,
                                              user_id,
                                              product_ids
                                       FROM   orders join (SELECT *
                                                           FROM   user_actions
                                                           WHERE  order_id not in (SELECT order_id
                                                                                   FROM   user_actions
                                                                                   WHERE  action = 'cancel_order')) as u_a using (order_id)) as t11) as t3 using (order_id)
GROUP BY user_id
ORDER BY user_id limit 1000


-- 16. Задание:
-- По данным таблиц orders, products и user_actions посчитайте ежедневную выручку сервиса. 
-- Под выручкой будем понимать стоимость всех реализованных товаров, содержащихся в заказах.
-- Колонку с датой назовите date, а колонку со значением выручки — revenue.
-- В расчётах учитывайте только неотменённые заказы.
-- Результат отсортируйте по возрастанию даты.
-- Поля в результирующей таблице: date, revenue
SELECT creation_time as date,
       sum(price) as revenue
FROM   products join(SELECT creation_time::date,
                            order_id,
                            unnest(product_ids) as product_id
                     FROM   orders
                     WHERE  order_id not in (SELECT order_id
                                             FROM   user_actions
                                             WHERE  action = 'cancel_order')) as foo using(product_id)
GROUP BY creation_time
ORDER BY date


-- 17. Задание:
-- По таблицам courier_actions , orders и products определите 10 самых популярных товаров, доставленных в сентябре 2022 года.
-- Самыми популярными товарами будем считать те, которые встречались в заказах чаще всего. Если товар встречается в одном заказе 
-- несколько раз (было куплено несколько единиц товара), то при подсчёте учитываем только одну единицу товара.
-- Выведите наименования товаров и сколько раз они встречались в заказах. Новую колонку с количеством покупок товара 
-- назовите times_purchased. 
-- Поля в результирующей таблице: name, times_purchased
(SELECT name,
        times_purchased
 FROM   (SELECT unnest(product_ids) as product_id,
                count(distinct order_id) as times_purchased
         FROM   orders
         WHERE  order_id in (SELECT order_id
                             FROM   courier_actions
                             WHERE  action = 'deliver_order'
                                and time between '2022-09-01'
                                and '2022-10-01')
         GROUP BY product_id) as t1
     LEFT JOIN products using (product_id)
 ORDER BY times_purchased desc, name desc limit 10)


-- 18. Задание:
-- Возьмите запрос, составленный на одном из прошлых уроков, и подтяните в него из таблицы users данные о поле пользователей 
-- таким образом, чтобы все пользователи из таблицы user_actions остались в результате. 
-- Затем посчитайте среднее значение cancel_rate для каждого пола, округлив его до трёх знаков после запятой. 
-- Колонку с посчитанным средним значением назовите avg_cancel_rate.
-- Помните про отсутствие информации о поле некоторых пользователей после join, так как не все пользователи из таблицы 
-- user_action есть в таблице users. Для этой группы тоже посчитайте cancel_rate и в результирующей таблице для пустого 
-- значения в колонке с полом укажите ‘unknown’ (без кавычек). Возможно, для этого придётся вспомнить, как работает COALESCE.
-- Результат отсортируйте по колонке с полом пользователя по возрастанию.
-- Поля в результирующей таблице: sex, avg_cancel_rate
SELECT coalesce(sex, 'unknown') as sex,
       round(avg(cancel_rate), 3) as avg_cancel_rate
FROM   (SELECT user_id,
               sex,
               count(distinct order_id) filter (WHERE action = 'cancel_order')::decimal / count(distinct order_id) as cancel_rate
        FROM   user_actions
            LEFT JOIN users using(user_id)
        GROUP BY user_id, sex
        ORDER BY cancel_rate desc) t
GROUP BY sex
ORDER BY sex

-- 19. Задание:
-- По таблицам orders и courier_actions определите id десяти заказов, которые доставляли дольше всего.
-- Поле в результирующей таблице: order_id
SELECT orders.order_id
FROM   orders join (SELECT time,
                           order_id
                    FROM   courier_actions
                    WHERE  action = 'deliver_order') as t1 using (order_id)
ORDER BY time - creation_time desc limit 10

-- 20. Задача:
-- Произведите замену списков с id товаров из таблицы orders на списки с наименованиями товаров. 
-- Наименования возьмите из таблицы products. Колонку с новыми списками наименований назовите product_names. 
-- Добавьте в запрос оператор LIMIT и выведите только первые 1000 строк результирующей таблицы.
-- Поля в результирующей таблице: order_id, product_names
SELECT order_id,
       array_agg(name) as product_names FROM(SELECT order_id,
                                             creation_time,
                                             unnest(product_ids) as product_id
                                      FROM   orders) as t1 join products using(product_id)
GROUP BY order_id limit 1000


-- 21. Задание:
-- Выясните, кто заказывал и доставлял самые большие заказы. Самыми большими считайте заказы с наибольшим числом товаров.
-- Выведите id заказа, id пользователя и id курьера. Также в отдельных колонках укажите возраст пользователя и возраст курьера. 
-- Возраст измерьте числом полных лет, как мы делали в прошлых уроках. Считайте его относительно 
-- последней даты в таблице user_actions — как для пользователей, так и для курьеров. 
-- Колонки с возрастом назовите user_age и courier_age. Результат отсортируйте по возрастанию id заказа.
-- Поля в результирующей таблице: order_id, user_id, user_age, courier_id, courier_age
with size as (SELECT order_id,
                     count(product_id) as size
              FROM   (SELECT order_id,
                             unnest(product_ids) as product_id
                      FROM   orders) as t1
              GROUP BY order_id)
SELECT DISTINCT(order_id),
                courier_id,
                user_id,
                date_part('year', age((SELECT max(time) FROM   user_actions), couriers.birth_date))::int as courier_age, 
                date_part('year', age((SELECT max(time) FROM   user_actions), users.birth_date))::int as user_age
FROM   (SELECT order_id,
               size
        FROM   size
        WHERE  size = (SELECT max(size)
                       FROM   size)) as big_orders
    LEFT JOIN courier_actions using (order_id)
    LEFT JOIN user_actions using (order_id)
    LEFT JOIN couriers using(courier_id)
    LEFT JOIN users using (user_id)
ORDER BY order_id

-- 22. Задание:
-- Выясните, какие пары товаров покупают вместе чаще всего.
-- Пары товаров сформируйте на основе таблицы с заказами. Отменённые заказы не учитывайте. 
-- В качестве результата выведите две колонки — колонку с парами наименований товаров и колонку со значениями, 
-- показывающими, сколько раз конкретная пара встретилась в заказах пользователей. 
-- Колонки назовите соответственно pair и count_pair.
-- Пары товаров должны быть представлены в виде списков из двух наименований. 
-- Пары товаров внутри списков должны быть отсортированы в порядке возрастания наименования. 
-- Результат отсортируйте сначала по убыванию частоты встречаемости пары товаров в заказах, затем по колонке pair — по возрастанию.
-- Поля в результирующей таблице: pair, count_pair
with unnested as (SELECT order_id,
                         creation_time,
                         unnest(product_ids) as product_id
                  FROM   orders
                  WHERE  order_id not in (SELECT order_id
                                          FROM   user_actions
                                          WHERE  action = 'cancel_order'))
SELECT products as pair,
       count(order_id) as count_pair FROM(SELECT order_id,
                                          array[first_name,
                                          name] as products
                                   FROM   (SELECT order_id,
                                                  name as first_name,
                                                  second
                                           FROM   (SELECT DISTINCT order_id,
                                                                   t2.product_id as first,
                                                                   t1.product_id as second
                                                   FROM   unnested as t1 join unnested as t2 using(order_id)
                                                   WHERE  t1.product_id > t2.product_id) as table1
                                               LEFT JOIN products
                                                   ON first = product_id) as first
                                       LEFT JOIN products
                                           ON second = product_id
                                   WHERE  first_name < name
                                   UNION
SELECT order_id,
                                          array[name,
                                          first_name] as products
                                   FROM   (SELECT order_id,
                                                  name as first_name,
                                                  second
                                           FROM   (SELECT DISTINCT order_id,
                                                                   t2.product_id as first,
                                                                   t1.product_id as second
                                                   FROM   unnested as t1 join unnested as t2 using(order_id)
                                                   WHERE  t1.product_id > t2.product_id) as table1
                                               LEFT JOIN products
                                                   ON first = product_id) as first
                                       LEFT JOIN products
                                           ON second = product_id
                                   WHERE  first_name > name) as res
GROUP BY products
ORDER BY count_pair desc, pair