-- Sistema de Gestión Inmobiliaria - Creación de BD

DROP DATABASE IF EXISTS inmobiliaria_db;
CREATE DATABASE inmobiliaria_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE inmobiliaria_db;

-- Tabla Tipos de Propiedad (para no repetir strings)
CREATE TABLE TipoPropiedad (
    id_tipo INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL UNIQUE,  -- Casa, Apartamento, Local Comercial, Oficina, etc.
    descripcion TEXT
);

-- Tabla Propiedades
CREATE TABLE Propiedad (
    id_propiedad INT AUTO_INCREMENT PRIMARY KEY,
    id_tipo INT NOT NULL,
    direccion VARCHAR(150) NOT NULL,
    ciudad VARCHAR(100) NOT NULL,
    precio_venta DECIMAL(15,2) DEFAULT NULL,
    precio_alquiler_mensual DECIMAL(12,2) DEFAULT NULL,
    estado ENUM('Disponible', 'Arrendada', 'Vendida', 'Reservada') DEFAULT 'Disponible',
    fecha_registro DATE DEFAULT (CURRENT_DATE),
    FOREIGN KEY (id_tipo) REFERENCES TipoPropiedad(id_tipo) ON DELETE RESTRICT
);

-- Tabla Agentes
CREATE TABLE Agente (
    id_agente INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    telefono VARCHAR(20),
    comision_porcentaje DECIMAL(5,2) DEFAULT 5.00  -- % comisión estándar
);

-- Tabla Clientes
CREATE TABLE Cliente (
    id_cliente INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE,
    telefono VARCHAR(20),
    tipo_interes ENUM('Compra', 'Alquiler', 'Ambos') DEFAULT 'Ambos'
);

-- Tabla Contratos
CREATE TABLE Contrato (
    id_contrato INT AUTO_INCREMENT PRIMARY KEY,
    id_propiedad INT NOT NULL,
    id_cliente INT NOT NULL,
    id_agente INT NOT NULL,
    tipo_contrato ENUM('Venta', 'Alquiler') NOT NULL,
    fecha_firma DATE NOT NULL,
    monto_total DECIMAL(15,2) NOT NULL,  -- Precio venta o total alquiler proyectado
    duracion_meses INT DEFAULT NULL,     -- Para alquileres
    estado ENUM('Activo', 'Finalizado', 'Cancelado', 'Pendiente') DEFAULT 'Activo',
    FOREIGN KEY (id_propiedad) REFERENCES Propiedad(id_propiedad) ON DELETE RESTRICT,
    FOREIGN KEY (id_cliente) REFERENCES Cliente(id_cliente) ON DELETE RESTRICT,
    FOREIGN KEY (id_agente) REFERENCES Agente(id_agente) ON DELETE RESTRICT
);

-- Tabla Pagos (para historial de arriendos/ventas)
CREATE TABLE Pago (
    id_pago INT AUTO_INCREMENT PRIMARY KEY,
    id_contrato INT NOT NULL,
    numero_pago INT NOT NULL,  -- 1,2,3... o cuota
    fecha_programada DATE NOT NULL,
    monto DECIMAL(12,2) NOT NULL,
    fecha_pago DATE DEFAULT NULL,
    estado ENUM('Pendiente', 'Pagado', 'Vencido') DEFAULT 'Pendiente',
    FOREIGN KEY (id_contrato) REFERENCES Contrato(id_contrato) ON DELETE CASCADE
);

-- Índices básicos para optimización (parte de los 8 puntos de optimización)
CREATE INDEX idx_propiedad_estado ON Propiedad(estado);
CREATE INDEX idx_contrato_fecha ON Contrato(fecha_firma);
CREATE INDEX idx_pago_estado ON Pago(estado);