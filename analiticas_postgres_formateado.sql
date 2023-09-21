-- Consulta 1
SELECT EXTRACT(MONTH FROM sale_date) AS mes, st.name, SUM(monto - discount + delivery) AS monto
FROM commerce.customer c
INNER JOIN commerce.sale s ON c.code = s.customer_code
INNER JOIN (
    SELECT s.code AS code, SUM(si.quantity * si.price) AS monto
    FROM commerce.sale s
    INNER JOIN commerce.sale_item si ON s.code = si.sale_code
    GROUP BY s.code
) sm ON s.code = sm.code
INNER JOIN commerce.store st ON s.store_code = st.code
GROUP BY EXTRACT(MONTH FROM sale_date), st.name;

-- Consulta 2 (CUBE)
SELECT EXTRACT(MONTH FROM sale_date) AS mes, st.name, SUM(monto - discount + delivery) AS monto
FROM commerce.customer c
INNER JOIN commerce.sale s ON c.code = s.customer_code
INNER JOIN (
    SELECT s.code AS code, SUM(si.quantity * si.price) AS monto
    FROM commerce.sale s
    INNER JOIN commerce.sale_item si ON s.code = si.sale_code
    GROUP BY s.code
) sm ON s.code = sm.code
INNER JOIN commerce.store st ON s.store_code = st.code
GROUP BY CUBE(EXTRACT(MONTH FROM sale_date), st.name);

-- Consulta 3
SELECT a.nombre, AVG(c.nota) AS Promedio,
RANK() OVER (ORDER BY AVG(c.nota) DESC) AS Ranking
FROM escuela.cursa c INNER JOIN escuela.alumno a ON c.legajo=a.legajo
GROUP BY a.nombre
ORDER BY AVG(c.nota) DESC;

-- Consulta 4
SELECT c.name, SUM(t.total + s.delivery - s.discount) AS Consumo,
RANK() OVER (ORDER BY SUM(t.total + s.delivery - s.discount) DESC) AS Ranking
FROM commerce.customer c JOIN commerce.sale s ON c.code = s.customer_code
JOIN (
    SELECT si.sale_code, SUM(si.quantity * si.price) AS Total
    FROM commerce.sale_item si
    GROUP BY si.sale_code
) t ON s.code = t.sale_code
GROUP BY c.name;

-- Consulta 5
SELECT m.nombre, COUNT(*) AS Cursantes,
RANK() OVER (ORDER BY COUNT(*) DESC) AS Rank_puro,
DENSE_RANK() OVER (ORDER BY COUNT(*) DESC) AS Rank_DS,
NTILE(2) OVER (ORDER BY COUNT(*) DESC) AS Rank_Ntile,
ROW_NUMBER() OVER (ORDER BY COUNT(*) DESC) AS Rank_RN
FROM escuela.materia m INNER JOIN escuela.cursa c ON m.codigo = c.codigo
GROUP BY m.nombre
ORDER BY COUNT(*) DESC;

-- Consulta 6
SELECT m.nombre Materia, a.nombre Alumno, c.nota nota,
RANK() OVER
(PARTITION BY m.nombre ORDER BY c.nota DESC) AS Ranking
FROM escuela.cursa c INNER JOIN escuela.materia m ON c.codigo=m.codigo
INNER JOIN escuela.alumno a ON c.legajo = a.legajo;

-- Consulta 7
SELECT st.name Sucursal, c.name Cliente,
SUM(t.total + s.delivery - s.discount) AS Consumo,
RANK() OVER (PARTITION BY st.name ORDER BY
SUM(t.total + s.delivery - s.discount) DESC) Ranking
FROM commerce.customer c JOIN commerce.sale s ON c.code = s.customer_code JOIN
(SELECT si.sale_code, SUM(si.quantity * si.price) AS total
FROM commerce.sale_item si
GROUP BY si.sale_code) t ON s.code = t.sale_code
JOIN commerce.store st ON s.store_code = st.code
GROUP BY st.name, c.name;

-- Consulta 8
SELECT s.sale_date, s.code, SUM(t.total + s.delivery - s.discount) AS Consumo,
AVG(SUM(t.total + s.delivery - s.discount)) OVER
(ORDER BY s.code, sale_date ROWS BETWEEN 1 PRECEDING
AND 1 FOLLOWING) AS ConsumoPromedioMovil
FROM commerce.sale s JOIN
(SELECT si.sale_code, SUM(si.quantity * si.price) AS total
FROM commerce.sale_item si
GROUP BY si.sale_code) t ON s.code = t.sale_code
GROUP BY s.code, s.sale_date
ORDER BY s.code, sale_date;

-- Consulta 9
SELECT s.sale_date, (t.total + s.delivery - s.discount) AS Consumo,
(SUM(t.total + s.delivery - s.discount) OVER
(PARTITION BY EXTRACT(MONTH FROM sale_date) ORDER BY sale_date
ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)) AS ConsumoAcumulado
FROM commerce.sale s
JOIN (
    SELECT si.sale_code, SUM(si.quantity * si.price) AS total
    FROM commerce.sale_item si
    GROUP BY si.sale_code
) t ON s.code = t.sale_code
ORDER BY sale_date;

-- Consulta 10 (diferente resultado)
SELECT s.sale_date, s.code, SUM(t.total + s.delivery - s.discount) AS Consumo,
AVG(SUM(t.total + s.delivery - s.discount)) OVER
(ORDER BY s.sale_date) AS ConsumoPromedioMovil
FROM commerce.sale s
JOIN (
    SELECT si.sale_code, SUM(si.quantity * si.price) AS total
    FROM commerce.sale_item si
    GROUP BY si.sale_code
) t ON s.code = t.sale_code
GROUP BY s.code, s.sale_date
ORDER BY s.code, s.sale_date;

-- Consulta 11
WITH SalesWithRank AS (
    SELECT
        s.sale_date,
        s.code,
        SUM(t.total + s.delivery - s.discount) AS Consumo,
        ROW_NUMBER() OVER (ORDER BY s.sale_date) AS row_num
    FROM commerce.sale s
    JOIN (
        SELECT si.sale_code, SUM(si.quantity * si.price) AS total
        FROM commerce.sale_item si
        GROUP BY si.sale_code
    ) t ON s.code = t.sale_code
    GROUP BY s.code, s.sale_date
)

SELECT
    sale_date,
    code,
    Consumo,
    AVG(Consumo) OVER (
        ORDER BY row_num
        ROWS BETWEEN 3 PRECEDING AND 3 FOLLOWING
    ) AS ConsumoPromedioMovil
FROM SalesWithRank
ORDER BY code, sale_date;
