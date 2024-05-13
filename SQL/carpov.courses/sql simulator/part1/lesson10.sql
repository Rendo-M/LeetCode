-- ОКОННЫЕ ФУНКЦИИ
-- 2. Задание:
-- Примените оконные функции к таблице products и с помощью ранжирующих функций упорядочьте все товары по цене — 
-- от самых дорогих к самым дешёвым. 
-- Добавьте в таблицу следующие колонки:
-- * Колонку product_number с порядковым номером товара (функция ROW_NUMBER).
-- * Колонку product_rank с рангом товара с пропусками рангов (функция RANK).
-- * Колонку product_dense_rank с рангом товара без пропусков рангов (функция DENSE_RANK).
-- Не забывайте указывать в окне сортировку записей — без неё ранжирующие функции могут давать некорректный результат, 
-- если таблица заранее не отсортирована. Деление на партиции внутри окна сейчас не требуется. 
-- Сортировать записи в результирующей таблице тоже не нужно.
-- Поля в результирующей таблице: product_id, name, price, product_number, product_rank, product_dense_rank
SELECT product_id,
       name,
       price,
       row_number() OVER (ORDER BY price desc) as product_number,
       rank() OVER (ORDER BY price desc) as product_rank,
       dense_rank() OVER (ORDER BY price desc) as product_dense_rank
FROM   products


-- 3. Задание:
-- Примените оконную функцию к таблице products и с помощью агрегирующей функции в отдельной колонке для каждой записи 
-- проставьте цену самого дорогого товара. Колонку с этим значением назовите max_price.
-- Затем для каждого товара посчитайте долю его цены в стоимости самого дорогого товара — просто поделите одну колонку на другую. 
-- Полученные доли округлите до двух знаков после запятой. Колонку с долями назовите share_of_max.
-- Выведите всю информацию о товарах, включая значения в новых колонках. 
-- Результат отсортируйте сначала по убыванию цены товара, затем по возрастанию id товара.
-- Поля в результирующей таблице: product_id, name, price, max_price, share_of_max
SELECT product_id,
       name,
       price,
       max(price) OVER () as max_price,
       round(price / max(price) OVER (), 2) as share_of_max
FROM   products
ORDER BY price desc, product_id

-- 4. Задание:
-- Примените две оконные функции к таблице products. Одну с агрегирующей функцией MAX, а другую с агрегирующей 
-- функцией MIN — для вычисления максимальной и минимальной цены. Для двух окон задайте инструкцию ORDER BY по убыванию цены. 
-- Поместите результат вычислений в две колонки max_price и min_price.
-- Выведите всю информацию о товарах, включая значения в новых колонках. Результат отсортируйте сначала по убыванию цены товара, 
-- затем по возрастанию id товара.
-- Поля в результирующей таблице: product_id, name, price, max_price, min_price
SELECT product_id,
       name,
       price,
       max(price) OVER (ORDER BY price desc) as max_price,
       min(price) OVER (ORDER BY price desc) as min_price
FROM   products
ORDER BY price desc, product_id


-- 5. Задание:
-- Сначала на основе таблицы orders сформируйте новую таблицу с общим числом заказов по дням. 
-- При подсчёте числа заказов не учитывайте отменённые заказы (их можно определить по таблице user_actions). 
-- Колонку с днями назовите date, а колонку с числом заказов — orders_count.
-- Затем поместите полученную таблицу в подзапрос и примените к ней оконную функцию в паре с агрегирующей функцией SUM 
-- для расчёта накопительной суммы числа заказов. Не забудьте для окна задать инструкцию ORDER BY по дате.
-- Колонку с накопительной суммой назовите orders_cum_count. В результате такой операции значение накопительной суммы 
-- для последнего дня должно получиться равным общему числу заказов за весь период.
-- Сортировку результирующей таблицы делать не нужно.
-- Поля в результирующей таблице: date, orders_count, orders_cum_count
SELECT date,
       orders_count,
       sum(orders_count) OVER(ORDER BY date) as orders_cum_count
FROM   (SELECT date_trunc('day', creation_time)::date as date,
               count(distinct order_id) as orders_count
        FROM   orders
        WHERE  order_id not in (SELECT order_id
                                FROM   user_actions
                                WHERE  action = 'cancel_order')
        GROUP BY date_trunc('day', creation_time)::date) as t

