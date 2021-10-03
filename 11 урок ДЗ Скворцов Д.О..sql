/*Практическое задание по теме “Оптимизация запросов”
Создайте таблицу logs типа Archive. 
Пусть при каждом создании записи в таблицах users, 
catalogs и products в таблицу logs помещается время и дата создания записи, 
название таблицы, идентификатор первичного ключа и содержимое поля name.
*/


-- ------------------Создадим таблицу Logs -----------------------

DROP TABLE IF EXISTS logs;
CREATE TABLE logs(
  create_at DATETIME DEFAULT CURRENT_TIMESTAMP, 
  table_name VARCHAR(50) NOT NULL, 
  table_id INT UNSIGNED NOT NULL, 
  name_value VARCHAR(50)) 
ENGINE=ARCHIVE;

-- -----------------таблица users --------------------------------

DELIMITER //

DROP TRIGGER IF EXISTS creation_record_users//

CREATE TRIGGER creation_record_users AFTER INSERT ON users
FOR EACH ROW BEGIN
		INSERT INTO logs (create_at, table_name, table_id, name_value)
	VALUES (NOW(), 'users', NEW.id, NEW.name);
END//

DELIMITER ;

-- ----------------таблица catalogs-------------------------------

DELIMITER //

DROP TRIGGER IF EXISTS creation_record_catalogs//

CREATE TRIGGER creation_record_catalogs AFTER INSERT ON catalogs
FOR EACH ROW BEGIN
		INSERT INTO logs (create_at, table_name, table_id, name_value)
	VALUES (NOW(), 'catalogs', NEW.id, NEW.name);
END//

DELIMITER //

-- ---------------таблица products--------------------------------

DELIMITER //

DROP TRIGGER IF EXISTS creation_record_products//

CREATE TRIGGER creation_record_products AFTER INSERT ON products
FOR EACH ROW BEGIN
		INSERT INTO logs (create_at, table_name, table_id, name_value)
	VALUES (NOW(), 'products', NEW.id, NEW.name);
END//

DELIMITER //

-- (по желанию) Создайте SQL-запрос, который помещает в таблицу users миллион записей.

