/* Урок 6. Вебинар. Операторы, фильтрация, сортировка и ограничение. Агрегация данных
 * Задание №1 Пусть задан некоторый пользователь.
 * Из всех пользователей соц. сети найдите человека,который больше всех общался с выбранным пользователем
 * (написал ему сообщений). */

SELECT 
	firstname AS 'Имя пользователя',
	lastname AS 'Фамилия пользователя',
	count(*) AS 'Количество сообщений'
FROM users usr
JOIN
messages msg
WHERE msg.from_user_id = usr.id AND msg.to_user_id = 1 
GROUP BY usr.firstname, usr.lastname
ORDER BY COUNT(from_user_id) DESC
LIMIT 1;

/*Задание №2 Подсчитать общее количество лайков, которые получили пользователи младше 10 лет. */

SELECT COUNT(*) AS 'Количество лайков, пользователи < 10 лет'
FROM likes lks
JOIN
profiles prf
WHERE prf.user_id = lks.user_id AND TIMESTAMPDIFF(YEAR, prf.birthday, NOW()) < 10;

/*Задание №3 Определить кто больше поставил лайков (всего): мужчины или женщины. */

SELECT CASE (gender)
        WHEN 'm' THEN 'мужчин'
        WHEN 'f' THEN 'женщин'
    	END AS 'Кого больше', COUNT(*) as 'Лайков'
FROM profiles prf 
JOIN
likes lks 
WHERE lks.user_id = prf.user_id
GROUP BY gender 
LIMIT 1