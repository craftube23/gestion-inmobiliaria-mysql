-- Funciones personalizadas para el Sistema de Gestión Inmobiliaria

DELIMITER //

-- 1. Calcular comisión de un agente en una venta específica
CREATE FUNCTION calcular_comision_venta(id_contrato_param INT)
RETURNS DECIMAL(12,2)
DETERMINISTIC
BEGIN
    DECLARE comision DECIMAL(12,2);
    DECLARE porc_comision DECIMAL(5,2);
    DECLARE monto_venta DECIMAL(15,2);
    
    SELECT c.monto_total, a.comision_porcentaje
    INTO monto_venta, porc_comision
    FROM Contrato c
    JOIN Agente a ON c.id_agente = a.id_agente
    WHERE c.id_contrato = id_contrato_param
    AND c.tipo_contrato = 'Venta';
    
    IF monto_venta IS NULL THEN
        RETURN 0.00;
    END IF;
    
    SET comision = monto_venta * (porc_comision / 100);
    RETURN comision;
END //

-- 2. Calcular deuda pendiente de un contrato de alquiler
CREATE FUNCTION calcular_deuda_pendiente(id_contrato_param INT)
RETURNS DECIMAL(12,2)
DETERMINISTIC
BEGIN
    DECLARE deuda DECIMAL(12,2) DEFAULT 0.00;
    
    SELECT SUM(monto) INTO deuda
    FROM Pago
    WHERE id_contrato = id_contrato_param
    AND estado IN ('Pendiente', 'Vencido')
    AND tipo_contrato = 'Alquiler';  -- Asegura que sea alquiler
    
    RETURN IFNULL(deuda, 0.00);
END //

-- 3. Total de propiedades disponibles por tipo
CREATE FUNCTION total_propiedades_disponibles_por_tipo(id_tipo_param INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE total INT;
    
    SELECT COUNT(*) INTO total
    FROM Propiedad
    WHERE id_tipo = id_tipo_param
    AND estado = 'Disponible';
    
    RETURN total;
END //

DELIMITER ;