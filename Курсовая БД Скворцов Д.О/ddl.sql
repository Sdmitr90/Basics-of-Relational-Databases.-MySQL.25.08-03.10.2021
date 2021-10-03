DROP DATABASE IF EXISTS online_market;    
CREATE DATABASE online_market;

USE online_market;


-- выборка всех позиций заказа с основными колонками связанных таблиц

DROP PROCEDURE IF EXISTS search_order;

DELIMITER //

CREATE PROCEDURE search_order(IN search_id INT)
BEGIN
	SELECT
		op.order_id AS 'Номер заказа',
		p.product_name AS 'Наименование продукта',
		SUM(op.amount) AS 'Количество',
		SUM(op.amount * p.price) AS 'Стоимость',
		s.shop_name AS 'Магазин',
		CONCAT(name,' ',last_name) AS 'ФИО Покупателя',
		u.phone AS 'Моб. Телефон'
	FROM order_products op
	JOIN products p ON op.product_id = p.id
	JOIN orders o ON o.id = op.order_id
	JOIN shops s ON s.id = o.shop_id
	JOIN users u ON u.id =o.user_id 
	WHERE op.order_id = search_id
	GROUP BY op.order_id, p.product_name
	ORDER BY op.order_id ASC
   	;
END //

DELIMITER ;

-- обновление каталога продуктов

DROP PROCEDURE IF EXISTS update_products;

DELIMITER //

CREATE PROCEDURE update_products(IN update_id INT)
BEGIN
    DECLARE pid INT;
    DECLARE done INT DEFAULT FALSE;
	DECLARE cur CURSOR FOR SELECT id FROM products;
    DECLARE CONTINUE handler FOR NOT FOUND SET done = TRUE;
    OPEN cur;
    read_loop: LOOP
    FETCH cur INTO pid;
        IF done THEN
      LEAVE read_loop;
    END IF;
	  IF pid IN (SELECT product_id from order_products where order_id = update_id) THEN
      set @amount := (SELECT SUM(amount) FROM order_products WHERE order_id = update_id LIMIT 1);
      set @av := (SELECT product_amount FROM products WHERE id = pid LIMIT 1);
      UPDATE products SET product_amount = @av - @amount WHERE id = pid;
	END IF;
    END LOOP;
    CLOSE cur;
END //

DELIMITER ;

-- пополнение баланса пользователя

DROP PROCEDURE IF EXISTS charge;

DELIMITER //

CREATE PROCEDURE charge(IN money INT, IN user_id varchar(10))
BEGIN
	UPDATE users
    SET account_balance = money + account_balance
    WHERE id = user_id;
END //

DELIMITER ;


DROP TABLE IF EXISTS couriers;
CREATE TABLE couriers (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(50) DEFAULT NULL,
  last_name VARCHAR(50) DEFAULT NULL,
  phone BIGINT UNSIGNED UNIQUE,
  credit DECIMAL (11,2) DEFAULT 0,
  status ENUM('свободен', 'занят') DEFAULT 'свободен',
  shop_id BIGINT UNSIGNED NOT NULL,
  KEY index_of_shop_id (shop_id)
) COMMENT 'Курьеры';


-- триггер ведения журнала статусов курьеров
DROP TRIGGER IF EXISTS after_courier_update;

DELIMITER //

CREATE TRIGGER after_courier_update
BEFORE UPDATE ON couriers 
	FOR EACH ROW BEGIN
		IF OLD.status != NEW.status THEN
			INSERT INTO courier_status_logs(courier_id , old_status , new_status)
			VALUES(NEW.id , OLD.status ,NEW.status);
		END IF;
END //

DELIMITER ;


DROP TABLE IF EXISTS courier_status_logs;
CREATE TABLE courier_status_logs (
  courier_id BIGINT UNSIGNED NOT NULL,
  old_status VARCHAR(100) DEFAULT NULL,
  new_status VARCHAR(100) DEFAULT NULL,
  change_time DATETIME DEFAULT CURRENT_TIMESTAMP,
  KEY index_of_courier_id (courier_id)
) COMMENT 'Статус курьеров';

