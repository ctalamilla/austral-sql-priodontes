-- 1. Listar los nombres de los alumnos (escuela.alumno.nombre).
SELECT nombre FROM escuela.alumno;

-- 2. Listar los nombres de los alumnos de la ciudad de 'Buenos Aires' (escuela.alumno.nombre).
SELECT nombre FROM escuela.alumno WHERE ciudad = 'Buenos Aires';

-- 3. Listar los nombres de las materias que contienen la letra 'i' como segundo caracter en su nombre (escuela.materia.nombre).
SELECT nombre FROM escuela.materia WHERE nombre LIKE '_i%';

-- 4. Listar los nombres de los alumnos que cursan materias (escuela.alumno.nombre).
SELECT a.nombre
FROM escuela.alumno a
WHERE EXISTS (
    SELECT 1
    FROM escuela.cursa c
    WHERE c.legajo = a.legajo
);

-- 5. Listar los nombres de los alumnos que no cursan materias (escuela.alumno.nombre).
SELECT a.nombre
FROM escuela.alumno a
WHERE NOT EXISTS (
    SELECT 1
    FROM escuela.cursa c
    WHERE c.legajo = a.legajo
);

-- 6. Listar los nombres de las materias de los alumnos de la ciudad de 'Buenos Aires' (escuela.materia.nombre).
SELECT m.nombre
FROM escuela.materia m
WHERE EXISTS (
    SELECT 1
    FROM escuela.alumno a
    JOIN escuela.cursa c ON c.legajo = a.legajo
    WHERE a.ciudad = 'Buenos Aires' AND c.codigo = m.codigo
);

-- 7. Listar el promedio de nota de cada materia (escuela.materia.codigo, escuela.materia.nombre, promedio).
SELECT m.codigo, m.nombre, AVG(c.nota) AS promedio
FROM escuela.materia m
JOIN escuela.cursa c ON c.codigo = m.codigo
GROUP BY m.codigo, m.nombre;

-- 8. Listar las materias cuyo promedio es mayor a 8 (escuela.materia.codigo, escuela.materia.nombre, promedio).
SELECT m.codigo, m.nombre, AVG(c.nota) AS promedio
FROM escuela.materia m
JOIN escuela.cursa c ON c.codigo = m.codigo
GROUP BY m.codigo, m.nombre
HAVING AVG(c.nota) > 8;

-- 9. Listar la cantidad de materias dictadas por cada docente (escuela.docente.legajo, escuela.docente.nombre, cantidad).
SELECT d.legajo, d.nombre, COUNT(di.codigo) AS cantidad
FROM escuela.docente d
JOIN escuela.dicta di ON d.legajo = di.legajo
GROUP BY d.legajo, d.nombre;

-- 10. Listar los nombres de los alumnos que cursan materias de docentes de su ciudad (escuela.alumno.nombre).
SELECT a.nombre
FROM escuela.alumno a
JOIN escuela.cursa c ON a.legajo = c.legajo
JOIN escuela.dicta di ON c.codigo = di.codigo
JOIN escuela.docente d ON di.legajo = d.legajo
WHERE a.ciudad = d.ciudad;

-- 11. Listar los docentes que dictan sólo una materia (escuela.docente.legajo, escuela.docente.nombre).
SELECT d.legajo, d.nombre
FROM escuela.docente d
JOIN escuela.dicta di ON di.legajo = d.legajo
GROUP BY d.legajo, d.nombre
HAVING COUNT(di.codigo) = 1;

-- 12. Listar por cada materia la cantidad de cursantes, la nota menor, la nota mayor y la nota promedio (escuela.materia.codigo, escuela.materia.nombre, cantidad, menor, mayor, promedio).
SELECT m.codigo, m.nombre, COUNT(c.legajo) AS cantidad, MIN(c.nota) AS menor, MAX(c.nota) AS mayor, AVG(c.nota) AS promedio
FROM escuela.materia m
JOIN escuela.cursa c ON m.codigo = c.codigo
GROUP BY m.codigo, m.nombre;

-- 13. Listar los nombres de los alumnos que cursan todas las materias (escuela.alumno.nombre).
SELECT a.nombre
FROM escuela.alumno a
WHERE NOT EXISTS (
    SELECT 1
    FROM escuela.materia m
    WHERE NOT EXISTS (
        SELECT 1
        FROM escuela.cursa c
        WHERE c.codigo = m.codigo AND c.legajo = a.legajo
    )
);

-- 14. Listar los nombres de los docentes que dictan materias sólo a alumnos que no son de su ciudad (escuela.docente.nombre).
SELECT d.nombre
FROM escuela.docente d
WHERE NOT EXISTS (
    SELECT 1
    FROM escuela.cursa c
    JOIN escuela.dicta di ON c.codigo = di.codigo
    JOIN escuela.alumno a ON c.legajo = a.legajo
    WHERE a.ciudad = d.ciudad AND di.legajo = d.legajo
);

-- 15. Listar los nombres de los alumnos que cursan todas las materias dictadas por 'Jose de San Martin' (escuela.alumno.nombre).
SELECT a.nombre
FROM escuela.alumno a
WHERE NOT EXISTS (
    SELECT 1
    FROM escuela.dicta di
    JOIN escuela.docente d ON d.legajo = di.legajo
    WHERE d.nombre = 'Jose de San Martin' AND NOT EXISTS (
        SELECT 1
        FROM escuela.cursa c
        WHERE c.codigo = di.codigo AND c.legajo = a.legajo
    )
);
