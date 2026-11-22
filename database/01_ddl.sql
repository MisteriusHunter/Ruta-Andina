-- ============================================================================
-- PROYECTO COLABORATIVO COIL 2026: RUTA ANDINA
-- TECSUP (Perú) & Institución Universitaria Politécnico Grancolombiano (Colombia)
-- Integrantes: Alexander Rojas, Mateo Atapoma y equipo binacional COIL
-- Archivo: 01_ddl.sql - Definición de Estructura de Base de Datos (14 Entidades en 3FN)
-- Compatible con: Supabase (PostgreSQL 14 / 15 / 16)
-- ============================================================================

-- Limpieza preventiva en orden inverso a dependencias de llaves foráneas
DROP VIEW IF EXISTS vw_resumen_viaje_pasajero CASCADE;
DROP TABLE IF EXISTS calificacion CASCADE;
DROP TABLE IF EXISTS pago CASCADE;
DROP TABLE IF EXISTS historial_estado_viaje CASCADE;
DROP TABLE IF EXISTS viaje CASCADE;
DROP TABLE IF EXISTS vehiculo CASCADE;
DROP TABLE IF EXISTS conductor CASCADE;
DROP TABLE IF EXISTS direccion_favorita CASCADE;
DROP TABLE IF EXISTS metodo_pago CASCADE;
DROP TABLE IF EXISTS empleado_empresa CASCADE;
DROP TABLE IF EXISTS pasajero CASCADE;
DROP TABLE IF EXISTS empresa CASCADE;
DROP TABLE IF EXISTS estado_viaje CASCADE;
DROP TABLE IF EXISTS tipo_servicio CASCADE;
DROP TABLE IF EXISTS pais CASCADE;

-- ----------------------------------------------------------------------------
-- 1. ENTIDAD: PAIS
-- Almacena los países de operación binacional y su moneda oficial
-- ----------------------------------------------------------------------------
CREATE TABLE pais (
    id_pais SERIAL PRIMARY KEY,
    nombre_pais VARCHAR(60) NOT NULL UNIQUE,
    moneda VARCHAR(3) NOT NULL,
    codigo_iso VARCHAR(2) NOT NULL UNIQUE,
    prefijo_telefonico VARCHAR(5) NOT NULL,
    CONSTRAINT chk_pais_moneda CHECK (moneda IN ('PEN', 'COP'))
);

COMMENT ON TABLE pais IS 'Países donde opera la plataforma Ruta Andina (Perú y Colombia)';
COMMENT ON COLUMN pais.moneda IS 'Moneda oficial restringida a PEN (Sol peruano) o COP (Peso colombiano)';

-- ----------------------------------------------------------------------------
-- 2. ENTIDAD: TIPO_SERVICIO
-- Catálogo de servicios disponibles con sus tarifas base y por kilómetro
-- ----------------------------------------------------------------------------
CREATE TABLE tipo_servicio (
    id_tipo_servicio SERIAL PRIMARY KEY,
    nombre_servicio VARCHAR(50) NOT NULL UNIQUE,
    descripcion VARCHAR(255) NOT NULL,
    tarifa_base NUMERIC(10, 2) NOT NULL CHECK (tarifa_base >= 0),
    tarifa_km NUMERIC(10, 2) NOT NULL CHECK (tarifa_km >= 0),
    capacidad_pasajeros INT NOT NULL DEFAULT 4 CHECK (capacidad_pasajeros > 0),
    activo BOOLEAN NOT NULL DEFAULT TRUE
);

COMMENT ON TABLE tipo_servicio IS 'Tipos de servicio de transporte (Estándar, Confort, Executive Black, etc.)';

-- ----------------------------------------------------------------------------
-- 3. ENTIDAD: ESTADO_VIAJE
-- Catálogo estricto del ciclo de vida de un viaje
-- ----------------------------------------------------------------------------
CREATE TABLE estado_viaje (
    id_estado SERIAL PRIMARY KEY,
    nombre_estado VARCHAR(30) NOT NULL UNIQUE,
    descripcion VARCHAR(150),
    CONSTRAINT chk_nombre_estado CHECK (nombre_estado IN ('Solicitado', 'Aceptado', 'En Curso', 'Finalizado', 'Cancelado'))
);

COMMENT ON TABLE estado_viaje IS 'Estados estrictos por los que transita un viaje en Ruta Andina';

