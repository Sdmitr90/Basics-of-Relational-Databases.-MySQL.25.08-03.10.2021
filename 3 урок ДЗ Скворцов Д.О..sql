USE vk;

DROP TABLE IF EXISTS activity_status; 
CREATE TABLE `activity status` (
	`active_user_id` SERIAL,
	`activity status` ENUM('Online', 'Offline'),
	`created_at` DATETIME DEFAULT NOW(), -- Дата создания, для отслеживания времени последней активности
    `updated_at` DATETIME ON UPDATE CURRENT_TIMESTAMP,
	
    PRIMARY KEY (active_user_id),
    FOREIGN KEY (active_user_id) REFERENCES users(id)

) COMMENT = 'Статус активности пользователей';

DROP TABLE IF EXISTS `user_wall`; -- Стена на странице пользователя
CREATE TABLE `user_wall` (
id SERIAL,
user_id BIGINT UNSIGNED NOT NULL,
photos_id BIGINT UNSIGNED NOT NULL,
description TINYTEXT,
created_at DATETIME DEFAULT NOW(),

FOREIGN KEY (user_id) REFERENCES users(id),
FOREIGN KEY (photos_id) REFERENCES photos(id)

)COMMENT = 'Стена пользователей';

DROP TABLE IF EXISTS `comments`; -- комментарии для стены пользователя
CREATE TABLE `comments` (
id SERIAL,
from_user_id BIGINT UNSIGNED NOT NULL,
user_wall_id BIGINT UNSIGNED NOT NULL,
comments TINYTEXT,
created_at DATETIME DEFAULT NOW(),

FOREIGN KEY (from_user_id) REFERENCES users(id),
FOREIGN KEY (user_wall_id) REFERENCES user_wall(id)
)COMMENT = 'Комментарии стены пользователей';