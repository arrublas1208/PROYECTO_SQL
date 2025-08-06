# Sistema de Gestión Agroindustrial 🌽🛠️📦

Este proyecto representa un modelo de base de datos relacional diseñado para gestionar una operación agroindustrial completa. Incluye el manejo de empleados, productos, inventario, maquinaria, ventas, producción, proveedores y clientes.

---

## 🧱 Estructura del Modelo de Datos

### Tablas principales

- **EMPLEADO**: Información sobre los trabajadores y su relación con departamentos.
- **DEPARTAMENTO**: Área a la que pertenece un empleado (Producción, Ventas, etc.).
- **PROVEEDOR**: Entidades externas que suministran productos o materias primas.
- **PRODUCTO**: Detalles sobre los productos producidos o vendidos.
- **INVENTARIO**: Control de stock y disponibilidad.
- **MAQUINARIA**: Equipos usados en la producción (estado, uso, adquisición).
- **CLIENTE**: Compradores o usuarios finales.
- **VENTAS**: Registro de ventas realizadas.
- **DETALLE_VENTA**: Productos vendidos por cada transacción.
- **PRODUCCIÓN**: Registro de lo producido, fechas y maquinaria involucrada.
- **MANTENIMIENTO_MAQUINARIA**: Registro de mantenimientos realizados.

---

## 🧩 Relaciones entre Tablas

- Un `EMPLEADO` pertenece a un `DEPARTAMENTO`
- Una `VENTA` pertenece a un `CLIENTE`
- Una `VENTA` tiene múltiples `DETALLE_VENTA`
- Un `PRODUCTO` tiene una relación con `PROVEEDOR`, `INVENTARIO`, y `PRODUCCIÓN`
- Una `PRODUCCIÓN` está asociada a una `MAQUINARIA` y un `EMPLEADO`
- Las `COMPRAS` son realizadas a `PROVEEDORES` y tienen `DETALLE_COMPRA`
- La `MAQUINARIA` puede tener registros en `MANTENIMIENTO_MAQUINARIA`

---

## 📷 Diagrama ER

![Diagrama ER](A_diagram_of_an_Entity-Relationship_(ER)_data_mode.png)

---

## 💡 Recomendaciones

- Extiende el modelo para incluir auditoría de usuarios si será usado en producción.
- Agrega constraints de integridad y triggers según las reglas de negocio.
- Considera usar vistas (views) para facilitar reportes de ventas o inventario.

---

## 🛠️ Tecnologías sugeridas

- **MySQL / PostgreSQL** como motor de base de datos
- **Workbench / dbdiagram.io** para edición visual del modelo

---

## 📁 Estructura del repositorio

```
📦 proyecto_agroindustrial
 ┣ 📄 README.md
 ┣ 📄 modelo_ER.png
 ┗ 📂 scripts_sql
     ┣ 📄 crear_tablas.sql
     ┗ 📄 insertar_datos.sql
```

---

## ✍️ Autores

Juan José – Estudiante de Desarrollo de Software 
Carlos Cisneros  - Estudiante Ingenieria de Sistemas
