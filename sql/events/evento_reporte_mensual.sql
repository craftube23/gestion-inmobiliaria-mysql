-- Optimización adicional e Evento programado mensual

-- Índices extras para consultas frecuentes
CREATE INDEX idx_pago_contrato_estado ON Pago(id_contrato, estado);
CREATE INDEX idx_contrato_propiedad_tipo ON Contrato(id_propiedad, tipo_contrato);

-- Tabla para reportes automáticos de pagos pendientes
CREATE TABLE IF NOT EXISTS Reporte_Pagos_Pendientes (
    id_reporte INT AUTO_INCREMENT PRIMARY KEY,
    fecha_generacion DATE NOT NULL,
    id_contrato INT NOT NULL,
    cliente_nombre VARCHAR(200),
    propiedad_direccion VARCHAR(150),
    monto_pendiente DECIMAL(12,2),
    pagos_vencidos INT,
    detalles TEXT,
    FOREIGN KEY (id_contrato) REFERENCES Contrato(id_contrato) ON DELETE CASCADE
);

-- Evento mensual: Genera reporte de pagos pendientes el día 1 de cada mes
DELIMITER //
CREATE EVENT evento_reporte_pagos_mensual
ON SCHEDULE EVERY 1 MONTH
STARTS CURRENT_TIMESTAMP + INTERVAL 1 DAY - INTERVAL HOUR(CURRENT_TIMESTAMP) HOUR - INTERVAL MINUTE(CURRENT_TIMESTAMP) MINUTE + INTERVAL 1 DAY
DO
BEGIN
    -- Limpiar reportes antiguos (opcional: últimos 12 meses)
    DELETE FROM Reporte_Pagos_Pendientes
    WHERE fecha_generacion < DATE_SUB(CURRENT_DATE, INTERVAL 12 MONTH);

    -- Insertar nuevo reporte
    INSERT INTO Reporte_Pagos_Pendientes (
        fecha_generacion,
        id_contrato,
        cliente_nombre,
        propiedad_direccion,
        monto_pendiente,
        pagos_vencidos,
        detalles
    )
    SELECT 
        CURRENT_DATE,
        c.id_contrato,
        CONCAT(cl.nombre, ' ', cl.apellido) AS cliente_nombre,
        p.direccion AS propiedad_direccion,
        SUM(pa.monto) AS monto_pendiente,
        COUNT(CASE WHEN pa.fecha_programada < CURRENT_DATE AND pa.estado != 'Pagado' THEN 1 END) AS pagos_vencidos,
        GROUP_CONCAT(CONCAT('Cuota ', pa.numero_pago, ': $', pa.monto, ' (', pa.estado, ')') SEPARATOR '; ') AS detalles
    FROM Contrato c
    JOIN Cliente cl ON c.id_cliente = cl.id_cliente
    JOIN Propiedad p ON c.id_propiedad = p.id_propiedad
    JOIN Pago pa ON c.id_contrato = pa.id_contrato
    WHERE c.tipo_contrato = 'Alquiler'
    AND c.estado = 'Activo'
    AND pa.estado IN ('Pendiente', 'Vencido')
    GROUP BY c.id_contrato
    HAVING monto_pendiente > 0;
END //
DELIMITER ;

-- Activar el scheduler de eventos (solo si no está ya)
SET GLOBAL event_scheduler = ON;