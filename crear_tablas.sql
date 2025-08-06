-- 1. DEPARTAMENTO
CREATE TABLE DEPARTAMENTO (
    ID_Departamento INT PRIMARY KEY,
    Nombre VARCHAR(100) NOT NULL
);

-- 2. CLIENTE
CREATE TABLE CLIENTE (
    ID_Cliente INT PRIMARY KEY,
    Nombre VARCHAR(100) NOT NULL,
    Apellido VARCHAR(100) NOT NULL,
    Telefono VARCHAR(20),
    Correo VARCHAR(100)
);

-- 3. DIRECCION_CLIENTE
CREATE TABLE DIRECCION_CLIENTE (
    ID_Direccion INT PRIMARY KEY,
    ID_Cliente INT,
    Ciudad VARCHAR(100),
    Departamento VARCHAR(100),
    Direccion_Detallada VARCHAR(200),
    FOREIGN KEY (ID_Cliente) REFERENCES CLIENTE(ID_Cliente)
);

-- 4. PROVEEDOR
CREATE TABLE PROVEEDOR (
    ID_Proveedor INT PRIMARY KEY,
    Nombre VARCHAR(200) NOT NULL,
    Contacto VARCHAR(100) NOT NULL,
    Direccion VARCHAR(200)
);

-- 5. PRODUCTO
CREATE TABLE PRODUCTO (
    ID_Producto INT PRIMARY KEY,
    Nombre VARCHAR(100) NOT NULL,
    Tipo VARCHAR(50) NOT NULL,
    Unidad_Medida DECIMAL(10,2) NOT NULL,
    ID_Proveedor INT,
    FOREIGN KEY (ID_Proveedor) REFERENCES PROVEEDOR(ID_Proveedor)
);

-- 6. BODEGA
CREATE TABLE BODEGA (
    ID_Bodega INT PRIMARY KEY,
    Nombre VARCHAR(100),
    Ubicacion VARCHAR(200)
);

-- 7. INVENTARIO
CREATE TABLE INVENTARIO (
    ID_Inventario INT PRIMARY KEY,
    ID_Producto INT,
    ID_Bodega INT,
    Cantidad INT NOT NULL,
    Fecha_Ultima_Actualizacion DATETIME,
    FOREIGN KEY (ID_Producto) REFERENCES PRODUCTO(ID_Producto),
    FOREIGN KEY (ID_Bodega) REFERENCES BODEGA(ID_Bodega)
);

-- 8. MAQUINARIA
CREATE TABLE MAQUINARIA (
    ID_Maquinaria INT PRIMARY KEY,
    Nombre VARCHAR(100) NOT NULL,
    Estado VARCHAR(45) NOT NULL CHECK (Estado IN ('Activo', 'Mantenimiento', 'Inactivo')),
    Fecha_Adquisicion DATE,
    Horas_Uso INT
);



-- 9. MANTENIMIENTO
CREATE TABLE MANTENIMIENTO (
    ID_Mantenimiento INT PRIMARY KEY,
    ID_Maquinaria INT,
    Fecha DATE,
    Descripcion TEXT,
    Costo DECIMAL(10,2),
    FOREIGN KEY (ID_Maquinaria) REFERENCES MAQUINARIA(ID_Maquinaria)
);

-- 10. VENTAS
CREATE TABLE VENTAS (
    ID_Venta INT PRIMARY KEY,
    ID_Cliente INT,
    Fecha DATE,
    Total DECIMAL(10,2),
    FOREIGN KEY (ID_Cliente) REFERENCES CLIENTE(ID_Cliente)
);

-- 11. DETALLES_VENTA
CREATE TABLE DETALLES_VENTA (
    ID_Detalle_Venta INT PRIMARY KEY,
    ID_Venta INT,
    ID_Producto INT,
    Cantidad INT,
    Precio_Por_Unidad DECIMAL(10,2),
    FOREIGN KEY (ID_Venta) REFERENCES VENTAS(ID_Venta),
    FOREIGN KEY (ID_Producto) REFERENCES PRODUCTO(ID_Producto)
);

-- 12. EMPLEADO
CREATE TABLE EMPLEADO (
    ID_Empleado INT PRIMARY KEY,
    Nombre VARCHAR(100) NOT NULL,
    Apellido VARCHAR(100) NOT NULL,
    Cargo VARCHAR(45) NOT NULL,
    Salario DECIMAL(10,2) NOT NULL,
    Fecha_Contratacion DATE NOT NULL,
    ID_Departamento INT,
    FOREIGN KEY (ID_Departamento) REFERENCES DEPARTAMENTO(ID_Departamento)
);

-- 13. TIPO_USUARIO
CREATE TABLE TIPO_USUARIO (
    ID_Tipo INT PRIMARY KEY,
    Descripcion VARCHAR(100)
);

-- 14. USUARIO
CREATE TABLE USUARIO (
    ID_Usuario INT PRIMARY KEY,
    Nombre_Usuario VARCHAR(100) NOT NULL,
    Contrasena VARCHAR(100) NOT NULL,
    Correo VARCHAR(100),
    ID_Tipo INT,
    FOREIGN KEY (ID_Tipo) REFERENCES TIPO_USUARIO(ID_Tipo)
);

-- 15. LOGIN
CREATE TABLE LOGIN (
    ID_Login INT PRIMARY KEY,
    ID_Usuario INT,
    Fecha DATETIME,
    Estado_Sesion VARCHAR(20),
    FOREIGN KEY (ID_Usuario) REFERENCES USUARIO(ID_Usuario)
);

-- 16. PAGO
CREATE TABLE PAGO (
    ID_Pago INT PRIMARY KEY,
    ID_Venta INT,
    Fecha_Pago DATE,
    Monto DECIMAL(10,2),
    Metodo_Pago VARCHAR(50),
    FOREIGN KEY (ID_Venta) REFERENCES VENTAS(ID_Venta)
)