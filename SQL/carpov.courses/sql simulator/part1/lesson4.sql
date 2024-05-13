-- ФИЛЬТРАЦИЯ ДАННЫХ
-- 1. Задание:
-- Напишите SQL-запрос к таблице products и выведите всю информацию о товарах, цена которых не превышает 100 рублей. 
-- Результат отсортируйте по возрастанию id товара.
-- Поля в результирующей таблице: product_id, name, price
SELECT product_id,
       name,
       price
FROM   products
WHERE  price <= 100
ORDER BY product_id


-- 2. Задание:
-- Отберите пользователей женского пола из таблицы users. Выведите только id этих пользователей. 
-- Результат отсортируйте по возрастанию id.
-- Добавьте в запрос оператор LIMIT и выведите только 1000 первых id из отсортированного списка.
-- Поле в результирующей таблице: user_id
SELECT user_id
FROM   users
WHERE  sex = 'female'
ORDER BY user_id limit 1000


-- 3. Задание:
-- Отберите из таблицы user_actions все действия пользователей по созданию заказов, 
-- которые были совершены ими после полуночи 6 сентября 2022 года. Выведите колонки с id пользователей, 
-- id созданных заказов и временем их создания.
-- Результат должен быть отсортирован по возрастанию id заказа.
-- Поля в результирующей таблице: user_id, order_id, time
SELECT user_id,
       order_id,
       time
FROM   user_actions
WHERE  action = 'create_order'
   and time > '2022-09-06 00:00:00'
ORDER BY order_id


-- 4. Задание:
-- Назначьте скидку 20% на все товары из таблицы products и отберите те, цена на которые с учётом скидки превышает 100 рублей. 
-- Выведите id товаров, их наименования, прежнюю цену и новую цену с учётом скидки. Колонку со старой ценой назовите old_price, 
-- с новой — new_price.
-- Результат должен быть отсортирован по возрастанию id товара.
-- Поля в результирующей таблице: product_id, name, old_price, new_price
SELECT product_id,
       name,
       price as old_price,
       price*0.8 as new_price
FROM   products
WHERE  price*0.8 > 100
ORDER BY product_id


-- 5. Задание:
-- Отберите из таблицы products все товары, названия которых либо начинаются со слова «чай», либо состоят из пяти символов. 
-- Выведите две колонки: id товаров и их наименования.
-- Результат должен быть отсортирован по возрастанию id товара.
-- Поля в результирующей таблице: product_id, name
SELECT product_id,
       name
FROM   products
WHERE  length(name) = 5
    or upper(split_part(name, ' ', 1)) = 'ЧАЙ'


-- 6. Задание:
-- Отберите из таблицы products все товары, содержащие в своём названии последовательность символов «чай» (без кавычек). 
-- Выведите две колонки: id продукта и его название.
-- Результат должен быть отсортирован по возрастанию id товара.
-- Поля в результирующей таблице: product_id, name
SELECT product_id,
       name
FROM   products
WHERE  name like '%чай%'
ORDER BY product_id


-- 7. Задание:
-- Выберите из таблицы products id и наименования только тех товаров, 
-- названия которых начинаются на букву «с» и содержат только одно слово.
-- Результат должен быть отсортирован по возрастанию id товара.
-- Поля в результирующей таблице: product_id, name
SELECT product_id,
       name
FROM   products
WHERE  (name like 'с%')
   and (name not like '% %')


-- 8. Задание:
-- Составьте SQL-запрос, который выбирает из таблицы products все чаи стоимостью больше 60 рублей 
-- и вычисляет для них цену со скидкой 25%.
-- Скидку в % менеджер попросил указать в отдельном столбце в формате текста, то есть вот так: «25%» (без кавычек). 
-- Столбцы со скидкой и новой ценой назовите соответственно discount и new_price.
-- Также необходимо любым известным способом избавиться от «чайного гриба»: 
-- вряд ли менеджер имел в виду и его, когда ставил нам задачу.
-- Результат должен быть отсортирован по возрастанию id товара.
-- Поля в результирующей таблице: product_id, name, price, discount, new_price
SELECT product_id,
       name,
       price,
       '25%' as discount,
       price * 0.75 as new_price
FROM   products
WHERE  (name like '%чай%')
   and (name not like '%чайный гриб%')
   and (price > 60)
ORDER BY product_id


-- 9. Задание:
-- Из таблицы user_actions выведите всю информацию о действиях пользователей с id 170, 200 и 230 за период 
-- с 25 августа по 4 сентября 2022 года включительно. 
-- Результат отсортируйте по убыванию id заказа — то есть от самых поздних действий к самым первым.
-- Поля в результирующей таблице: user_id, order_id, action, time
SELECT user_id,
       order_id,
       action,
       time
FROM   user_actions
WHERE  (user_id in (170, 200, 230))
   and (time between '2022-08-25'
   and '2022-09-05')
ORDER BY time desc