-- 6. Задание:
-- Для каждого пользователя в таблице user_actions посчитайте порядковый номер каждого заказа.
-- Для этого примените оконную функцию ROW_NUMBER к колонке с временем заказа. 
-- Не забудьте указать деление на партиции по пользователям и сортировку внутри партиций. Отменённые заказы не учитывайте.
-- Новую колонку с порядковым номером заказа назовите order_number. Результат отсортируйте сначала по возрастанию id пользователя, 
-- затем по возрастанию порядкового номера заказа.
-- Добавьте в запрос оператор LIMIT и выведите только первые 1000 строк результирующей таблицы.
-- Поля в результирующей таблице: user_id, order_id, time, order_number
SELECT user_id,
       time,
       order_id,
       row_number() OVER(PARTITION BY user_id
                         ORDER BY time) as order_number
FROM   user_actions
WHERE  order_id not in (SELECT order_id
                        FROM   user_actions
                        WHERE  action = 'cancel_order') limit 1000


-- 7. Задание:
-- Дополните запрос из предыдущего задания и с помощью оконной функции для каждого заказа каждого пользователя рассчитайте, 
-- сколько времени прошло с момента предыдущего заказа. 
-- Для этого сначала в отдельном столбце с помощью LAG сделайте смещение по столбцу time на одно значение назад. 
-- Столбец со смещёнными значениями назовите time_lag. Затем отнимите от каждого значения в колонке time новое значение со смещением 
-- (либо можете использовать уже знакомую функцию AGE). Колонку с полученным интервалом назовите time_diff. 
-- Менять формат отображения значений не нужно, они должны иметь примерно следующий вид:

-- 3 days, 12:18:22

-- По-прежнему не учитывайте отменённые заказы. Также оставьте в запросе порядковый номер каждого заказа, 
-- рассчитанный на прошлом шаге. Результат отсортируйте сначала по возрастанию id пользователя, 
-- затем по возрастанию порядкового номера заказа.
-- Добавьте в запрос оператор LIMIT и выведите только первые 1000 строк результирующей таблицы.
-- Поля в результирующей таблице: user_id, order_id, time, order_number, time_lag, time_diff
SELECT user_id,
       time,
       order_id,
       order_number,
       lag(time, 1) OVER (PARTITION BY user_id
                          ORDER BY time) as time_lag,
       (time - lag(time, 1) OVER (PARTITION BY user_id
                                  ORDER BY time)) as time_diff
FROM   (SELECT user_id,
               time,
               order_id,
               row_number() OVER(PARTITION BY user_id
                                 ORDER BY time) as order_number
        FROM   user_actions
        WHERE  order_id not in (SELECT order_id
                                FROM   user_actions
                                WHERE  action = 'cancel_order')) as t2 limit 1000


-- 8. Задание:
-- На основе запроса из предыдущего задания для каждого пользователя рассчитайте, сколько в среднем времени проходит 
-- между его заказами. Посчитайте этот показатель только для тех пользователей, которые за всё время оформили 
-- более одного неотмененного заказа.
-- Среднее время между заказами выразите в часах, округлив значения до целого числа. 
-- Колонку со средним значением времени назовите hours_between_orders. Результат отсортируйте по возрастанию id пользователя.
-- Добавьте в запрос оператор LIMIT и включите в результат только первые 1000 записей.
-- Поля в результирующей таблице: user_id, hours_between_orders
SELECT user_id,
       round(extract(epoch
FROM   avg(time_diff))/3600)::int as hours_between_orders
FROM   (SELECT user_id,
               order_id,
               time,
               time - lag(time, 1) OVER (PARTITION BY user_id
                                         ORDER BY time) as time_diff
        FROM   user_actions
        WHERE  order_id not in (SELECT order_id
                                FROM   user_actions
                                WHERE  action = 'cancel_order')) t
WHERE  time_diff is not null
GROUP BY user_id
ORDER BY user_id limit 1000


