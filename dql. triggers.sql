-- Después de insertar un mantenimiento // Actualizar fecha último mantenimiento en maquinaria
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

-- Antes de eliminar un proveedor // Impedir si tiene compras
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

-- Después de insertar una dirección de cliente // Actualizar ciudad si está vacía
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

-- Antes de actualizar maquinaria // No poner “En uso” si está en mantenimiento activo
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

-- Después de eliminar un detalle de venta // Devolver cantidad al inventario
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

-- Antes de insertar un empleado // Verificar que el departamento exista
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

-- Después de insertar una compra // Crear registro vacío en detalles_compra
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

-- Antes de actualizar producción // No reducir cantidad ya en inventario
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

-- Después de eliminar producción // Disminuir inventario
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

-- Antes de eliminar bodega // Bloquear si tiene inventario
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


-- Después de insertar una venta // Descontar del inventario la cantidad vendida
DELIMITER //
CREATE TRIGGER tr_after_venta_insert
AFTER INSERT ON DETALLES_VENTA
FOR EACH ROW
BEGIN
    UPDATE INVENTARIO
    SET Cantidad = Cantidad - NEW.Cantidad
    WHERE ID_Producto = NEW.ID_Producto;
END //
DELIMITER ;

-- Antes de eliminar un producto // Impedir eliminar un producto que tenga ventas registradas
DELIMITER //
CREATE TRIGGER tr_before_producto_delete
BEFORE DELETE ON PRODUCTO
FOR EACH ROW
BEGIN
    DECLARE ventas_count INT;
    SELECT COUNT(*) INTO ventas_count FROM DETALLES_VENTA WHERE ID_Producto = OLD.ID_Producto;
    IF ventas_count > 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No se puede eliminar producto con ventas registradas';
    END IF;
END //
DELIMITER ;

-- Después de actualizar el salario de un empleado // Guardar en una tabla historial los cambios de salario
CREATE TABLE IF NOT EXISTS HISTORIAL_SALARIOS (
    ID_Historial INT AUTO_INCREMENT PRIMARY KEY,
    ID_Empleado INT,
    Salario_Anterior DECIMAL(10,2),
    Salario_Nuevo DECIMAL(10,2),
    Fecha_Cambio DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (ID_Empleado) REFERENCES EMPLEADO(ID_Empleado)
);

DELIMITER //
CREATE TRIGGER tr_after_salario_update
AFTER UPDATE ON EMPLEADO
FOR EACH ROW
BEGIN
    IF NEW.Salario != OLD.Salario THEN
        INSERT INTO HISTORIAL_SALARIOS (ID_Empleado, Salario_Anterior, Salario_Nuevo)
        VALUES (NEW.ID_Empleado, OLD.Salario, NEW.Salario);
    END IF;
END //
DELIMITER ;

-- Antes de insertar una maquinaria // Verificar que no exista otra maquinaria con el mismo nombre y modelo
DELIMITER //
CREATE TRIGGER tr_before_maquinaria_insert
BEFORE INSERT ON MAQUINARIA
FOR EACH ROW
BEGIN
    DECLARE maquinaria_count INT;
    SELECT COUNT(*) INTO maquinaria_count FROM MAQUINARIA
    WHERE Nombre = NEW.Nombre AND Modelo = NEW.Modelo;
    IF maquinaria_count > 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Ya existe maquinaria con este nombre y modelo';
    END IF;
END //
DELIMITER ;

-- Después de insertar un registro de producción // Aumentar el inventario con la cantidad producida
DELIMITER //
CREATE TRIGGER tr_after_produccion_insert
AFTER INSERT ON PRODUCCION
FOR EACH ROW
BEGIN
    UPDATE INVENTARIO
    SET Cantidad = Cantidad + NEW.Cantidad_Producida
    WHERE ID_Producto = NEW.ID_Producto;
END //
DELIMITER ;

-- Antes de actualizar la cantidad en inventario // Impedir que la cantidad quede en valores negativos
DELIMITER //
CREATE TRIGGER tr_before_inventario_update
BEFORE UPDATE ON INVENTARIO
FOR EACH ROW
BEGIN
    IF NEW.Cantidad < 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La cantidad en inventario no puede ser negativa';
    END IF;
END //
DELIMITER ;

-- Después de eliminar un empleado // Asignar sus producciones y mantenimientos a un registro genérico
INSERT IGNORE INTO EMPLEADO (ID_Empleado, Nombre, Apellido, Cargo)
VALUES (0, 'Empleado', 'Eliminado', 'Registro genérico');

DELIMITER //
CREATE TRIGGER tr_after_empleado_delete
AFTER DELETE ON EMPLEADO
FOR EACH ROW
BEGIN
    UPDATE PRODUCCION SET ID_Empleado = 0 WHERE ID_Empleado = OLD.ID_Empleado;
    UPDATE MANTENIMIENTO SET ID_Empleado = 0 WHERE ID_Empleado = OLD.ID_Empleado;
END //
DELIMITER ;

-- Antes de insertar un detalle de compra // Verificar que el producto exista y que el costo sea mayor que cero
DELIMITER //
CREATE TRIGGER tr_before_detallecompra_insert
BEFORE INSERT ON DETALLES_COMPRA
FOR EACH ROW
BEGIN
    DECLARE producto_count INT;
    SELECT COUNT(*) INTO producto_count FROM PRODUCTO WHERE ID_Producto = NEW.ID_Producto;

    IF producto_count = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El producto no existe';
    END IF;

    IF NEW.Costo_Unitario <= 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El costo unitario debe ser mayor que cero';
    END IF;
END //
DELIMITER ;

-- Después de insertar un detalle de compra // Incrementar el inventario con la cantidad comprada
DELIMITER //
CREATE TRIGGER tr_after_detallecompra_insert
AFTER INSERT ON DETALLES_COMPRA
FOR EACH ROW
BEGIN
    UPDATE INVENTARIO
    SET Cantidad = Cantidad + NEW.Cantidad
    WHERE ID_Producto = NEW.ID_Producto;
END //
DELIMITER ;

-- Antes de actualizar el precio de un producto // Guardar el precio anterior en un historial
CREATE TABLE IF NOT EXISTS HISTORIAL_PRECIOS (
    ID_Historial INT AUTO_INCREMENT PRIMARY KEY,
    ID_Producto INT,
    Precio_Anterior DECIMAL(10,2),
    Precio_Nuevo DECIMAL(10,2),
    Fecha_Cambio DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (ID_Producto) REFERENCES PRODUCTO(ID_Producto)
);

DELIMITER //
CREATE TRIGGER tr_before_precio_update
BEFORE UPDATE ON PRODUCTO
FOR EACH ROW
BEGIN
    IF NEW.Precio_unitario != OLD.Precio_unitario THEN
        INSERT INTO HISTORIAL_PRECIOS (ID_Producto, Precio_Anterior, Precio_Nuevo)
        VALUES (OLD.ID_Producto, OLD.Precio_unitario, NEW.Precio_unitario);
    END IF;
END //
DELIMITER ;