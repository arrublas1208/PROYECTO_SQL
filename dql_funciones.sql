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


USE gestion_agroindustrial;

-- Elimina la función si existe
DROP FUNCTION IF EXISTS RedondearPrecioProducto;

-- Función para redondear el precio de un producto al entero más cercano
DELIMITER $$
CREATE FUNCTION RedondearPrecioProducto(p_ID_Producto INT)
RETURNS DECIMAL(12,0)
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE v_precio DECIMAL(12,2);

    SELECT Costo_Unitario
    INTO v_precio
    FROM precio_producto
    WHERE ID_Producto = p_ID_Producto
    LIMIT 1;

    IF v_precio IS NULL THEN
        RETURN NULL; -- producto no existe o precio nulo
    END IF;

    RETURN ROUND(v_precio);
END $$
DELIMITER ;

-- Prueba de la función RedondearPrecioProducto
SELECT RedondearPrecioProducto(1) AS Precio_Redondeado;

-- Función para calcular días desde la primera compra de un cliente
DELIMITER //
CREATE FUNCTION DiasDesdeRegistro(p_ID_Cliente INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE fecha_inicio DATE;

    SELECT MIN(Fecha_Venta)
    INTO fecha_inicio
    FROM ventas
    WHERE ID_Cliente = p_ID_Cliente;

    RETURN DATEDIFF(CURDATE(), fecha_inicio);
END //
DELIMITER ;

-- Prueba de DiasDesdeRegistro
SELECT 
    c.ID_Cliente,
    c.Nombre,
    c.Apellido,
    DiasDesdeRegistro(c.ID_Cliente) AS Dias_Desde_Registro
FROM cliente c;

-- Función para obtener las tres primeras letras de un producto
DELIMITER //
CREATE FUNCTION TresPrimerasLetrasProducto(p_ID_Producto INT)
RETURNS VARCHAR(3)
DETERMINISTIC
BEGIN
    DECLARE resultado VARCHAR(3);

    SELECT LEFT(Nombre, 3)
    INTO resultado
    FROM producto
    WHERE ID_Producto = p_ID_Producto;

    RETURN resultado;
END //
DELIMITER ;

-- Prueba de TresPrimerasLetrasProducto
SELECT 
    ID_Producto,
    Nombre,
    TresPrimerasLetrasProducto(ID_Producto) AS Iniciales
FROM producto;

-- Elimina la función de precio con IVA si existe
DROP FUNCTION IF EXISTS PrecioConIVA;

-- Función para calcular precio con IVA (19%)
DELIMITER //
CREATE FUNCTION PrecioConIVA(p_Costo DECIMAL(10,2))
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    RETURN ROUND(p_Costo * 1.19, 2);
END //
DELIMITER ;

-- Prueba de PrecioConIVA
SELECT 
    ID_Producto,
    Costo_Unitario,
    PrecioConIVA(Costo_Unitario) AS Precio_con_IVA
FROM precio_producto;

-- Función para formatear salario como moneda
DELIMITER //
CREATE FUNCTION FormatearSalario(p_Salario DECIMAL(10,2))
RETURNS VARCHAR(20)
DETERMINISTIC
BEGIN
    RETURN CONCAT('$', FORMAT(p_Salario, 2));
END //
DELIMITER ;

-- Prueba de FormatearSalario
SELECT 
    ID_Empleado,
    Nombre,
    Salario,
    FormatearSalario(Salario) AS Salario_Formateado
FROM empleado;

-- Función para calcular la longitud del nombre completo
DELIMITER //
CREATE FUNCTION LargoNombreCompleto(p_Nombre VARCHAR(50), p_Apellido VARCHAR(50))
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN CHAR_LENGTH(CONCAT(p_Nombre, ' ', p_Apellido));
END //
DELIMITER ;

-- Prueba de LargoNombreCompleto
SELECT 
    ID_Empleado,
    Nombre,
    Apellido,
    LargoNombreCompleto(Nombre, Apellido) AS Longitud
FROM empleado;

-- Función para obtener el último día del mes de una fecha dada
DELIMITER //
CREATE FUNCTION UltimoDiaMes(p_Fecha DATE)
RETURNS DATE
DETERMINISTIC
BEGIN
    RETURN LAST_DAY(p_Fecha);
END //
DELIMITER ;

-- Prueba de UltimoDiaMes
SELECT 
    ID_Empleado,
    Fecha_Contratacion,
    UltimoDiaMes(Fecha_Contratacion) AS Ultimo_Dia
FROM empleado;

-- Función para redondear a 2 decimales
DELIMITER //
CREATE FUNCTION Redondear2Dec(p_Valor DECIMAL(10,2))
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    RETURN ROUND(p_Valor, 2);
END //
DELIMITER ;

-- Prueba de Redondear2Dec
SELECT 
    Redondear2Dec(MIN(Costo_Unitario)) AS Precio_Min,
    Redondear2Dec(MAX(Costo_Unitario)) AS Precio_Max
FROM precio_producto;

-- Función para calcular promedio con 2 decimales
DELIMITER //
CREATE FUNCTION Promedio2Dec(p_Valor DECIMAL(10,2))
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    RETURN ROUND(p_Valor, 2);
END //
DELIMITER ;

-- Prueba de Promedio2Dec
SELECT 
    Promedio2Dec(AVG(Salario)) AS Salario_Promedio
FROM empleado;

-- Función para calcular días desde la fecha de contratación
DELIMITER //
CREATE FUNCTION DiasDesdeContratacion(p_Fecha DATE)
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN DATEDIFF(CURDATE(), p_Fecha);
END //
DELIMITER ;

-- Prueba de DiasDesdeContratacion
SELECT 
    ID_Empleado,
    Fecha_Contratacion,
    DiasDesdeContratacion(Fecha_Contratacion) AS Dias_Trabajados
FROM empleado;