-- 9. Задание:
-- Сначала на основе таблицы orders сформируйте новую таблицу с общим числом заказов по дням. 
-- Вы уже делали это в одной из предыдущих задач. При подсчёте числа заказов не учитывайте отменённые заказы 
-- (их можно определить по таблице user_actions). Колонку с числом заказов назовите orders_count.
-- Затем поместите полученную таблицу в подзапрос и примените к ней оконную функцию в паре с агрегирующей 
-- функцией AVG для расчёта скользящего среднего числа заказов. Скользящее среднее для каждой записи считайте 
-- по трём предыдущим дням. Подумайте, как правильно задать границы рамки, чтобы получить корректные расчёты.
-- Полученные значения скользящего среднего округлите до двух знаков после запятой. Колонку с рассчитанным 
-- показателем назовите moving_avg. Сортировку результирующей таблицы делать не нужно.
-- Поля в результирующей таблице: date, orders_count, moving_avg
with count_orders as (SELECT date,
                             orders_count,
                             sum(orders_count) OVER(ORDER BY date) as orders_cum_count
                      FROM   (SELECT date_trunc('day', creation_time)::date as date,
                                     count(distinct order_id) as orders_count
                              FROM   orders
                              WHERE  order_id not in (SELECT order_id
                                                      FROM   user_actions
                                                      WHERE  action = 'cancel_order')
                              GROUP BY date_trunc('day', creation_time)::date) as t)
SELECT round(avg(orders_count) OVER (rows between 3 preceding and 1 preceding),
             2) as moving_avg,
       date,
       orders_count
FROM   count_orders


-- 10. Задание:
-- Отметьте в отдельной таблице тех курьеров, которые доставили в сентябре 2022 года заказов больше, чем в среднем все курьеры.
-- Сначала для каждого курьера в таблице courier_actions рассчитайте общее количество доставленных в сентябре заказов. 
-- Затем в отдельном столбце с помощью оконной функции укажите, сколько в среднем заказов доставили в этом месяце все курьеры. 
-- После этого сравните число заказов, доставленных каждым курьером, со средним значением в новом столбце. 
-- Если курьер доставил больше заказов, чем в среднем все курьеры, то в отдельном столбце с помощью CASE укажите число 1, 
-- в противном случае укажите 0.
-- Колонку с результатом сравнения назовите is_above_avg, 
-- колонку с числом доставленных заказов каждым курьером — delivered_orders, 
-- а колонку со средним значением — avg_delivered_orders. 
-- При расчёте среднего значения округлите его до двух знаков после запятой. Результат отсортируйте по возрастанию id курьера.
-- Поля в результирующей таблице: courier_id, delivered_orders, avg_delivered_orders, is_above_avg
with total_delivered as (SELECT courier_id,
                                count(distinct order_id) as delivered_orders
                         FROM   courier_actions
                         WHERE  (action = 'deliver_order')
                            and(extract(month
                         FROM   time) = 9)
                         GROUP BY courier_id)
SELECT courier_id,
       delivered_orders,
       round(avg(delivered_orders) OVER (), 2) as avg_delivered_orders,
       case when (avg(delivered_orders) OVER ()) >= delivered_orders then 0
            else 1 end as is_above_avg
FROM   total_delivered


-- 11. Задание:
-- По данным таблицы user_actions посчитайте число первых и повторных заказов на каждую дату.
-- Для этого сначала с помощью оконных функций и оператора CASE сформируйте таблицу, в которой напротив каждого заказа будет 
-- стоять отметка «Первый» или «Повторный» (без кавычек). Для каждого пользователя первым заказом будет тот, который был сделан 
-- раньше всего. Все остальные заказы должны попасть, соответственно, в категорию «Повторный». 
-- Затем на каждую дату посчитайте число заказов каждой категории.
-- Колонку с типом заказа назовите order_type, колонку с датой — date, колонку с числом заказов — orders_count.
-- В расчётах учитывайте только неотменённые заказы.
-- Результат отсортируйте сначала по возрастанию даты, затем по возрастанию значений в колонке с типом заказа.
-- Поля в результирующей таблице: date, order_type, orders_count
with order_cte as(SELECT time::date as date,
                         user_id,
                         rank() OVER(PARTITION BY user_id
                                     ORDER BY time) as num
                  FROM   user_actions
                  WHERE  order_id not in (SELECT order_id
                                          FROM   user_actions
                                          WHERE  action = 'cancel_order'))
SELECT *
FROM   (SELECT date,
               count(num) filter(WHERE num = 1) as orders_count,
               'Первый' as order_type
        FROM   order_cte
        GROUP BY date
        UNION
SELECT date,
               count(num) filter(WHERE num > 1) as orders_count,
               'Повторный' as order_type
        FROM   order_cte
        GROUP BY date) as foo
