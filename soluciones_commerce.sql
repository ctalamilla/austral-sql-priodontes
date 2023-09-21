-- 1. Listar los nombres de los productos (commerce.product.name).
SELECT name FROM commerce.product;

-- 2. Listar los nombres de los productos cuyo precio es mayor a 500 (commerce.product.name).
SELECT p.name
FROM commerce.product p
WHERE p.price > 500;

-- 3. Listar los nombres de los productos cuyo precio se encuentra entre 300 y 550 (commerce.product.name).
SELECT p.name
FROM commerce.product p
WHERE p.price BETWEEN 300 AND 550;

-- 4. Listar los nombres de los productos cuyo nombre comienza con 'F' (commerce.product.name).
SELECT p.name
FROM commerce.product p
WHERE p.name LIKE 'F%';

-- 5. Listar los nombres de los productos cuyo nombre contiene la letra 'e' (commerce.product.name).
SELECT p.name
FROM commerce.product p
WHERE p.name LIKE '%e%';

-- 6. Listar los nombres de los productos cuyo nombre contiene la letra 'a' en la segunda posición (commerce.product.name).
SELECT p.name
FROM commerce.product p
WHERE p.name LIKE '_a%';

-- 7. Listar los códigos de los productos vendidos (commerce.product.code).
SELECT DISTINCT si.product_code
FROM commerce.sale_item si;

-- 8. Listar las ventas que contienen el código de producto 4 (commerce.sale.*).
SELECT s.*
FROM commerce.sale s
WHERE EXISTS (
    SELECT 1
    FROM commerce.sale_item si
    WHERE si.product_code = 4 AND si.sale_code = s.code
);

-- 9. Listar las ventas cuyo flete es mayor a $30 (commerce.sale.*).
SELECT s.*
FROM commerce.sale s
WHERE delivery > 30;

-- 10. Listar los nombres de los clientes que han comprado con descuento (commerce.customer.name).
SELECT DISTINCT c.name
FROM commerce.sale s
JOIN commerce.customer c ON s.customer_code = c.code
WHERE s.discount > 0;

-- 11. Listar los nombres de los productos provistos por 'Bandera' (commerce.product.name).
SELECT p.name
FROM commerce.supplier s
JOIN commerce.product_supplier ps ON s.code = ps.supplier_code
JOIN commerce.product p ON p.code = ps.product_code
WHERE s.name = 'Bandera';

-- 12. Listar los nombres de los productos adquiridos por 'Arturo Illia' (commerce.product.name).
SELECT DISTINCT p.name
FROM commerce.customer c
JOIN commerce.sale s ON c.code = s.customer_code
JOIN commerce.sale_item si ON s.code = si.sale_code
JOIN commerce.product p ON si.product_code = p.code
WHERE c.name = 'Arturo Illia';

-- 13. Listar los nombres de los proveedores con los depósitos que poseen productos provistos por él (commerce.supplier.name, commerce.warehouse.name).
SELECT DISTINCT s.name, w.name
FROM commerce.supplier s
JOIN commerce.product_supplier ps ON s.code = ps.supplier_code
JOIN commerce.stock st ON ps.product_code = st.product_code
JOIN commerce.warehouse w ON st.warehouse_code = w.code;

-- 14. Listar los nombres de los productos de mayor precio (commerce.product.name).
SELECT p.name
FROM commerce.product p
WHERE p.price = (
    SELECT MAX(t.price)
    FROM commerce.product t
);

-- 15. Listar el código de las ventas donde el costo de todos los productos supera los $500 (commerce.sale.code).
SELECT s.code
FROM commerce.sale s
JOIN commerce.sale_item si ON s.code = si.sale_code
GROUP BY s.code
HAVING SUM(si.cost * si.quantity) > 500;

-- 16. Listar los nombres de los proveedores de las ciudades donde existan depósitos (commerce.supplier.name).
SELECT DISTINCT s.name
FROM commerce.supplier s
WHERE EXISTS (
    SELECT 1
    FROM commerce.warehouse w
    WHERE w.city = s.city
);

-- 17. Listar los nombres de los clientes que han hecho más de dos compras (commerce.customer.name).
SELECT c.name
FROM commerce.customer c
JOIN commerce.sale s ON c.code = s.customer_code
GROUP BY c.code
HAVING COUNT(s.code) > 2;

-- 18. Listar los nombres de las sucursales que no tienen depósitos en su ciudad (commerce.store.name).
SELECT s.name
FROM commerce.store s
WHERE NOT EXISTS (
    SELECT 1
    FROM commerce.warehouse w
    WHERE w.city = s.city
);

-- 19. Listar los códigos de los depósitos de 'Buenos Aires' con más de 40 unidades de productos (commerce.warehouse.code).
SELECT w.code
FROM commerce.warehouse w
JOIN commerce.stock s ON w.code = s.warehouse_code
WHERE w.city = 'Buenos Aires'
GROUP BY w.code
HAVING SUM(s.quantity) > 40;

-- 20. Listar los nombres de los productos, sus precios máximos, mínimos y precio promedio de ventas (commerce.product.name, max, min, avg).
SELECT p.name, MAX(i.price), MIN(i.price), AVG(i.price)
FROM commerce.product p
JOIN commerce.sale_item i ON p.code = i.product_code
GROUP BY p.name;

