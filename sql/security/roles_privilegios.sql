-- Seguridad: Creación de roles y privilegios diferenciados

-- Rol Administrador (acceso total)
CREATE ROLE 'admin_inmobiliaria';
GRANT ALL PRIVILEGES ON inmobiliaria_db.* TO 'admin_inmobiliaria';

-- Rol Agente Inmobiliario (lectura/escritura limitada)
CREATE ROLE 'agente_inmobiliaria';
GRANT SELECT, INSERT, UPDATE ON inmobiliaria_db.Propiedad TO 'agente_inmobiliaria';
GRANT SELECT, INSERT, UPDATE ON inmobiliaria_db.Contrato TO 'agente_inmobiliaria';
GRANT SELECT ON inmobiliaria_db.Cliente TO 'agente_inmobiliaria';
GRANT SELECT ON inmobiliaria_db.Agente TO 'agente_inmobiliaria';
GRANT SELECT, INSERT ON inmobiliaria_db.Pago TO 'agente_inmobiliaria';

-- Rol Contador (lectura financiera + reportes)
CREATE ROLE 'contador_inmobiliaria';
GRANT SELECT ON inmobiliaria_db.* TO 'contador_inmobiliaria';
GRANT UPDATE (fecha_pago, estado) ON inmobiliaria_db.Pago TO 'contador_inmobiliaria';
GRANT SELECT ON inmobiliaria_db.Auditoria_Propiedad TO 'contador_inmobiliaria';
GRANT SELECT ON inmobiliaria_db.Auditoria_Contrato TO 'contador_inmobiliaria';

-- Ejemplo de usuarios (usuarios  demo)
CREATE USER 'admin1'@'localhost' IDENTIFIED BY 'AdminSeguro123';
CREATE USER 'agente1'@'localhost' IDENTIFIED BY 'AgentePass456';
CREATE USER 'contador1'@'localhost' IDENTIFIED BY 'Contador789';

GRANT 'admin_inmobiliaria' TO 'admin1'@'localhost';
GRANT 'agente_inmobiliaria' TO 'agente1'@'localhost';
GRANT 'contador_inmobiliaria' TO 'contador1'@'localhost';

-- Activar roles por defecto al loguear (opcional)
SET DEFAULT ROLE ALL TO 'admin1'@'localhost', 'agente1'@'localhost', 'contador1'@'localhost';