/* Урок 9. Видеоурок. Транзакции, переменные, представления. Администрирование.
 *  Хранимые процедуры и функции, триггеры
 * 
 * Практическое задание по теме “Транзакции, переменные, представления”
 * 
 * Задание №1 В базе данных shop и sample присутствуют одни и те же таблицы, учебной базы данных. 
 * Переместите запись id = 1 из таблицы shop.users в таблицу sample.users. 
 * Используйте транзакции. */


START TRANSACTION;

INSERT INTO sample.users
	SELECT * FROM shop.users WHERE id = 1;

COMMIT;

/* Задание №2 Создайте представление, которое выводит название name 
 * товарной позиции из таблицы products и 
 * соответствующее название каталога name из таблицы catalogs. */

CREATE OR REPLACE VIEW products_catalogs AS
	SELECT
		p.name AS product,
		c.name AS catalog
FROM
	products AS p
JOIN
	catalogs AS c
ON
	p.catalog_id = c.id;


/* Практическое задание по теме “Хранимые процедуры и функции, триггеры"
 * 
 * Задание №1 Создайте хранимую функцию hello(), 
 * которая будет возвращать приветствие, в зависимости от текущего времени суток. 
 * С 6:00 до 12:00 функция должна возвращать фразу "Доброе утро", 
 * с 12:00 до 18:00 функция должна возвращать фразу "Добрый день", 
 * с 18:00 до 00:00 — "Добрый вечер", с 00:00 до 6:00 — "Доброй ночи".*/

DELIMITER //

CREATE FUNCTION hello()
RETURNS TEXT READS SQL DATA
BEGIN
	CASE
		WHEN HOUR(NOW()) BETWEEN 0 AND 5 THEN
			RETURN 'Доброй ночи';
		WHEN HOUR(NOW()) BETWEEN 6 AND 11 THEN
			RETURN 'Доброе утро';
		WHEN HOUR(NOW()) BETWEEN 12 AND 17 THEN
			RETURN 'Добрый день';
		WHEN HOUR(NOW()) BETWEEN 18 AND 23 THEN
			RETURN 'Добрый вечер';
	END CASE;
END//

DELIMITER ;

SELECT hello();


/* Задание №2 В таблице products есть два текстовых поля:
 * name с названием товара и description с его описанием.
 * Допустимо присутствие обоих полей или одно из них.
 * Ситуация, когда оба поля принимают неопределенное значение NULL неприемлема.
 * Используя триггеры, добейтесь того, чтобы одно из этих полей или оба поля были заполнены.
 * При попытке присвоить полям NULL-значение необходимо отменить операцию.*/

DELIMITER //
DROP TRIGGER IF EXISTS correct_name_description//

CREATE TRIGGER correct_name_description BEFORE INSERT ON products
FOR EACH ROW BEGIN
	IF ISNULL(NEW.name)  AND ISNULL(NEW.description) THEN
		SIGNAL SQLSTATE '45000'
		SET message_text = 'Поля name и description = NULL';
	END IF;
END//

-- При попытке присвоить полям NULL-значение необходимо отменить операцию. 

CREATE TRIGGER correct_name_description BEFORE UPDATE ON products
FOR EACH ROW BEGIN
	IF NEW.name IS NULL AND NEW.description IS NULL THEN
		SIGNAL SQLSTATE '45000'
		SET message_text = 'Поля name и description = NULL';
	END IF;
END//

DELIMITER ;

