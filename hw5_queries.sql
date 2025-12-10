--====================================================================
--  1. SELECT з підзапитом: відобразити order_details + customer_id
--====================================================================
SELECT 
    od.*,
    (SELECT o.customer_id 
     FROM orders AS o 
     WHERE o.order_id = od.order_id) AS customer_id
FROM order_details AS od;
--====================================================================
--  2. WHERE з підзапитом: shipper_id = 3
--====================================================================
SELECT *
FROM order_details
WHERE order_id IN (
    SELECT order_id 
    FROM orders
    WHERE shipper_id = 3
);
--====================================================================
--  3. Підзапит у FROM (середня кількість quantity > 10)
--====================================================================
SELECT order_id, AVG(quantity) AS avg_quantity
FROM (
    SELECT *
    FROM order_details
    WHERE quantity > 10
) AS temp
GROUP BY order_id;
--====================================================================
--  4. Те ж саме, але через WITH
--====================================================================
WITH temp AS (
    SELECT *
    FROM order_details
    WHERE quantity > 10
)
SELECT order_id, AVG(quantity) AS avg_quantity
FROM temp
GROUP BY order_id;
--====================================================================
--  5. Функція: divide FLOAT / застосувати до quantity
--====================================================================
-- Спершу видаляємо, якщо існує:
DROP FUNCTION IF EXISTS divide_float;
-- Створення функції:
DELIMITER $$

CREATE FUNCTION divide_float(
    num1 FLOAT,
    num2 FLOAT
)
RETURNS FLOAT
DETERMINISTIC
BEGIN
    RETURN num1 / num2;
END $$

DELIMITER ;
-- Використання (наприклад, ділимо quantity на 2):
SELECT id, order_id, product_id, quantity,
       divide_float(quantity, 2) AS divided_quantity
FROM order_details;
--====================================================================
