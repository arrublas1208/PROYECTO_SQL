use gestion_agroindustrial;

-- Calcular_Costos_Produccion_Mensual → Inserta en COSTOS el total de producción del mes
DELIMITER //
CREATE EVENT Calcular_Costos_Produccion_Mensual
ON SCHEDULE EVERY 1 MONTH
STARTS '2025-09-01 00:00:00'
DO
BEGIN
    INSERT INTO costos (Mes, Anio, Total_Produccion)
    SELECT MONTH(CURDATE()), YEAR(CURDATE()), SUM(Costo_Total)
    FROM produccion
    WHERE MONTH(Fecha) = MONTH(CURDATE()) AND YEAR(Fecha) = YEAR(CURDATE());
END //
DELIMITER ;

-- Actualizar_Horas_Uso_Maquinaria → Suma 8 horas a cada maquinaria una vez al día
DELIMITER //
CREATE EVENT Actualizar_Horas_Uso_Maquinaria
ON SCHEDULE EVERY 1 DAY
STARTS '2025-08-12 00:00:00'
DO
BEGIN
    UPDATE maquinaria
    SET Horas_Uso = Horas_Uso + 8;
END //
DELIMITER ;

-- Generar_Facturas_Mensuales → Inserta un registro ficticio en FACTURAS
DELIMITER //
CREATE EVENT Generar_Facturas_Mensuales
ON SCHEDULE EVERY 1 MONTH
STARTS '2025-09-01 00:00:00'
DO
BEGIN
    INSERT INTO facturas (Fecha, Cliente, Total)
    VALUES (CURDATE(), 'Cliente Prueba', 100000);
END //
DELIMITER ;

-- Verificar_Mantenimientos_Pendientes → Inserta en ALERTAS maquinaria con mantenimiento vencido
DELIMITER //
CREATE EVENT Verificar_Mantenimientos_Pendientes
ON SCHEDULE EVERY 1 DAY
STARTS '2025-08-12 00:00:00'
DO
BEGIN
    INSERT INTO alertas (Fecha_Alerta, Mensaje)
    SELECT CURDATE(), CONCAT('Mantenimiento vencido para maquinaria ID ', ID_Maquinaria)
    FROM mantenimiento
    WHERE Fecha_Fin < CURDATE() AND Estado <> 'Completado';
END //
DELIMITER ;


-- Actualizar_Costo_Promedio_Producto → Aumenta PRECIO_PRODUCTO.Costo_Unitario en 1%
DELIMITER //
CREATE EVENT Actualizar_Costo_Promedio_Producto
ON SCHEDULE EVERY 1 MONTH
STARTS '2025-09-01 00:00:00'
DO
BEGIN
    UPDATE precio_producto
    SET Costo_Unitario = Costo_Unitario * 1.01;
END //
DELIMITER ;

-- Depurar_Direcciones_Clientes_No_Usadas → Elimina direcciones sin cliente asociado
DELIMITER //
CREATE EVENT Depurar_Direcciones_Clientes_No_Usadas
ON SCHEDULE EVERY 1 MONTH
STARTS '2025-09-01 00:00:00'
DO
BEGIN
    DELETE FROM direccion_cliente
    WHERE ID_Cliente NOT IN (SELECT ID_Cliente FROM cliente);
END //
DELIMITER ;

-- Revisar_Caducidad_Precios → Inserta en ALERTAS productos sin cambio de precio hace 180 días
DELIMITER //
CREATE EVENT Revisar_Caducidad_Precios
ON SCHEDULE EVERY 1 DAY
STARTS '2025-08-12 00:00:00'
DO
BEGIN
    INSERT INTO alertas (Fecha_Alerta, Mensaje)
    SELECT CURDATE(), CONCAT('El precio del producto ID ', ID_Producto, ' no cambia hace 180 días')
    FROM precio_producto
    WHERE DATEDIFF(CURDATE(), Fecha) >= 180;
END //
DELIMITER ;

-- Generar_Reporte_Compras_Proveedores → Inserta en REPORTES el total de compras del mes
DELIMITER //
CREATE EVENT Generar_Reporte_Compras_Proveedores
ON SCHEDULE EVERY 1 MONTH
STARTS '2025-09-01 00:00:00'
DO
BEGIN
    INSERT INTO reportes (Mes, Anio, Descripcion, Total)
    SELECT MONTH(CURDATE()), YEAR(CURDATE()), 'Total compras por proveedor', SUM(Total_Compra)
    FROM compras
    WHERE MONTH(Fecha_Compra) = MONTH(CURDATE()) AND YEAR(Fecha_Compra) = YEAR(CURDATE());
END //
DELIMITER ;

-- Controlar_Ventas_Fuera_Horario → Inserta en ALERTAS ventas fuera de 08:00–18:00
DELIMITER //
CREATE EVENT Controlar_Ventas_Fuera_Horario
ON SCHEDULE EVERY 1 DAY
STARTS '2025-08-12 00:00:00'
DO
BEGIN
    INSERT INTO alertas (Fecha_Alerta, Mensaje)
    SELECT CURDATE(), CONCAT('Venta fuera de horario ID ', ID_Venta)
    FROM ventas
    WHERE HOUR(Hora_Venta) NOT BETWEEN 8 AND 18;
END //
DELIMITER ;

-- Notificar_Vencimiento_Seguros_Maquinaria → Inserta alerta si seguro vence en menos de 30 días
DELIMITER //
CREATE EVENT Notificar_Vencimiento_Seguros_Maquinaria
ON SCHEDULE EVERY 1 DAY
STARTS '2025-08-12 00:00:00'
DO
BEGIN
    INSERT INTO alertas (Fecha_Alerta, Mensaje)
    SELECT CURDATE(), CONCAT('El seguro de la maquinaria ID ', ID_Maquinaria, ' vence pronto')
    FROM seguros_maquinaria
    WHERE DATEDIFF(Fecha_Vencimiento, CURDATE()) <= 30;
