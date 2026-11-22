-- Esquema SQL de contingencia compatible con H2 (Modo PostgreSQL)
DROP VIEW IF EXISTS vw_resumen_viaje_pasajero;
DROP TABLE IF EXISTS calificacion;
DROP TABLE IF EXISTS pago;
DROP TABLE IF EXISTS historial_estado_viaje;
DROP TABLE IF EXISTS viaje;
DROP TABLE IF EXISTS vehiculo;
DROP TABLE IF EXISTS conductor;
DROP TABLE IF EXISTS direccion_favorita;
DROP TABLE IF EXISTS metodo_pago;
DROP TABLE IF EXISTS empleado_empresa;
DROP TABLE IF EXISTS pasajero;
DROP TABLE IF EXISTS empresa;
DROP TABLE IF EXISTS estado_viaje;
DROP TABLE IF EXISTS tipo_servicio;
DROP TABLE IF EXISTS pais;

CREATE TABLE pais (
    id_pais INT PRIMARY KEY,
    nombre_pais VARCHAR(60) NOT NULL,
    moneda VARCHAR(3) NOT NULL,
    codigo_iso VARCHAR(2) NOT NULL,
    prefijo_telefonico VARCHAR(5) NOT NULL
);

CREATE TABLE tipo_servicio (
    id_tipo_servicio INT PRIMARY KEY,
    nombre_servicio VARCHAR(50) NOT NULL,
    descripcion VARCHAR(255) NOT NULL,
    tarifa_base NUMERIC(10, 2) NOT NULL,
    tarifa_km NUMERIC(10, 2) NOT NULL,
    capacidad_pasajeros INT NOT NULL DEFAULT 4,
    activo BOOLEAN NOT NULL DEFAULT TRUE
);

CREATE TABLE estado_viaje (
    id_estado INT PRIMARY KEY,
    nombre_estado VARCHAR(30) NOT NULL,
    descripcion VARCHAR(150)
);

CREATE TABLE empresa (
    id_empresa INT PRIMARY KEY,
    ruc_nit VARCHAR(20) NOT NULL,
    razon_social VARCHAR(150) NOT NULL,
    tipo_empresa VARCHAR(30) NOT NULL,
    id_pais INT NOT NULL,
    contacto VARCHAR(100) NOT NULL,
    correo_contacto VARCHAR(120) NOT NULL,
    telefono_contacto VARCHAR(25) NOT NULL,
    direccion_fiscal VARCHAR(255) NOT NULL,
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_pais) REFERENCES pais(id_pais)
);

CREATE TABLE pasajero (
    id_pasajero INT PRIMARY KEY,
    nombres VARCHAR(100) NOT NULL,
    apellidos VARCHAR(100) NOT NULL,
    tipo_documento VARCHAR(20) NOT NULL,
    numero_documento VARCHAR(25) NOT NULL,
    telefono VARCHAR(20) NOT NULL,
    correo VARCHAR(120) NOT NULL,
    id_pais INT NOT NULL,
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_pais) REFERENCES pais(id_pais)
);

CREATE TABLE empleado_empresa (
    id_empleado INT PRIMARY KEY,
    id_empresa INT NOT NULL,
    id_pasajero INT NOT NULL,
    cargo VARCHAR(100) NOT NULL,
    limite_mensual NUMERIC(10, 2) DEFAULT 0.00,
    activo BOOLEAN NOT NULL DEFAULT TRUE,
    fecha_asignacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_empresa) REFERENCES empresa(id_empresa),
    FOREIGN KEY (id_pasajero) REFERENCES pasajero(id_pasajero)
);

CREATE TABLE metodo_pago (
    id_metodo_pago INT PRIMARY KEY,
    id_pasajero INT NOT NULL,
    tipo_metodo VARCHAR(50) NOT NULL,
    numero_referencia VARCHAR(50) NOT NULL,
    titular VARCHAR(120) NOT NULL,
    predeterminado BOOLEAN NOT NULL DEFAULT FALSE,
    activo BOOLEAN NOT NULL DEFAULT TRUE,
    FOREIGN KEY (id_pasajero) REFERENCES pasajero(id_pasajero)
);

CREATE TABLE direccion_favorita (
    id_direccion INT PRIMARY KEY,
    id_pasajero INT NOT NULL,
    nombre_direccion VARCHAR(50) NOT NULL,
    ciudad VARCHAR(50) NOT NULL,
    direccion VARCHAR(200) NOT NULL,
    referencia VARCHAR(200),
    latitud NUMERIC(10, 7),
    longitud NUMERIC(10, 7),
    FOREIGN KEY (id_pasajero) REFERENCES pasajero(id_pasajero)
);

CREATE TABLE conductor (
    id_conductor INT PRIMARY KEY,
    id_empresa_flota INT,
    nombres VARCHAR(100) NOT NULL,
    apellidos VARCHAR(100) NOT NULL,
    tipo_documento VARCHAR(20) NOT NULL,
    numero_documento VARCHAR(25) NOT NULL,
    telefono VARCHAR(20) NOT NULL,
    correo VARCHAR(120) NOT NULL,
    numero_licencia VARCHAR(50) NOT NULL,
    categoria_licencia VARCHAR(20) NOT NULL,
    vencimiento_licencia DATE NOT NULL,
    estado VARCHAR(20) NOT NULL DEFAULT 'Disponible',
    cuenta_pago VARCHAR(50) NOT NULL,
    id_pais INT NOT NULL,
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_empresa_flota) REFERENCES empresa(id_empresa),
    FOREIGN KEY (id_pais) REFERENCES pais(id_pais)
);

