# 📦 Gestión de una Finca de Producción Agrícola

## 📄 Descripción del Proyecto
El proyecto **"Gestión Agroindustrial"** es un sistema de base de datos diseñado para administrar de manera integral las operaciones de una finca de producción agrícola.  
Su objetivo principal es optimizar la gestión de clientes, ventas, producción, inventarios, compras, proveedores, maquinaria, mantenimiento y demás procesos clave.  

La base de datos incluye:
- Registro y seguimiento de **clientes** y sus direcciones.
- Gestión de **productos**, precios y proveedores.
- Control de **ventas** y sus detalles.
- Administración de **inventarios** por bodega.
- Registro de **compras** y relación con proveedores.
- Control de **producción** y uso de maquinaria.
- Programación y control de **mantenimientos**.
- Automatización de procesos mediante **procedimientos, funciones, triggers y eventos**.
- Roles de usuario con diferentes permisos según sus funciones.

---

## 🖥️ Requisitos del Sistema
Para ejecutar este proyecto, se requiere:
- **Sistema Gestor de Base de Datos:** MySQL **8.0** o superior.
- **Cliente de Administración:** MySQL Workbench (o compatible).
- **Sistema Operativo:** Windows, Linux o macOS.
- Permisos de administrador en MySQL para crear bases de datos, tablas, usuarios y roles.

---

## ⚙️ Instalación y Configuración

### 1️⃣ Crear la estructura de la base de datos
Ejecutar el script **`DDL.sql`**:
```sql
SOURCE /ruta/a/DDL.sql;
```

### 2️⃣ Cargar los datos iniciales
Ejecutar el script **`DML.sql`**:
```sql
SOURCE /ruta/a/DML.sql;
```

### 3️⃣ Crear funciones, procedimientos, triggers y eventos
En el siguiente orden:
```sql
SOURCE /ruta/a/DQL_FUNCIONES.sql;
SOURCE /ruta/a/DQL_PROCEDIMIENTOS.sql;
SOURCE /ruta/a/DQL_TRIGGERS.sql;
SOURCE /ruta/a/DQL_EVENTOS.sql;
```

### 4️⃣ Consultas de ejemplo
```sql
SOURCE /ruta/a/DQL_SELECT.sql;
```

### 5️⃣ Crear roles y usuarios
Ejecutar:
```sql
-- Administrador
CREATE USER 'administrador'@'localhost' IDENTIFIED BY 'Campus2023';
GRANT ALL PRIVILEGES ON gestion_agroindustrial.* TO 'administrador'@'localhost';

-- Gerente
CREATE USER 'gerente'@'localhost' IDENTIFIED BY 'Campus2023';
GRANT SELECT, INSERT, UPDATE, DELETE ON gestion_agroindustrial.ventas TO 'gerente'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE ON gestion_agroindustrial.produccion TO 'gerente'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE ON gestion_agroindustrial.inventario TO 'gerente'@'localhost';

-- Vendedor
CREATE USER 'vendedor'@'localhost' IDENTIFIED BY 'Campus2023';
GRANT SELECT, INSERT ON gestion_agroindustrial.ventas TO 'vendedor'@'localhost';
GRANT SELECT, INSERT ON gestion_agroindustrial.cliente TO 'vendedor'@'localhost';

-- Agricultor
CREATE USER 'agricultor'@'localhost' IDENTIFIED BY 'Campus2023';
GRANT SELECT, INSERT ON gestion_agroindustrial.produccion TO 'agricultor'@'localhost';

-- Contador
CREATE USER 'contador'@'localhost' IDENTIFIED BY 'Campus2023';
GRANT SELECT ON gestion_agroindustrial.ventas TO 'contador'@'localhost';
GRANT SELECT ON gestion_agroindustrial.compras TO 'contador'@'localhost';

FLUSH PRIVILEGES;
```

---

## 🗄️ Estructura de la Base de Datos
La base de datos **`gestion_agroindustrial`** contiene las siguientes tablas principales:

