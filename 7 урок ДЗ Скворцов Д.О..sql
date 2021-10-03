
/* Задание №1. Составьте список пользователей users, которые осуществили хотя бы один заказ orders в интернет магазине.*/


/*Заполняем таблицы для задания*/
DROP TABLE IF EXISTS orders;
CREATE TABLE orders (
  id SERIAL PRIMARY KEY,
  user_id INT UNSIGNED,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  KEY index_of_user_id(user_id)
) COMMENT = 'Заказы';

INSERT INTO orders (id,user_id,created_at,updated_at)
VALUES 
(1,3,'2021-09-12 11:22:43','2021-09-12 11:22:43'),
(2,3,'2021-09-12 11:22:43','2021-09-12 11:22:43'),
(3,4,'2021-09-12 11:22:43','2021-09-12 11:22:43'),
(4,5,'2021-09-12 11:22:43','2021-09-12 11:22:43'),
(5,4,'2021-09-12 11:22:43','2021-09-12 11:22:43'),
(6,4,'2021-09-12 11:22:43','2021-09-12 11:22:43'),
(7,2,'2021-09-12 11:22:43','2021-09-12 11:22:43');


DROP TABLE IF EXISTS orders_products;
CREATE TABLE orders_products (
  id SERIAL PRIMARY KEY,
  order_id INT UNSIGNED,
  product_id INT UNSIGNED,
  total INT UNSIGNED DEFAULT 1 COMMENT 'Количество заказанных товарных позиций',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = 'Состав заказа';

INSERT INTO orders_products (id,order_id,product_id,total,created_at,updated_at)
VALUES 
(1,1,4,2,'2021-09-12 11:22:43','2021-09-12 11:22:43'),
(2,2,3,3,'2021-09-12 11:22:43','2021-09-12 11:22:43'),
(3,3,3,1,'2021-09-12 11:22:43','2021-09-12 11:22:43'),
(4,4,6,3,'2021-09-12 11:22:43','2021-09-12 11:22:43'),
(5,5,4,4,'2021-09-12 11:22:43','2021-09-12 11:22:43'),
(6,6,2,1,'2021-09-12 11:22:43','2021-09-12 11:22:43'),
(7,7,4,3,'2021-09-12 11:22:43','2021-09-12 11:22:43'),
(8,8,1,2,'2021-09-12 11:22:43','2021-09-12 11:22:43'),
(9,9,4,1,'2021-09-12 11:22:43','2021-09-12 11:22:43'),
(10,11,5,4,'2021-09-12 11:22:43','2021-09-12 11:22:43');

SELECT us.name, COUNT(ord.user_id) as 'Количество заказов'
FROM users us 
JOIN
orders ord 
WHERE us.id = ord.user_id
GROUP BY name;

/* Задание №2. Выведите список товаров products и разделов catalogs, который соответствует товару.*/

SELECT prod.id, prod.name, ctlg.name
FROM products prod 
JOIN
catalogs ctlg 
ON prod.catalog_id = ctlg.id;

/* Задание №3. (по желанию) Пусть имеется таблица рейсов flights (id, from, to) и таблица городов cities (label, name). 
Поля from, to и label содержат английские названия городов, поле name — русское.
Выведите список рейсов flights с русскими названиями городов.*/

DROP TABLE IF EXISTS flights;
CREATE TABLE flights (
	id SERIAL PRIMARY KEY,
	`from` varchar(100),
	`to` varchar(100)
);

INSERT INTO flights (id,`from`,`to`) VALUES 
(1,'moscow','omsk'),
(2,'novgorod','kazan'),
(3,'irkutsk','moscow'),
(4,'omsk','irkutsk'),
(5,'moscow','kazan');


DROP TABLE IF EXISTS cities;
CREATE TABLE cities (
	label varchar(99) NULL,
	name varchar(99) NULL
);

INSERT INTO cities (label,name) VALUES 
	('Moscow','Москва'),
	('Irkutsk','Иркутск'),
	('Novgorod','Новгород'),
	('Kazan','Казань'),
	('Omsk','Омск');
	

SELECT fl.id, cit_f.name `from`, cit_t.name `to`
FROM flights fl
JOIN cities cit_f
ON fl.`from` = cit_f.label 
JOIN cities cit_t
ON fl.`to` = cit_t.label 
ORDER BY fl.id;