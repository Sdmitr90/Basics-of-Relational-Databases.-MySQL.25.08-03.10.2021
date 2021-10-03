/* Задание №1. Пусть в таблице users поля created_at и updated_at оказались незаполненными. Заполните их текущими датой и временем. */

UPDATE users
   set created_at = NOW()
where created_at IS NULL;

UPDATE users
   set updated_at = NOW()
WHERE updated_at IS NULL;


/* Задание №2. Таблица users была неудачно спроектирована. Записи created_at и updated_at были заданы типом VARCHAR и в них долгое время помещались значения в формате "20.10.2017 8:10". Необходимо преобразовать поля к типу DATETIME, сохранив введеные ранее значения. */

UPDATE users
SET
created_at = STR_TO_DATE(created_at, '%d.%m.%Y %k:%i'),
updated_at = STR_TO_DATE(updated_at, '%d.%m.%Y %k:%i');

/* Задание №3. В таблице складских запасов storehouses_products в поле value могут встречаться самые разные цифры: 0, если товар закончился и выше нуля, если на складе имеются запасы. Необходимо отсортировать записи таким образом, чтобы они выводились в порядке увеличения значения value. Однако, нулевые запасы должны выводиться в конце, после всех записей. */

INSERT INTO storehouses_products (storehouse_id, product_id, value) VALUES
  (1, 5, 0),
  (2, 8, 2500),
  (3, 4, 0),
  (4, 6, 30),
  (5, 7, 500),
  (6, 3, 1);
  
SELECT value FROM storehouses_products ORDER BY IF(value > 0, 0, 1), value;


/* Задание №4. Из таблицы users необходимо извлечь пользователей, родившихся в августе и мае. Месяцы заданы в виде списка английских названий ('may', 'august') */

SELECT name, birthday_at FROM users WHERE DATE_FORMAT(birthday_at, '%M') IN ('may', 'august');

/* Задание №5. Из таблицы catalogs извлекаются записи при помощи запроса. SELECT * FROM catalogs WHERE id IN (5, 1, 2); Отсортируйте записи в порядке, заданном в списке IN. */

SELECT * FROM catalogs WHERE id IN (5, 1, 2) ORDER BY FIELD(id, 5, 1, 2);


/* Практическое задание теме “Агрегация данных”
 * Задание №1. Подсчитайте средний возраст пользователей в таблице users. */

SELECT AVG(TIMESTAMPDIFF(YEAR, birthday_at, NOW())) AS age FROM users;


/* Задание №2. Подсчитайте количество дней рождения, которые приходятся на каждый из дней недели. Следует учесть, что необходимы дни недели текущего года, а не года рождения. */

SELECT
	DATE_FORMAT(DATE(CONCAT_WS('-', YEAR(NOW()), MONTH(birthday_at), DAY(birthday_at))), '%W') AS Days, COUNT(*) AS Quantity
FROM users
GROUP BY Days
ORDER BY FIELD(Days, "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday" ,"Sunday");

/* Задание №3. Подсчитайте произведение чисел в столбце таблицы */

SELECT EXP(SUM(LOG(id))) as multiplication FROM catalogs;