-- Procedimiento para registrar un nuevo cliente
DELIMITER //
CREATE PROCEDURE Agregar_clientes (
    IN N_ID_Cliente INT,
    IN N_Nombre VARCHAR(50),
    IN N_Apellido VARCHAR(50),
    IN N_Telefono VARCHAR(20),
    IN N_Email VARCHAR(50),
    IN N_Tipo VARCHAR(45)
)
BEGIN
    INSERT INTO CLIENTE(ID_Cliente, Nombre, Apellido, Telefono, Email, Tipo)
    VALUES (N_ID_Cliente, N_Nombre, N_Apellido, N_Telefono, N_Email, N_Tipo);
END;
//
DELIMITER ;


-- Procedimiento para actualizar precios de productos manteniendo histórico
DELIMITER //
CREATE PROCEDURE Modificar_precio (
    IN N_ID_Precio INT,
    IN N_ID_Producto INT,
    IN N_Costo_Unitario DECIMAL(10,2)
)
BEGIN
    DECLARE N_Fecha DATE;
    SET N_Fecha = CURRENT_DATE();
    INSERT INTO PRECIO_PRODUCTO(ID_Precio, ID_Producto, Fecha, Costo_Unitario)
    VALUES (N_ID_Precio, N_ID_Producto, N_Fecha, N_Costo_Unitario);
END;
//
DELIMITER ;


-- Procedimiento para generar reporte de ventas por período
DELIMITER //
CREATE PROCEDURE Reporte_Ventas(
    IN Inicio DATE,
    IN Fin DATE
)
BEGIN
    SELECT v.ID_Cliente, dv.ID_Producto, dv.Cantidad, dv.Precio_Por_Unidad, v.Fecha_Venta
    FROM VENTAS v
    JOIN DETALLES_VENTA dv ON v.ID_Venta  = dv.ID_Venta
    WHERE v.Fecha_Venta BETWEEN Inicio AND Fin;
END;
//
DELIMITER ;


-- Procedimiento para calcular la rotación de inventario (ventas / stock actual)
DELIMITER //
CREATE PROCEDURE Rotacion_Inventario()
BEGIN
    SELECT 
        p.ID_Producto,
        p.Nombre,
        IFNULL(SUM(dv.Cantidad), 0) AS Total_Vendido,
        IFNULL(inv.Cantidad, 0) AS Stock_Actual,
        CASE 
            WHEN IFNULL(inv.Cantidad, 0) > 0 THEN 
                ROUND(SUM(dv.Cantidad) / inv.Cantidad, 2)
            ELSE 0
        END AS Rotacion
    FROM PRODUCTO p
    LEFT JOIN DETALLES_VENTA dv ON p.ID_Producto = dv.ID_Producto
    LEFT JOIN INVENTARIO inv ON p.ID_Producto = inv.ID_Producto
    GROUP BY p.ID_Producto, p.Nombre, inv.Cantidad;
END;
//
DELIMITER ;


-- Procedimiento para registrar producción diaria
DELIMITER //
CREATE PROCEDURE Registrar_Produccion(
    IN N_ID_Produccion INT,
    IN N_ID_Producto INT,
    IN N_Cantidad_Producida INT,
    IN N_Fecha_Cosecha DATE,
    IN N_ID_Empleado INT,
    IN N_ID_Maquinaria INT
)
BEGIN
    INSERT INTO PRODUCCION(ID_Produccion, ID_Producto, Cantidad_Producida, Fecha_Cosecha, ID_Empleado, ID_Maquinaria)
    VALUES (N_ID_Produccion, N_ID_Producto, N_Cantidad_Producida, N_Fecha_Cosecha, N_ID_Empleado, N_ID_Maquinaria);
END;
//
DELIMITER ;


-- Procedimiento para programar mantenimiento de maquinaria
DELIMITER //
CREATE PROCEDURE Programar_Mantenimiento(
    IN N_ID_Mantenimiento INT,
    IN N_ID_Maquinaria INT,
    IN N_Fecha DATE,
    IN N_Descripcion TEXT,
    IN N_Costo DECIMAL(10,2)
)
BEGIN
    INSERT INTO MANTENIMIENTO(ID_Mantenimiento, ID_Maquinaria, Fecha, Descripcion, Costo)
    VALUES (N_ID_Mantenimiento, N_ID_Maquinaria, N_Fecha, N_Descripcion, N_Costo);
END;
//
DELIMITER ;


-- Procedimiento para generar una compra con sus detalles
DELIMITER //
CREATE PROCEDURE Generar_Compra(
    IN N_ID_Compra INT,
    IN N_ID_Proveedor INT,
    IN N_Fecha_Compra DATETIME,
    IN N_ID_Detalle_Compra INT,
    IN N_ID_Producto INT,
    IN N_Cantidad INT,
    IN N_Costo_Unitario DECIMAL(10,2)
)
BEGIN
    INSERT INTO COMPRAS(ID_Compra, ID_Proveedor, Fecha_Compra)
    VALUES (N_ID_Compra, N_ID_Proveedor, N_Fecha_Compra);

    INSERT INTO DETALLES_COMPRA(ID_Detalle_Compra, ID_Compra, ID_Producto, Cantidad, Costo_Unitario)
    VALUES (N_ID_Detalle_Compra, N_ID_Compra, N_ID_Producto, N_Cantidad, N_Costo_Unitario);
END;
//
DELIMITER ;


-- Procedimiento para actualizar niveles de inventario
DELIMITER //
CREATE PROCEDURE Actualizar_Inventario(
    IN N_ID_Producto INT,
    IN N_ID_Bodega INT,
    IN N_Cantidad INT
)
BEGIN
    IF EXISTS (
        SELECT 1 FROM INVENTARIO 
        WHERE ID_Producto = N_ID_Producto AND ID_Bodega = N_ID_Bodega
    ) THEN
        UPDATE INVENTARIO
        SET Cantidad = Cantidad + N_Cantidad,
            Fecha_Ultima_Actualizacion = CURRENT_DATE()
        WHERE ID_Producto = N_ID_Producto AND ID_Bodega = N_ID_Bodega;
    ELSE
        INSERT INTO INVENTARIO(ID_Inventario, ID_Producto, ID_Bodega, Cantidad, Fecha_Ultima_Actualizacion)
        VALUES ((SELECT IFNULL(MAX(ID_Inventario),0) + 1 FROM INVENTARIO), N_ID_Producto, N_ID_Bodega, N_Cantidad, CURRENT_DATE());
    END IF;
END;
//
DELIMITER ;


-- Procedimiento para buscar productos por tipo
DELIMITER //
CREATE PROCEDURE Buscar_Producto_Tipo(
    IN N_Tipo VARCHAR(50)
)
BEGIN
    SELECT * FROM PRODUCTO WHERE Tipo = N_Tipo;
END;
//
DELIMITER ;


-- Procedimiento para calcular nómina total por departamento
DELIMITER //
CREATE PROCEDURE Nomina_Departamento()
BEGIN
    SELECT 
        d.Nombre AS Departamento,
        SUM(e.Salario) AS Total_Nomina
    FROM EMPLEADO e
    JOIN DEPARTAMENTO d ON e.ID_Departamento = d.ID_Departamento
    GROUP BY d.Nombre;
END;
//
DELIMITER ;