-- ----------------------------------------------------------------------------
-- 4. ENTIDAD: EMPRESA
-- Entidades corporativas: Operadora central, Clientes Corporativos y Flotas
-- ----------------------------------------------------------------------------
CREATE TABLE empresa (
    id_empresa SERIAL PRIMARY KEY,
    ruc_nit VARCHAR(20) NOT NULL UNIQUE,
    razon_social VARCHAR(150) NOT NULL,
    tipo_empresa VARCHAR(30) NOT NULL,
    id_pais INT NOT NULL,
    contacto VARCHAR(100) NOT NULL,
    correo_contacto VARCHAR(120) NOT NULL,
    telefono_contacto VARCHAR(25) NOT NULL,
    direccion_fiscal VARCHAR(255) NOT NULL,
    fecha_registro TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_empresa_pais FOREIGN KEY (id_pais) REFERENCES pais(id_pais) ON UPDATE CASCADE,
    CONSTRAINT chk_tipo_empresa CHECK (tipo_empresa IN ('Operadora', 'Cliente_Corporativo', 'Flota'))
);

COMMENT ON TABLE empresa IS 'Empresas registradas (Operadora, Clientes Corporativos y Empresas de Flota)';

-- ----------------------------------------------------------------------------
-- 5. ENTIDAD: PASAJERO
-- Usuarios individuales o corporativos que solicitan traslados
-- ----------------------------------------------------------------------------
CREATE TABLE pasajero (
    id_pasajero SERIAL PRIMARY KEY,
    nombres VARCHAR(100) NOT NULL,
    apellidos VARCHAR(100) NOT NULL,
    tipo_documento VARCHAR(20) NOT NULL,
    numero_documento VARCHAR(25) NOT NULL,
    telefono VARCHAR(20) NOT NULL,
    correo VARCHAR(120) NOT NULL UNIQUE,
    id_pais INT NOT NULL,
    fecha_registro TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_pasajero_pais FOREIGN KEY (id_pais) REFERENCES pais(id_pais) ON UPDATE CASCADE,
    CONSTRAINT uq_pasajero_documento UNIQUE (tipo_documento, numero_documento),
    CONSTRAINT chk_pasajero_tipo_doc CHECK (tipo_documento IN ('DNI', 'CE', 'CC', 'Pasaporte'))
);

COMMENT ON TABLE pasajero IS 'Pasajeros registrados en la plataforma';

-- ----------------------------------------------------------------------------
-- 6. ENTIDAD: EMPLEADO_EMPRESA
-- Asociación de pasajeros a cuentas corporativas para cobro a empresa
-- ----------------------------------------------------------------------------
CREATE TABLE empleado_empresa (
    id_empleado SERIAL PRIMARY KEY,
    id_empresa INT NOT NULL,
    id_pasajero INT NOT NULL,
    cargo VARCHAR(100) NOT NULL,
    limite_mensual NUMERIC(10, 2) DEFAULT 0.00 CHECK (limite_mensual >= 0),
    activo BOOLEAN NOT NULL DEFAULT TRUE,
    fecha_asignacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_empleado_empresa FOREIGN KEY (id_empresa) REFERENCES empresa(id_empresa) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_empleado_pasajero FOREIGN KEY (id_pasajero) REFERENCES pasajero(id_pasajero) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT uq_empleado_empresa_pasajero UNIQUE (id_empresa, id_pasajero)
);

COMMENT ON TABLE empleado_empresa IS 'Relación que habilita a un pasajero a cargar viajes a cuenta de su empresa';

-- ----------------------------------------------------------------------------
-- 7. ENTIDAD: METODO_PAGO
-- Métodos de pago registrados por el pasajero
-- ----------------------------------------------------------------------------
CREATE TABLE metodo_pago (
    id_metodo_pago SERIAL PRIMARY KEY,
    id_pasajero INT NOT NULL,
    tipo_metodo VARCHAR(50) NOT NULL,
    numero_referencia VARCHAR(50) NOT NULL,
    titular VARCHAR(120) NOT NULL,
    predeterminado BOOLEAN NOT NULL DEFAULT FALSE,
    activo BOOLEAN NOT NULL DEFAULT TRUE,
    CONSTRAINT fk_metodo_pasajero FOREIGN KEY (id_pasajero) REFERENCES pasajero(id_pasajero) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT chk_tipo_metodo CHECK (tipo_metodo IN ('Tarjeta_Credito', 'Tarjeta_Debito', 'Efectivo', 'Cuenta_Corporativa', 'Billetera_Digital'))
);

COMMENT ON TABLE metodo_pago IS 'Medios de pago asociados a un pasajero';

