-- 1. Después de insertar un mantenimiento → Actualizar fecha último mantenimiento en maquinaria
DELIMITER //
CREATE TRIGGER trg_mantenimiento_actualiza_maquinaria
AFTER INSERT ON mantenimiento
FOR EACH ROW
BEGIN
    UPDATE maquinaria
    SET Fecha_Ultimo_Mantenimiento = NEW.Fecha_Mantenimiento
    WHERE ID_Maquinaria = NEW.ID_Maquinaria;
END //
DELIMITER ;

-- Prueba
INSERT INTO mantenimiento (ID_Mantenimiento, ID_Maquinaria, Fecha_Mantenimiento, Descripcion)
VALUES (1, 1, '2025-08-10', 'Cambio de aceite');
SELECT * FROM maquinaria WHERE ID_Maquinaria = 1;

-- 2. Antes de eliminar un proveedor → Impedir si tiene compras
DELIMITER //
CREATE TRIGGER trg_proveedor_con_compras
BEFORE DELETE ON proveedor
FOR EACH ROW
BEGIN
    IF EXISTS (SELECT 1 FROM compras WHERE ID_Proveedor = OLD.ID_Proveedor) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'No se puede eliminar un proveedor con compras registradas';
    END IF;
END //
DELIMITER ;

-- Prueba
DELETE FROM proveedor WHERE ID_Proveedor = 1;

-- 3. Después de insertar una dirección de cliente → Actualizar ciudad si está vacía
DELIMITER //
CREATE TRIGGER trg_direccion_actualiza_cliente
AFTER INSERT ON direccion_cliente
FOR EACH ROW
BEGIN
    UPDATE cliente
    SET Ciudad = NEW.Ciudad
    WHERE ID_Cliente = NEW.ID_Cliente
    AND (Ciudad IS NULL OR Ciudad = '');
END //
DELIMITER ;

-- Prueba
INSERT INTO direccion_cliente (ID_Direccion, ID_Cliente, Calle, Ciudad)
VALUES (1, 1, 'Calle 123', 'Bogotá');
SELECT ID_Cliente, Ciudad FROM cliente WHERE ID_Cliente = 1;

-- 4. Antes de actualizar maquinaria → No poner “En uso” si está en mantenimiento activo
DELIMITER //
CREATE TRIGGER trg_maquinaria_no_en_uso_mantenimiento
BEFORE UPDATE ON maquinaria
FOR EACH ROW
BEGIN
    IF NEW.Estado = 'En uso' AND EXISTS (
        SELECT 1 FROM mantenimiento
        WHERE ID_Maquinaria = OLD.ID_Maquinaria
        AND Fecha_Fin IS NULL
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'No se puede poner en uso maquinaria con mantenimiento activo';
    END IF;
END //
DELIMITER ;

-- Prueba
UPDATE maquinaria SET Estado = 'En uso' WHERE ID_Maquinaria = 1;

-- 5. Después de eliminar un detalle de venta → Devolver cantidad al inventario
DELIMITER //
CREATE TRIGGER trg_detalle_venta_devuelve_inventario
AFTER DELETE ON detalles_venta
FOR EACH ROW
BEGIN
    UPDATE inventario
    SET Cantidad = Cantidad + OLD.Cantidad
    WHERE ID_Producto = OLD.ID_Producto;
END //
DELIMITER ;

-- Prueba
DELETE FROM detalles_venta WHERE ID_Venta = 1 AND ID_Producto = 1;
SELECT * FROM inventario WHERE ID_Producto = 1;

-- 6. Antes de insertar un empleado → Verificar que el departamento exista
DELIMITER //
CREATE TRIGGER trg_empleado_departamento_existe
BEFORE INSERT ON empleado
FOR EACH ROW
BEGIN
    IF NOT EXISTS (SELECT 1 FROM departamento WHERE ID_Departamento = NEW.ID_Departamento) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El departamento asignado no existe';
    END IF;
END //
DELIMITER ;

-- Prueba
INSERT INTO empleado (ID_Empleado, Nombre, Apellido, ID_Departamento)
VALUES (1, 'Juan', 'Pérez', 999);

-- 7. Después de insertar una compra → Crear registro vacío en detalles_compra
DELIMITER //
CREATE TRIGGER trg_compra_crea_detalle
AFTER INSERT ON compras
FOR EACH ROW
BEGIN
    INSERT INTO detalles_compra (ID_Compra, ID_Producto, Cantidad, Precio_Por_Unidad)
    VALUES (NEW.ID_Compra, NULL, 0, 0.00);
END //
DELIMITER ;

-- Prueba
INSERT INTO compras (ID_Compra, ID_Proveedor, Fecha_Compra)
VALUES (10, 1, '2025-08-10');
SELECT * FROM detalles_compra WHERE ID_Compra = 10;

-- 8. Antes de actualizar producción → No reducir cantidad ya en inventario
DELIMITER //
CREATE TRIGGER trg_produccion_no_disminuir
BEFORE UPDATE ON produccion
FOR EACH ROW
BEGIN
    DECLARE cantidad_inventario INT;
    SELECT Cantidad INTO cantidad_inventario
    FROM inventario
    WHERE ID_Producto = OLD.ID_Producto;

    IF NEW.Cantidad < OLD.Cantidad AND cantidad_inventario >= OLD.Cantidad THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'No se puede reducir la cantidad producida ya registrada en inventario';
    END IF;
END //
DELIMITER ;

-- Prueba
UPDATE produccion SET Cantidad = Cantidad - 10 WHERE ID_Produccion = 1;

-- 9. Después de eliminar producción → Disminuir inventario
DELIMITER //
CREATE TRIGGER trg_produccion_eliminada_disminuye_inventario
AFTER DELETE ON produccion
FOR EACH ROW
BEGIN
    UPDATE inventario
    SET Cantidad = Cantidad - OLD.Cantidad
    WHERE ID_Producto = OLD.ID_Producto;
END //
DELIMITER ;

-- Prueba
DELETE FROM produccion WHERE ID_Produccion = 1;
SELECT * FROM inventario WHERE ID_Producto = 1;

-- 10. Antes de eliminar bodega → Bloquear si tiene inventario
DELIMITER //
CREATE TRIGGER trg_bodega_con_inventario
BEFORE DELETE ON bodega
FOR EACH ROW
BEGIN
    IF EXISTS (SELECT 1 FROM inventario WHERE ID_Bodega = OLD.ID_Bodega) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'No se puede eliminar una bodega con inventario asociado';
    END IF;
END //
DELIMITER ;

-- Prueba
DELETE FROM bodega WHERE ID_Bodega = 1;
