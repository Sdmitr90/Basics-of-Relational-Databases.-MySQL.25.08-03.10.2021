USE online_market;

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
	GROUP by op.order_id, p.product_name
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