-- ----------------------------------------------------------------------------
-- 8. ENTIDAD: DIRECCION_FAVORITA
-- Puntos frecuentes guardados por los pasajeros
-- ----------------------------------------------------------------------------
CREATE TABLE direccion_favorita (
    id_direccion SERIAL PRIMARY KEY,
    id_pasajero INT NOT NULL,
    nombre_direccion VARCHAR(50) NOT NULL,
    ciudad VARCHAR(50) NOT NULL,
    direccion VARCHAR(200) NOT NULL,
    referencia VARCHAR(200),
    latitud NUMERIC(10, 7),
    longitud NUMERIC(10, 7),
    CONSTRAINT fk_direccion_pasajero FOREIGN KEY (id_pasajero) REFERENCES pasajero(id_pasajero) ON UPDATE CASCADE ON DELETE CASCADE
);

COMMENT ON TABLE direccion_favorita IS 'Direcciones habituales de los pasajeros (Casa, Trabajo, Sede Corporativa, etc.)';

-- ----------------------------------------------------------------------------
-- 9. ENTIDAD: CONDUCTOR
-- Choferes profesionales certificados con control estricto de licencias
-- ----------------------------------------------------------------------------
CREATE TABLE conductor (
    id_conductor SERIAL PRIMARY KEY,
    id_empresa_flota INT,
    nombres VARCHAR(100) NOT NULL,
    apellidos VARCHAR(100) NOT NULL,
    tipo_documento VARCHAR(20) NOT NULL,
    numero_documento VARCHAR(25) NOT NULL UNIQUE,
    telefono VARCHAR(20) NOT NULL,
    correo VARCHAR(120) NOT NULL UNIQUE,
    numero_licencia VARCHAR(50) NOT NULL UNIQUE,
    categoria_licencia VARCHAR(20) NOT NULL,
    vencimiento_licencia DATE NOT NULL,
    estado VARCHAR(20) NOT NULL DEFAULT 'Disponible',
    cuenta_pago VARCHAR(50) NOT NULL,
    id_pais INT NOT NULL,
    fecha_registro TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_conductor_flota FOREIGN KEY (id_empresa_flota) REFERENCES empresa(id_empresa) ON UPDATE CASCADE ON DELETE SET NULL,
    CONSTRAINT fk_conductor_pais FOREIGN KEY (id_pais) REFERENCES pais(id_pais) ON UPDATE CASCADE,
    CONSTRAINT chk_conductor_estado CHECK (estado IN ('Disponible', 'Ocupado', 'Inactivo', 'Suspendido')),
    CONSTRAINT chk_conductor_tipo_doc CHECK (tipo_documento IN ('DNI', 'CE', 'CC', 'Pasaporte'))
);

COMMENT ON TABLE conductor IS 'Conductores afiliados directamente o mediante empresas de flota';

-- ----------------------------------------------------------------------------
-- 10. ENTIDAD: VEHICULO
-- Unidades vehiculares asignadas a los conductores con vigencia de seguro
-- ----------------------------------------------------------------------------
CREATE TABLE vehiculo (
    id_vehiculo SERIAL PRIMARY KEY,
    id_conductor INT NOT NULL,
    placa VARCHAR(15) NOT NULL UNIQUE,
    marca VARCHAR(50) NOT NULL,
    modelo VARCHAR(50) NOT NULL,
    anio INT NOT NULL,
    color VARCHAR(30) NOT NULL,
    id_tipo_servicio INT NOT NULL,
    seguro VARCHAR(50) NOT NULL,
    vencimiento_seguro DATE NOT NULL,
    estado VARCHAR(20) NOT NULL DEFAULT 'Activo',
    CONSTRAINT fk_vehiculo_conductor FOREIGN KEY (id_conductor) REFERENCES conductor(id_conductor) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_vehiculo_tipo_servicio FOREIGN KEY (id_tipo_servicio) REFERENCES tipo_servicio(id_tipo_servicio) ON UPDATE CASCADE,
    CONSTRAINT chk_vehiculo_anio CHECK (anio >= 2012 AND anio <= 2027),
    CONSTRAINT chk_vehiculo_estado CHECK (estado IN ('Activo', 'Mantenimiento', 'Inactivo'))
);

COMMENT ON TABLE vehiculo IS 'Vehículos registrados con seguro vigente asignados a un conductor';

