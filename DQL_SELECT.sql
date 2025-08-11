use gestion_agroindustrial;





-- Listar todos los clientes con sus datos personales
SELECT * FROM CLIENTE;

-- Mostrar los productos con precio unitario mayor a $2000
SELECT * FROM PRODUCTO WHERE Precio_unitario > 2000;

-- Listar las ventas realizadas en enero de 2023
SELECT * FROM VENTAS 
WHERE Fecha_Venta BETWEEN '2023-01-01' AND '2023-01-31';

-- Mostrar los proveedores de la ciudad de Bogotá
SELECT * FROM PROVEEDOR 
WHERE Direccion LIKE '%Bogotá%';

-- Listar los empleados contratados después del 1/1/2020
SELECT * FROM EMPLEADO 
WHERE Fecha_Contratacion > '2020-01-01';

-- Mostrar las máquinas con más de 1500 horas de uso
SELECT * FROM MAQUINARIA 
WHERE Horas_Uso > 1500;

-- Listar los productos del tipo "Granos"
SELECT * FROM PRODUCTO 
WHERE Tipo = 'Granos';

-- Mostrar las ventas pagadas con tarjeta de crédito
SELECT * FROM VENTAS 
WHERE Metodo_Pago = 'Tarjeta de crédito';

-- Listar los clientes de tipo "Mayorista"
SELECT * FROM CLIENTE 
WHERE Tipo = 'Mayorista';

-- Mostrar los productos ordenados por precio descendente
SELECT * FROM PRODUCTO 
ORDER BY Precio_unitario DESC;

-- Listar las bodegas ubicadas en Antioquia
SELECT * FROM BODEGA 
WHERE Ubicacion LIKE '%Antioquia%';

-- Mostrar los mantenimientos con costo mayor a $300,000
SELECT * FROM MANTENIMIENTO 
WHERE Costo > 300000;

-- Listar los departamentos de la empresa
SELECT * FROM DEPARTAMENTO;

-- Mostrar las compras realizadas al proveedor con ID 5
SELECT * FROM COMPRAS 
WHERE ID_Proveedor = 5;

-- Listar los productos con menos de 100 unidades en inventario
SELECT p.ID_Producto, p.Nombre, i.Cantidad 
FROM PRODUCTO p
JOIN INVENTARIO i ON p.ID_Producto = i.ID_Producto
WHERE i.Cantidad < 100;

-- Mostrar clientes con sus direcciones completas
SELECT c.*, d.Ciudad, d.Departamento, d.Direccion_Detallada
FROM CLIENTE c
JOIN DIRECCION_CLIENTE d ON c.ID_Cliente = d.ID_Cliente;

-- Listar ventas con nombres de clientes y método de pago
SELECT v.ID_Venta, c.Nombre, c.Apellido, v.Metodo_Pago, v.Fecha_Venta
FROM VENTAS v
JOIN CLIENTE c ON v.ID_Cliente = c.ID_Cliente;

-- Mostrar productos con nombre de proveedor y precio
SELECT p.ID_Producto, p.Nombre, pr.Nombre AS Proveedor, p.Precio_unitario
FROM PRODUCTO p
JOIN PROVEEDOR pr ON p.ID_Proveedor = pr.ID_Proveedor;

-- Listar empleados con nombre de departamento
SELECT e.ID_Empleado, e.Nombre, e.Apellido, d.Nombre AS Departamento
FROM EMPLEADO e
JOIN DEPARTAMENTO d ON e.ID_Departamento = d.ID_Departamento;

-- Mostrar producción con nombre de producto y empleado
SELECT pr.ID_Produccion, p.Nombre AS Producto, CONCAT(e.Nombre, ' ', e.Apellido) AS Empleado
FROM PRODUCCION pr
JOIN PRODUCTO p ON pr.ID_Producto = p.ID_Producto
JOIN EMPLEADO e ON pr.ID_Empleado = e.ID_Empleado;

-- Listar mantenimientos con nombre de máquina y costo
SELECT m.ID_Mantenimiento, ma.Nombre AS Maquina, m.Costo, m.Fecha
FROM MANTENIMIENTO m
JOIN MAQUINARIA ma ON m.ID_Maquinaria = ma.ID_Maquinaria;

-- Mostrar inventario con nombre de producto y bodega
SELECT i.ID_Inventario, p.Nombre AS Producto, b.Nombre AS Bodega, i.Cantidad
FROM INVENTARIO i
JOIN PRODUCTO p ON i.ID_Producto = p.ID_Producto
JOIN BODEGA b ON i.ID_Bodega = b.ID_Bodega;

-- Listar compras con nombre de proveedor y fecha
SELECT c.ID_Compra, p.Nombre AS Proveedor, c.Fecha_Compra
FROM COMPRAS c
JOIN PROVEEDOR p ON c.ID_Proveedor = p.ID_Proveedor;

-- Mostrar detalles de venta con nombre de producto
SELECT dv.ID_Detalle_Venta, p.Nombre AS Producto, dv.Cantidad, dv.Precio_Por_Unidad
FROM DETALLES_VENTA dv
JOIN PRODUCTO p ON dv.ID_Producto = p.ID_Producto;

