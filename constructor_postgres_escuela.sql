-- Crear el esquema "escuela" si no existe
CREATE SCHEMA IF NOT EXISTS escuela;

-- Crear la tabla "materia" en el esquema "escuela"
CREATE TABLE escuela.materia (
    codigo INTEGER NOT NULL,
    nombre VARCHAR(50),
    PRIMARY KEY (codigo)
);

-- Crear la tabla "docente" en el esquema "escuela"
CREATE TABLE escuela.docente (
    legajo INTEGER NOT NULL,
    nombre VARCHAR(50),
    ciudad VARCHAR(50),
    PRIMARY KEY (legajo)
);

-- Crear la tabla "alumno" en el esquema "escuela"
CREATE TABLE escuela.alumno (
    legajo INTEGER NOT NULL,
    nombre VARCHAR(50),
    ciudad VARCHAR(50),
    PRIMARY KEY (legajo)
);

-- Crear la tabla "dicta" en el esquema "escuela"
CREATE TABLE escuela.dicta (
    legajo INTEGER NOT NULL,
    codigo INTEGER NOT NULL,
    PRIMARY KEY (legajo, codigo),
    FOREIGN KEY (legajo) REFERENCES escuela.docente(legajo),
    FOREIGN KEY (codigo) REFERENCES escuela.materia(codigo)
);

-- Crear la tabla "cursa" en el esquema "escuela"
CREATE TABLE escuela.cursa (
    legajo INTEGER NOT NULL,
    codigo INTEGER NOT NULL,
    nota INTEGER,
    PRIMARY KEY (legajo, codigo),
    FOREIGN KEY (legajo) REFERENCES escuela.alumno(legajo),
    FOREIGN KEY (codigo) REFERENCES escuela.materia(codigo)
);


-- Insertar registros en la tabla "alumno" en el esquema "escuela"
INSERT INTO escuela.alumno (legajo, nombre, ciudad) VALUES
    (1, 'Arturo Illia', 'Pergamino'),
    (2, 'Arturo Frondizi', 'Paso de los Libres'),
    (3, 'Hipolito Yrigoyen', 'Buenos Aires'),
    (4, 'Juan Domingo Peron', 'Lobos'),
    (5, 'Bartolome Mitre', 'Buenos Aires');

-- Insertar registros en la tabla "docente" en el esquema "escuela"
INSERT INTO escuela.docente (legajo, nombre, ciudad) VALUES
    (1, 'Jose de San Martin', 'Yapeyu'),
    (2, 'Cornelio Saavedra', 'Otuyo'),
    (3, 'Manuel Belgrano', 'Buenos Aires'),
    (4, 'Santiago de Liniers', 'Niort'),
    (5, 'Juan Martin de Pueyredon', 'Buenos Aires');

-- Insertar registros en la tabla "materia" en el esquema "escuela"
INSERT INTO escuela.materia (codigo, nombre) VALUES
    (1, 'Matematica'),
    (2, 'Literatura'),
    (3, 'Geografia'),
    (4, 'Historia'),
    (5, 'Arte'),
    (6, 'Educacion fisica');

-- Insertar registros en la tabla "dicta" en el esquema "escuela"
INSERT INTO escuela.dicta (legajo, codigo) VALUES
    (1, 1),
    (1, 6),
    (2, 2),
    (3, 3),
    (4, 4),
    (5, 5);

-- Insertar registros en la tabla "cursa" en el esquema "escuela"
INSERT INTO escuela.cursa (legajo, codigo, nota) VALUES
    (1, 1, 7),
    (1, 2, 7),
    (1, 3, 8),
    (1, 4, 7),
    (1, 5, 9),
    (1, 6, 10),
    (2, 1, 10),
    (2, 3, 9),
    (2, 5, 9),
    (4, 2, 9),
    (4, 4, 7),
    (4, 6, 9),
    (5, 1, 10),
    (5, 5, 10);


