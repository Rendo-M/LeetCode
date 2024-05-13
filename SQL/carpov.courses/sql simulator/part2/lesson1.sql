-- -- Задача 1.
-- -- Для начала давайте проанализируем, насколько быстро растёт аудитория нашего сервиса, и посмотрим на динамику 
-- -- числа пользователей и курьеров. 
-- -- Задание:
-- -- Для каждого дня, представленного в таблицах user_actions и courier_actions, рассчитайте следующие показатели:
-- -- 1. Число новых пользователей.
-- -- 2. Число новых курьеров.
-- -- 3. Общее число пользователей на текущий день.
-- -- 4. Общее число курьеров на текущий день.
-- -- Колонки с показателями назовите соответственно new_users, new_couriers, total_users, total_couriers. 
-- -- Колонку с датами назовите date. Проследите за тем, чтобы показатели были выражены целыми числами. 
-- -- Результат должен быть отсортирован по возрастанию даты.
-- -- Поля в результирующей таблице: date, new_users, new_couriers, total_users, total_couriers

-- Проанализируйте построенные графики и попробуйте ответить на следующие вопросы:
-- 1. Что растёт быстрее: количество пользователей или количество курьеров?
-- 2. Насколько стабильны показатели числа новых пользователей и курьеров? 
-- 2a. Нет ли в данных таких дней, когда показатели сильно выбивались из общей динамики?
-- 3. Можно ли сказать, что показатель числа новых курьеров более стабилен, чем показатель числа новых пользователей?
with sub_couriers as(SELECT data,
                            new_couriers,
                            sum(new_couriers) OVER (rows between unbounded preceding and current row) as total_couriers
                     FROM   (SELECT data,
                                    count(courier_id) as new_couriers
                             FROM   (SELECT DISTINCT ON(courier_id) courier_id,
                                                     data
                                     FROM   (SELECT courier_id,
                                                    date_trunc('day', time) as data
                                             FROM   courier_actions) as q1
                                     ORDER BY courier_id, data) as sub1
                            GROUP BY data
                            ORDER BY data) as t1), 

    sub_users as(SELECT data,
                        new_users,
                        sum(new_users) OVER (rows between unbounded preceding and current row) as total_users
                FROM   (SELECT  data,
                                count(user_id) as new_users
                        FROM   (SELECT  DISTINCT ON(user_id) user_id,
                                        data
                                FROM   (SELECT  user_id,
                                                date_trunc('day', time) as data
                                        FROM   user_actions) as q1
                                        ORDER BY user_id, data) as sub2
                        GROUP BY data
                        ORDER BY data) as t2)
SELECT (data::date) as date,
       new_users,
       new_couriers,
       (total_users::integer) as total_users,
       (total_couriers::integer) as total_couriers
FROM   sub_users 
JOIN sub_couriers 
USING(data)

-- another version
SELECT start_date as date,
       new_users,
       new_couriers,
       (sum(new_users) OVER (ORDER BY start_date))::int as total_users,
       (sum(new_couriers) OVER (ORDER BY start_date))::int as total_couriers
FROM   (SELECT start_date,
               count(courier_id) as new_couriers
        FROM   (SELECT courier_id,
                       min(time::date) as start_date
                FROM   courier_actions
                GROUP BY courier_id) t1
        GROUP BY start_date) t2
    LEFT JOIN (SELECT start_date,
                      count(user_id) as new_users
               FROM   (SELECT user_id,
                              min(time::date) as start_date
                       FROM   user_actions
                       GROUP BY user_id) t3
               GROUP BY start_date) t4 using (start_date)


-- Задача 2.
-- Анализируя динамику показателей из предыдущего задания, вы могли заметить, что сравнивать абсолютные значения не очень удобно. 
-- Давайте посчитаем динамику показателей в относительных величинах.
-- Задание
-- Дополните запрос из предыдущего задания и теперь для каждого дня, представленного в таблицах user_actions и courier_actions, 
-- дополнительно рассчитайте следующие показатели:
-- Прирост числа новых пользователей.
-- Прирост числа новых курьеров.
-- Прирост общего числа пользователей.
-- Прирост общего числа курьеров.
-- Показатели, рассчитанные на предыдущем шаге, также включите в результирующую таблицу.
-- Колонки с новыми показателями назовите соответственно new_users_change, new_couriers_change, total_users_growth, 
-- total_couriers_growth. Колонку с датами назовите date.
-- Все показатели прироста считайте в процентах относительно значений в предыдущий день. 
-- При расчёте показателей округляйте значения до двух знаков после запятой.
-- Результирующая таблица должна быть отсортирована по возрастанию даты.
-- Поля в результирующей таблице: 
-- date, new_users, new_couriers, total_users, total_couriers, 
-- new_users_change, new_couriers_change, total_users_growth, total_couriers_growth