| Tabla | Descripción |
|-------|-------------|
| **CLIENTE** | Datos personales y tipo de cliente. |
| **DIRECCION_CLIENTE** | Direcciones asociadas a cada cliente. |
| **VENTAS** | Registro de ventas realizadas. |
| **DETALLES_VENTA** | Detalle de productos vendidos por venta. |
| **PRODUCTO** | Información de productos con tipo, precio y proveedor. |
| **PRECIO_PRODUCTO** | Histórico de precios por producto. |
| **PROVEEDOR** | Información de proveedores. |
| **INVENTARIO** | Control de stock por bodega. |
| **BODEGA** | Ubicación y datos de bodegas. |
| **COMPRAS** / **DETALLES_COMPRA** | Registro y detalle de compras. |
| **PRODUCCION** | Producción agrícola, responsable y maquinaria usada. |
| **MAQUINARIA** | Inventario y estado de maquinaria. |
| **MANTENIMIENTO** | Mantenimientos programados o realizados. |
| **DEPARTAMENTO** | Departamentos internos. |
| **EMPLEADO** | Información de empleados, cargo y salario. |

---

## 🔍 Ejemplos de Consultas
Algunas consultas incluidas en `DQL_SELECT.sql`:

```sql
-- Listar todos los clientes con sus datos
SELECT * FROM CLIENTE;

-- Productos con precio mayor a $2000
SELECT * FROM PRODUCTO WHERE Precio_unitario > 2000;

-- Ventas realizadas en enero de 2023
SELECT * FROM VENTAS 
WHERE Fecha_Venta BETWEEN '2023-01-01' AND '2023-01-31';

-- Clientes de tipo Mayorista
SELECT * FROM CLIENTE WHERE Tipo = 'Mayorista';

-- Total de ventas por método de pago
SELECT Metodo_Pago, SUM(Cantidad * Precio_Por_Unidad) AS Total
FROM DETALLES_VENTA dv
JOIN VENTAS v ON dv.ID_Venta = v.ID_Venta
GROUP BY Metodo_Pago;
```

---

## 🛠️ Procedimientos, Funciones, Triggers y Eventos

### **Procedimientos**
Ejemplos:
- `Agregar_clientes` → Registra un nuevo cliente.
- `Modificar_precio` → Actualiza precio de producto manteniendo histórico.
- `Reporte_Ventas` → Genera informe de ventas por rango de fechas.
- `Rotacion_Inventario` → Calcula la rotación de inventarios.

### **Funciones**
Ejemplos:
- `Salario_Anual` → Calcula salario anual de un empleado.
- `Precio_Producto` → Obtiene precio por nombre de producto.
- `PrecioConIVA` → Calcula precio con IVA del 19%.
- `DiasDesdeRegistro` → Días desde la primera compra de un cliente.

### **Triggers**
Ejemplos:
- Evitar eliminar proveedor con compras (`trg_proveedor_con_compras`).
- Descontar inventario tras una venta (`tr_after_venta_insert`).
- Bloquear eliminación de bodega con inventario (`trg_bodega_con_inventario`).

### **Eventos**
Ejemplos:
- `Calcular_Costos_Produccion_Mensual` → Calcula costos mensuales de producción.
- `Actualizar_Horas_Uso_Maquinaria` → Suma horas diarias de uso.
- `Revisar_Caducidad_Precios` → Detecta precios sin cambios en 180 días.

---

## 👥 Roles de Usuario y Permisos
| Rol | Permisos |
|-----|----------|
| **Administrador** | Acceso total a todas las tablas y operaciones. |
| **Gerente** | CRUD en ventas, producción e inventario. |
| **Vendedor** | Lectura y alta de ventas y clientes. |
| **Agricultor** | Lectura y alta de producción. |
| **Contador** | Lectura de ventas y compras. |

---

## 🤝 Contribuciones
Este proyecto fue desarrollado por:
- **Carlos Cisneros Vega** – Diseño y creación de estructura de base de datos, procedimientos, triggers y funciones.
- **Juan Jose Arrublas Gutierrez** – Inserción de datos, consultas avanzadas, creación de eventos y documentación.

---

## 📜 Licencia y Contacto
**Licencia:** Libre uso para fines académicos.  
**Contacto:** Para consultas o mejoras, escribir a: `contacto@gestionagro.com`.