END //
DELIMITER ;


SELECT * FROM information_schema.EVENTS WHERE EVENT_SCHEMA = 'gestion_agroindustrial';




-- Evento de rotación mensual
ALTER TABLE INVENTARIO ADD COLUMN Rotacion DECIMAL(10,2) NULL;
DELIMITER //
CREATE EVENT ev_rotacion_inventario
ON SCHEDULE EVERY 1 MONTH
STARTS '2025-09-01 00:00:00'
DO
BEGIN
    UPDATE INVENTARIO i
    SET Rotacion = CASE 
        WHEN i.Cantidad > 0 
        THEN (
            SELECT IFNULL(SUM(dv.Cantidad), 0)
            FROM DETALLES_VENTA dv
            JOIN VENTAS v ON dv.ID_Venta = v.ID_Venta
            WHERE dv.ID_Producto = i.ID_Producto
            AND MONTH(v.Fecha_Venta) = MONTH(CURDATE())
            AND YEAR(v.Fecha_Venta) = YEAR(CURDATE())
        ) / i.Cantidad
        ELSE NULL 
    END;
END;
//
DELIMITER ;


-- Marcar maquinaria con más de 1000 horas como "Mantenimiento"
CREATE EVENT ev_maquinaria_mantenimiento
ON SCHEDULE EVERY 1 DAY
STARTS '2025-08-12 03:00:00'
DO
UPDATE MAQUINARIA
SET Estado = 'Mantenimiento'
WHERE Horas_Uso > 1000;

--  Resetear a "Operativa" la maquinaria que esté en mantenimiento menos de 1000 horas
CREATE EVENT ev_maquinaria_operativa
ON SCHEDULE EVERY 1 DAY
STARTS '2025-08-12 03:10:00'
DO
UPDATE MAQUINARIA
SET Estado = 'Operativa'
WHERE Estado = 'Mantenimiento' AND Horas_Uso <= 1000;

--  Rotación de maquinaria mensual (>500 horas)
CREATE EVENT ev_rotacion_maquinaria
ON SCHEDULE EVERY 1 MONTH
STARTS '2025-09-01 00:05:00'
DO
UPDATE MAQUINARIA
SET Estado = 'En Rotacion'
WHERE Horas_Uso > 500 AND Estado != 'Mantenimiento';

--  Limpiar inventario con cantidad negativa
CREATE EVENT ev_limpiar_inventario_negativo
ON SCHEDULE EVERY 1 DAY
STARTS '2025-08-12 02:00:00'
DO
UPDATE INVENTARIO
SET Cantidad = 0
WHERE Cantidad < 0;

--  Registrar ventas diarias en una tabla de resumen
CREATE EVENT ev_resumen_ventas_diario
ON SCHEDULE EVERY 1 DAY
STARTS '2025-08-12 23:59:00'
DO
INSERT INTO resumen_ventas (Fecha, Total_Ventas)
SELECT CURDATE(), IFNULL(SUM(dv.Cantidad * p.Precio), 0)
FROM DETALLES_VENTA dv
JOIN PRODUCTO p ON dv.ID_Producto = p.ID_Producto
JOIN VENTAS v ON dv.ID_Venta = v.ID_Venta
WHERE DATE(v.Fecha_Venta) = CURDATE();

--  Marcar productos sin ventas en el último mes como "Bajo movimiento"
CREATE EVENT ev_marcar_bajo_movimiento
ON SCHEDULE EVERY 1 MONTH
STARTS '2025-09-01 01:00:00'
DO
UPDATE PRODUCTO
SET Tipo = 'Bajo movimiento'
WHERE ID_Producto NOT IN (
    SELECT DISTINCT dv.ID_Producto
    FROM DETALLES_VENTA dv
    JOIN VENTAS v ON dv.ID_Venta = v.ID_Venta
    WHERE v.Fecha_Venta >= DATE_SUB(CURDATE(), INTERVAL 1 MONTH)
);

--  Aumentar horas de uso de maquinaria cada día (simulación)
CREATE EVENT ev_sumar_horas_maquinaria
ON SCHEDULE EVERY 1 DAY
STARTS '2025-08-12 04:00:00'
DO
UPDATE MAQUINARIA
SET Horas_Uso = Horas_Uso + 8
WHERE Estado != 'Mantenimiento';

--  Ajustar inventario por ventas del día
CREATE EVENT ev_ajustar_inventario
ON SCHEDULE EVERY 1 DAY
STARTS '2025-08-12 23:50:00'
DO
UPDATE INVENTARIO i
JOIN (
    SELECT dv.ID_Producto, SUM(dv.Cantidad) AS Vendidas
    FROM DETALLES_VENTA dv
    JOIN VENTAS v ON dv.ID_Venta = v.ID_Venta
    WHERE DATE(v.Fecha_Venta) = CURDATE()
    GROUP BY dv.ID_Producto
) ventas ON i.ID_Producto = ventas.ID_Producto
SET i.Cantidad = i.Cantidad - ventas.Vendidas;

-- Marcar maquinaria inactiva si no ha tenido uso en un mes
CREATE EVENT ev_marcar_inactiva
ON SCHEDULE EVERY 1 MONTH
STARTS '2025-09-01 02:00:00'
DO
UPDATE MAQUINARIA
SET Estado = 'Inactiva'
WHERE Horas_Uso = 0;
