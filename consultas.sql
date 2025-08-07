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