-- Проанализируйте построенные графики и попробуйте ответить на следующие вопросы:
-- 1. Как изменились темпы прироста общего числа пользователей и курьеров за рассматриваемый промежуток времени? 
-- Какая в целом динамика у этих показателей: они растут или, наоборот, затухают?
-- 2. В какие дни темп прироста числа новых курьеров заметно опережал темп прироста числа новых пользователей?
-- 3. Можно ли, глядя на графики с относительными показателями, сказать, что показатель числа новых курьеров более стабилен, 
-- чем показатель числа новых пользователей?
with sub_couriers as(SELECT data,
                            new_couriers,
                            sum(new_couriers) OVER (rows between unbounded preceding and current row) as total_couriers
                     FROM   (SELECT data,
                                    count(courier_id) as new_couriers
                             FROM   (SELECT DISTINCT ON(courier_id) courier_id,
                                                     data
                                     FROM   (SELECT courier_id,
                                                    date_trunc('day', time) as data
                                             FROM   courier_actions) as q1
                                     ORDER BY courier_id, data) as sub1
                             GROUP BY data
                             ORDER BY data) as t1), 
    sub_users as(SELECT data,
                        new_users,
                        sum(new_users) OVER (rows between unbounded preceding and current row) as total_users
                FROM   (SELECT  data,
                                count(user_id) as new_users
                        FROM   (SELECT DISTINCT ON(user_id) user_id,
                                        data
                                FROM   (SELECT  user_id,
                                                date_trunc('day', time) as data
                                        FROM   user_actions) as q1
                                        ORDER BY user_id, data) as sub2
                        GROUP BY data
                        ORDER BY data) as t2)
SELECT data::date as date,
       new_users,
       new_couriers,
       (total_users::integer) as total_users,
       (total_couriers::integer) as total_couriers,
       round((100 * new_users::decimal) / lag(new_users) OVER () -100,
             2) as new_users_change,
       round((100 * new_couriers::decimal) / lag(new_couriers) OVER () -100,
             2) as new_couriers_change,
       round((100 * new_users::decimal) / lag(total_users) OVER (),
             2) as total_users_growth,
       round((100 * new_couriers::decimal) / lag(total_couriers) OVER (),
             2) as total_couriers_growth
FROM   sub_users join sub_couriers using(data)
-- another variant
SELECT date,
       new_users,
       new_couriers,
       total_users,
       total_couriers,
       round(100 * (new_users - lag(new_users, 1) OVER (ORDER BY date)) / lag(new_users, 1) OVER (ORDER BY date)::decimal,
             2) as new_users_change,
       round(100 * (new_couriers - lag(new_couriers, 1) OVER (ORDER BY date)) / lag(new_couriers, 1) OVER (ORDER BY date)::decimal,
             2) as new_couriers_change,
       round(100 * new_users::decimal / lag(total_users, 1) OVER (ORDER BY date),
             2) as total_users_growth,
       round(100 * new_couriers::decimal / lag(total_couriers, 1) OVER (ORDER BY date),
             2) as total_couriers_growth
FROM   (SELECT start_date as date,
               new_users,
               new_couriers,
               (sum(new_users) OVER (ORDER BY start_date))::int as total_users,
               (sum(new_couriers) OVER (ORDER BY start_date))::int as total_couriers
        FROM   (SELECT start_date,
                       count(courier_id) as new_couriers
                FROM   (SELECT courier_id,
                               min(time::date) as start_date
                        FROM   courier_actions
                        GROUP BY courier_id) t1
                GROUP BY start_date) t2
            LEFT JOIN (SELECT start_date,
                              count(user_id) as new_users
                       FROM   (SELECT user_id,
                                      min(time::date) as start_date
                               FROM   user_actions
                               GROUP BY user_id) t3
                       GROUP BY start_date) t4 using (start_date)) t5


