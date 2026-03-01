-- Inserts de prueba para Sistema de Gestión Inmobiliaria

USE inmobiliaria_db;

-- Tipos de Propiedad
INSERT INTO TipoPropiedad (nombre, descripcion) VALUES
('Casa', 'Vivienda unifamiliar'),
('Apartamento', 'Unidad en edificio'),
('Local Comercial', 'Espacio para negocios'),
('Oficina', 'Espacio administrativo');

-- Propiedades
INSERT INTO Propiedad (id_tipo, direccion, ciudad, precio_venta, precio_alquiler_mensual, estado) VALUES
(1, 'Calle 45 #12-34', 'Floridablanca', 850000000.00, NULL, 'Disponible'),
(2, 'Avenida Santander 76-89', 'Bucaramanga', 320000000.00, 1800000.00, 'Arrendada'),
(3, 'Carrera 22 #15-67', 'Bucaramanga', NULL, 3500000.00, 'Disponible'),
(1, 'Barrio La Floresta Mz 3 Cs 8', 'Floridablanca', 620000000.00, NULL, 'Vendida'),
(2, 'Calle 100 #1E-45 Torre Norte Apt 1203', 'Bucaramanga', 280000000.00, 1500000.00, 'Disponible');

-- Agentes
INSERT INTO Agente (nombre, apellido, email, telefono, comision_porcentaje) VALUES
('Juan', 'Pérez', 'juan.perez@inmobiliaria.co', '3001234567', 5.00),
('María', 'Gómez', 'maria.gomez@inmobiliaria.co', '3159876543', 6.50),
('Carlos', 'Rodríguez', 'carlos.rodriguez@inmobiliaria.co', '3184567890', 4.80);

-- Clientes
INSERT INTO Cliente (nombre, apellido, email, telefono, tipo_interes) VALUES
('Ana', 'López', 'ana.lopez@gmail.com', '3012345678', 'Alquiler'),
('Pedro', 'Martínez', 'pedro.mtz@hotmail.com', '3208765432', 'Compra'),
('Sofía', 'Ramírez', 'sofia.ramirez@yahoo.com', '3123456789', 'Ambos'),
('Luis', 'Hernández', 'luis.hdz@outlook.com', '3009876543', 'Alquiler');

-- Contratos
INSERT INTO Contrato (id_propiedad, id_cliente, id_agente, tipo_contrato, fecha_firma, monto_total, duracion_meses, estado) VALUES
(2, 1, 1, 'Alquiler', '2026-01-15', 21600000.00, 12, 'Activo'),          -- 1.8M x 12
(5, 2, 2, 'Venta', '2026-02-20', 280000000.00, NULL, 'Activo'),
(1, 3, 3, 'Venta', '2025-11-10', 850000000.00, NULL, 'Pendiente'),
(3, 4, 1, 'Alquiler', '2026-03-05', 42000000.00, 12, 'Activo');           -- 3.5M x 12

-- Pagos (algunos pendientes, vencidos y pagados para probar funciones)
INSERT INTO Pago (id_contrato, numero_pago, fecha_programada, monto, fecha_pago, estado) VALUES
(1, 1, '2026-02-01', 1800000.00, '2026-02-02', 'Pagado'),
(1, 2, '2026-03-01', 1800000.00, NULL, 'Pendiente'),
(1, 3, '2026-04-01', 1800000.00, NULL, 'Pendiente'),
(4, 1, '2026-04-05', 3500000.00, NULL, 'Vencido'),   -- Vencido para probar deuda
(4, 2, '2026-05-05', 3500000.00, NULL, 'Pendiente'),
(2, 1, '2026-02-20', 280000000.00, '2026-02-25', 'Pagado');  -- Venta completa