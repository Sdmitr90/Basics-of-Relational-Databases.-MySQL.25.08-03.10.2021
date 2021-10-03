/* Урок 6. Вебинар. Операторы, фильтрация, сортировка и ограничение. Агрегация данных
 * Задание №1 Пусть задан некоторый пользователь.
 * Из всех пользователей соц. сети найдите человека,который больше всех общался с выбранным пользователем
 * (написал ему сообщений). */

SELECT 
	lastname as 'Фамилия пользователя',
	count(*) AS 'Количество сообщений'
FROM messages
JOIN users ON users.id = messages.from_user_id
WHERE to_user_id = 1
GROUP BY from_user_id
ORDER BY count(*) DESC
LIMIT 1;

/*Задание №2 Подсчитать общее количество лайков, которые получили пользователи младше 10 лет. */

SELECT count(*) as 'Количество лайков, пользователи < 10 лет'
FROM likes
WHERE user_id IN (
	SELECT user_id 
	FROM profiles
	WHERE TIMESTAMPDIFF(year, birthday, now()) < 10)
;

/*Задание №3 Определить кто больше поставил лайков (всего): мужчины или женщины. */

SELECT 
	(SELECT 
		gender FROM profiles 
		WHERE likes.user_id = profiles.user_id
		) AS "Пол",
	count(id) AS 'Количество лайков'
FROM likes
GROUP BY Пол;