-- ----------------------------------------------------------------------------
-- 11. ENTIDAD: VIAJE
-- Operación central de traslado entre origen y destino
-- ----------------------------------------------------------------------------
CREATE TABLE viaje (
    id_viaje SERIAL PRIMARY KEY,
    id_pasajero INT NOT NULL,
    id_conductor INT,
    id_vehiculo INT,
    id_tipo_servicio INT NOT NULL,
    id_estado INT NOT NULL DEFAULT 1,
    id_pais INT NOT NULL,
    es_corporativo BOOLEAN NOT NULL DEFAULT FALSE,
    origen VARCHAR(255) NOT NULL,
    destino VARCHAR(255) NOT NULL,
    fecha_solicitud TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    fecha_inicio TIMESTAMP,
    fecha_fin TIMESTAMP,
    distancia_km NUMERIC(8, 2) NOT NULL CHECK (distancia_km >= 0),
    tarifa_total NUMERIC(10, 2) NOT NULL CHECK (tarifa_total >= 0),
    moneda VARCHAR(3) NOT NULL,
    CONSTRAINT fk_viaje_pasajero FOREIGN KEY (id_pasajero) REFERENCES pasajero(id_pasajero) ON UPDATE CASCADE,
    CONSTRAINT fk_viaje_conductor FOREIGN KEY (id_conductor) REFERENCES conductor(id_conductor) ON UPDATE CASCADE,
    CONSTRAINT fk_viaje_vehiculo FOREIGN KEY (id_vehiculo) REFERENCES vehiculo(id_vehiculo) ON UPDATE CASCADE,
    CONSTRAINT fk_viaje_tipo_servicio FOREIGN KEY (id_tipo_servicio) REFERENCES tipo_servicio(id_tipo_servicio) ON UPDATE CASCADE,
    CONSTRAINT fk_viaje_estado FOREIGN KEY (id_estado) REFERENCES estado_viaje(id_estado) ON UPDATE CASCADE,
    CONSTRAINT fk_viaje_pais FOREIGN KEY (id_pais) REFERENCES pais(id_pais) ON UPDATE CASCADE,
    CONSTRAINT chk_viaje_moneda CHECK (moneda IN ('PEN', 'COP')),
    CONSTRAINT chk_fechas_viaje CHECK (
        (fecha_inicio IS NULL OR fecha_inicio >= fecha_solicitud) AND
        (fecha_fin IS NULL OR (fecha_inicio IS NOT NULL AND fecha_fin >= fecha_inicio))
    )
);

COMMENT ON TABLE viaje IS 'Registro de traslados urbanos y corporativos';

-- ----------------------------------------------------------------------------
-- 12. ENTIDAD: HISTORIAL_ESTADO_VIAJE
-- Auditoría de trazabilidad inmutable del ciclo de vida del viaje
-- ----------------------------------------------------------------------------
CREATE TABLE historial_estado_viaje (
    id_historial SERIAL PRIMARY KEY,
    id_viaje INT NOT NULL,
    estado_anterior VARCHAR(50),
    estado_nuevo VARCHAR(50) NOT NULL,
    fecha_cambio TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_historial_viaje FOREIGN KEY (id_viaje) REFERENCES viaje(id_viaje) ON DELETE CASCADE
);

COMMENT ON TABLE historial_estado_viaje IS 'Auditoría inmutable de transiciones de estado de cada viaje';

-- ----------------------------------------------------------------------------
-- 13. ENTIDAD: PAGO
-- Transacciones financieras vinculadas a cada viaje finalizado
-- ----------------------------------------------------------------------------
CREATE TABLE pago (
    id_pago SERIAL PRIMARY KEY,
    id_viaje INT NOT NULL UNIQUE,
    id_metodo_pago INT,
    monto NUMERIC(10, 2) NOT NULL CHECK (monto >= 0),
    moneda VARCHAR(3) NOT NULL,
    fecha_pago TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    estado VARCHAR(20) NOT NULL DEFAULT 'Completado',
    comision_plataforma NUMERIC(10, 2) NOT NULL CHECK (comision_plataforma >= 0),
    CONSTRAINT fk_pago_viaje FOREIGN KEY (id_viaje) REFERENCES viaje(id_viaje) ON DELETE CASCADE,
    CONSTRAINT fk_pago_metodo FOREIGN KEY (id_metodo_pago) REFERENCES metodo_pago(id_metodo_pago) ON UPDATE CASCADE ON DELETE SET NULL,
    CONSTRAINT chk_pago_moneda CHECK (moneda IN ('PEN', 'COP')),
    CONSTRAINT chk_pago_estado CHECK (estado IN ('Pendiente', 'Completado', 'Fallido', 'Reembolsado'))
);