ORDER BY date, order_type
-- и классическое решение:
with order_cte as (SELECT time::date as date,
                          user_id,
                          case when min(time) OVER(PARTITION BY user_id) = time then 'Первый'
                               else 'Повторный' end as order_type
                   FROM   user_actions
                   WHERE  order_id not in (SELECT order_id
                                           FROM   user_actions
                                           WHERE  action = 'cancel_order'))
SELECT date,
       order_type,
       count(user_id) as orders_count
FROM   order_cte
GROUP BY date, order_type
ORDER BY date, order_type


-- 12. Задание:
-- К запросу, полученному на предыдущем шаге, примените оконную функцию и для каждого дня посчитайте долю первых и повторных заказов. 
-- Сохраните структуру полученной ранее таблицы и добавьте только одну новую колонку с посчитанными значениями.
-- Колонку с долей заказов каждой категории назовите orders_share. Значения в полученном столбце округлите до двух знаков 
-- после запятой. В результат также включите количество заказов в группах, посчитанное на предыдущем шаге.
-- В расчётах по-прежнему учитывайте только неотменённые заказы.
-- Результат отсортируйте сначала по возрастанию даты, затем по возрастанию значений в колонке с типом заказа.
-- Поля в результирующей таблице: date, order_type, orders_count, orders_share
with order_cte as (SELECT time::date as date,
                          user_id,
                          case when min(time) OVER(PARTITION BY user_id) = time then 'Первый'
                               else 'Повторный' end as order_type
                   FROM   user_actions
                   WHERE  order_id not in (SELECT order_id
                                           FROM   user_actions
                                           WHERE  action = 'cancel_order'))
SELECT date,
       order_type,
       orders_count,
       case when order_type = 'Первый' then round(orders_count::numeric/(orders_count+lead(orders_count)OVER(ORDER BY date, order_type)),
                                                  2)
            else round(orders_count::numeric/(orders_count+lag(orders_count)OVER(ORDER BY date, order_type)),
                       2) end as orders_share
FROM   (SELECT date,
               order_type,
               count(user_id) as orders_count
        FROM   order_cte
        GROUP BY date, order_type
        ORDER BY date, order_type) as foo 



-- 13. Задание:
-- Примените оконную функцию к таблице products и с помощью агрегирующей функции в отдельной колонке для каждой записи 
-- проставьте среднюю цену всех товаров. Колонку с этим значением назовите avg_price.
-- Затем с помощью оконной функции и оператора FILTER в отдельной колонке рассчитайте среднюю цену товаров без учёта самого дорогого. 
-- Колонку с этим средним значением назовите avg_price_filtered. 
-- Полученные средние значения в колонках avg_price и avg_price_filtered округлите до двух знаков после запятой.
-- Выведите всю информацию о товарах, включая значения в новых колонках. 
-- Результат отсортируйте сначала по убыванию цены товара, затем по возрастанию id товара.
-- Поля в результирующей таблице: product_id, name, price, avg_price, avg_price_filtered        
SELECT product_id,
       name,
       price,
       round(avg(price) OVER (), 2) as avg_price,
       round(avg(price) filter(WHERE price < (SELECT max(price)
                                       FROM   products))
OVER(), 2) as avg_price_filtered
FROM   products
ORDER BY price desc, product_id


-- 14. Задание:
-- Для каждой записи в таблице user_actions с помощью оконных функций и предложения FILTER посчитайте, 
-- сколько заказов сделал и сколько отменил каждый пользователь на момент совершения нового действия.
-- Иными словами, для каждого пользователя в каждый момент времени посчитайте две накопительные суммы — 
-- числа оформленных и числа отменённых заказов. Если пользователь оформляет заказ, то число оформленных 
-- им заказов увеличивайте на 1, если отменяет — увеличивайте на 1 количество отмен.
-- Колонки с накопительными суммами числа оформленных и отменённых заказов назовите соответственно created_orders 
-- и canceled_orders. На основе этих двух колонок для каждой записи пользователя посчитайте показатель cancel_rate, 
-- т.е. долю отменённых заказов в общем количестве оформленных заказов. Значения показателя округлите до двух знаков 
-- после запятой. Колонку с ним назовите cancel_rate.
-- В результате у вас должны получиться три новые колонки с динамическими показателями, 
-- которые изменяются во времени с каждым новым действием пользователя.
-- В результирующей таблице отразите все колонки из исходной таблицы вместе с новыми колонками. 
-- Отсортируйте результат по колонкам user_id, order_id, time — по возрастанию значений в каждой.
-- Добавьте в запрос оператор LIMIT и выведите только первые 1000 строк результирующей таблицы.
-- Поля в результирующей таблице:
-- user_id, order_id, action, time, created_orders, canceled_orders, cancel_rate
SELECT user_id,
       order_id,
       action,
       time,
       created_orders,
       canceled_orders,
       round(canceled_orders::decimal / created_orders, 2) as cancel_rate
