CREATE DATABASE GESTION_AGROINDUSTRIAL;
USE GESTION_AGROINDUSTRIAL;

CREATE TABLE CLIENTE (
    ID_Cliente INT PRIMARY KEY,
    Nombre VARCHAR(50),
    Apellido VARCHAR(50),
    Telefono VARCHAR(20),
    Email VARCHAR(50),
    Tipo VARCHAR(45)
);

CREATE TABLE DIRECCION_CLIENTE (
    ID_Direccion INT PRIMARY KEY,
    ID_Cliente INT,
    Ciudad VARCHAR(100),
    Departamento VARCHAR(100),
    Direccion_Detallada VARCHAR(200),
    FOREIGN KEY (ID_Cliente) REFERENCES CLIENTE(ID_Cliente)
);

CREATE TABLE VENTAS (
    ID_Venta INT PRIMARY KEY,
    ID_Cliente INT,
    Fecha_Venta DATETIME,
    Metodo_Pago VARCHAR(50),
    FOREIGN KEY (ID_Cliente) REFERENCES CLIENTE(ID_Cliente)
);

CREATE TABLE DETALLES_VENTA (
    ID_Detalle_Venta INT PRIMARY KEY,
    ID_Venta INT,
    ID_Producto INT,
    Cantidad INT,
    Precio_Por_Unidad DECIMAL(10,2),
    FOREIGN KEY (ID_Venta) REFERENCES VENTAS(ID_Venta),
    FOREIGN KEY (ID_Producto) REFERENCES PRODUCTO(ID_Producto)
);

CREATE TABLE PROVEEDOR (
    ID_Proveedor INT PRIMARY KEY,
    Nombre VARCHAR(100),
    Telefono VARCHAR(15),
    Direccion VARCHAR(200)
);

CREATE TABLE PRODUCTO (
    ID_Producto INT PRIMARY KEY,
    Nombre VARCHAR(100),
    Tipo VARCHAR(50),
    Precio_unitario DECIMAL(10,2),
    ID_Proveedor INT,
    FOREIGN KEY (ID_Proveedor) REFERENCES PROVEEDOR(ID_Proveedor)
);

CREATE TABLE PRECIO_PRODUCTO (
    ID_Precio INT PRIMARY KEY,
    ID_Producto INT,
    Fecha DATE,
    Costo_Unitario DECIMAL(10,2),
    FOREIGN KEY (ID_Producto) REFERENCES PRODUCTO(ID_Producto)
);

CREATE TABLE BODEGA (
    ID_Bodega INT PRIMARY KEY,
    Nombre VARCHAR(100),
    Ubicacion VARCHAR(100)
);

CREATE TABLE INVENTARIO (
    ID_Inventario INT PRIMARY KEY,
    ID_Producto INT,
    ID_Bodega INT,
    Cantidad INT,
    Fecha_Ultima_Actualizacion DATE,
    FOREIGN KEY (ID_Producto) REFERENCES PRODUCTO(ID_Producto),
    FOREIGN KEY (ID_Bodega) REFERENCES BODEGA(ID_Bodega)
);

CREATE TABLE COMPRAS (
    ID_Compra INT PRIMARY KEY,
    ID_Proveedor INT,
    Fecha_Compra DATETIME,
    FOREIGN KEY (ID_Proveedor) REFERENCES PROVEEDOR(ID_Proveedor)
);

CREATE TABLE DETALLES_COMPRA (
    ID_Detalle_Compra INT PRIMARY KEY,
    ID_Compra INT,
    ID_Producto INT,
    Cantidad INT,
    Costo_Unitario DECIMAL(10,2),
    FOREIGN KEY (ID_Compra) REFERENCES COMPRAS(ID_Compra),
    FOREIGN KEY (ID_Producto) REFERENCES PRODUCTO(ID_Producto)
);

CREATE TABLE DEPARTAMENTO (
    ID_Departamento INT PRIMARY KEY,
    Nombre VARCHAR(100)
);

CREATE TABLE EMPLEADO (
    ID_Empleado INT PRIMARY KEY,
    Nombre VARCHAR(100),
    Apellido VARCHAR(100),
    Cargo VARCHAR(45),
    Salario DECIMAL(10,2),
    Fecha_Contratacion DATE,
    ID_Departamento INT,
    FOREIGN KEY (ID_Departamento) REFERENCES DEPARTAMENTO(ID_Departamento)
);

CREATE TABLE MAQUINARIA (
    ID_Maquinaria INT PRIMARY KEY,
    Nombre VARCHAR(100),
    Modelo VARCHAR(45),
    Estado VARCHAR(30),
    Fecha_Adquisicion DATE,
    Horas_Uso INT
);

CREATE TABLE PRODUCCION (
    ID_Produccion INT PRIMARY KEY,
    ID_Producto INT,
    Cantidad_Producida INT,
    Fecha_Cosecha DATE,
    ID_Empleado INT,
    ID_Maquinaria INT,
    FOREIGN KEY (ID_Producto) REFERENCES PRODUCTO(ID_Producto),
    FOREIGN KEY (ID_Empleado) REFERENCES EMPLEADO(ID_Empleado),
    FOREIGN KEY (ID_Maquinaria) REFERENCES MAQUINARIA(ID_Maquinaria)
);

CREATE TABLE MANTENIMIENTO (
    ID_Mantenimiento INT PRIMARY KEY,
    ID_Maquinaria INT,
    Fecha DATE,
    Descripcion TEXT,
    Costo DECIMAL(10,2),
    FOREIGN KEY (ID_Maquinaria) REFERENCES MAQUINARIA(ID_Maquinaria)
);
