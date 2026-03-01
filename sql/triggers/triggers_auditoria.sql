-- Triggers de auditoría para el Sistema de Gestión Inmobiliaria

-- Tabla de auditoría para cambios en propiedades
CREATE TABLE IF NOT EXISTS Auditoria_Propiedad (
    id_auditoria INT AUTO_INCREMENT PRIMARY KEY,
    id_propiedad INT NOT NULL,
    estado_anterior ENUM('Disponible', 'Arrendada', 'Vendida', 'Reservada'),
    estado_nuevo ENUM('Disponible', 'Arrendada', 'Vendida', 'Reservada'),
    fecha_cambio DATETIME DEFAULT CURRENT_TIMESTAMP,
    usuario VARCHAR(100) DEFAULT USER()
);

-- Trigger: Registrar cambio de estado en Propiedad
DELIMITER //
CREATE TRIGGER trg_propiedad_cambio_estado
AFTER UPDATE ON Propiedad
FOR EACH ROW
BEGIN
    IF OLD.estado != NEW.estado THEN
        INSERT INTO Auditoria_Propiedad (id_propiedad, estado_anterior, estado_nuevo)
        VALUES (OLD.id_propiedad, OLD.estado, NEW.estado);
    END IF;
END //
DELIMITER ;

-- Tabla de auditoría para nuevos contratos
CREATE TABLE IF NOT EXISTS Auditoria_Contrato (
    id_auditoria INT AUTO_INCREMENT PRIMARY KEY,
    id_contrato INT NOT NULL,
    accion VARCHAR(50) NOT NULL,  -- 'INSERT' por ahora
    fecha_registro DATETIME DEFAULT CURRENT_TIMESTAMP,
    usuario VARCHAR(100) DEFAULT USER()
);

-- Trigger: Registrar nuevo contrato
DELIMITER //
CREATE TRIGGER trg_contrato_nuevo
AFTER INSERT ON Contrato
FOR EACH ROW
BEGIN
    INSERT INTO Auditoria_Contrato (id_contrato, accion)
    VALUES (NEW.id_contrato, 'INSERT');
END //
DELIMITER ;