FROM   (SELECT user_id,
               order_id,
               action,
               time,
               count(order_id) filter (WHERE action != 'cancel_order') OVER (PARTITION BY user_id
                                                                             ORDER BY time) as created_orders,
               count(order_id) filter (WHERE action = 'cancel_order') OVER (PARTITION BY user_id
                                                                            ORDER BY time) as canceled_orders
        FROM   user_actions) t
ORDER BY user_id, order_id, time 
limit 1000


-- 15. Задание:
-- Из таблицы courier_actions отберите топ 10% курьеров по количеству доставленных за всё время заказов. 
-- Выведите id курьеров, количество доставленных заказов и порядковый номер курьера в соответствии с числом доставленных заказов.
-- У курьера, доставившего наибольшее число заказов, порядковый номер должен быть равен 1, 
-- а у курьера с наименьшим числом заказов — числу, равному десяти процентам от общего количества курьеров в таблице courier_actions.
-- При расчёте номера последнего курьера округляйте значение до целого числа.
-- Колонки с количеством доставленных заказов и порядковым номером назовите соответственно orders_count и courier_rank. 
-- Результат отсортируйте по возрастанию порядкового номера курьера.
-- Поля в результирующей таблице: courier_id, orders_count, courier_rank 
SELECT courier_id,
       rank as courier_rank,
       total as orders_count
FROM   (SELECT courier_id,
               total,
               rank() OVER (ORDER BY total desc, courier_id) as rank
        FROM   (SELECT courier_id,
                       count(action) as total
                FROM   courier_actions
                WHERE  (action = 'deliver_order')
                GROUP BY courier_id
                ORDER BY total desc) as t) as t2
WHERE  rank <= (SELECT round(count(distinct courier_id)::numeric/10)
                FROM   courier_actions)

-- 16. Задание:
-- С помощью оконной функции отберите из таблицы courier_actions всех курьеров, которые работают в нашей компании 10 и более дней. 
-- Также рассчитайте, сколько заказов они уже успели доставить за всё время работы.
-- Будем считать, что наш сервис предлагает самые выгодные условия труда и поэтому за весь анализируемый период 
-- ни один курьер не уволился из компании. Возможные перерывы между сменами не учитывайте — для нас важна только 
-- разница во времени между первым действием курьера и текущей отметкой времени.
-- Текущей отметкой времени, относительно которой необходимо рассчитывать продолжительность работы курьера, 
-- считайте время последнего действия в таблице courier_actions. Учитывайте только целые дни, прошедшие с момента 
-- первого выхода курьера на работу (часы и минуты не учитывайте).
-- В результат включите три колонки: id курьера, продолжительность работы в днях и число доставленных заказов. 
-- Две новые колонки назовите соответственно days_employed и delivered_orders. Результат отсортируйте сначала по 
-- убыванию количества отработанных дней, затем по возрастанию id курьера.
-- Поля в результирующей таблице: courier_id, days_employed, delivered_orders            
SELECT courier_id,
       delivered_orders,
       date_part::int as days_employed
FROM   (SELECT courier_id,
               date_part('day', (SELECT max(time)
                          FROM   courier_actions) - min(time))
        FROM   courier_actions
        WHERE  action = 'accept_order'
        GROUP BY courier_id) as t2 join (SELECT courier_id,
                                        count(order_id) delivered_orders
                                 FROM   courier_actions
                                 WHERE  action = 'deliver_order'
                                 GROUP BY courier_id) as t1 using (courier_id)
WHERE  date_part >= 10
ORDER BY days_employed desc, courier_id


