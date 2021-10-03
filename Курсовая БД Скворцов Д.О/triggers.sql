USE online_market;

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