-- Задача 3.
-- Теперь предлагаем вам посмотреть на нашу аудиторию немного под другим углом — давайте посчитаем не просто всех пользователей, 
-- а именно ту часть, которая оформляет и оплачивает заказы в нашем сервисе. 
-- Заодно выясним, какую долю платящие пользователи составляют от их общего числа.
-- Задание:
-- Для каждого дня, представленного в таблицах user_actions и courier_actions, рассчитайте следующие показатели:
-- Число платящих пользователей.
-- Число активных курьеров.
-- Долю платящих пользователей в общем числе пользователей на текущий день.
-- Долю активных курьеров в общем числе курьеров на текущий день.
-- Колонки с показателями назовите соответственно paying_users, active_couriers, paying_users_share, active_couriers_share. 
-- Колонку с датами назовите date. Проследите за тем, чтобы абсолютные показатели были выражены целыми числами. 
-- Все показатели долей необходимо выразить в процентах. При их расчёте округляйте значения до двух знаков после запятой.
-- Результат должен быть отсортирован по возрастанию даты. 
-- Поля в результирующей таблице: date, paying_users, active_couriers, paying_users_share, active_couriers_share

-- Проанализируйте построенные графики и попробуйте ответить на следующие вопросы:
-- 1. Можно ли сказать, что вместе с общим числом пользователей и курьеров растёт число платящих пользователей и активных курьеров?
-- 2. Как в то же время ведут себя показатели долей платящих пользователей и активных курьеров? 
-- Можно ли считать их текущую динамику в целом нормальной и закономерной?
with p_users as (SELECT count(distinct paying_users) as paying_users,
                        date
                 FROM   (SELECT user_id as paying_users,
                                time::date as date
                         FROM   user_actions
                         WHERE  order_id not in (SELECT order_id
                                                 FROM   user_actions
                                                 WHERE  action = 'cancel_order')) as t1
                 GROUP BY date), 
    a_couriers as   (SELECT   count(distinct active_couriers) as active_couriers,
                            date
                    FROM   (SELECT courier_id as active_couriers,
                                              time::date as date
                            FROM   courier_actions
                            WHERE  order_id in (SELECT order_id
                                                FROM   courier_actions
                                                WHERE  action = 'deliver_order')) as t1
                    GROUP BY date), 
    total as    (SELECT   start_date as date,
                          new_users,
                          new_couriers,
                          (sum(new_users) OVER (ORDER BY start_date))::int as total_users,
                          (sum(new_couriers) OVER (ORDER BY start_date))::int as total_couriers
                FROM   (SELECT  start_date,
                                count(courier_id) as new_couriers
                        FROM   (SELECT  courier_id,
                                        min(time::date) as start_date
                                FROM   courier_actions
                                GROUP BY courier_id) t1
                        GROUP BY start_date) t2
                LEFT JOIN   (SELECT   start_date,
                                    count(user_id) as new_users
                            FROM   (SELECT  user_id,
                                            min(time::date) as start_date
                                    FROM   user_actions
                                    GROUP BY user_id) t3
                            GROUP BY start_date) t4 
                USING (start_date))

SELECT date,
       active_couriers,
       paying_users,
       round(100 * active_couriers::decimal/total_couriers, 2) as active_couriers_share,
       round(100 * paying_users::decimal/total_users, 2) as paying_users_share
FROM   a_couriers join p_users using (date) join total using(date)


-- Задача 4.
-- Давайте подробнее остановимся на платящих пользователях, копнём немного глубже и выясним, 
-- как много платящих пользователей совершают более одного заказа в день. В конце концов нам важно понимать, 
-- как в большинстве своём ведут себя наши пользователи — они заходят в приложение, чтобы сделать всего один заказ, 
-- или же наш сервис настолько хорош, что они готовы пользоваться им несколько раз в день.
-- Задание:
-- Для каждого дня, представленного в таблице user_actions, рассчитайте следующие показатели:
-- Долю пользователей, сделавших в этот день всего один заказ, в общем количестве платящих пользователей.
-- Долю пользователей, сделавших в этот день несколько заказов, в общем количестве платящих пользователей.
-- Колонки с показателями назовите соответственно single_order_users_share, several_orders_users_share. 
-- Колонку с датами назовите date. Все показатели с долями необходимо выразить в процентах. 
-- При расчёте долей округляйте значения до двух знаков после запятой.
-- Результат должен быть отсортирован по возрастанию даты.
-- Поля в результирующей таблице: date, single_order_users_share, several_orders_users_share
with marking_cte as (SELECT time::date,
                            user_id,
                            case when count(order_id) = 1 then 'once'
                                 else 'two' end as answer
                     FROM   user_actions
                     WHERE  order_id not in (SELECT order_id
                                             FROM   user_actions
                                             WHERE  action = 'cancel_order')
                     GROUP BY 1, 2
                     ORDER BY 1)
