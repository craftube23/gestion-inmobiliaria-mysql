# 🏠 Sistema de Gestión Inmobiliaria - MySQL

Proyecto de base de datos profesional para la administración de propiedades, clientes, contratos y pagos.

## 📂 Estructura del Proyecto

```text
gestion-inmobiliaria-mysql/
├── docs/
│   └── normalizacion.xlsx          # Proceso 0NF → 3FN + MER
├── sql/
│   ├── ddl/
│   │   └── 01_create_database.sql  # Creación de BD y tablas
│   ├── functions/
│   │   └── 02_funciones_udf.sql    # Lógica de negocio
│   ├── triggers/
│   │   └── 03_triggers_auditoria.sql # Auditoría automática
│   ├── security/
│   │   └── 04_roles_privilegios.sql # RBAC (Roles y usuarios)
│   └── events/
│       └── 05_evento_reporte_mensual.sql # Automatización de reportes
├── data/                           # Inserts de prueba
└── README.md                       # Documentación
```


## 🚀 Instalación y Uso

1. **Requisito:** Tener instalado MySQL 8.0+ o MariaDB.
2. **Ejecución de scripts:** Ejecuta en la terminal en este **orden estricto**:

> **mysql -u root -p < sql/ddl/01_create_database.sql
> mysql -u root -p inmobiliaria_db < sql/functions/02_funciones_udf.sql
> mysql -u root -p inmobiliaria_db < sql/triggers/03_triggers_auditoria.sql
> mysql -u root -p inmobiliaria_db < sql/security/04_roles_privilegios.sql
> mysql -u root -p inmobiliaria_db < sql/events/05_evento_reporte_mensual.sql**

3. **Activar Automatización:** Ejecuta dentro de MySQL para habilitar los reportes programados:

SET GLOBAL event_scheduler = ON;

## 🔐 Seguridad y Accesos


| **Usuario**   | **Contraseña**  | **Rol**           |
| ------------- | ---------------- | ----------------- |
| **admin1**    | `AdminSeguro123` | Acceso total      |
| **agente1**   | `AgentePass456`  | Operaciones       |
| **contador1** | `Contador789`    | Reportes/Finanzas |

## 📊 Modelo de Datos

* **Normalización:** 3ra Forma Normal (3FN).
* **Entidades:** Propiedades, Agentes, Clientes, Contratos, Pagos.
* **Auditoría:** Registro de cambios de estado y nuevos contratos.

## 🔍 Consultas de Ejemplo

* **Comisión de Agente:**`SELECT calcular_comision_venta(1) AS comision;`
* **Deuda de Alquiler:**`SELECT calcular_deuda_pendiente(2) AS deuda;`
* **Stock de Propiedades:**`SELECT total_propiedades_disponibles_por_tipo(1) AS total;`
* **Reporte Mensual:**`SELECT * FROM Reporte_Pagos_Pendientes ORDER BY fecha_generacion DESC;`