-- 17. Задание:
-- На основе информации в таблицах orders и products рассчитайте стоимость каждого заказа, ежедневную выручку сервиса 
-- и долю стоимости каждого заказа в ежедневной выручке, выраженную в процентах. В результат включите следующие колонки: 
-- id заказа, время создания заказа, стоимость заказа, выручку за день, 
-- в который был совершён заказ, а также долю стоимости заказа в выручке за день, выраженную в процентах.
-- При расчёте долей округляйте их до трёх знаков после запятой.
-- Результат отсортируйте сначала по убыванию даты совершения заказа (именно даты, а не времени), 
-- потом по убыванию доли заказа в выручке за день, затем по возрастанию id заказа.
-- При проведении расчётов отменённые заказы не учитывайте.
-- Поля в результирующей таблице:
-- order_id, creation_time, order_price, daily_revenue, percentage_of_daily_revenue
SELECT order_id,
       order_price,
       creation_time,
       daily_revenue,
       round(order_price * 100.0 / daily_revenue, 3) as percentage_of_daily_revenue
FROM   (SELECT order_id,
               order_price,
               creation_time,
               sum(order_price) OVER (PARTITION BY date_trunc('day', creation_time)) as daily_revenue
        FROM   (SELECT order_id,
                       sum(price) as order_price
                FROM   (SELECT unnest(product_ids) as product_id,
                               order_id,
                               creation_time
                        FROM   orders
                        WHERE  order_id not in (SELECT order_id
                                                FROM   user_actions
                                                WHERE  action = 'cancel_order')) as t1
                    LEFT JOIN products using(product_id)
                GROUP BY order_id) as t2
            LEFT JOIN orders using (order_id)) as t3
ORDER BY date_trunc('day', creation_time) desc, round(order_price * 100.0 / daily_revenue, 3) desc, order_id


-- 18. Задание:
-- На основе информации в таблицах orders и products рассчитайте ежедневную выручку сервиса и отразите её в колонке daily_revenue. 
-- Затем с помощью оконных функций и функций смещения посчитайте ежедневный прирост выручки. 
-- Прирост выручки отразите как в абсолютных значениях, так и в % относительно предыдущего дня. 
-- Колонку с абсолютным приростом назовите revenue_growth_abs, а колонку с относительным — revenue_growth_percentage.
-- Для самого первого дня укажите прирост равным 0 в обеих колонках. При проведении расчётов отменённые заказы не учитывайте. 
-- Результат отсортируйте по колонке с датами по возрастанию.
-- Метрики daily_revenue, revenue_growth_abs, revenue_growth_percentage округлите до одного знака при помощи ROUND().
-- Поля в результирующей таблице: date, daily_revenue, revenue_growth_abs, revenue_growth_percentage
SELECT date,
       daily_revenue,
       coalesce(daily_revenue - lag(daily_revenue, 1) OVER (ORDER BY date),
                0) as revenue_growth_abs,
       round(coalesce(100.0 * daily_revenue / lag(daily_revenue, 1) OVER (ORDER BY date) - 100, 0),
             1) as revenue_growth_percentage
FROM   (SELECT creation_time:: date as date,
               sum(order_price) as daily_revenue
        FROM   (SELECT order_id,
                       sum(price) as order_price
                FROM   (SELECT unnest(product_ids) as product_id,
                               order_id,
                               creation_time
                        FROM   orders
                        WHERE  order_id not in (SELECT order_id
                                                FROM   user_actions
                                                WHERE  action = 'cancel_order')) as t1
                    LEFT JOIN products using(product_id)
                GROUP BY order_id) as t2
            LEFT JOIN orders using (order_id)
        GROUP BY creation_time:: date) as t3
ORDER BY date


-- 19. Задание:
-- С помощью оконной функции рассчитайте медианную стоимость всех заказов из таблицы orders, оформленных в нашем сервисе. 
-- В качестве результата выведите одно число. 
-- Колонку с ним назовите median_price. Отменённые заказы не учитывайте.
-- Поле в результирующей таблице: median_price
WITH main_table AS (
  SELECT
    order_price,
    ROW_NUMBER() OVER (
      ORDER BY
        order_price
    ) AS row_number,
    COUNT(*) OVER() AS total_rows
  FROM
    (
      SELECT
        SUM(price) AS order_price
      FROM
        (
          SELECT
            order_id,
            product_ids,
            UNNEST(product_ids) AS product_id
          FROM
            orders
          WHERE
            order_id NOT IN (
              SELECT
                order_id
              FROM
                user_actions
              WHERE
                action = 'cancel_order'
            )
        ) t3
        LEFT JOIN products USING(product_id)
      GROUP BY
        order_id
    ) t1
)
SELECT
  AVG(order_price) AS median_price
FROM
  main_table
WHERE
  row_number BETWEEN total_rows / 2.0
  AND total_rows / 2.0 + 1