COMMENT ON TABLE pago IS 'Registro de cobro y liquidación de comisiones de Ruta Andina';

-- ----------------------------------------------------------------------------
-- 14. ENTIDAD: CALIFICACION
-- Evaluaciones bidireccionales de calidad del servicio
-- ----------------------------------------------------------------------------
CREATE TABLE calificacion (
    id_calificacion SERIAL PRIMARY KEY,
    id_viaje INT NOT NULL,
    puntaje INT NOT NULL,
    comentario TEXT,
    fecha_calificacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    tipo_calificador VARCHAR(20) NOT NULL,
    CONSTRAINT fk_calificacion_viaje FOREIGN KEY (id_viaje) REFERENCES viaje(id_viaje) ON DELETE CASCADE,
    CONSTRAINT chk_calificacion_puntaje CHECK (puntaje >= 1 AND puntaje <= 5),
    CONSTRAINT chk_calificacion_tipo CHECK (tipo_calificador IN ('Pasajero', 'Conductor'))
);

COMMENT ON TABLE calificacion IS 'Calificaciones 1 a 5 estrellas emitidas por pasajero o conductor';

-- ============================================================================
-- INDICES PARA OPTIMIZACION DE CONSULTAS DE NEGOCIO
-- ============================================================================
CREATE INDEX idx_viaje_conductor ON viaje(id_conductor);
CREATE INDEX idx_viaje_pasajero ON viaje(id_pasajero);
CREATE INDEX idx_viaje_estado ON viaje(id_estado);
CREATE INDEX idx_viaje_pais ON viaje(id_pais);
CREATE INDEX idx_viaje_fecha_solicitud ON viaje(fecha_solicitud);
CREATE INDEX idx_conductor_licencia_venc ON conductor(vencimiento_licencia);
CREATE INDEX idx_vehiculo_seguro_venc ON vehiculo(vencimiento_seguro);
CREATE INDEX idx_pago_viaje ON pago(id_viaje);
CREATE INDEX idx_calificacion_viaje ON calificacion(id_viaje);

-- ============================================================================
-- TRIGGERS Y FUNCIONES DE INTEGRIDAD DE NEGOCIO (POSTGRESQL / SUPABASE)
-- ============================================================================

-- ----------------------------------------------------------------------------
-- TRIGGER 1: VALIDACION ESTRICTA DE DOCUMENTOS DE CONDUCTOR Y VEHICULO
-- Regla de negocio: No se puede asignar un viaje a un conductor con licencia
-- vencida o con vehículo cuyo seguro (SOAT) esté vencido a la fecha actual.
-- ----------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION fn_validar_documentos_viaje()
RETURNS TRIGGER AS $$
DECLARE
    v_venc_licencia DATE;
    v_venc_seguro DATE;
    v_estado_conductor VARCHAR(20);
BEGIN
    -- Solo validar si se está asignando o actualizando conductor o vehículo
    IF NEW.id_conductor IS NOT NULL THEN
        SELECT vencimiento_licencia, estado 
        INTO v_venc_licencia, v_estado_conductor
        FROM conductor 
        WHERE id_conductor = NEW.id_conductor;

        IF v_venc_licencia < CURRENT_DATE THEN
            RAISE EXCEPTION 'Regla de Negocio COIL: El conductor tiene la licencia vencida (Vence: %). No puede recibir viajes.', v_venc_licencia;
        END IF;

        IF v_estado_conductor = 'Suspendido' THEN
            RAISE EXCEPTION 'Regla de Negocio COIL: El conductor está Suspendido. No puede recibir viajes.';
        END IF;
    END IF;

    IF NEW.id_vehiculo IS NOT NULL THEN
        SELECT vencimiento_seguro 
        INTO v_venc_seguro
        FROM vehiculo 
        WHERE id_vehiculo = NEW.id_vehiculo;

        IF v_venc_seguro < CURRENT_DATE THEN
            RAISE EXCEPTION 'Regla de Negocio COIL: El vehículo asignado tiene el seguro vehicular (SOAT) vencido (Vence: %). No puede operar.', v_venc_seguro;
        END IF;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_validar_documentos_viaje ON viaje;
CREATE TRIGGER trg_validar_documentos_viaje
BEFORE INSERT OR UPDATE OF id_conductor, id_vehiculo ON viaje
FOR EACH ROW
EXECUTE FUNCTION fn_validar_documentos_viaje();