-- Listar precios de productos con nombre de producto
SELECT pp.ID_Precio, p.Nombre AS Producto, pp.Costo_Unitario, pp.Fecha
FROM PRECIO_PRODUCTO pp
JOIN PRODUCTO p ON pp.ID_Producto = p.ID_Producto;

-- Mostrar ventas con nombre de cliente y productos comprados
SELECT v.ID_Venta, c.Nombre AS Cliente, p.Nombre AS Producto, dv.Cantidad
FROM VENTAS v
JOIN CLIENTE c ON v.ID_Cliente = c.ID_Cliente
JOIN DETALLES_VENTA dv ON v.ID_Venta = dv.ID_Venta
JOIN PRODUCTO p ON dv.ID_Producto = p.ID_Producto;

-- Listar productos con su proveedor y bodega donde están almacenados
SELECT p.ID_Producto, p.Nombre AS Producto, pr.Nombre AS Proveedor, b.Nombre AS Bodega
FROM PRODUCTO p
JOIN PROVEEDOR pr ON p.ID_Proveedor = pr.ID_Proveedor
JOIN INVENTARIO i ON p.ID_Producto = i.ID_Producto
JOIN BODEGA b ON i.ID_Bodega = b.ID_Bodega;

-- Mostrar empleados con su departamento y salario
SELECT e.ID_Empleado, e.Nombre, e.Apellido, d.Nombre AS Departamento, e.Salario
FROM EMPLEADO e
JOIN DEPARTAMENTO d ON e.ID_Departamento = d.ID_Departamento;

-- Listar máquinas con su último mantenimiento realizado
SELECT m.ID_Maquinaria, m.Nombre, MAX(mt.Fecha) AS Ultimo_Mantenimiento
FROM MAQUINARIA m
LEFT JOIN MANTENIMIENTO mt ON m.ID_Maquinaria = mt.ID_Maquinaria
GROUP BY m.ID_Maquinaria, m.Nombre;

-- Mostrar producción con nombre de producto y máquina utilizada
SELECT pr.ID_Produccion, p.Nombre AS Producto, m.Nombre AS Maquina
FROM PRODUCCION pr
JOIN PRODUCTO p ON pr.ID_Producto = p.ID_Producto
JOIN MAQUINARIA m ON pr.ID_Maquinaria = m.ID_Maquinaria;


-- Mostrar los productos más caros (top 5)
SELECT Nombre, Precio_unitario
FROM PRODUCTO
ORDER BY Precio_unitario DESC
LIMIT 5;

-- Listar clientes que han gastado más de $1M en compras
SELECT c.ID_Cliente, c.Nombre, c.Apellido, 
       SUM(dv.Cantidad * dv.Precio_Por_Unidad) AS Total_Gastado
FROM CLIENTE c
JOIN VENTAS v ON c.ID_Cliente = v.ID_Cliente
JOIN DETALLES_VENTA dv ON v.ID_Venta = dv.ID_Venta
GROUP BY c.ID_Cliente, c.Nombre, c.Apellido
HAVING Total_Gastado > 1000000
ORDER BY Total_Gastado DESC;

-- Mostrar el promedio de salario por departamento
SELECT d.Nombre AS Departamento, AVG(e.Salario) AS Salario_Promedio
FROM DEPARTAMENTO d
JOIN EMPLEADO e ON d.ID_Departamento = e.ID_Departamento
GROUP BY d.Nombre
ORDER BY Salario_Promedio DESC;

-- Listar productos con stock por debajo del promedio
SELECT p.ID_Producto, p.Nombre, i.Cantidad
FROM PRODUCTO p
JOIN INVENTARIO i ON p.ID_Producto = i.ID_Producto
WHERE i.Cantidad < (SELECT AVG(Cantidad) FROM INVENTARIO);

-- Mostrar la venta con el mayor monto total
SELECT v.ID_Venta, c.Nombre AS Cliente,
       SUM(dv.Cantidad * dv.Precio_Por_Unidad) AS Monto_Total
FROM VENTAS v
JOIN CLIENTE c ON v.ID_Cliente = c.ID_Cliente
JOIN DETALLES_VENTA dv ON v.ID_Venta = dv.ID_Venta
GROUP BY v.ID_Venta, c.Nombre
ORDER BY Monto_Total DESC
LIMIT 1;

-- Listar proveedores que suministran más de 5 productos
SELECT pr.ID_Proveedor, pr.Nombre, COUNT(p.ID_Producto) AS Cantidad_Productos
FROM PROVEEDOR pr
JOIN PRODUCTO p ON pr.ID_Proveedor = p.ID_Proveedor
GROUP BY pr.ID_Proveedor, pr.Nombre
HAVING Cantidad_Productos > 5
ORDER BY Cantidad_Productos DESC;

-- Mostrar el total de ventas por método de pago
SELECT v.Metodo_Pago, SUM(dv.Cantidad * dv.Precio_Por_Unidad) AS Total_Ventas
FROM VENTAS v
JOIN DETALLES_VENTA dv ON v.ID_Venta = dv.ID_Venta
GROUP BY v.Metodo_Pago
ORDER BY Total_Ventas DESC;