SELECT time as date,
       round(count(answer) filter (WHERE answer = 'once')*100.0/count(answer),
             2) as single_order_users_share,
       round(count(answer) filter (WHERE answer = 'two')*100.0/count(answer),
             2) as several_orders_users_share
FROM   marking_cte
GROUP BY time


-- * Задача 5.
-- Продолжим изучать наш сервис и рассчитаем несколько показателей, связанных с заказами.
-- Задание:
-- Для каждого дня, представленного в таблице user_actions, рассчитайте следующие показатели:
-- Общее число заказов.
-- Число первых заказов (заказов, сделанных пользователями впервые).
-- Число заказов новых пользователей (заказов, сделанных пользователями в тот же день, когда они впервые воспользовались сервисом).
-- Долю первых заказов в общем числе заказов (долю п.2 в п.1).
-- Долю заказов новых пользователей в общем числе заказов (долю п.3 в п.1).
-- Колонки с показателями назовите соответственно orders, first_orders, new_users_orders, first_orders_share, new_users_orders_share.
-- Колонку с датами назовите date. Проследите за тем, чтобы во всех случаях количество заказов было выражено целым числом. 
-- Все показатели с долями необходимо выразить в процентах. При расчёте долей округляйте значения до двух знаков после запятой.
-- Результат должен быть отсортирован по возрастанию даты.
-- Поля в результирующей таблице: date, orders, first_orders, new_users_orders, first_orders_share, new_users_orders_share

-- Проанализируйте построенные графики и попробуйте ответить на следующие вопросы:
-- 1. Какая в целом динамика у абсолютных показателей? Можно ли сказать, что вместе с ростом количества всех заказов растут 
-- показатели числа первых заказов и числа заказов новых пользователей?
-- 2. Что можно сказать о динамике относительных показателей? Можно ли считать её в целом закономерной? 
-- Как, на ваш взгляд, будут вести себя эти показатели в долгосрочной перспективе: они будут расти или снижаться?
WITH order_type_cte as (SELECT time::date, 
                                COUNT(user_id) as orders,
                                COUNT(user_id) FILTER (WHERE(time::date, user_id) in (SELECT    min(time::date), 
                                                                                                 user_id 
                                                                                        FROM user_actions
                                                                    
                                                                                        GROUP BY 2)) as new_users_orders,
                                COUNT(user_id) FILTER   (WHERE (time, user_id) in   (SELECT min(time), user_id 
                                                                                    FROM user_actions 
                                                                                    WHERE order_id not in  (SELECT order_id FROM user_actions WHERE action='cancel_order' )
                                                                                    GROUP BY user_id)
                                                                                    ) as first_orders                            
                        FROM user_actions
                        WHERE order_id not in (SELECT order_id FROM user_actions WHERE action='cancel_order')
                        GROUP BY 1
                        ORDER BY 1)

SELECT  time as date, 
        orders, 
        first_orders, 
        new_users_orders, 
        round(first_orders*100.0/orders, 2) as first_orders_share, 
        round(new_users_orders*100.0/orders, 2) as new_users_orders_share       
FROM order_type_cte