-- 21. Listar los nombres de los productos y su variación en pesos de precio de ventas (precio máximo - precio mínimo) - (commerce.product.name, variación).
SELECT p.name, MAX(i.price) - MIN(i.price)
FROM commerce.product p
JOIN commerce.sale_item i ON p.code = i.product_code
GROUP BY p.name;

-- 22. Listar los nombres de los clientes y la cantidad gastada (monto total de precio de productos + envíos - descuentos) - (commerce.customer.name, amount).
SELECT c.name, SUM(t.total + s.delivery - s.discount)
FROM commerce.customer c
JOIN commerce.sale s ON c.code = s.customer_code
JOIN (
    SELECT si.sale_code, SUM(si.quantity * si.price) AS total
    FROM commerce.sale_item si
    GROUP BY si.sale_code
) t ON s.code = t.sale_code
GROUP BY c.name;

-- 23. Listar los nombres de los productos y su stock (commerce.product.name, cantidad).
SELECT p.name, SUM(s.quantity)
FROM commerce.product p
JOIN commerce.stock s ON s.product_code = p.code
GROUP BY p.name;

-- 24. Listar los nombres de los depósitos que poseen todos los productos (commerce.warehouse.name).
SELECT w.name
FROM commerce.warehouse w
WHERE NOT EXISTS (
    SELECT 1
    FROM commerce.product p
    WHERE NOT EXISTS (
        SELECT 1
        FROM commerce.stock s
        WHERE s.product_code = p.code AND s.warehouse_code = w.code
    )
);

-- 25. Listar los nombres de los proveedores y la cantidad de productos diferentes que proveen (commerce.supplier.name, cantidad).
SELECT s.name, COUNT(ps.product_code)
FROM commerce.supplier s
JOIN commerce.product_supplier ps ON s.code = ps.supplier_code
GROUP BY s.name;

-- 26. Listar los nombres de los clientes y el promedio de compra de cada uno de ellos (commerce.customer.name, promedio).
SELECT c.name, AVG(t.total + s.delivery - s.discount)
FROM commerce.customer c
JOIN commerce.sale s ON c.code = s.customer_code
JOIN (
    SELECT si.sale_code, SUM(si.quantity * si.price) AS total
    FROM commerce.sale_item si
    GROUP BY si.sale_code
) t ON s.code = t.sale_code
GROUP BY c.name;

-- 27. Listar los nombres de los productos no adquiridos por ningún cliente (commerce.product.name).
SELECT p.name
FROM commerce.product p
WHERE NOT EXISTS (
    SELECT 1
    FROM commerce.sale_item si
    WHERE si.product_code = p.code
);

-- 28. Listar los clientes que han adquirido más de dos productos diferentes (commerce.customer.name, cantidad).
SELECT c.name, COUNT(DISTINCT si.product_code)
FROM commerce.customer c
JOIN commerce.sale s ON c.code = s.customer_code
JOIN commerce.sale_item si ON s.code = si.sale_code
GROUP BY c.name
HAVING COUNT(DISTINCT si.product_code) > 2;

-- 29. Listar los clientes que han adquirido productos en una sola sucursal (commerce.customer.name).
SELECT c.name
FROM commerce.customer c
JOIN commerce.sale s ON c.code = s.customer_code
GROUP BY c.name
HAVING COUNT(DISTINCT s.store_code) = 1;

-- 30. Listar los clientes que han adquirido productos en todas las sucursales (commerce.customer.name).
SELECT c.name
FROM commerce.customer c
WHERE NOT EXISTS (
    SELECT 1
    FROM commerce.store st
    WHERE NOT EXISTS (
        SELECT 1
        FROM commerce.sale s
        WHERE c.code = s.customer_code AND s.store_code = st.code
    )
);

-- 31. Listar los proveedores que proveen productos a su misma ciudad (commerce.supplier.name).
SELECT s.name
FROM commerce.supplier s
WHERE EXISTS (
    SELECT 1
    FROM commerce.product_supplier ps
    JOIN commerce.stock st ON ps.product_code = st.product_code
    JOIN commerce.warehouse w ON w.code = st.warehouse_code
    WHERE w.city = s.city
);

-- 32. Listar por cada sucursal el monto vendido (commerce.store.name, monto).
SELECT st.name, SUM(t.total + s.delivery - s.discount)
FROM commerce.store st
JOIN commerce.sale s ON st.code = s.store_code
JOIN (
    SELECT si.sale_code, SUM(si.quantity * si.price) AS total
    FROM commerce.sale_item si
    GROUP BY si.sale_code
) t ON s.code = t.sale_code
GROUP BY st.name;

-- 33. Listar por cada sucursal la cantidad de clientes (commerce.store.name, cantidad).
SELECT st.name, COUNT(DISTINCT s.customer_code)
FROM commerce.store st
JOIN commerce.sale s ON st.code = s.store_code
GROUP BY st.name;

-- 34. Listar por cada sucursal la cantidad de productos diferentes vendidos (commerce.store.name, cantidad).
SELECT st.name, COUNT(DISTINCT si.product_code)
FROM commerce.store st
JOIN commerce.sale s ON st.code = s.store_code
JOIN commerce.sale_item si ON s.code = si.sale_code
GROUP BY st.name;

-- 35. Listar los nombres de los productos almacenados en 'Baires I' (commerce.product.name).
SELECT p.name
FROM commerce.warehouse w
JOIN commerce.stock s ON w.code = s.warehouse_code
JOIN commerce.product p ON p.code = s.product_code
WHERE w.name = 'Baires I';