-- Listar empleados con salario mayor al promedio
SELECT e.ID_Empleado, e.Nombre, e.Apellido, e.Salario
FROM EMPLEADO e
WHERE e.Salario > (SELECT AVG(Salario) FROM EMPLEADO)
ORDER BY e.Salario DESC;

-- Mostrar la máquina con más horas de uso
SELECT ID_Maquinaria, Nombre, Modelo, Horas_Uso
FROM MAQUINARIA
ORDER BY Horas_Uso DESC
LIMIT 1;

-- Listar productos que nunca han sido comprados
SELECT p.ID_Producto, p.Nombre
FROM PRODUCTO p
LEFT JOIN DETALLES_VENTA dv ON p.ID_Producto = dv.ID_Producto
WHERE dv.ID_Producto IS NULL;


-- Historial de precios de un producto específico (ej: ID=5)
SELECT p.Nombre, pp.Costo_Unitario, pp.Fecha
FROM PRECIO_PRODUCTO pp
JOIN PRODUCTO p ON pp.ID_Producto = p.ID_Producto
WHERE p.ID_Producto = 5
ORDER BY pp.Fecha DESC;

-- Rotación de productos (ventas/inventario)
SELECT 
    p.ID_Producto,
    p.Nombre,
    COALESCE(SUM(dv.Cantidad), 0) AS Total_Ventas,
    AVG(i.Cantidad) AS Inventario_Promedio,
    CASE 
        WHEN AVG(i.Cantidad) = 0 THEN NULL
        ELSE ROUND(COALESCE(SUM(dv.Cantidad), 0) / AVG(i.Cantidad), 2)
    END AS Indice_Rotacion
FROM PRODUCTO p
LEFT JOIN DETALLES_VENTA dv ON p.ID_Producto = dv.ID_Producto
LEFT JOIN INVENTARIO i ON p.ID_Producto = i.ID_Producto
GROUP BY p.ID_Producto, p.Nombre
ORDER BY Indice_Rotacion DESC;

-- Proyección de inventario basado en ventas promedio (próximos 30 días)
SELECT 
    p.ID_Producto,
    p.Nombre,
    i.Cantidad AS Stock_Actual,
    ROUND(
        (SELECT AVG(dv.Cantidad) 
         FROM DETALLES_VENTA dv 
         JOIN VENTAS v ON dv.ID_Venta = v.ID_Venta
         WHERE dv.ID_Producto = p.ID_Producto
         AND v.Fecha_Venta >= DATE_SUB(CURDATE(), INTERVAL 90 DAY))
    , 2) AS Ventas_Promedio_Diario,
    ROUND(i.Cantidad / NULLIF(
        (SELECT AVG(dv.Cantidad) 
         FROM DETALLES_VENTA dv 
         JOIN VENTAS v ON dv.ID_Venta = v.ID_Venta
         WHERE dv.ID_Producto = p.ID_Producto
         AND v.Fecha_Venta >= DATE_SUB(CURDATE(), INTERVAL 90 DAY))
    , 0), 1) AS Dias_Inventario_Restante
FROM PRODUCTO p
JOIN INVENTARIO i ON p.ID_Producto = i.ID_Producto
WHERE i.Cantidad > 0;

-- Productos con aumento de precio superior al 10%
SELECT 
    p.ID_Producto,
    p.Nombre,
    old.Costo_Unitario AS Precio_Anterior,
    new.Costo_Unitario AS Precio_Actual,
    ROUND((new.Costo_Unitario - old.Costo_Unitario) / old.Costo_Unitario * 100, 2) AS Porcentaje_Aumento
FROM PRODUCTO p
JOIN PRECIO_PRODUCTO new ON p.ID_Producto = new.ID_Producto
JOIN PRECIO_PRODUCTO old ON p.ID_Producto = old.ID_Producto
WHERE new.Fecha > old.Fecha
AND (new.Costo_Unitario - old.Costo_Unitario) / old.Costo_Unitario > 0.1
AND new.Fecha = (SELECT MAX(Fecha) FROM PRECIO_PRODUCTO WHERE ID_Producto = p.ID_Producto)
AND old.Fecha = (
    SELECT MAX(Fecha) 
    FROM PRECIO_PRODUCTO 
    WHERE ID_Producto = p.ID_Producto 
    AND Fecha < new.Fecha
);

-- Relación producción/ventas por producto
SELECT 
    p.ID_Producto,
    p.Nombre,
    COALESCE(SUM(pr.Cantidad_Producida), 0) AS Total_Producido,
    COALESCE(SUM(dv.Cantidad), 0) AS Total_Vendido,
    CASE 
        WHEN COALESCE(SUM(dv.Cantidad), 0) = 0 THEN NULL
        ELSE ROUND(COALESCE(SUM(pr.Cantidad_Producida), 0) / COALESCE(SUM(dv.Cantidad), 0), 2)
    END AS Relacion_Produccion_Ventas
FROM PRODUCTO p
LEFT JOIN PRODUCCION pr ON p.ID_Producto = pr.ID_Producto
LEFT JOIN DETALLES_VENTA dv ON p.ID_Producto = dv.ID_Producto
GROUP BY p.ID_Producto, p.Nombre
ORDER BY Relacion_Produccion_Ventas DESC;