-- Задача 6.
-- Теперь давайте попробуем примерно оценить нагрузку на наших курьеров и узнаем, сколько в среднем заказов и 
-- пользователей приходится на каждого из них.
-- Задание:
-- На основе данных в таблицах user_actions, courier_actions и orders для каждого дня рассчитайте следующие показатели:
-- 1. Число платящих пользователей на одного активного курьера.
-- 2. Число заказов на одного активного курьера.
-- Колонки с показателями назовите соответственно users_per_courier и orders_per_courier. 
-- Колонку с датами назовите date. При расчёте показателей округляйте значения до двух знаков после запятой.
-- Результирующая таблица должна быть отсортирована по возрастанию даты.
-- Поля в результирующей таблице: date, users_per_courier, orders_per_courier
WITH 
active_courier_cte AS (SELECT       time::date, 
                                    count(DISTINCT courier_id) as couriers, 
                                    count(order_id) FILTER(WHERE action='accept_order') as orders, 
                                    ROUND((count(order_id) FILTER(WHERE action='accept_order'))::NUMERIC/count(DISTINCT courier_id), 2) as orders_per_courier
                            FROM courier_actions
                            WHERE order_id not in (SELECT order_id FROM user_actions WHERE action='cancel_order')
                            GROUP BY 1),

active_users_cte as (SELECT time::date, 
                            COUNT(DISTINCT user_id) as users
                    FROM user_actions
                    WHERE order_id not in (SELECT order_id FROM user_actions WHERE action='cancel_order')
                    GROUP BY 1
                    ORDER BY 1)
                
SELECT  time as date, 
        orders_per_courier, 
        ROUND(users::NUMERIC/couriers,2) as users_per_courier
FROM active_courier_cte
JOIN active_users_cte
USING(time)


-- Задача 7.
-- Давайте рассчитаем ещё один полезный показатель, характеризующий качество работы курьеров.
-- Задание:
-- На основе данных в таблице courier_actions для каждого дня рассчитайте, за сколько минут в среднем курьеры доставляли свои заказы.
-- Колонку с показателем назовите minutes_to_deliver. Колонку с датами назовите date. 
-- При расчёте среднего времени доставки округляйте количество минут до целых значений. 
-- Учитывайте только доставленные заказы, отменённые заказы не учитывайте.
-- Результирующая таблица должна быть отсортирована по возрастанию даты.
-- Поля в результирующей таблице: date, minutes_to_deliver
WITH 
accept_cte as   (SELECT time as accept, order_id
                FROM courier_actions as a1
                WHERE(action='accept_order')and order_id not in (SELECT order_id
                                                                FROM   user_actions
                                                                WHERE  action = 'cancel_order')),
deliver_cte as (SELECT order_id, time as deliver 
                FROM courier_actions 
                WHERE (action='deliver_order') and order_id not in (SELECT order_id
                                                                    FROM   user_actions
                                                                    WHERE  action = 'cancel_order'))

SELECT accept::date as date, ROUND(SUM(EXTRACT(epoch FROM deliver-accept)/60)/COUNT(order_id))::int as minutes_to_deliver
FROM accept_cte
JOIN deliver_cte
USING(order_id)
GROUP BY 1
ORDER BY date


-- Задача 8.
-- И наконец, давайте оценим почасовую нагрузку на наш сервис, выясним, в какие часы пользователи оформляют больше всего заказов, 
-- и заодно проанализируем, как изменяется доля отмен в зависимости от времени оформления заказа.
-- Задача:
-- На основе данных в таблице orders для каждого часа в сутках рассчитайте следующие показатели:
-- 1. Число успешных (доставленных) заказов.
-- 2. Число отменённых заказов.
-- 3. Долю отменённых заказов в общем числе заказов (cancel rate).
-- Колонки с показателями назовите соответственно successful_orders, canceled_orders, cancel_rate. 
-- Колонку с часом оформления заказа назовите hour. При расчёте доли отменённых заказов округляйте значения 
-- до трёх знаков после запятой.
-- Результирующая таблица должна быть отсортирована по возрастанию колонки с часом оформления заказа.
-- Поля в результирующей таблице: hour, successful_orders, canceled_orders, cancel_rate
SELECT  DATE_PART('hour',creation_time)::int as hour, 
        count(order_id) FILTER (WHERE order_id not in   (SELECT order_id 
                                                        FROM user_actions 
                                                        WHERE action='cancel_order')) as successful_orders,
        count(order_id) FILTER (WHERE order_id in   (SELECT order_id 
                                                    FROM user_actions 
                                                    WHERE action='cancel_order')) as canceled_orders,
        ROUND(  count(order_id) FILTER (WHERE order_id in   (SELECT order_id 
                                                            FROM user_actions 
                                                            WHERE action='cancel_order'))::DECIMAL
                /count(order_id), 3) as cancel_rate
FROM orders
GROUP BY 1