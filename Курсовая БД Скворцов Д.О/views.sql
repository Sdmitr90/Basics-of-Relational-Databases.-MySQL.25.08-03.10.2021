
-- представление заказа пользователя со статусом, менеджером описанием лога и временем.

DROP VIEW IF EXISTS order_status;

CREATE VIEW order_status AS 

SELECT
    CONCAT(u.last_name, ' ',u.name) AS 'Клиент',
    o.id AS 'Номер заказа',
    osl.new_status AS 'Статус заказа',
    odl.description AS 'Описание статуса',
    CONCAT(m.name, ' ', m.lastName) AS 'Менеджер',
    o.created_at AS 'Время создания',
    o.updated_at AS 'Время обновления'
FROM users u 
JOIN orders o ON o.user_id = u.id 
JOIN order_status_logs osl ON osl.order_id = o.id 
JOIN order_description_logs odl ON odl.order_id = o.id
JOIN managers m ON m.shop_id = o.shop_id
GROUP BY o.id
ORDER BY u.last_name ASC;
    
-- представление каталогов магазинов с менеджером, номером телефона и временем работы.

DROP VIEW IF EXISTS shops_catalogs;

CREATE VIEW shops_catalogs AS 

SELECT 
    s.shop_name AS 'Магазин',
    p.product_name AS 'Товар',
    p.price AS 'Цена',
    CONCAT(m.name, ' ', m.lastName) AS 'Менеджер',
    s.phone AS 'Телефон',
    CONCAT(sch.open_time, ' - ', sch.close_time) AS 'Время работы'
FROM shops s 
JOIN products p ON s.id = p.shop_id
JOIN schedule sch ON sch.shop_id =s.id
JOIN managers m ON m.shop_id = s.id
ORDER BY s.id;