-- Eficiencia de máquinas (producción/horas uso)
SELECT 
    m.ID_Maquinaria,
    m.Nombre,
    m.Horas_Uso,
    COALESCE(SUM(pr.Cantidad_Producida), 0) AS Total_Producido,
    CASE 
        WHEN m.Horas_Uso = 0 THEN NULL
        ELSE ROUND(COALESCE(SUM(pr.Cantidad_Producida), 0) / m.Horas_Uso, 2)
    END AS Eficiencia
FROM MAQUINARIA m
LEFT JOIN PRODUCCION pr ON m.ID_Maquinaria = pr.ID_Maquinaria
GROUP BY m.ID_Maquinaria, m.Nombre, m.Horas_Uso
ORDER BY Eficiencia DESC;

-- Estacionalidad de ventas por producto (por mes)
SELECT 
    p.ID_Producto,
    p.Nombre,
    MONTH(v.Fecha_Venta) AS Mes,
    SUM(dv.Cantidad) AS Total_Vendido
FROM PRODUCTO p
JOIN DETALLES_VENTA dv ON p.ID_Producto = dv.ID_Producto
JOIN VENTAS v ON dv.ID_Venta = v.ID_Venta
GROUP BY p.ID_Producto, p.Nombre, MONTH(v.Fecha_Venta)
ORDER BY p.Nombre, Mes;

-- Clientes con patrones de compra recurrentes (compran regularmente)
SELECT 
    c.ID_Cliente,
    c.Nombre,
    c.Apellido,
    COUNT(DISTINCT DATE_FORMAT(v.Fecha_Venta, '%Y-%m')) AS Meses_Con_Compras,
    COUNT(v.ID_Venta) AS Total_Compras,
    ROUND(COUNT(v.ID_Venta) / COUNT(DISTINCT DATE_FORMAT(v.Fecha_Venta, '%Y-%m')), 2) AS Frecuencia_Compras
FROM CLIENTE c
JOIN VENTAS v ON c.ID_Cliente = v.ID_Cliente
GROUP BY c.ID_Cliente, c.Nombre, c.Apellido
HAVING COUNT(DISTINCT DATE_FORMAT(v.Fecha_Venta, '%Y-%m')) > 3
ORDER BY Frecuencia_Compras DESC;

-- Valor total del inventario por bodega
SELECT 
    b.ID_Bodega,
    b.Nombre AS Bodega,
    SUM(i.Cantidad * p.Precio_unitario) AS Valor_Total
FROM BODEGA b
JOIN INVENTARIO i ON b.ID_Bodega = i.ID_Bodega
JOIN PRODUCTO p ON i.ID_Producto = p.ID_Producto
GROUP BY b.ID_Bodega, b.Nombre
ORDER BY Valor_Total DESC;

-- Productos con mayor tiempo en inventario (FIFO)
SELECT 
    p.ID_Producto,
    p.Nombre,
    i.Fecha_Ultima_Actualizacion AS Fecha_Ingreso,
    DATEDIFF(CURDATE(), i.Fecha_Ultima_Actualizacion) AS Dias_En_Inventario,
    i.Cantidad
FROM PRODUCTO p
JOIN INVENTARIO i ON p.ID_Producto = i.ID_Producto
WHERE i.Cantidad > 0
ORDER BY Dias_En_Inventario DESC;



















--Mostrar las direcciones de clientes en Medellín

SELECT *
FROM DIRECCION_CLIENTE
WHERE Ciudad = 'Medellín';


DESCRIBE ventas;

--Listar las ventas con sus métodos de pago

SELECT ID_Venta, Fecha_Venta, Metodo_Pago
FROM ventas;

describe proveedor
--Mostrar los productos y sus proveedores

SELECT P.Nombre AS Nombre_Producto,  PR.Nombre AS Nombre_Proveedor
FROM producto P, proveedor PR
WHERE  P.ID_Proveedor = PR.ID_Proveedor;

--listar los empleados del departemento de postcosecha

select * from departamento d ;

select e.nombre, e.apellido,d.nombre
from empleado e, departamento d 
where d.ID_Departamento = e.ID_Departamento and d.nombre ='postcosecha';

-- Mostrar las máquinas adquiridas en 2021

describe maquinaria;

select m.nombre, m.modelo, m.fecha_adquisicion 
from maquinaria m 
where YEAR(Fecha_Adquisicion) = '2021';

-- Listar los mantenimientos realizados en enero 2025
select * from produccion p 

describe mantenimiento ;

select m1.nombre, m2.fecha
from maquinaria m1, mantenimiento m2
where  m1.ID_Maquinaria = m2.ID_Maquinaria AND MONTH(m2.Fecha ) = 1 and YEAR(m2.Fecha ) = 2025;

-- Mostrar la producción de maíz  (ID 7)

describe produccion;

select R.Cantidad_producida, P.Nombre
from produccion R , producto P
where P.ID_Producto = R.ID_Producto and P.ID_Producto = 7;


--Listar los clientes con sus teléfonos y emails

select c.Nombre ,c.telefono, c.email
from cliente c 


--Mostrar los productos con su costo unitario actual

describe producto;

select p.nombre, p.Precio_unitario
from producto p ;


--Listar las bodegas ordenadas por nombre

