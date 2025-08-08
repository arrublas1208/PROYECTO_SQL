use gestion_agroindustrial

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