-- 10. Задание:
-- Напишите SQL-запрос к таблице couriers и выведите всю информацию о курьерах, у которых не указан их день рождения.
-- Результат должен быть отсортирован по возрастанию id курьера.
-- Поля в результирующей таблице: birth_date, courier_id, sex
SELECT birth_date,
       courier_id,
       sex
FROM   couriers
WHERE  birth_date is null
ORDER BY courier_id


-- 11. Задание:
-- Определите id и даты рождения 50 самых молодых пользователей мужского пола из таблицы users. 
-- Не учитывайте тех пользователей, у которых не указана дата рождения.
-- Поле в результирующей таблице: user_id, birth_date
SELECT user_id,
       birth_date
FROM   users
WHERE  (birth_date is not null)
   and (sex = 'male')
ORDER BY birth_date desc 
LIMIT 50


-- 12. Задание:
-- Напишите SQL-запрос к таблице courier_actions, 
-- чтобы узнать id и время доставки последних 10 заказов, доставленных курьером с id 100.
-- Поля в результирующей таблице: order_id, time
SELECT order_id,
       time
FROM   courier_actions
WHERE  (courier_id = 100)
   and (action = 'deliver_order')
ORDER BY order_id desc
LIMIT 10


-- 13. Задание:
-- Из таблицы user_actions получите id всех заказов, сделанных пользователями сервиса в августе 2022 года.
-- Результат отсортируйте по возрастанию id заказа.
-- Поле в результирующей таблице: order_id
SELECT order_id
FROM   user_actions
WHERE  (date_part('month', time) = 8)
   and (date_part('year', time) = 2022)
   and (action = 'create_order')
ORDER BY order_id


-- 14. Задание:
-- Из таблицы couriers отберите id всех курьеров, родившихся в период с 1990 по 1995 год включительно.
-- Результат отсортируйте по возрастанию id курьера.
-- Поле в результирующей таблице: courier_id
SELECT courier_id
FROM   couriers
WHERE  (date_part('year', birth_date) between 1990
   and 1995)
ORDER BY courier_id


-- 15. Задание:
-- Из таблицы user_actions получите информацию о всех отменах заказов, которые пользователи совершали в течение августа 2022 года 
-- по средам с 12:00 до 15:59.
-- Результат отсортируйте по убыванию id отменённых заказов.
-- Поля в результирующей таблице: user_id, order_id, action, time
SELECT user_id,
       order_id,
       action,
       time
FROM   user_actions
WHERE  action = 'cancel_order'
   and date_part('month', time) = 8
   and date_part('year', time) = 2022
   and date_part('dow', time) = 3
   and date_part('hour', time) in (12, 13, 14, 15)
ORDER BY order_id desc


-- 16. Задание:
-- Как и в задаче из прошлого урока, вычислите НДС каждого товара в таблице products и рассчитайте цену без учёта НДС. 
-- Однако теперь примите во внимание, что для товаров из списка налог составляет 10%. Для остальных товаров НДС тот же — 20%.
-- Выведите всю информацию о товарах, включая сумму налога и цену без его учёта. 
-- Колонки с суммой налога и ценой без НДС назовите соответственно tax и price_before_tax. 
-- Округлите значения в этих колонках до двух знаков после запятой.
-- Результат отсортируйте сначала по убыванию цены товара без учёта НДС, затем по возрастанию id товара.
-- Поля в результирующей таблице: product_id, name, price, tax, price_before_tax
SELECT name,
       price,
       product_id,
       case when name in ('сахар', 'сухарики', 'сушки', 'семечки', 'масло льняное', 'виноград', 'масло оливковое', 'арбуз', 'батон', 'йогурт', 'сливки', 'гречка', 'овсянка', 'макароны', 'баранина', 'апельсины', 'бублики', 'хлеб', 'горох', 'сметана', 'рыба копченая', 'мука', 'шпроты', 'сосиски', 'свинина', 'рис', 'масло кунжутное', 'сгущенка', 'ананас', 'говядина', 'соль', 'рыба вяленая', 'масло подсолнечное', 'яблоки', 'груши', 'лепешка', 'молоко', 'курица', 'лаваш', 'вафли', 'мандарины') then round(price * 10 / 110,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         2)
            else round(price * 20 / 120, 2) end as tax,
       case when name in ('сахар', 'сухарики', 'сушки', 'семечки', 'масло льняное', 'виноград', 'масло оливковое', 'арбуз', 'батон', 'йогурт', 'сливки', 'гречка', 'овсянка', 'макароны', 'баранина', 'апельсины', 'бублики', 'хлеб', 'горох', 'сметана', 'рыба копченая', 'мука', 'шпроты', 'сосиски', 'свинина', 'рис', 'масло кунжутное', 'сгущенка', 'ананас', 'говядина', 'соль', 'рыба вяленая', 'масло подсолнечное', 'яблоки', 'груши', 'лепешка', 'молоко', 'курица', 'лаваш', 'вафли', 'мандарины') then round(price * 100 / 110,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         2)
            else round(price * 100 / 120, 2) end as price_before_tax
FROM   products
ORDER BY price_before_tax desc, product_id