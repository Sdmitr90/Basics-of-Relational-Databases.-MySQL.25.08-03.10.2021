USE online_market;

-- выборка самых популярных товаров в каждом магазине

(SELECT
    SUM(op.amount) AS 'Общее количество',
    p.product_name AS 'Наименование товара',
    s.shop_name AS 'Название магазина'
FROM online_market.order_products op
JOIN online_market.products p
JOIN online_market.shops s ON s.id = p.shop_id
JOIN online_market.orders o ON o.id = op.order_id AND p.id = op.product_id
WHERE o.shop_id = 1
GROUP BY p.product_name, o.shop_id
ORDER BY o.shop_id, SUM(op.amount) DESC
LIMIT 1)
UNION ALL
(SELECT
    SUM(op.amount) AS 'Общее количество',
    p.product_name AS 'Наименование товара',
    s.shop_name AS 'Название магазина'
FROM online_market.order_products op
JOIN online_market.products p
JOIN online_market.shops s ON s.id = p.shop_id
JOIN online_market.orders o ON o.id = op.order_id AND p.id = op.product_id
WHERE o.shop_id = 2
GROUP BY p.product_name, o.shop_id
ORDER BY o.shop_id, SUM(op.amount) DESC
LIMIT 1)
UNION ALL
(SELECT
    SUM(op.amount) AS 'Общее количество',
    p.product_name AS 'Наименование товара',
    s.shop_name AS 'Название магазина'
FROM online_market.order_products op
JOIN online_market.products p
JOIN online_market.shops s ON s.id = p.shop_id
JOIN online_market.orders o ON o.id = op.order_id AND p.id = op.product_id
WHERE o.shop_id = 3
GROUP BY p.product_name, o.shop_id
ORDER BY o.shop_id, SUM(op.amount) DESC
LIMIT 1)
UNION ALL
(SELECT
    SUM(op.amount) AS 'Общее количество',
    p.product_name AS 'Наименование товара',
    s.shop_name AS 'Название магазина'
FROM online_market.order_products op
JOIN online_market.products p
JOIN online_market.shops s ON s.id = p.shop_id
JOIN online_market.orders o ON o.id = op.order_id AND p.id = op.product_id
WHERE o.shop_id = 4
GROUP BY p.product_name, o.shop_id
ORDER BY o.shop_id, SUM(op.amount) DESC
LIMIT 1)
UNION ALL
(SELECT
    SUM(op.amount) AS 'Общее количество',
    p.product_name AS 'Наименование товара',
    s.shop_name AS 'Название магазина'
FROM online_market.order_products op
JOIN online_market.products p
JOIN online_market.shops s ON s.id = p.shop_id
JOIN online_market.orders o ON o.id = op.order_id AND p.id = op.product_id
WHERE o.shop_id = 5
GROUP BY p.product_name, o.shop_id
ORDER BY o.shop_id, SUM(op.amount) DESC
LIMIT 1);

-- выборка общей стоимости каждого заказа

SELECT
	order_id AS 'Номер заказа',
	SUM(op.amount) AS 'Общее количество ед. товара',
	SUM(op.amount * p.price) as 'стоимость заказа'
FROM order_products op
JOIN products p ON op.product_id = p.id
GROUP by op.order_id
ORDER BY op.order_id ASC;

-- выборка всех позиций заказа с основными колонками связанных таблиц (процедура)

call search_order(1); -- заказ № 1