describe bodega;

select b.nombre, b.Ubicacion
from bodega b 
order by b.Nombre  asc;

--Mostrar los detalles de venta con cantidad mayor a 5

describe detalles_venta;

select *
from detalles_venta dv 
where dv.Cantidad  > 5;

Listar los empleados con salario entre $3M y $5M

select *from empleado e ;

select e.nombre, e.apellido, e.Salario
from empleado e 
where e.Salario between 3000000 and 5000000;


--Mostrar las máquinas en mantenimiento

select * from maquinaria;

select m.nombre, m.modelo, m.estado
from maquinaria m 
where m.Estado = 'Mantenimiento';

--Listar las compras ordenadas por fecha descendente

select c.Fecha_Compra , p.Nombre 
from compras c , producto p 
order by c.Fecha_Compra  desc ;


--Mostrar los productos que no han tenido ventas

SELECT p.Nombre
FROM producto p
LEFT JOIN detalles_venta dv ON p.ID_Producto = dv.ID_Producto
WHERE dv.ID_Producto IS NULL;

-- Listar clientes con el total de ventas realizadas

select c.nombre as cliente, count(v.ID_Venta) as ventas_totales
from cliente c 
join ventas v on v.ID_Cliente = c.ID_Cliente
group  by c.Nombre ;


--Mostrar productos con su precio actual y costo unitario

select p.nombre as producto, p.Precio_unitario, dc.Costo_unitario
from producto p 
join detalles_compra dc on dc.ID_Producto = p.ID_Producto;


--Listar proveedores con los productos que suministran

describe proveedor;

select pr.nombre as proveedor, p.nombre as producto
from proveedor pr
join producto p on p.ID_Proveedor = pr.ID_Proveedor;

--Mostrar bodegas con la cantidad de productos diferentes almacenados

SELECT  b.Nombre AS Bodega, COUNT(DISTINCT p.ID_Producto) AS Productos_Diferentes
FROM bodega b
JOIN inventario i ON b.ID_Bodega = i.ID_Bodega
JOIN  producto p ON i.ID_Producto = p.ID_Producto
GROUP BY b.ID_Bodega, b.Nombre;

-- Listar empleados con las máquinas que han operado

SELECT  e.Nombre AS Empleado, m.Nombre AS Maquina
FROM  produccion p 
join maquinaria m on m.ID_Maquinaria = p.ID_Maquinaria
join empleado e on e.ID_Empleado = p.ID_Empleado
group by e.Nombre , m.Nombre ;

--Mostrar ventas con detalles completos (cliente, productos, cantidades)

SELECT v.ID_Venta, c.Nombre AS Cliente,  p.Nombre AS Producto,  dv.Cantidad, dv.Precio_Por_Unidad 
FROM  ventas v
JOIN cliente c ON v.ID_Cliente = c.ID_Cliente
JOIN  detalles_venta dv ON v.ID_Venta = dv.ID_Venta
JOIN  producto p ON dv.ID_Producto = p.ID_Producto;

-- Listar productos con su stock actual en todas las bodegas

select b.nombre as bodega, p.nombre, SUM(i.cantidad ) as cantitad
from bodega b 
join inventario i on i.ID_Bodega = b.ID_Bodega
join producto p on p.ID_Producto = i.ID_Producto
group  by b.Nombre, p.Nombre;

--Mostrar máquinas con horas de uso y estado actual



SELECT m.Nombre AS Maquina,m.Horas_Uso, m.Estado
FROM maquinaria m;

-- Listar mantenimientos con descripción y nombre de máquina
SELECT mto.ID_Mantenimiento,maq.Nombre AS Maquina, mto.Descripcion, mto.Fecha,mto.Costo
FROM mantenimiento mto
JOIN maquinaria maq ON mto.ID_Maquinaria = maq.ID_Maquinaria;

--Mostrar producción con fechas y empleados responsables

SELECT pr.ID_Produccion,pr.Fecha_Cosecha , e.Nombre AS Empleado
FROM  produccion pr
JOIN empleado e ON pr.ID_Empleado = e.ID_Empleado;

--Listar compras con detalles de productos adquiridos

SELECT c.ID_Compra, p.Nombre AS Producto,dc.Cantidad,dc.Costo_Unitario _Unitario
FROM compras c
JOIN  detalles_compra dc ON c.ID_Compra = dc.ID_Compra
JOIN producto p ON dc.ID_Producto = p.ID_Producto;

-- Mostrar clientes con su tipo y dirección completa

SELECT  c.Nombre AS Cliente,c.Tipo AS Tipo_Cliente,dc.Direccion_Detallada
FROM cliente c
JOIN direccion_cliente dc ON dc.ID_Cliente = c.ID_Cliente;

-- Listar productos con su proveedor y fechas de compra

SELECT p.Nombre AS Producto,pr.Nombre AS Proveedor,c.Fecha_Compra
FROM producto p
JOIN proveedor pr ON p.ID_Proveedor = pr.ID_Proveedor
JOIN detalles_compra dc ON p.ID_Producto = dc.ID_Producto
JOIN compras c ON dc.ID_Compra = c.ID_Compra;


-- Mostrar empleados con su producción realizada

