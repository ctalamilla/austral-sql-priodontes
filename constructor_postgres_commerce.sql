-- Crear el esquema "commerce" si no existe
CREATE SCHEMA IF NOT EXISTS commerce;

-- Crear las tablas en el esquema "commerce"
CREATE TABLE commerce.customer (
    code INTEGER NOT NULL,
    name VARCHAR(50),
    city VARCHAR(50),
    PRIMARY KEY (code)
);

CREATE TABLE commerce.product (
    code INTEGER NOT NULL,
    name VARCHAR(50),
    cost DECIMAL(10,2),
    price DECIMAL(10,2),
    PRIMARY KEY (code)
);

CREATE TABLE commerce.store (
    code INTEGER NOT NULL,
    name VARCHAR(50),
    city VARCHAR(50),
    PRIMARY KEY (code)
);

CREATE TABLE commerce.supplier (
    code INTEGER NOT NULL,
    name VARCHAR(50),
    city VARCHAR(50),
    PRIMARY KEY (code)
);

CREATE TABLE commerce.warehouse (
    code INTEGER NOT NULL,
    name VARCHAR(50),
    city VARCHAR(50),
    PRIMARY KEY (code)
);

CREATE TABLE commerce.product_supplier (
    product_code INTEGER NOT NULL,
    supplier_code INTEGER NOT NULL,
    PRIMARY KEY (product_code, supplier_code),
    FOREIGN KEY (product_code) REFERENCES commerce.product(code),
    FOREIGN KEY (supplier_code) REFERENCES commerce.supplier(code)
);

CREATE TABLE commerce.sale (
    code INTEGER NOT NULL,
    customer_code INTEGER NOT NULL,
    store_code INTEGER NOT NULL,
    sale_date DATE,
    delivery DECIMAL(10,2),
    discount DECIMAL(10,2),
    PRIMARY KEY (code),
    FOREIGN KEY (customer_code) REFERENCES commerce.customer(code),
    FOREIGN KEY (store_code) REFERENCES commerce.store(code)
);

CREATE TABLE commerce.sale_item (
    sale_code INTEGER NOT NULL,
    product_code INTEGER NOT NULL,
    quantity INTEGER,
    cost DECIMAL(10,2),
    price DECIMAL(10,2),
    PRIMARY KEY (sale_code, product_code),
    FOREIGN KEY (sale_code) REFERENCES commerce.sale(code),
    FOREIGN KEY (product_code) REFERENCES commerce.product(code)
);

CREATE TABLE commerce.stock (
    product_code INTEGER NOT NULL,
    warehouse_code INTEGER NOT NULL,
    quantity INTEGER,
    PRIMARY KEY (product_code, warehouse_code),
    FOREIGN KEY (product_code) REFERENCES commerce.product(code),
    FOREIGN KEY (warehouse_code) REFERENCES commerce.warehouse(code)
);

-- Insertar registros en las tablas en el esquema "commerce"
INSERT INTO commerce.customer (code, name, city) VALUES
    (1, 'Arturo Illia', 'Pergamino'),
    (2, 'Arturo Frondizi', 'Paso de los Libres'),
    (3, 'Hipolito Yrigoyen', 'Buenos Aires'),
    (4, 'Bartolome Mitre', 'Buenos Aires');

INSERT INTO commerce.product (code, name, cost, price) VALUES
    (1, 'Earth', 234.00, 345.00),
    (2, 'Air', 432.00, 543.00),
    (3, 'Water', 345.00, 456.00),
    (4, 'Fire', 543.00, 654.00);

INSERT INTO commerce.store (code, name, city) VALUES
    (1, 'Pergamino', 'Pergamino'),
    (2, 'Libres', 'Paso de los Libres'),
    (3, 'Baires I', 'Buenos Aires'),
    (4, 'Baires II', 'Buenos Aires');

INSERT INTO commerce.supplier (code, name, city) VALUES
    (1, 'Bandera', 'Rosario'),
    (2, 'Batalla', 'Maipu'),
    (3, 'Revolucion', 'Buenos Aires'),
    (4, 'Independencia', 'Tucuman');

INSERT INTO commerce.warehouse (code, name, city) VALUES
    (1, 'Pergamino', 'Pergamino'),
    (2, 'Baires I', 'Buenos Aires'),
    (3, 'Baires II', 'Buenos Aires');

INSERT INTO commerce.stock (product_code, warehouse_code, quantity) VALUES
    (1, 1, 10),
    (1, 2, 25),
    (2, 1, 15),
    (2, 3, 10),
    (3, 1, 20),
    (3, 2, 20),
    (4, 1, 25),
    (4, 3, 14);

INSERT INTO commerce.product_supplier (product_code, supplier_code) VALUES
    (1, 1),
    (1, 3),
    (1, 4),
    (2, 2),
    (2, 3),
    (3, 1),
    (3, 3),
    (4, 2),
    (4, 3),
    (4, 4);

INSERT INTO commerce.sale (code, customer_code, store_code, sale_date, delivery, discount) VALUES
    (10, 1, 1, '2016-01-01', 10.00, 0.00),
    (11, 2, 4, '2016-02-01', 10.00, 10.00),
    (12, 3, 1, '2016-02-01', 10.00, 20.00),
    (20, 1, 2, '2016-01-02', 20.00, 10.00),
    (21, 2, 4, '2016-02-02', 20.00, 20.00),
    (22, 3, 3, '2016-02-02', 20.00, 30.00),
    (30, 1, 3, '2016-02-03', 30.00, 20.00),
    (31, 2, 4, '2016-02-03', 30.00, 30.00),
    (32, 3, 1, '2016-02-03', 30.00, 0.00),
    (40, 1, 4, '2016-02-04', 40.00, 30.00),
    (41, 2, 4, '2016-02-04', 40.00, 0.00),
    (42, 3, 3, '2016-02-04', 40.00, 10.00),
    (50, 2, 4, '2016-02-05', 0.00, 0.00),
    (51, 2, 4, '2016-02-05', 0.00, 10.00),
    (52, 4, 4, '2016-02-05', 0.00, 20.00);

INSERT INTO commerce.sale_item (sale_code, product_code, quantity, cost, price) VALUES
    (10, 1, 1, 123.00, 234.00),
    (11, 4, 1, 543.00, 632.00),
    (12, 1, 1, 123.00, 234.00),
    (20, 1, 2, 123.00, 234.00),
    (20, 2, 1, 421.00, 532.00),
    (21, 2, 3, 421.00, 532.00),
    (22, 2, 3, 432.00, 543.00),
    (30, 1, 2, 123.00, 234.00),
    (30, 4, 1, 543.00, 632.00),
    (31, 4, 3, 543.00, 632.00),
    (32, 1, 3, 234.00, 345.00),
    (40, 1, 1, 234.00, 345.00),
    (41, 2, 2, 432.00, 543.00),
    (42, 2, 2, 432.00, 543.00),
    (50, 2, 1, 421.00, 532.00),
    (51, 4, 2, 543.00, 654.00),
    (52, 4, 4, 543.00, 654.00);
