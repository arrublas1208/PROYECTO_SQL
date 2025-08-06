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