SELECT e.Nombre AS Empleado,pr.Fecha_Cosecha ,pr.Cantidad_Producida 
FROM empleado e
JOIN produccion pr ON e.ID_Empleado = pr.ID_Empleado;

-- Listar máquinas con su producción asociada y mantenimientos

SELECT  m.Nombre AS Maquina,pr.ID_Produccion,mto.ID_Mantenimiento
FROM maquinaria m
LEFT JOIN produccion pr ON m.ID_Maquinaria = pr.ID_Maquinaria
LEFT JOIN mantenimiento mto ON m.ID_Maquinaria = mto.ID_Maquinaria;

-Listar los meses con mayor volumen de ventas

SELECT  
    m.Nombre AS Maquina,
    (
        SELECT SUM(mt.Costo)
        FROM mantenimiento mt
        WHERE mt.ID_Maquinaria = m.ID_Maquinaria
    ) AS Costo_Total_Mantenimiento
FROM maquinaria m;


--Listar los meses con mayor volumen de ventas
SELECT DISTINCT MONTH(v.Fecha_Venta) AS Mes,
       (SELECT SUM(dv.Cantidad)
        FROM ventas v2
        JOIN detalles_venta dv ON v2.ID_Venta = dv.ID_Venta
        WHERE MONTH(v2.Fecha_Venta) = MONTH(v.Fecha_Venta)) AS Total_Vendido
FROM ventas v
ORDER BY Total_Vendido DESC;


--Mostrar la producción promedio por tipo de producto

SELECT DISTINCT p.Tipo,
       (SELECT AVG(pr.Cantidad_Producida)
        FROM produccion pr
        JOIN producto p2 ON pr.ID_Producto = p2.ID_Producto
        WHERE p2.Tipo = p.Tipo) AS Promedio_Produccion
FROM producto p;

--Listar clientes con más ventas realizadas

SELECT c.Nombre,
       (SELECT COUNT(*)
        FROM ventas v
        WHERE v.ID_Cliente = c.ID_Cliente) AS Cantidad_Ventas
FROM cliente c
ORDER BY Cantidad_Ventas DESC;

--Mostrar la diferencia entre precio y costo unitario por producto
SELECT p.Nombre,
       p.Precio_Unitario - (
           SELECT pp.Costo_Unitario
           FROM precio_producto pp
           WHERE pp.ID_Producto = p.ID_Producto
           ORDER BY pp.Fecha DESC
           LIMIT 1
       ) AS Diferencia
FROM producto p;


--Listar bodegas con capacidad utilizada (total de productos)

SELECT b.Nombre,
       (SELECT SUM(i.Cantidad)
        FROM inventario i
        WHERE i.ID_Bodega = b.ID_Bodega) AS Capacidad_Utilizada
FROM bodega b;


--Mostrar el empleado con mayor producción

SELECT e.Nombre,
       (SELECT SUM(pr.Cantidad_Producida)
        FROM produccion pr
        WHERE pr.ID_Empleado = e.ID_Empleado) AS Total_Produccion
FROM empleado e
ORDER BY Total_Produccion DESC
LIMIT 1;

--Listar productos con mayor margen de ganancia

SELECT p.Nombre,
       p.Precio_Unitario - (
           SELECT pp.Costo_Unitario
           FROM precio_producto pp
           WHERE pp.ID_Producto = p.ID_Producto
           ORDER BY pp.Fecha DESC
           LIMIT 1
       ) AS Margen_Ganancia
FROM producto p
ORDER BY Margen_Ganancia DESC;

-- Mostrar el proveedor con más compras realizadas

SELECT pr.Nombre,
       (SELECT COUNT(*)
        FROM compras c
        WHERE c.ID_Proveedor = pr.ID_Proveedor) AS Total_Compras
FROM proveedor pr
ORDER BY Total_Compras DESC
LIMIT 1;

-- Listar máquinas que no han tenido mantenimiento en 2023

SELECT m.Nombre
FROM maquinaria m
WHERE m.ID_Maquinaria NOT IN (
    SELECT DISTINCT mt.ID_Maquinaria
    FROM mantenimiento mt
    WHERE YEAR(mt.Fecha) = 2023
);


--Mostrar la rentabilidad por línea de producto
SELECT 
    p.Tipo AS Linea_Producto,
    SUM((p.Precio_Unitario - pp.Costo_Unitario) * dv.Cantidad) AS Rentabilidad_Total
FROM producto p
JOIN precio_producto pp ON p.ID_Producto = pp.ID_Producto
JOIN detalles_venta dv ON p.ID_Producto = dv.ID_Producto
GROUP BY p.Tipo
ORDER BY Rentabilidad_Total DESC;

Listar correlación entre mantenimiento y producción
SELECT 
    m.ID_Maquinaria,
    (SELECT COUNT(*) FROM mantenimiento WHERE ID_Maquinaria = m.ID_Maquinaria) AS Total_Mantenimientos,
    (SELECT SUM(pr.Cantidad_Producida) 
     FROM produccion pr 
     WHERE pr.ID_Maquinaria = m.ID_Maquinaria) AS Total_Produccion
FROM maquinaria m;


--Mostrar la distribución geográfica de clientes
SELECT 
    dc.Ciudad,
    COUNT(c.ID_Cliente) AS Total_Clientes