-- ----------------------------------------------------------------------------
-- TRIGGER 2: REGISTRO AUTOMATICO DE HISTORIAL DE ESTADOS
-- Registra en historial_estado_viaje cada cambio de estado de un viaje
-- ----------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION fn_registrar_historial_estado()
RETURNS TRIGGER AS $$
DECLARE
    v_estado_ant VARCHAR(50);
    v_estado_new VARCHAR(50);
BEGIN
    SELECT nombre_estado INTO v_estado_new FROM estado_viaje WHERE id_estado = NEW.id_estado;
    
    IF TG_OP = 'INSERT' THEN
        INSERT INTO historial_estado_viaje (id_viaje, estado_anterior, estado_nuevo, fecha_cambio)
        VALUES (NEW.id_viaje, NULL, v_estado_new, CURRENT_TIMESTAMP);
    ELSIF TG_OP = 'UPDATE' AND (OLD.id_estado IS DISTINCT FROM NEW.id_estado) THEN
        SELECT nombre_estado INTO v_estado_ant FROM estado_viaje WHERE id_estado = OLD.id_estado;
        INSERT INTO historial_estado_viaje (id_viaje, estado_anterior, estado_nuevo, fecha_cambio)
        VALUES (NEW.id_viaje, v_estado_ant, v_estado_new, CURRENT_TIMESTAMP);
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_registrar_historial_estado ON viaje;
CREATE TRIGGER trg_registrar_historial_estado
AFTER INSERT OR UPDATE OF id_estado ON viaje
FOR EACH ROW
EXECUTE FUNCTION fn_registrar_historial_estado();

-- ----------------------------------------------------------------------------
-- TRIGGER 3: LIQUIDACION AUTOMATICA DE PAGO Y LIBERACION DE CONDUCTOR
-- Cuando el viaje pasa a 'Finalizado', se calcula automáticamente la comisión
-- de la plataforma (15%) y se genera el registro en la tabla pago si no existe,
-- liberando además el estado del conductor a 'Disponible'.
-- ----------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION fn_procesar_viaje_finalizado()
RETURNS TRIGGER AS $$
DECLARE
    v_nombre_estado VARCHAR(30);
    v_comision NUMERIC(10, 2);
    v_metodo_defecto INT;
BEGIN
    SELECT nombre_estado INTO v_nombre_estado FROM estado_viaje WHERE id_estado = NEW.id_estado;

    IF v_nombre_estado = 'Finalizado' THEN
        -- Calcular comisión de la plataforma: 15% del total
        v_comision := ROUND(NEW.tarifa_total * 0.15, 2);

        -- Buscar método predeterminado del pasajero o el primero disponible
        SELECT id_metodo_pago INTO v_metodo_defecto
        FROM metodo_pago 
        WHERE id_pasajero = NEW.id_pasajero
        ORDER BY predeterminado DESC, id_metodo_pago ASC
        LIMIT 1;

        -- Insertar pago si no fue insertado previamente
        IF NOT EXISTS (SELECT 1 FROM pago WHERE id_viaje = NEW.id_viaje) THEN
            INSERT INTO pago (id_viaje, id_metodo_pago, monto, moneda, fecha_pago, estado, comision_plataforma)
            VALUES (NEW.id_viaje, v_metodo_defecto, NEW.tarifa_total, NEW.moneda, CURRENT_TIMESTAMP, 'Completado', v_comision);
        END IF;

        -- Liberar conductor a Disponible
        IF NEW.id_conductor IS NOT NULL THEN
            UPDATE conductor SET estado = 'Disponible' WHERE id_conductor = NEW.id_conductor;
        END IF;
    ELSIF v_nombre_estado = 'En Curso' THEN
        -- Marcar conductor como Ocupado
        IF NEW.id_conductor IS NOT NULL THEN
            UPDATE conductor SET estado = 'Ocupado' WHERE id_conductor = NEW.id_conductor;
        END IF;
    ELSIF v_nombre_estado = 'Cancelado' THEN
        -- Si se cancela y tenía conductor, devolver a Disponible
        IF NEW.id_conductor IS NOT NULL THEN
            UPDATE conductor SET estado = 'Disponible' WHERE id_conductor = NEW.id_conductor;
        END IF;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_procesar_viaje_finalizado ON viaje;
CREATE TRIGGER trg_procesar_viaje_finalizado
AFTER UPDATE OF id_estado ON viaje
FOR EACH ROW
EXECUTE FUNCTION fn_procesar_viaje_finalizado();