DROP TABLE IF EXISTS users;
CREATE TABLE users (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  password_hash VARCHAR(100),
  email VARCHAR(120) UNIQUE,
  name VARCHAR(50) DEFAULT NULL,
  last_name VARCHAR(50) DEFAULT NULL,
  gender CHAR(1) DEFAULT NULL,
  phone BIGINT UNSIGNED UNIQUE,
  birthday DATE DEFAULT NULL,
  account_balance INT(11) DEFAULT NULL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT 'Клиенты магазина';


-- Триггер Заполнение журнала изменения баланса пользователя
DROP TRIGGER IF EXISTS after_users_balance_update;

DELIMITER //

CREATE TRIGGER after_users_balance_update BEFORE UPDATE ON users 
FOR EACH ROW BEGIN
		IF OLD.account_balance != NEW.account_balance THEN
			INSERT INTO users_balance_logs(user_id, old_balance  , new_balance , change_time)
			VALUES(NEW.id , OLD.account_balance , NEW.account_balance , NOW());
		END IF;
END//

DELIMITER ;


DROP TABLE IF EXISTS users_balance_logs;
CREATE TABLE users_balance_logs (
  user_id BIGINT UNSIGNED NOT NULL,
  old_balance DECIMAL (11,2) DEFAULT NULL,
  new_balance DECIMAL (11,2) DEFAULT NULL,
  change_time DATETIME DEFAULT CURRENT_TIMESTAMP,
  KEY index_of_user_id (user_id)
) COMMENT 'Изменения баланса счетов клиентов';

DROP TABLE IF EXISTS users_address;
CREATE TABLE users_address (
  user_id BIGINT UNSIGNED NOT NULL,
  address VARCHAR(500) DEFAULT NULL,
  postal_code INT(6) DEFAULT NULL, -- почтовый индекс
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, 
  KEY index_of_user_id (user_id)
) COMMENT 'Адрес клиента';

DROP TABLE IF EXISTS deliveries;
CREATE TABLE deliveries (
  courier_id BIGINT UNSIGNED NOT NULL,
  order_id BIGINT UNSIGNED NOT NULL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  KEY index_of_courier_id (courier_id),
  KEY index_of_order_id (order_id)
) COMMENT 'Доставка';

DROP TABLE IF EXISTS managers;
CREATE TABLE managers (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(50) DEFAULT NULL,
  lastName VARCHAR(50) DEFAULT NULL,
  shop_id BIGINT UNSIGNED NOT NULL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT 'Менеджеры';

DROP TABLE IF EXISTS order_description_logs;
CREATE TABLE order_description_logs (
  order_id BIGINT UNSIGNED NOT NULL,
  description VARCHAR(255) DEFAULT NULL,
  change_time DATETIME DEFAULT CURRENT_TIMESTAMP,
  KEY index_of_order_id (order_id)
) COMMENT 'Журнал заказов';

DROP TABLE IF EXISTS order_products;
CREATE TABLE order_products (
  order_id BIGINT UNSIGNED NOT NULL,
  product_id BIGINT UNSIGNED NOT NULL,
  amount INT UNSIGNED DEFAULT 1 COMMENT 'Количество заказанных товарных позиций',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  KEY index_of_order_id (order_id),
  KEY index_of_product_id (product_id)
) COMMENT = 'Состав заказа';

DROP TABLE IF EXISTS discounts;
CREATE TABLE discounts (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  user_id BIGINT UNSIGNED NOT NULL,
  product_id BIGINT UNSIGNED NOT NULL,
  discount FLOAT UNSIGNED COMMENT 'Величина скидки от 0.0 до 1.0',
  started_at DATETIME,
  finished_at DATETIME,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  KEY index_of_user_id(user_id),
  KEY index_of_product_id(product_id)
) COMMENT = 'Скидки';


DROP TABLE IF EXISTS orders;
CREATE TABLE orders (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  shop_id BIGINT UNSIGNED NOT NULL,
  user_id BIGINT UNSIGNED NOT NULL,
  payment VARCHAR(100) DEFAULT NULL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  KEY index_of_shop_id (shop_id),
  KEY index_of_user_id (user_id)
)  COMMENT = 'Заказы';


-- Тригер ведение журналов, проверки наличия товара на складе, наличия(для покупки) и изменение баланса пользователя, статуса курьера, графика работы магазина.  

DROP TRIGGER IF EXISTS before_submitting;

DELIMITER //

CREATE TRIGGER before_submitting BEFORE INSERT ON order_products
FOR EACH ROW BEGIN
		
		SET @price := (SELECT p.price FROM products p
						WHERE p.id = NEW.product_id);
	
		SET @totprice := @price * NEW.amount;

		SET @curcredit := (SELECT u.account_balance FROM users u , orders o 
			WHERE o.id = NEW.order_id and o.user_id = u.id);
		
		SET @cur_amount := (SELECT p.product_amount FROM products p
			WHERE p.id = NEW.product_id);
	
		SET @cst := (SELECT c.id FROM couriers c , orders o WHERE o.id = NEW.order_id and c.status = 'свободен' and c.shop_id = o.shop_id limit 1);
 		
		SET @us := (SELECT u.id FROM users u , orders o WHERE o.id = NEW.order_id and o.user_id = u.id);
 		
		SET @s1 := (SELECT s.open_time FROM schedule s, orders o WHERE o.id = NEW.order_id and s.shop_id = o.shop_id limit 1);
 		
		SET @s2 := (SELECT s.close_time FROM schedule s, orders o WHERE o.id = NEW.order_id and s.shop_id = o.shop_id limit 1);
	    
		IF NEW.amount > @cur_amount THEN 
            INSERT INTO order_status_logs (order_id , old_status , new_status, change_time)
			VALUES(NEW.order_id,'Зарегистрирован','Отклонен' ,NOW());
			INSERT INTO order_description_logs (order_id, description, change_time) 
            VALUES (NEW.order_id,'Нет на складе!', NOW());		

		ELSEIF @curcredit < @totprice THEN
            INSERT INTO order_status_logs(order_id , old_status , new_status)
			VALUES(NEW.order_id,'Зарегистрирован','Отклонен');	
			INSERT INTO order_description_logs (order_id, description) 
            VALUES (NEW.order_id,'Нет денег на балансе!');	

 		ELSEIF HOUR(NOW()) < HOUR(@s1) or HOUR(NOW()) > HOUR(@s2) then
            INSERT INTO order_status_logs(order_id , old_status , new_status)
					VALUES(NEW.order_id,'Зарегистрирован','Отклонен');
			INSERT INTO order_description_logs (order_id, description) 
            		VALUES (NEW.order_id,'Магазин закрыт');	
        ELSEIF @cst is null then
            INSERT into order_status_logs(order_id , old_status , new_status)
					VALUES(NEW.order_id,'Зарегистрирован','Отклонен');
				INSERT INTO order_description_logs (order_id, description) 
            VALUES (NEW.order_id,'Нет свободных курьеров');	
		ELSE
			INSERT INTO order_description_logs (order_id, description) 
            	VALUES (NEW.order_id,'Готов к отправке');	
 			UPDATE couriers c
 				SET c.status = 'занят'
				WHERE c.id = @cst;
			UPDATE couriers c
				SET c.credit = credit + @totprice
				WHERE c.id = @cst;
			INSERT INTO deliveries(courier_id, order_id)
				VALUES(@cst , new.order_id);
 			INSERT INTO order_status_logs(order_id , old_status , new_status)
				VALUES(NEW.order_id,'Зарегистрирован','Доставляется');
 			INSERT INTO order_status_logs(order_id , old_status , new_status)
				VALUES(NEW.order_id,'Доставляется','Выполнен');
			CALL update_products(NEW.order_id);
			UPDATE users u 
            	SET account_balance = account_balance - @totprice
             	WHERE u.id = @us;
		END IF;        
	END
//		

DELIMITER ;



DROP TABLE IF EXISTS order_status_logs;
CREATE TABLE order_status_logs (
  order_id BIGINT UNSIGNED NOT NULL,
  old_status VARCHAR(100) DEFAULT NULL,
  new_status VARCHAR(100) DEFAULT NULL,
  change_time DATETIME DEFAULT CURRENT_TIMESTAMP,
  KEY index_of_order_id (order_id)
) COMMENT = 'Статус заказа';

DROP TABLE IF EXISTS products;
CREATE TABLE products (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  shop_id BIGINT UNSIGNED NOT NULL,
  product_name VARCHAR(200) DEFAULT NULL,
  price DECIMAL (11,2),
  product_amount INT(11) DEFAULT NULL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  KEY index_of_shop_id (shop_id)
) COMMENT = 'Товарные позиции';

DROP TABLE IF EXISTS schedule;
CREATE TABLE schedule (
  shop_id BIGINT UNSIGNED NOT NULL,
  open_time time DEFAULT NULL,
  close_time time DEFAULT NULL,
  KEY index_of_shop_id (shop_id)
) COMMENT = 'Расписание магазина';

DROP TABLE IF EXISTS shops;
CREATE TABLE shops (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  shop_name varchar(200) DEFAULT NULL,
  city varchar(100) DEFAULT NULL,
  address varchar(500) DEFAULT NULL,
  phone BIGINT UNSIGNED,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = 'Магазины (Склады)';

ALTER TABLE couriers
  ADD CONSTRAINT couriers_fk 
  FOREIGN KEY (shop_id) REFERENCES shops (id);
  
 ALTER TABLE courier_status_logs
  ADD CONSTRAINT courier_status_logs_fk
  FOREIGN KEY (courier_id) REFERENCES couriers (id);

ALTER TABLE users_balance_logs
  ADD CONSTRAINT users_balance_logs_fk
  FOREIGN KEY (user_id) REFERENCES users (id);

ALTER TABLE users_address
  ADD CONSTRAINT users_address_fk
  FOREIGN KEY (user_id) REFERENCES users (id);

 ALTER TABLE deliveries
  ADD CONSTRAINT deliveries_fk_1 FOREIGN KEY (courier_id) REFERENCES couriers (id),
  ADD CONSTRAINT deliveries_fk_2 FOREIGN KEY (order_id) REFERENCES orders (id);
 
ALTER TABLE managers
  ADD CONSTRAINT managers_fk
  FOREIGN KEY (shop_id) REFERENCES shops (id);

ALTER TABLE  order_description_logs
  ADD CONSTRAINT  order_description_logs_fk
  FOREIGN KEY (order_id) REFERENCES orders (id);

ALTER TABLE discounts
  ADD CONSTRAINT discounts_fk_1 FOREIGN KEY (user_id) REFERENCES users (id),
  ADD CONSTRAINT discounts_fk_2 FOREIGN KEY (product_id) REFERENCES products (id);

ALTER TABLE order_products
  ADD CONSTRAINT order_products_fk_1 FOREIGN KEY (order_id) REFERENCES orders (id),
  ADD CONSTRAINT order_products_fk_2 FOREIGN KEY (product_id) REFERENCES products (id);
 
ALTER TABLE orders
  ADD CONSTRAINT orders_fk_1 FOREIGN KEY (shop_id) REFERENCES shops (id),
  ADD CONSTRAINT orders_fk_2 FOREIGN KEY (user_id) REFERENCES users (id);

ALTER TABLE order_status_logs
  ADD CONSTRAINT order_status_logs_fk
  FOREIGN KEY (order_id) REFERENCES orders (id);

ALTER TABLE products
  ADD CONSTRAINT products_fk
  FOREIGN KEY (shop_id) REFERENCES shops (id);

ALTER TABLE schedule
  ADD CONSTRAINT schedule_fk
  FOREIGN KEY (shop_id) REFERENCES shops (id) ON DELETE CASCADE;