CREATE TABLE vehiculo (
    id_vehiculo INT PRIMARY KEY,
    id_conductor INT NOT NULL,
    placa VARCHAR(15) NOT NULL,
    marca VARCHAR(50) NOT NULL,
    modelo VARCHAR(50) NOT NULL,
    anio INT NOT NULL,
    color VARCHAR(30) NOT NULL,
    id_tipo_servicio INT NOT NULL,
    seguro VARCHAR(50) NOT NULL,
    vencimiento_seguro DATE NOT NULL,
    estado VARCHAR(20) NOT NULL DEFAULT 'Activo',
    FOREIGN KEY (id_conductor) REFERENCES conductor(id_conductor),
    FOREIGN KEY (id_tipo_servicio) REFERENCES tipo_servicio(id_tipo_servicio)
);

CREATE TABLE viaje (
    id_viaje INT PRIMARY KEY,
    id_pasajero INT NOT NULL,
    id_conductor INT,
    id_vehiculo INT,
    id_tipo_servicio INT NOT NULL,
    id_estado INT NOT NULL,
    id_pais INT NOT NULL,
    es_corporativo BOOLEAN NOT NULL DEFAULT FALSE,
    origen VARCHAR(255) NOT NULL,
    destino VARCHAR(255) NOT NULL,
    fecha_solicitud TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_inicio TIMESTAMP,
    fecha_fin TIMESTAMP,
    distancia_km NUMERIC(8, 2) NOT NULL,
    tarifa_total NUMERIC(10, 2) NOT NULL,
    moneda VARCHAR(3) NOT NULL,
    FOREIGN KEY (id_pasajero) REFERENCES pasajero(id_pasajero),
    FOREIGN KEY (id_conductor) REFERENCES conductor(id_conductor),
    FOREIGN KEY (id_vehiculo) REFERENCES vehiculo(id_vehiculo),
    FOREIGN KEY (id_tipo_servicio) REFERENCES tipo_servicio(id_tipo_servicio),
    FOREIGN KEY (id_estado) REFERENCES estado_viaje(id_estado),
    FOREIGN KEY (id_pais) REFERENCES pais(id_pais)
);

CREATE TABLE historial_estado_viaje (
    id_historial INT PRIMARY KEY,
    id_viaje INT NOT NULL,
    estado_anterior VARCHAR(50),
    estado_nuevo VARCHAR(50) NOT NULL,
    fecha_cambio TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_viaje) REFERENCES viaje(id_viaje)
);

CREATE TABLE pago (
    id_pago INT PRIMARY KEY,
    id_viaje INT NOT NULL,
    id_metodo_pago INT,
    monto NUMERIC(10, 2) NOT NULL,
    moneda VARCHAR(3) NOT NULL,
    fecha_pago TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    estado VARCHAR(20) NOT NULL DEFAULT 'Completado',
    comision_plataforma NUMERIC(10, 2) NOT NULL,
    FOREIGN KEY (id_viaje) REFERENCES viaje(id_viaje),
    FOREIGN KEY (id_metodo_pago) REFERENCES metodo_pago(id_metodo_pago)
);

CREATE TABLE calificacion (
    id_calificacion INT PRIMARY KEY,
    id_viaje INT NOT NULL,
    puntaje INT NOT NULL,
    comentario TEXT,
    fecha_calificacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    tipo_calificador VARCHAR(20) NOT NULL,
    FOREIGN KEY (id_viaje) REFERENCES viaje(id_viaje)
);

CREATE VIEW vw_resumen_viaje_pasajero AS
SELECT 
    v.id_viaje,
    v.id_pasajero,
    pas.nombres || ' ' || pas.apellidos AS nombre_pasajero,
    p.nombre_pais AS pais,
    v.es_corporativo,
    ts.nombre_servicio,
    ev.nombre_estado AS estado_viaje,
    v.origen,
    v.destino,
    v.fecha_solicitud,
    v.fecha_inicio,
    v.fecha_fin,
    v.distancia_km,
    v.tarifa_total,
    v.moneda,
    c.id_conductor,
    COALESCE(c.nombres || ' ' || c.apellidos, 'Sin Asignar') AS nombre_conductor,
    c.telefono AS telefono_conductor,
    veh.placa,
    veh.marca || ' ' || veh.modelo AS vehiculo,
    veh.color AS color_vehiculo,
    pag.estado AS estado_pago,
    COALESCE(mp.tipo_metodo, 'No Registrado') AS metodo_pago,
    cal.puntaje AS calificacion_otorgada,
    cal.comentario AS comentario_calificacion
FROM viaje v
JOIN pasajero pas ON v.id_pasajero = pas.id_pasajero
JOIN pais p ON v.id_pais = p.id_pais
JOIN tipo_servicio ts ON v.id_tipo_servicio = ts.id_tipo_servicio
JOIN estado_viaje ev ON v.id_estado = ev.id_estado
LEFT JOIN conductor c ON v.id_conductor = c.id_conductor
LEFT JOIN vehiculo veh ON v.id_vehiculo = veh.id_vehiculo
LEFT JOIN pago pag ON v.id_viaje = pag.id_viaje
LEFT JOIN metodo_pago mp ON pag.id_metodo_pago = mp.id_metodo_pago
LEFT JOIN calificacion cal ON v.id_viaje = cal.id_viaje AND cal.tipo_calificador = 'Pasajero';