FROM cliente c
JOIN direccion_cliente dc ON c.ID_Cliente = dc.ID_Cliente
GROUP BY dc.Ciudad
ORDER BY Total_Clientes DESC;

--Listar tendencias de compra por temporada
SELECT 
    MONTH(v.Fecha_Venta ) AS Mes,
    YEAR(v.Fecha_Venta ) AS Año,
    SUM(dv.Cantidad) AS Total_Unidades
FROM ventas v
JOIN detalles_venta dv ON v.ID_Venta = dv.ID_Venta
GROUP BY Año, Mes
ORDER BY Año DESC, Mes DESC;

--Mostrar el ciclo de vida de productos (introducción, crecimiento, etc.)
SELECT 
    p.Nombre,
    CASE 
        WHEN SUM(dv.Cantidad) < 100 THEN 'Introducción'
        WHEN SUM(dv.Cantidad) BETWEEN 100 AND 500 THEN 'Crecimiento'
        WHEN SUM(dv.Cantidad) BETWEEN 501 AND 1000 THEN 'Madurez'
        ELSE 'Declive'
    END AS Etapa
FROM producto p
JOIN detalles_venta dv ON p.ID_Producto = dv.ID_Producto
GROUP BY p.ID_Producto;

--Listar la utilización de capacidad por bodega
SELECT 
    b.Nombre AS Bodega,
    SUM(i.Cantidad) AS Total_Productos,
    b.Capacidad,
    CONCAT(ROUND((SUM(i.Cantidad) / b.Capacidad) * 100, 2), '%') AS Porcentaje_Utilizado
FROM bodega b
JOIN inventario i ON b.ID_Bodega = i.ID_Bodega
GROUP BY b.ID_Bodega;

--Mostrar la relación costo-beneficio de máquinas
SELECT 
    b.Nombre AS Bodega,
    SUM(i.Cantidad) AS Total_Productos
FROM bodega b
JOIN inventario i ON b.ID_Bodega = i.ID_Bodega
GROUP BY b.ID_Bodega
ORDER BY Total_Productos DESC;

--Listar productos complementarios en ventas
SELECT 
    m.Nombre,
    (SELECT SUM(Costo) FROM mantenimiento WHERE ID_Maquinaria = m.ID_Maquinaria) AS Costo_Total,
    (SELECT SUM(pr.Cantidad_Producida * p.Precio_Unitario)
     FROM produccion pr
     JOIN producto p ON pr.ID_Producto = p.ID_Producto
     WHERE pr.ID_Maquinaria = m.ID_Maquinaria) AS Beneficio_Total
FROM maquinaria m;

--Mostrar el valor del inventario obsoleto
SELECT 
    dv1.ID_Producto AS Producto_1,
    dv2.ID_Producto AS Producto_2,
    COUNT(*) AS Veces_Vendidos_Juntos
FROM detalles_venta dv1
JOIN detalles_venta dv2 
    ON dv1.ID_Venta = dv2.ID_Venta 
    AND dv1.ID_Producto < dv2.ID_Producto
GROUP BY Producto_1, Producto_2
ORDER BY Veces_Vendidos_Juntos DESC;

--Listar oportunidades de descuento por productos con exceso de inventario
SELECT 
    p.Nombre,
    i.Cantidad,
    (i.Cantidad * p.Precio_Unitario) AS Valor_Total
FROM inventario i
JOIN producto p ON i.ID_Producto = p.ID_Producto
WHERE p.ID_Producto NOT IN (
    SELECT DISTINCT ID_Producto 
    FROM detalles_venta dv
    JOIN ventas v ON dv.ID_Venta = v.ID_Venta
    WHERE v.Fecha_Venta  >= DATE_SUB(CURDATE(), INTERVAL 1 YEAR)
);





drop procedure TransferirInventario

--Transferir inventario entre bodegas - SP para mover productos de una bodega a otra

DELIMITER //
CREATE PROCEDURE TransferirInventario(
    IN p_ID_Producto INT,
    IN p_ID_Bodega_Origen INT,
    IN p_ID_Bodega_Destino INT,
    IN p_Cantidad INT
)
BEGIN
    -- Restar de la bodega origen
    UPDATE inventario
    SET Cantidad = Cantidad - p_Cantidad
    WHERE ID_Producto = p_ID_Producto
      AND ID_Bodega = p_ID_Bodega_Origen;

    -- Agregar a la bodega destino
    INSERT INTO inventario (ID_Producto, ID_Bodega, Cantidad)
    VALUES (p_ID_Producto, p_ID_Bodega_Destino, p_Cantidad)
    ON DUPLICATE KEY UPDATE Cantidad = Cantidad + p_Cantidad;
END //
DELIMITER ;

CALL TransferirInventario(
    5,   -- ID del producto
    1,   -- ID bodega origen
    2,   -- ID bodega destino
    10   -- cantidad a transferir
);



SELECT * 
FROM inventario
WHERE ID_Producto = 1 
  AND ID_Bodega IN (1, 2);

CALL TransferirInventario(1, 1, 2, 5);

SHOW COLUMNS FROM ventas;


