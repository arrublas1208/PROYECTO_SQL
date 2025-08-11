use gestion_agroindustrial;

-- 1. Calcular_Costos_Produccion_Mensual → Inserta en COSTOS el total de producción del mes
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

-- 2. Actualizar_Horas_Uso_Maquinaria → Suma 8 horas a cada maquinaria una vez al día
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

-- 3. Generar_Facturas_Mensuales → Inserta un registro ficticio en FACTURAS
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

-- 4. Verificar_Mantenimientos_Pendientes → Inserta en ALERTAS maquinaria con mantenimiento vencido
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


-- 5. Actualizar_Costo_Promedio_Producto → Aumenta PRECIO_PRODUCTO.Costo_Unitario en 1%
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

-- 6. Depurar_Direcciones_Clientes_No_Usadas → Elimina direcciones sin cliente asociado
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

-- 7. Revisar_Caducidad_Precios → Inserta en ALERTAS productos sin cambio de precio hace 180 días
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

-- 8. Generar_Reporte_Compras_Proveedores → Inserta en REPORTES el total de compras del mes
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

-- 9. Controlar_Ventas_Fuera_Horario → Inserta en ALERTAS ventas fuera de 08:00–18:00
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

-- 10. Notificar_Vencimiento_Seguros_Maquinaria → Inserta alerta si seguro vence en menos de 30 días
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
