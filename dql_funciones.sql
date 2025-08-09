-- Calcular el salario anual de cada empleado
DROP FUNCTION IF EXISTS Salario_Anual;
DELIMITER //

CREATE FUNCTION Salario_Anual(p_salario_mensual DECIMAL(10,2))
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN 
    DECLARE v_total DECIMAL(10,2);
    SET v_total = p_salario_mensual * 12;
    RETURN v_total;
END;
//
DELIMITER ;

SELECT nombre, Salario_Anual(Salario) AS Salario_Anual
FROM empleado;


-- Mostrar el precio con un incremento del 10%
DROP FUNCTION IF EXISTS Precio_Incremento;
DELIMITER //

CREATE FUNCTION Precio_Incremento(p_precio DECIMAL(10,2))
RETURNS DECIMAL(10,2)
DETERMINISTIC 
BEGIN 
    DECLARE v_incremento DECIMAL(10,2);
    SET v_incremento = p_precio * 0.10;
    RETURN p_precio + v_incremento;
END;
//
DELIMITER ;

SELECT nombre, Precio_Incremento(Precio_unitario) AS Precio_Incrementado
FROM producto;


-- Obtener el precio de un producto por nombre
DROP FUNCTION IF EXISTS Precio_Producto;
DELIMITER //

CREATE FUNCTION Precio_Producto(p_nombre VARCHAR(100))
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE v_precio DECIMAL(10,2);
    SELECT Precio_unitario 
    INTO v_precio
    FROM producto
    WHERE Nombre = p_nombre
    LIMIT 1;
    RETURN v_precio;
END;
//
DELIMITER ;

SELECT Nombre, Precio_Producto('Tomate') AS Precio
FROM producto;


-- Concatenar nombre y apellido de un empleado
DROP FUNCTION IF EXISTS Nombre_Completo;
DELIMITER //

CREATE FUNCTION Nombre_Completo(p_id INT)
RETURNS VARCHAR(200)
DETERMINISTIC 
BEGIN 
    DECLARE v_nombre_completo VARCHAR(200);
    SELECT CONCAT(Nombre, ' ', Apellido)
    INTO v_nombre_completo
    FROM empleado
    WHERE ID_Empleado = p_id
    LIMIT 1;
    RETURN v_nombre_completo;
END;
//
DELIMITER ;

SELECT Nombre_Completo(1);


-- Nombre del cliente en mayúsculas
DROP FUNCTION IF EXISTS Upper_Cliente;
DELIMITER //

CREATE FUNCTION Upper_Cliente(p_id INT)
RETURNS VARCHAR(200)
DETERMINISTIC
BEGIN
    DECLARE v_nombre_cliente VARCHAR(200);
    SELECT UPPER(Nombre)
    INTO v_nombre_cliente
    FROM cliente
    WHERE ID_Cliente = p_id
    LIMIT 1;
    RETURN v_nombre_cliente;
END;
//
DELIMITER ;

SELECT Upper_Cliente(1);

-- Mostrar el nombre del cliente en minúsculas
DELIMITER //
CREATE FUNCTION cliente_minusculas(nombre_cliente VARCHAR(255))
RETURNS VARCHAR(255)
DETERMINISTIC
BEGIN
    RETURN LOWER(nombre_cliente);
END //
DELIMITER ;

-- Extraer el año de la fecha de contratación de cada empleado
DELIMITER //
CREATE FUNCTION anio_contratacion(fecha_contratacion DATE)
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN YEAR(fecha_contratacion);
END //
DELIMITER ;

-- Mostrar solo el mes de la fecha de contratación de cada empleado
DELIMITER //
CREATE FUNCTION mes_contratacion(fecha_contratacion DATE)
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN MONTH(fecha_contratacion);
END //
DELIMITER ;

-- Obtener la longitud del nombre de cada producto
DELIMITER //
CREATE FUNCTION longitud_producto(nombre_producto VARCHAR(255))
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN CHAR_LENGTH(nombre_producto);
END //
DELIMITER ;

-- Reemplazar la palabra "Azúcar" por "Endulzante" en los nombres de los productos
DELIMITER //
CREATE FUNCTION reemplazar_azucar(nombre_producto VARCHAR(255))
RETURNS VARCHAR(255)
DETERMINISTIC
BEGIN
    RETURN REPLACE(nombre_producto, 'Azúcar', 'Endulzante');
END //
DELIMITER ;