--Obtener historial de precios - SP que muestre evolución de precios de un producto
DELIMITER //

DELIMITER $$
CREATE PROCEDURE ObtenerHistorialPrecios(IN p_ID_Producto INT)
BEGIN
    SELECT Fecha, Costo_Unitario
    FROM precio_producto
    WHERE ID_Producto = p_ID_Producto
    ORDER BY Fecha DESC;
END $$
DELIMITER ;


CALL ObtenerHistorialPrecios(1);

drop procedure  RegistrarVenta;

--Registrar venta completa - SP que registre venta, detalles y actualice inventario
DELIMITER //
CREATE PROCEDURE RegistrarVenta(
    IN p_ID_Cliente INT,
    IN p_ID_Producto INT,
    IN p_Cantidad INT,
    IN p_Precio DECIMAL(10,2)
)
BEGIN
    DECLARE v_ID_Venta INT;

    -- Insertar la venta
    INSERT INTO ventas (ID_Cliente, Fecha_Venta)
    VALUES (p_ID_Cliente, CURDATE());
    SET v_ID_Venta = LAST_INSERT_ID();

    -- Insertar detalle de la venta
    INSERT INTO detalles_venta (ID_Venta, ID_Producto, Cantidad, Precio_Por_Unidad)
    VALUES (v_ID_Venta, p_ID_Producto, p_Cantidad, p_Precio);

    -- Actualizar inventario
    UPDATE inventario
    SET Cantidad = Cantidad - p_Cantidad
    WHERE ID_Producto = p_ID_Producto;
END //
DELIMITER ;

CALL RegistrarVenta(1, 3, 5, 1200.00);


drop procedure GenerarAlertasStockMinimo;

--Generar alertas de stock mínimo - SP que identifique productos bajo nivel mínimo
DELIMITER //

CREATE PROCEDURE GenerarAlertasStockMinimo()
BEGIN
    SELECT p.Nombre, i.Cantidad
    FROM producto p
    JOIN inventario i ON p.ID_Producto = i.ID_Producto
    WHERE i.Cantidad < 10;  -- Aquí usas 10 como stock mínimo fijo
END //

DELIMITER ;


CALL GenerarAlertasStockMinimo();

--Obtener productos más vendidos - SP con ranking de productos por volumen ventas

DESCRIBE producto;

DELIMITER //
CREATE PROCEDURE ProductosMasVendidos()
BEGIN
    SELECT p.Nombre, SUM(dv.Cantidad) AS Total_Vendido
    FROM producto p
    JOIN detalles_venta dv ON p.ID_Producto = dv.ID_Producto
    GROUP BY p.ID_Producto
    ORDER BY Total_Vendido DESC
    LIMIT 10;
END //
DELIMITER ;

CALL ProductosMasVendidos();


--Registrar horas de uso de maquinaria - SP para actualizar horas de trabajo de equipos
DELIMITER //
CREATE PROCEDURE RegistrarHorasMaquinaria(
    IN p_ID_Maquinaria INT,
    IN p_Horas_Adicionales INT
)
BEGIN
    UPDATE maquinaria
    SET Horas_Uso = Horas_Uso + p_Horas_Adicionales
    WHERE ID_Maquinaria = p_ID_Maquinaria;
END //
DELIMITER ;

CALL RegistrarHorasMaquinaria(3, 5);


--Generar reporte de productividad - SP que relacione producción vs recursos usados
DELIMITER //
CREATE PROCEDURE ReporteProductividad()
BEGIN
    SELECT m.ID_Maquinaria,
           SUM(pr.Cantidad_Producida) AS Total_Produccion,
           COUNT(DISTINCT pr.ID_Empleado) AS Empleados_Involucrados
    FROM produccion pr
    JOIN maquinaria m ON pr.ID_Maquinaria = m.ID_Maquinaria
    GROUP BY m.ID_Maquinaria;
END //
DELIMITER ;


--Buscar clientes por ubicación - SP que filtre clientes por ciudad/departamento
DELIMITER //
CREATE PROCEDURE BuscarClientesPorUbicacion(
    IN p_Ciudad VARCHAR(100)
)
BEGIN
    SELECT c.ID_Cliente, c.Nombre, d.Direccion_Detallada
    FROM cliente c
    JOIN direccion_cliente d ON c.ID_Cliente = d.ID_Cliente
    WHERE d.Direccion_Detallada LIKE CONCAT('%', p_Ciudad, '%');
END //
DELIMITER ;

CALL BuscarClientesPorUbicacion('Bogotá');


drop procedure CalcularMargenGanancia;

--Calcular margen de ganancia - SP que determine margen (precio venta - costo) por producto

DELIMITER //
CREATE PROCEDURE CalcularMargenGanancia()
BEGIN
    SELECT p.Nombre,
           pp.Costo_Unitario,
           p.Precio_unitario,
           (p.Precio_unitario - pp.Costo_Unitario) AS Margen,
           ROUND(((p.Precio_unitario - pp.Costo_Unitario) / pp.Costo_Unitario) * 100, 2) AS Margen_Porcentaje
    FROM producto p
    JOIN precio_producto pp ON p.ID_Producto = pp.ID_Producto;
END //
DELIMITER ;

CALL CalcularMargenGanancia();
