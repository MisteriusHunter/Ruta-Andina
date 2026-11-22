-- ============================================================================
-- PROYECTO COLABORATIVO COIL 2026: RUTA ANDINA
-- TECSUP (PerÃº) & InstituciÃ³n Universitaria PolitÃ©cnico Grancolombiano (Colombia)
-- Integrantes: Alexander Rojas, Mateo Atapoma y equipo binacional COIL
-- Archivo: 02_dml.sql - Datos de Prueba Realistas y Coherentes (Lima & MEDotÃ¡)
-- Compatible con: Supabase (PostgreSQL 14 / 15 / 16)
-- ============================================================================

-- Desactivar temporalmente triggers de auditorÃ­a si fuera necesario, o insertar en orden estricto
-- ----------------------------------------------------------------------------
-- 1. PAÃSES (PerÃº y Colombia)
-- ----------------------------------------------------------------------------
INSERT INTO pais (id_pais, nombre_pais, moneda, codigo_iso, prefijo_telefonico) VALUES
(1, 'PerÃº', 'PEN', 'PE', '+51'),
(2, 'Colombia', 'COP', 'CO', '+57')
ON CONFLICT (id_pais) DO NOTHING;

-- ----------------------------------------------------------------------------
-- 2. TIPOS DE SERVICIO
-- Tarifas base y por km (normalizadas para cÃ¡lculo; el backend y cotizador aplican factor de escala local)
-- ----------------------------------------------------------------------------
INSERT INTO tipo_servicio (id_tipo_servicio, nombre_servicio, descripcion, tarifa_base, tarifa_km, capacidad_pasajeros, activo) VALUES
(1, 'Andina EstÃ¡ndar', 'Movilidad urbana Ã¡gil, moderna y econÃ³mica para el dÃ­a a dÃ­a', 6.00, 1.80, 4, true),
(2, 'Andina Confort', 'Sedanes amplios con aire acondicionado, asientos premium y alta valoraciÃ³n', 9.50, 2.40, 4, true),
(3, 'Executive Black', 'VehÃ­culos de alta gama, chofer bilingÃ¼e de traje y amenidades a bordo', 16.00, 3.80, 4, true),
(4, 'Van Corporativa', 'Transporte para equipos de trabajo, traslados al aeropuerto y delegaciones', 28.00, 5.50, 7, true),
(5, 'EnvÃ­o Express', 'Entrega inmediata de documentos corporativos y paquetes con seguimiento en vivo', 5.00, 1.50, 1, true)
ON CONFLICT (id_tipo_servicio) DO NOTHING;

-- ----------------------------------------------------------------------------
-- 3. ESTADOS DE VIAJE
-- ----------------------------------------------------------------------------
INSERT INTO estado_viaje (id_estado, nombre_estado, descripcion) VALUES
(1, 'Solicitado', 'Viaje solicitado por el pasajero esperando asignaciÃ³n de conductor'),
(2, 'Aceptado', 'Conductor ha aceptado el servicio y va en camino al punto de origen'),
(3, 'En Curso', 'Pasajero a bordo del vehÃ­culo en trayecto al destino'),
(4, 'Finalizado', 'Viaje completado exitosamente y liquidado con la plataforma'),
(5, 'Cancelado', 'Viaje cancelado por el pasajero o conductor antes de completarse')
ON CONFLICT (id_estado) DO NOTHING;

-- ----------------------------------------------------------------------------
-- 4. EMPRESAS (Operadoras, Clientes Corporativos y Flotas en Lima y MEDotÃ¡)
-- ----------------------------------------------------------------------------
INSERT INTO empresa (id_empresa, ruc_nit, razon_social, tipo_empresa, id_pais, contacto, correo_contacto, telefono_contacto, direccion_fiscal) VALUES
(1, '20601928371', 'Ruta Andina PerÃº Operaciones S.A.C.', 'Operadora', 1, 'Mateo Atapoma', 'operaciones.pe@rutaandina.com', '+51 987654321', 'Av. Javier Prado Este 4200, Surco, Lima'),
(2, '901458921-3', 'Ruta Andina Colombia Movilidad S.A.S.', 'Operadora', 2, 'Alexander Rojas', 'operaciones.co@rutaandina.com', '+57 3109876543', 'Calle 10 # 43E-20, ChicÃ³ Norte, MEDotÃ¡'),
(3, '20100047218', 'Banco de CrÃ©dito del PerÃº BCP - Corporativo', 'Cliente_Corporativo', 1, 'Valeria Mendoza (Gerencia RRHH)', 'movilidad.bcp@bcp.com.pe', '+51 971234567', 'Calle Centenario 156, La Molina, Lima'),
(4, '890903938-8', 'Bancolombia S.A. - DivisiÃ³n Corporativa', 'Cliente_Corporativo', 2, 'Camilo Restrepo (Operaciones)', 'movilidad.Medellin@bancolombia.com.co', '+57 3154567890', 'Carrera 43A # 1-50, Torre Bancolombia, MEDotÃ¡'),
(5, '20554891024', 'Flota Andina Express Lima S.A.C.', 'Flota', 1, 'Jorge Barrenechea (Jefe Flota)', 'flota.lima@andinaexpress.pe', '+51 965432187', 'Av. TomÃ¡s Marsano 1840, Surquillo, Lima'),
(6, '900762194-5', 'Transportes Ejecutivos Andinos MEDotÃ¡ S.A.S.', 'Flota', 2, 'Gustavo PinzÃ³n (Director LogÃ­stica)', 'flota.Medellin@ejecutivosandinos.co', '+57 3123456789', 'Calle 100 # 19-61, UsaquÃ©n, MEDotÃ¡')
ON CONFLICT (id_empresa) DO NOTHING;

-- ----------------------------------------------------------------------------
-- 5. PASAJEROS (20 pasajeros: 10 en Lima, 10 en MEDotÃ¡)
-- ----------------------------------------------------------------------------
INSERT INTO pasajero (id_pasajero, nombres, apellidos, tipo_documento, numero_documento, telefono, correo, id_pais) VALUES
-- Pasajeros PerÃº (Lima)
(1, 'Luciana', 'Vargas Castro', 'DNI', '72349012', '+51 941230001', 'luciana.vargas@gmail.com', 1),
(2, 'Rodrigo', 'Quispe Navarro', 'DNI', '45891234', '+51 941230002', 'rodrigo.quispe@bcp.com.pe', 1),
(3, 'Fiorella', 'Benavides Wong', 'DNI', '73456789', '+51 941230003', 'fiorella.benavides@outlook.com', 1),
(4, 'Diego', 'Alva Centeno', 'DNI', '48901235', '+51 941230004', 'diego.alva@bcp.com.pe', 1),
(5, 'Mariana', 'Paz SoldÃ¡n', 'DNI', '71234560', '+51 941230005', 'mariana.paz@empresa.pe', 1),
(6, 'Gonzalo', 'Flores CÃ¡rdenas', 'DNI', '46789012', '+51 941230006', 'gonzalo.flores@yahoo.es', 1),
(7, 'Camila', 'Ramos Salazar', 'DNI', '74567891', '+51 941230007', 'camila.ramos@bcp.com.pe', 1),
(8, 'SebastiÃ¡n', 'Morales Gil', 'DNI', '43215678', '+51 941230008', 'sebastian.morales@tecsup.edu.pe', 1),
(9, 'Andrea', 'ChÃ¡vez Larco', 'DNI', '70984512', '+51 941230009', 'andrea.chavez@consulting.pe', 1),
(10, 'JoaquÃ­n', 'Bustamante Silva', 'DNI', '47890123', '+51 941230010', 'joaquin.bustamante@corp.pe', 1),
-- Pasajeros Colombia (MEDotÃ¡)
(11, 'Juliana', 'GÃ³mez Jaramillo', 'CC', '1018456789', '+57 3001230011', 'juliana.gomez@bancolombia.com.co', 2),
(12, 'AndrÃ©s Felipe', 'MuÃ±oz RincÃ³n', 'CC', '1020456123', '+57 3001230012', 'andres.munoz@poligran.edu.co', 2),
(13, 'Valentina', 'Osorio Caicedo', 'CC', '1032987456', '+57 3001230013', 'valentina.osorio@gmail.com', 2),
(14, 'Santiago', 'Herrera Pardo', 'CC', '1015678234', '+57 3001230014', 'santiago.herrera@bancolombia.com.co', 2),
(15, 'Daniela', 'Cardona Duque', 'CC', '1024567890', '+57 3001230015', 'daniela.cardona@startup.co', 2),
(16, 'Mateo', 'Villamizar Prada', 'CC', '1019876543', '+57 3001230016', 'mateo.villamizar@telecom.co', 2),
(17, 'Catalina', 'Restrepo MejÃ­a', 'CC', '1035678901', '+57 3001230017', 'catalina.restrepo@bancolombia.com.co', 2),
(18, 'NicolÃ¡s', 'PeÃ±a SantamarÃ­a', 'CC', '1014321987', '+57 3001230018', 'nicolas.pena@andina.co', 2),
(19, 'Gabriela', 'Montoya VÃ©lez', 'CC', '1027654321', '+57 3001230019', 'gabriela.montoya@fintech.co', 2),
(20, 'Felipe', 'BeltrÃ¡n Cifuentes', 'CC', '1012345678', '+57 3001230020', 'felipe.beltran@bancolombia.com.co', 2)
ON CONFLICT (id_pasajero) DO NOTHING;

-- ----------------------------------------------------------------------------
-- 6. EMPLEADOS DE EMPRESAS (Clientes Corporativos BCP y Bancolombia)
-- ----------------------------------------------------------------------------
INSERT INTO empleado_empresa (id_empleado, id_empresa, id_pasajero, cargo, limite_mensual, activo) VALUES
-- BCP Lima
(1, 3, 2, 'Gerente Adjunto de Finanzas', 1500.00, true),
(2, 3, 4, 'Auditor Senior de Riesgos', 1200.00, true),
(3, 3, 7, 'Subgerente de Banca Corporativa', 2000.00, true),
(4, 3, 10, 'Analista de Infraestructura TI', 800.00, true),
-- Bancolombia MEDotÃ¡
(5, 4, 11, 'Directora de Banca Mayorista', 4500000.00, true),
(6, 4, 14, 'Especialista en TesorerÃ­a', 3000000.00, true),
(7, 4, 17, 'Gerente de TransformaciÃ³n Digital', 4000000.00, true),
(8, 4, 20, 'LÃ­der TÃ©cnico de Arquitectura', 2500000.00, true)
ON CONFLICT (id_empleado) DO NOTHING;

-- ----------------------------------------------------------------------------
-- 7. METODOS DE PAGO
-- ----------------------------------------------------------------------------
INSERT INTO metodo_pago (id_metodo_pago, id_pasajero, tipo_metodo, numero_referencia, titular, predeterminado, activo) VALUES
-- MÃ©todos PerÃº
(1, 1, 'Tarjeta_Credito', 'Visa **** 4912', 'Luciana Vargas', true, true),
(2, 2, 'Cuenta_Corporativa', 'BCP-CORP-001', 'Banco de CrÃ©dito BCP', true, true),
(3, 3, 'Billetera_Digital', 'Yape 941230003', 'Fiorella Benavides', true, true),
(4, 4, 'Cuenta_Corporativa', 'BCP-CORP-002', 'Banco de CrÃ©dito BCP', true, true),
(5, 5, 'Tarjeta_Debito', 'Mastercard **** 8120', 'Mariana Paz SoldÃ¡n', true, true),
(6, 6, 'Efectivo', 'Efectivo en Soles (PEN)', 'Gonzalo Flores', true, true),
(7, 7, 'Cuenta_Corporativa', 'BCP-CORP-003', 'Banco de CrÃ©dito BCP', true, true),
(8, 8, 'Billetera_Digital', 'Plin 941230008', 'SebastiÃ¡n Morales', true, true),
-- MÃ©todos Colombia
(9, 11, 'Cuenta_Corporativa', 'BANCOLOMBIA-CORP-101', 'Bancolombia S.A.', true, true),
(10, 12, 'Billetera_Digital', 'Nequi 3001230012', 'AndrÃ©s Felipe MuÃ±oz', true, true),
(11, 13, 'Tarjeta_Credito', 'Mastercard **** 9015', 'Valentina Osorio', true, true),
(12, 14, 'Cuenta_Corporativa', 'BANCOLOMBIA-CORP-102', 'Bancolombia S.A.', true, true),
(13, 15, 'Tarjeta_Debito', 'Visa **** 3144', 'Daniela Cardona', true, true),
(14, 16, 'Billetera_Digital', 'DaviPlata 3001230016', 'Mateo Villamizar', true, true),
(15, 17, 'Cuenta_Corporativa', 'BANCOLOMBIA-CORP-103', 'Bancolombia S.A.', true, true),
(16, 20, 'Cuenta_Corporativa', 'BANCOLOMBIA-CORP-104', 'Bancolombia S.A.', true, true)
ON CONFLICT (id_metodo_pago) DO NOTHING;

-- ----------------------------------------------------------------------------
-- 8. DIRECCIONES FAVORITAS
-- ----------------------------------------------------------------------------
INSERT INTO direccion_favorita (id_direccion, id_pasajero, nombre_direccion, ciudad, direccion, referencia, latitud, longitud) VALUES
(1, 1, 'Departamento', 'Lima', 'Av. MalecÃ³n de la Reserva 729, Miraflores', 'Frente a Larcomar', -12.1312, -77.0298),
(2, 1, 'Oficina San Isidro', 'Lima', 'Av. Canaval y Moreyra 480, San Isidro', 'Edificio Alto Caral, Piso 14', -12.0965, -77.0241),
(3, 2, 'Sede Central BCP', 'Lima', 'Calle Centenario 156, La Molina', 'Edificio Las Begonias', -12.0867, -76.9542),
(4, 2, 'Casa', 'Lima', 'Av. del EjÃ©rcito 1240, Magdalena del Mar', 'Cerca al malecÃ³n', -12.1054, -77.0689),
(5, 11, 'Torre Bancolombia', 'MEDotÃ¡', 'Carrera 43A # 1-50, Chapinero', 'RecepciÃ³n Torre Sur', 4.6548, -74.0571),
(6, 11, 'Apartamento', 'MEDotÃ¡', 'Calle 127A # 15-30, UsaquÃ©n', 'Conjunto Bosques del Norte', 4.7082, -74.0412),
(7, 12, 'Campus PolitÃ©cnico', 'MEDotÃ¡', 'Calle 57 # 3-00 Este, Chapinero Alto', 'Campus Principal Poligran', 4.6432, -74.0543),
(8, 14, 'Aeropuerto José María Córdova', 'MEDotÃ¡', 'Av. El Dorado # 103-09, FontibÃ³n', 'Terminal 1 - Salidas Internacionales', 4.7016, -74.1469)
ON CONFLICT (id_direccion) DO NOTHING;

-- ----------------------------------------------------------------------------
-- 9. CONDUCTORES (10 conductores: 5 en Lima, 5 en MEDotÃ¡)
-- Incluye casos para alertas de vencimiento en <30 dÃ­as (Consulta 5):
-- Conductor 4 (Lima) tiene licencia por vencer en 15 dÃ­as (2026-12-05)
-- Conductor 9 (MEDotÃ¡) tiene licencia por vencer en 22 dÃ­as (2026-12-12)
-- ----------------------------------------------------------------------------
INSERT INTO conductor (id_conductor, id_empresa_flota, nombres, apellidos, tipo_documento, numero_documento, telefono, correo, numero_licencia, categoria_licencia, vencimiento_licencia, estado, cuenta_pago, id_pais) VALUES
-- Conductores PerÃº (Lima)
(1, 5, 'Carlos', 'Mendoza Paredes', 'DNI', '10293847', '+51 988771122', 'carlos.mendoza@choferes.pe', 'Q-10293847-A2B', 'A-IIb', '2028-05-15', 'Disponible', 'BCP-CTA-193-998811-01', 1),
(2, 5, 'Julio CÃ©sar', 'Paredes Rivas', 'DNI', '20394857', '+51 988771123', 'julio.paredes@choferes.pe', 'Q-20394857-A2B', 'A-IIb', '2027-11-20', 'Disponible', 'BBVA-CTA-0011-0812-90', 1),
(3, NULL, 'Miguel Ãngel', 'CÃ¡rdenas Tello', 'DNI', '30495867', '+51 988771124', 'miguel.cardenas@choferes.pe', 'Q-30495867-A2B', 'A-IIa', '2029-01-10', 'Disponible', 'Interbank-CTA-200-3019', 1),
(4, 5, 'HernÃ¡n', 'Soto Valdivia', 'DNI', '40596877', '+51 988771125', 'hernan.soto@choferes.pe', 'Q-40596877-A2B', 'A-IIb', '2026-12-05', 'Disponible', 'BCP-CTA-193-445566-02', 1), -- VENCE EN 15 DÃAS!
(5, NULL, 'Patricia', 'Guerrero Silva', 'DNI', '50697887', '+51 988771126', 'patricia.guerrero@choferes.pe', 'Q-50697887-A2B', 'A-IIb', '2028-08-30', 'Disponible', 'Scotiabank-CTA-045-882', 1),
-- Conductores Colombia (MEDotÃ¡)
(6, 6, 'Jairo', 'RamÃ­rez CÃ¡rdenas', 'CC', '79845123', '+57 3112223344', 'jairo.ramirez@conductores.co', 'C1-79845123-MED', 'C1', '2028-03-22', 'Disponible', 'Bancolombia-AHO-458129', 2),
(7, 6, 'William', 'CastaÃ±eda GÃ³mez', 'CC', '80123456', '+57 3112223345', 'william.castaneda@conductores.co', 'C1-80123456-MED', 'C2', '2027-09-18', 'Disponible', 'Davivienda-CTA-009841', 2),
(8, NULL, 'Albeiro', 'Montoya Ospina', 'CC', '79456789', '+57 3112223346', 'albeiro.montoya@conductores.co', 'C1-79456789-MED', 'C1', '2029-02-14', 'Disponible', 'BBVA-CO-349812-00', 2),
(9, 6, 'Nelson', 'Buitrago PeÃ±a', 'CC', '80987654', '+57 3112223347', 'nelson.buitrago@conductores.co', 'C1-80987654-MED', 'C1', '2026-12-12', 'Disponible', 'Bancolombia-AHO-994120', 2), -- VENCE EN 22 DÃAS!
(10, NULL, 'Esperanza', 'Duque Morales', 'CC', '52890123', '+57 3112223348', 'esperanza.duque@conductores.co', 'C1-52890123-MED', 'C1', '2028-10-05', 'Disponible', 'BancoMedellin-CTA-77123', 2)
ON CONFLICT (id_conductor) DO NOTHING;

-- ----------------------------------------------------------------------------
-- 10. VEHÃCULOS (10 vehÃ­culos con SOAT y asignados a conductores)
-- Incluye casos para alertas de vencimiento de SOAT/seguro en <30 dÃ­as:
-- VehÃ­culo 2 (Lima): Vence en 18 dÃ­as (2026-12-08)
-- VehÃ­culo 7 (MEDotÃ¡): Vence en 25 dÃ­as (2026-12-15)
-- ----------------------------------------------------------------------------
INSERT INTO vehiculo (id_vehiculo, id_conductor, placa, marca, modelo, anio, color, id_tipo_servicio, seguro, vencimiento_seguro, estado) VALUES
-- VehÃ­culos PerÃº (Lima)
(1, 1, 'BAP-842', 'Toyota', 'Corolla Hybrid', 2023, 'Negro Cosmos', 2, 'RÃ­mac Seguros SOAT', '2027-04-15', 'Activo'),
(2, 2, 'CFX-195', 'Mercedes-Benz', 'C-200 Executive', 2024, 'Negro Obsidiana', 3, 'PacÃ­fico Seguros Todo Riesgo', '2026-12-08', 'Activo'), -- SEGURO VENCE EN 18 DÃAS!
(3, 3, 'AYZ-610', 'Hyundai', 'Elantra', 2022, 'Gris Plata', 1, 'La Positiva SOAT', '2027-06-20', 'Activo'),
(4, 4, 'BKR-308', 'Hyundai', 'H-1 Grand Starex', 2023, 'Blanco Glaciar', 4, 'RÃ­mac Seguros Flotas', '2027-01-30', 'Activo'),
(5, 5, 'D1E-743', 'Nissan', 'Versa Advance', 2023, 'Azul ElÃ©ctrico', 1, 'Mapfre Seguros SOAT', '2027-08-14', 'Activo'),
-- VehÃ­culos Colombia (MEDotÃ¡)
(6, 6, 'WLM-492', 'Renault', 'Logan Zen', 2023, 'Gris Cuarzo', 1, 'Seguros BolÃ­var SOAT', '2027-05-10', 'Activo'),
(7, 7, 'KMS-811', 'BMW', 'Serie 3 330e HÃ­brido', 2024, 'Negro Zafiro', 3, 'Sura Todo Riesgo Corporativo', '2026-12-15', 'Activo'), -- SEGURO VENCE EN 25 DÃAS!
(8, 8, 'FNT-324', 'Toyota', 'Yaris SedÃ¡n', 2022, 'Rojo BorgoÃ±a', 2, 'Allianz Seguros SOAT', '2027-09-02', 'Activo'),
(9, 9, 'TLR-605', 'Chevrolet', 'Traverse Premier 7P', 2023, 'Plata MetÃ¡lico', 4, 'Equidad Seguros Flota', '2027-03-25', 'Activo'),
(10, 10, 'MXZ-759', 'Kia', 'Rio SedÃ¡n', 2023, 'Blanco Perla', 1, 'Seguros del Estado SOAT', '2027-11-19', 'Activo')
ON CONFLICT (id_vehiculo) DO NOTHING;

-- ----------------------------------------------------------------------------
-- 11. VIAJES (52 viajes distribuidos entre Lima y MEDotÃ¡)
-- Incluye viajes en todos los estados:
-- 40 Finalizados (para historial, calificaciones y consultas analÃ­ticas)
-- 4 En Curso (monitoreo en vivo)
-- 3 Aceptados (conductor asignado en ruta a recoger)
-- 3 Solicitados (en radar de conductores pendientes de aceptar)
-- 2 Cancelados (para tasa de cancelaciÃ³n)
-- ----------------------------------------------------------------------------

-- Temporada reciente: Octubre, Noviembre 2026 (mes actual: 2026-11)
INSERT INTO viaje (id_viaje, id_pasajero, id_conductor, id_vehiculo, id_tipo_servicio, id_estado, id_pais, es_corporativo, origen, destino, fecha_solicitud, fecha_inicio, fecha_fin, distancia_km, tarifa_total, moneda) VALUES
-- VIAJES LIMA (PERÃš - PEN)
-- Conductor 1: Carlos Mendoza (Toyota Corolla - Confort)
(1, 1, 1, 1, 2, 4, 1, false, 'Av. MalecÃ³n de la Reserva 729, Miraflores', 'Av. Canaval y Moreyra 480, San Isidro', '2026-10-15 08:30:00', '2026-10-15 08:38:00', '2026-10-15 09:05:00', 8.50, 29.90, 'PEN'),
(2, 2, 1, 1, 2, 4, 1, true,  'Calle Centenario 156, La Molina', 'Av. Dionisio Derteano 184, San Isidro', '2026-10-18 14:10:00', '2026-10-18 14:18:00', '2026-10-18 14:52:00', 12.00, 38.30, 'PEN'),
(3, 3, 1, 1, 2, 4, 1, false, 'Av. Arequipa 3800, Miraflores', 'Av. JosÃ© Pardo 601, Miraflores', '2026-10-22 19:00:00', '2026-10-22 19:06:00', '2026-10-22 19:22:00', 3.20, 17.18, 'PEN'),
(4, 4, 1, 1, 2, 4, 1, true,  'Av. Javier Prado Este 3200, San Borja', 'Centro Empresarial Real, San Isidro', '2026-11-02 08:15:00', '2026-11-02 08:24:00', '2026-11-02 08:58:00', 9.80, 33.02, 'PEN'),
(5, 5, 1, 1, 2, 4, 1, false, 'Av. Benavides 1900, Miraflores', 'Av. Larco 880, Miraflores', '2026-11-05 17:40:00', '2026-11-05 17:46:00', '2026-11-05 18:05:00', 4.50, 20.30, 'PEN'),
(6, 7, 1, 1, 2, 4, 1, true,  'Calle Centenario 156, La Molina', 'Aeropuerto Jorge ChÃ¡vez, Callao', '2026-11-10 05:30:00', '2026-11-10 05:40:00', '2026-11-10 06:45:00', 26.50, 73.10, 'PEN'),
(7, 8, 1, 1, 2, 4, 1, false, 'Av. Salaverry 2400, JesÃºs MarÃ­a', 'Av. Pardo y Aliaga 640, San Isidro', '2026-11-14 13:20:00', '2026-11-14 13:28:00', '2026-11-14 13:50:00', 5.60, 22.94, 'PEN'),

-- Conductor 2: Julio CÃ©sar Paredes (Mercedes-Benz C200 - Executive Black)
(8, 2, 2, 2, 3, 4, 1, true,  'Centro Financiero San Isidro', 'Club Golf Los Incas, Surco', '2026-10-12 18:30:00', '2026-10-12 18:40:00', '2026-10-12 19:25:00', 14.20, 69.96, 'PEN'),
(9, 4, 2, 2, 3, 4, 1, true,  'Hotel Westin Lima, San Isidro', 'Aeropuerto Jorge ChÃ¡vez (Terminal Ejecutivo)', '2026-10-20 06:00:00', '2026-10-20 06:10:00', '2026-10-20 07:02:00', 22.00, 99.60, 'PEN'),
(10, 7, 2, 2, 3, 4, 1, true,  'Av. Rivera Navarrete 501, San Isidro', 'Restaurante Central, Barranco', '2026-10-28 20:00:00', '2026-10-28 20:10:00', '2026-10-28 20:38:00', 8.40, 47.92, 'PEN'),
(11, 2, 2, 2, 3, 4, 1, true,  'Calle Centenario 156, La Molina', 'Av. VÃ­ctor AndrÃ©s BelaÃºnde 147, San Isidro', '2026-11-04 09:00:00', '2026-11-04 09:12:00', '2026-11-04 09:50:00', 11.50, 59.70, 'PEN'),
(12, 10, 2, 2, 3, 4, 1, true, 'Sede BCP Miraflores', 'Sede BCP San Isidro', '2026-11-08 11:30:00', '2026-11-08 11:36:00', '2026-11-08 11:58:00', 4.80, 34.24, 'PEN'),
(13, 1, 2, 2, 3, 4, 1, false, 'MalecÃ³n Cisneros, Miraflores', 'Jockey Plaza, Surco', '2026-11-12 16:00:00', '2026-11-12 16:10:00', '2026-11-12 16:45:00', 10.20, 54.76, 'PEN'),

-- Conductor 3: Miguel Ãngel CÃ¡rdenas (Hyundai Elantra - EstÃ¡ndar)
(14, 3, 3, 3, 1, 4, 1, false, 'Av. Brasil 1400, JesÃºs MarÃ­a', 'Plaza San Miguel', '2026-10-10 12:10:00', '2026-10-10 12:16:00', '2026-10-10 12:35:00', 6.00, 16.80, 'PEN'),
(15, 5, 3, 3, 1, 4, 1, false, 'Av. Angamos Este 1500, Surquillo', 'Open Plaza Angamos', '2026-10-19 15:40:00', '2026-10-19 15:45:00', '2026-10-19 15:58:00', 2.80, 11.04, 'PEN'),
(16, 6, 3, 3, 1, 4, 1, false, 'Av. Arenales 2100, Lince', 'Av. Abancay 450, Centro de Lima', '2026-10-25 10:20:00', '2026-10-25 10:27:00', '2026-10-25 10:55:00', 7.50, 19.50, 'PEN'),
(17, 8, 3, 3, 1, 4, 1, false, 'Av. La Marina 2800, San Miguel', 'Av. Universitaria 1801, San Miguel', '2026-11-03 14:00:00', '2026-11-03 14:06:00', '2026-11-03 14:22:00', 3.50, 12.30, 'PEN'),
(18, 9, 3, 3, 1, 4, 1, false, 'Av. Conquistadores 780, San Isidro', 'Av. Dos de Mayo 1200, San Isidro', '2026-11-09 18:15:00', '2026-11-09 18:20:00', '2026-11-09 18:32:00', 2.10, 9.78, 'PEN'),
(19, 1, 3, 3, 1, 4, 1, false, 'Av. 28 de Julio 850, Miraflores', 'Av. Larcomar', '2026-11-15 21:00:00', '2026-11-15 21:06:00', '2026-11-15 21:18:00', 2.40, 10.32, 'PEN'),

-- Conductor 4: HernÃ¡n Soto (Van Hyundai H-1 - Van Corporativa)
(20, 2, 4, 4, 4, 4, 1, true,  'Sede Central BCP, La Molina', 'Centro de Convenciones de Lima, San Borja', '2026-10-14 07:45:00', '2026-10-14 07:55:00', '2026-10-14 08:35:00', 9.50, 80.25, 'PEN'),
(21, 4, 4, 4, 4, 4, 1, true,  'Aeropuerto Jorge ChÃ¡vez', 'Hotel SwissÃ´tel, San Isidro', '2026-10-24 16:30:00', '2026-10-24 16:45:00', '2026-10-24 17:55:00', 21.00, 143.50, 'PEN'),
(22, 7, 4, 4, 4, 4, 1, true,  'Torre BCP, San Isidro', 'Aeropuerto Jorge ChÃ¡vez (DelegaciÃ³n)', '2026-11-06 04:30:00', '2026-11-06 04:42:00', '2026-11-06 05:40:00', 23.40, 156.70, 'PEN'),
(23, 10, 4, 4, 4, 4, 1, true, 'Centro Empresarial Kronos, Surco', 'Campus TECSUP Santa Anita', '2026-11-11 08:30:00', '2026-11-11 08:42:00', '2026-11-11 09:20:00', 8.20, 73.10, 'PEN'),

-- Conductor 5: Patricia Guerrero (Nissan Versa - EstÃ¡ndar)
(24, 6, 5, 5, 1, 4, 1, false, 'Av. Caminos del Inca 1200, Surco', 'Av. El Polo 670, Surco', '2026-10-16 11:00:00', '2026-10-16 11:08:00', '2026-10-16 11:25:00', 4.20, 13.56, 'PEN'),
(25, 8, 5, 5, 1, 4, 1, false, 'Av. Sucre 450, Pueblo Libre', 'Plaza San Miguel', '2026-10-26 17:15:00', '2026-10-26 17:22:00', '2026-10-26 17:38:00', 3.00, 11.40, 'PEN'),
(26, 9, 5, 5, 1, 4, 1, false, 'Av. Encalada 890, Surco', 'Jockey Salud, Surco', '2026-11-07 10:00:00', '2026-11-07 10:07:00', '2026-11-07 10:20:00', 2.60, 10.68, 'PEN'),
(27, 3, 5, 5, 1, 4, 1, false, 'Parque Kennedy, Miraflores', 'Barranco Boulevard', '2026-11-13 22:30:00', '2026-11-13 22:36:00', '2026-11-13 22:52:00', 4.00, 13.20, 'PEN'),

-- VIAJES MEDOTÃ (COLOMBIA - COP)
-- Nota: En MEDotÃ¡ las tarifas estÃ¡n en miles de COP (ej. base ~6,000 + ~1,800/km)
-- Conductor 6: Jairo RamÃ­rez (Renault Logan - EstÃ¡ndar)
(28, 11, 6, 6, 1, 4, 2, true,  'Carrera 43A # 1-50, Chapinero', 'Calle 100 # 8A-49, ChicÃ³', '2026-10-11 08:00:00', '2026-10-11 08:09:00', '2026-10-11 08:35:00', 6.20, 17160.00, 'COP'),
(29, 12, 6, 6, 1, 4, 2, false, 'Calle 57 # 3-00 Este, Chapinero', 'Carrera 13 # 63-39, Chapinero', '2026-10-17 13:15:00', '2026-10-17 13:21:00', '2026-10-17 13:35:00', 2.50, 10500.00, 'COP'),
(30, 13, 6, 6, 1, 4, 2, false, 'Parque Lleras, ChicÃ³', 'Centro Comercial Andino, El Retiro', '2026-10-23 18:30:00', '2026-10-23 18:37:00', '2026-10-23 18:55:00', 3.40, 12120.00, 'COP'),
(31, 14, 6, 6, 1, 4, 2, true,  'Torre Bancolombia, Carrera 7 # 71', 'World Trade Center MEDotÃ¡, Calle 100', '2026-11-01 09:30:00', '2026-11-01 09:39:00', '2026-11-01 10:10:00', 5.80, 16440.00, 'COP'),
(32, 15, 6, 6, 1, 4, 2, false, 'Calle 127 # 15-02, Unicentro', 'Calle 85 # 11-53, Zona T', '2026-11-06 20:00:00', '2026-11-06 20:10:00', '2026-11-06 20:38:00', 7.50, 19500.00, 'COP'),
(33, 16, 6, 6, 1, 4, 2, false, 'Carrera 15 # 93-60, ChicÃ³', 'Aeropuerto José María Córdova, Terminal 1', '2026-11-12 05:00:00', '2026-11-12 05:10:00', '2026-11-12 05:55:00', 16.50, 35700.00, 'COP'),
(34, 18, 6, 6, 1, 4, 2, false, 'Plaza de BolÃ­var, Centro HistÃ³rico', 'Museo Nacional, Carrera 7', '2026-11-16 14:20:00', '2026-11-16 14:26:00', '2026-11-16 14:42:00', 3.20, 11760.00, 'COP'),

-- Conductor 7: William CastaÃ±eda (BMW Serie 3 330e - Executive Black)
(35, 11, 7, 7, 3, 4, 2, true,  'Torre Bancolombia, Chapinero', 'Aeropuerto José María Córdova (Terminal Puente AÃ©reo)', '2026-10-13 06:15:00', '2026-10-13 06:25:00', '2026-10-13 07:15:00', 17.00, 80600.00, 'COP'),
(36, 14, 7, 7, 3, 4, 2, true,  'Club El Nogal, Carrera 7 # 78', 'Torre Colpatria, Centro Internacional', '2026-10-21 12:45:00', '2026-10-21 12:55:00', '2026-10-21 13:28:00', 7.80, 45640.00, 'COP'),
(37, 17, 7, 7, 3, 4, 2, true,  'Centro Empresarial Santa BÃ¡rbara', 'Hotel Grand Hyatt MEDotÃ¡, Salitre', '2026-10-29 17:30:00', '2026-10-29 17:42:00', '2026-10-29 18:35:00', 13.50, 67300.00, 'COP'),
(38, 20, 7, 7, 3, 4, 2, true,  'Torre Bancolombia, MEDotÃ¡', 'Zona Franca de FontibÃ³n', '2026-11-04 10:00:00', '2026-11-04 10:12:00', '2026-11-04 11:05:00', 15.20, 73760.00, 'COP'),
(39, 11, 7, 7, 3, 4, 2, true,  'Hotel Four Seasons Casa Medina', 'Aeropuerto José María Córdova, Salidas VIP', '2026-11-10 16:00:00', '2026-11-10 16:12:00', '2026-11-10 17:05:00', 16.80, 79840.00, 'COP'),
(40, 13, 7, 7, 3, 4, 2, false, 'Restaurante Harry Sasson, Zona G', 'Calle 116 # 9-20, Santa BÃ¡rbara', '2026-11-15 22:00:00', '2026-11-15 22:08:00', '2026-11-15 22:30:00', 6.40, 40320.00, 'COP'),

-- Conductor 8: Albeiro Montoya (Toyota Yaris - Confort)
(41, 12, 8, 8, 2, 4, 2, false, 'Campus PolitÃ©cnico Grancolombiano', 'Centro Comercial Santa Fe, Autonorte', '2026-10-18 16:00:00', '2026-10-18 16:10:00', '2026-10-18 17:10:00', 18.00, 52700.00, 'COP'),
(42, 15, 8, 8, 2, 4, 2, false, 'Carrera 11 # 82-01, El Virrey', 'Calle 72 # 10-34, Quinta Camacho', '2026-10-27 11:20:00', '2026-10-27 11:26:00', '2026-10-27 11:42:00', 3.60, 18140.00, 'COP'),
(43, 16, 8, 8, 2, 4, 2, false, 'Parque SimÃ³n BolÃ­var, Teusaquillo', 'Corferias, Entrada Principal', '2026-11-05 15:30:00', '2026-11-05 15:38:00', '2026-11-05 15:58:00', 4.50, 20300.00, 'COP'),
(44, 19, 8, 8, 2, 4, 2, false, 'Calle 140 # 11-45, Cedritos', 'Hacienda Santa BÃ¡rbara, UsaquÃ©n', '2026-11-11 13:00:00', '2026-11-11 13:08:00', '2026-11-11 13:25:00', 4.00, 19100.00, 'COP'),

-- VIAJES EN CURSO (ESTADO 3 - ACTIVOS EN TIEMPO REAL)
(45, 1, 1, 1, 2, 3, 1, false, 'Av. Larco 1000, Miraflores', 'Av. Dos de Mayo 1500, San Isidro', '2026-11-20 20:30:00', '2026-11-20 20:38:00', NULL, 5.20, 21.98, 'PEN'),
(46, 14, 6, 6, 1, 3, 2, true,  'Torre Bancolombia, Carrera 7 # 71', 'Parque Lleras, MEDotÃ¡', '2026-11-20 20:25:00', '2026-11-20 20:34:00', NULL, 4.30, 13740.00, 'COP'),
(47, 2, 2, 2, 3, 3, 1, true,  'Westin Hotel San Isidro', 'Country Club Lima Hotel', '2026-11-20 20:40:00', '2026-11-20 20:46:00', NULL, 3.50, 29.30, 'PEN'),
(48, 17, 7, 7, 3, 3, 2, true,  'Calle 100 con Carrera 15, MEDotÃ¡', 'Aeropuerto José María Córdova, MEDotÃ¡', '2026-11-20 20:35:00', '2026-11-20 20:44:00', NULL, 15.80, 76040.00, 'COP'),

-- VIAJES ACEPTADOS (ESTADO 2 - CONDUCTOR EN CAMINO AL PASAJERO)
(49, 3, 3, 3, 1, 2, 1, false, 'Av. Salaverry 1900, JesÃºs MarÃ­a', 'Av. Javier Prado Oeste 750, Magdalena', '2026-11-20 20:45:00', NULL, NULL, 4.10, 13.38, 'PEN'),
(50, 12, 8, 8, 2, 2, 2, false, 'Carrera 7 # 45-10, Javeriana', 'Calle 85 con Carrera 11, Zona Rosa', '2026-11-20 20:48:00', NULL, NULL, 6.00, 23900.00, 'COP'),

-- VIAJES SOLICITADOS (ESTADO 1 - RADAR DE CONDUCTORES PENDIENTES)
(51, 5, NULL, NULL, 1, 1, 1, false, 'Av. Benavides 2150, Miraflores', 'Jockey Plaza Mall, Surco', '2026-11-20 20:52:00', NULL, NULL, 7.30, 19.14, 'PEN'),
(52, 15, NULL, NULL, 2, 1, 2, false, 'Calle 93 # 12-40, ChicÃ³ Norte', 'Calle 116 con Autopista Norte', '2026-11-20 20:55:00', NULL, NULL, 5.50, 22700.00, 'COP'),

-- VIAJES CANCELADOS (ESTADO 5 - PARA TASA DE CANCELACIÃ“N)
(53, 6, 5, 5, 1, 5, 1, false, 'Av. Petit Thouars 4000, San Isidro', 'Av. Primavera 120, Surco', '2026-10-14 19:10:00', NULL, NULL, 6.80, 18.24, 'PEN'),
(54, 18, 10, 10, 1, 5, 2, false, 'Carrera 10 # 24-00, Centro', 'Calle 63 con Carrera 30, Movistar Arena', '2026-10-25 18:00:00', NULL, NULL, 5.00, 15000.00, 'COP')
ON CONFLICT (id_viaje) DO NOTHING;

-- ----------------------------------------------------------------------------
-- 12. HISTORIAL DE ESTADO DE VIAJES (Trazabilidad)
-- ----------------------------------------------------------------------------
INSERT INTO historial_estado_viaje (id_viaje, estado_anterior, estado_nuevo, fecha_cambio) VALUES
(1, NULL, 'Solicitado', '2026-10-15 08:30:00'),
(1, 'Solicitado', 'Aceptado', '2026-10-15 08:32:00'),
(1, 'Aceptado', 'En Curso', '2026-10-15 08:38:00'),
(1, 'En Curso', 'Finalizado', '2026-10-15 09:05:00'),
(2, NULL, 'Solicitado', '2026-10-18 14:10:00'),
(2, 'Solicitado', 'Aceptado', '2026-10-18 14:12:00'),
(2, 'Aceptado', 'En Curso', '2026-10-18 14:18:00'),
(2, 'En Curso', 'Finalizado', '2026-10-18 14:52:00'),
(45, NULL, 'Solicitado', '2026-11-20 20:30:00'),
(45, 'Solicitado', 'Aceptado', '2026-11-20 20:32:00'),
(45, 'Aceptado', 'En Curso', '2026-11-20 20:38:00'),
(49, NULL, 'Solicitado', '2026-11-20 20:45:00'),
(49, 'Solicitado', 'Aceptado', '2026-11-20 20:47:00'),
(51, NULL, 'Solicitado', '2026-11-20 20:52:00'),
(53, NULL, 'Solicitado', '2026-10-14 19:10:00'),
(53, 'Solicitado', 'Cancelado', '2026-10-14 19:15:00')
ON CONFLICT (id_historial) DO NOTHING;

-- ----------------------------------------------------------------------------
-- 13. PAGOS (Transacciones de los 40 viajes finalizados)
-- ComisiÃ³n de plataforma estÃ¡ndar: 15% del total
-- ----------------------------------------------------------------------------
INSERT INTO pago (id_pago, id_viaje, id_metodo_pago, monto, moneda, fecha_pago, estado, comision_plataforma) VALUES
-- Pagos Lima (PEN)
(1, 1, 1, 29.90, 'PEN', '2026-10-15 09:05:00', 'Completado', 4.49),
(2, 2, 2, 38.30, 'PEN', '2026-10-18 14:52:00', 'Completado', 5.75),
(3, 3, 3, 17.18, 'PEN', '2026-10-22 19:22:00', 'Completado', 2.58),
(4, 4, 4, 33.02, 'PEN', '2026-11-02 08:58:00', 'Completado', 4.95),
(5, 5, 5, 20.30, 'PEN', '2026-11-05 18:05:00', 'Completado', 3.05),
(6, 6, 7, 73.10, 'PEN', '2026-11-10 06:45:00', 'Completado', 10.97),
(7, 7, 8, 22.94, 'PEN', '2026-11-14 13:50:00', 'Completado', 3.44),
(8, 8, 2, 69.96, 'PEN', '2026-10-12 19:25:00', 'Completado', 10.49),
(9, 9, 4, 99.60, 'PEN', '2026-10-20 07:02:00', 'Completado', 14.94),
(10, 10, 7, 47.92, 'PEN', '2026-10-28 20:38:00', 'Completado', 7.19),
(11, 11, 2, 59.70, 'PEN', '2026-11-04 09:50:00', 'Completado', 8.96),
(12, 12, 2, 34.24, 'PEN', '2026-11-08 11:58:00', 'Completado', 5.14),
(13, 13, 1, 54.76, 'PEN', '2026-11-12 16:45:00', 'Completado', 8.21),
(14, 14, 3, 16.80, 'PEN', '2026-10-10 12:35:00', 'Completado', 2.52),
(15, 15, 5, 11.04, 'PEN', '2026-10-19 15:58:00', 'Completado', 1.66),
(16, 16, 6, 19.50, 'PEN', '2026-10-25 10:55:00', 'Completado', 2.93),
(17, 17, 8, 12.30, 'PEN', '2026-11-03 14:22:00', 'Completado', 1.85),
(18, 18, 1, 9.78, 'PEN', '2026-11-09 18:32:00', 'Completado', 1.47),
(19, 19, 1, 10.32, 'PEN', '2026-11-15 21:18:00', 'Completado', 1.55),
(20, 20, 2, 80.25, 'PEN', '2026-10-14 08:35:00', 'Completado', 12.04),
(21, 21, 4, 143.50, 'PEN', '2026-10-24 17:55:00', 'Completado', 21.53),
(22, 22, 7, 156.70, 'PEN', '2026-11-06 05:40:00', 'Completado', 23.51),
(23, 23, 2, 73.10, 'PEN', '2026-11-11 09:20:00', 'Completado', 10.97),
(24, 24, 6, 13.56, 'PEN', '2026-10-16 11:25:00', 'Completado', 2.03),
(25, 25, 8, 11.40, 'PEN', '2026-10-26 17:38:00', 'Completado', 1.71),
(26, 26, 1, 10.68, 'PEN', '2026-11-07 10:20:00', 'Completado', 1.60),
(27, 27, 3, 13.20, 'PEN', '2026-11-13 22:52:00', 'Completado', 1.98),
-- Pagos MEDotÃ¡ (COP)
(28, 28, 9, 17160.00, 'COP', '2026-10-11 08:35:00', 'Completado', 2574.00),
(29, 29, 10, 10500.00, 'COP', '2026-10-17 13:35:00', 'Completado', 1575.00),
(30, 30, 11, 12120.00, 'COP', '2026-10-23 18:55:00', 'Completado', 1818.00),
(31, 31, 12, 16440.00, 'COP', '2026-11-01 10:10:00', 'Completado', 2466.00),
(32, 32, 13, 19500.00, 'COP', '2026-11-06 20:38:00', 'Completado', 2925.00),
(33, 33, 14, 35700.00, 'COP', '2026-11-12 05:55:00', 'Completado', 5355.00),
(34, 34, 10, 11760.00, 'COP', '2026-11-16 14:42:00', 'Completado', 1764.00),
(35, 35, 9, 80600.00, 'COP', '2026-10-13 07:15:00', 'Completado', 12090.00),
(36, 36, 12, 45640.00, 'COP', '2026-10-21 13:28:00', 'Completado', 6846.00),
(37, 37, 15, 67300.00, 'COP', '2026-10-29 18:35:00', 'Completado', 10095.00),
(38, 38, 16, 73760.00, 'COP', '2026-11-04 11:05:00', 'Completado', 11064.00),
(39, 39, 9, 79840.00, 'COP', '2026-11-10 17:05:00', 'Completado', 11976.00),
(40, 40, 11, 40320.00, 'COP', '2026-11-15 22:30:00', 'Completado', 6048.00),
(41, 41, 10, 52700.00, 'COP', '2026-10-18 17:10:00', 'Completado', 7905.00),
(42, 42, 13, 18140.00, 'COP', '2026-10-27 11:42:00', 'Completado', 2721.00),
(43, 43, 14, 20300.00, 'COP', '2026-11-05 15:58:00', 'Completado', 3045.00),
(44, 44, 11, 19100.00, 'COP', '2026-11-11 13:25:00', 'Completado', 2865.00)
ON CONFLICT (id_pago) DO NOTHING;

-- ----------------------------------------------------------------------------
-- 14. CALIFICACIONES
-- Incluye calificaciones de Pasajeros y Conductores.
-- Casos para Consulta 7: Los viajes 7 (Pasajero 8 SebastiÃ¡n Morales), 13 (Pasajero 1 Luciana),
-- 27 (Pasajero 3 Fiorella) y 44 (Pasajero 19 Gabriela) fueron finalizados pero NUNCA calificados
-- por el pasajero para que la Consulta 7 devuelva datos verificables.
-- ----------------------------------------------------------------------------
INSERT INTO calificacion (id_calificacion, id_viaje, puntaje, comentario, fecha_calificacion, tipo_calificador) VALUES
-- Viajes Conductor 1: Carlos Mendoza (Promedio ~4.83)
(1, 1, 5, 'Excelente servicio, muy puntual y el auto impecable.', '2026-10-15 09:10:00', 'Pasajero'),
(2, 2, 5, 'Excelente trato para viaje corporativo, ruta muy fluida.', '2026-10-18 15:00:00', 'Pasajero'),
(3, 3, 5, 'Muy amable Carlos, conducciÃ³n segura.', '2026-10-22 19:30:00', 'Pasajero'),
(4, 4, 5, 'Gran experiencia corporativa, mÃºsica agradable y aire acondicionado perfecto.', '2026-11-02 09:05:00', 'Pasajero'),
(5, 5, 4, 'Todo bien, llegÃ³ 2 minutos despuÃ©s de lo estimado por trÃ¡fico.', '2026-11-05 18:15:00', 'Pasajero'),
(6, 6, 5, 'Excelente viaje al aeropuerto, puntual a las 5 am.', '2026-11-10 07:00:00', 'Pasajero'),
-- Viaje 7: SIN CALIFICACIÃ“N DE PASAJERO (Consulta 7)

-- Viajes Conductor 2: Julio CÃ©sar Paredes (Promedio ~5.00)
(7, 8, 5, 'VehÃ­culo de primera gama, chofer con saco y corbata impecable.', '2026-10-12 19:35:00', 'Pasajero'),
(8, 9, 5, 'Servicio Black de nivel internacional para directorio.', '2026-10-20 07:15:00', 'Pasajero'),
(9, 10, 5, 'Muy profesional y discreto.', '2026-10-28 20:45:00', 'Pasajero'),
(10, 11, 5, 'Puntualidad suiza, Mercedes-Benz impecable.', '2026-11-04 10:00:00', 'Pasajero'),
(11, 12, 5, 'Excelente atenciÃ³n corporativa BCP.', '2026-11-08 12:05:00', 'Pasajero'),
-- Viaje 13: SIN CALIFICACIÃ“N DE PASAJERO (Consulta 7)

-- Viajes Conductor 3: Miguel Ãngel CÃ¡rdenas (Promedio ~4.20)
(12, 14, 4, 'Buen viaje, auto limpio.', '2026-10-10 12:45:00', 'Pasajero'),
(13, 15, 4, 'Servicio rÃ¡pido y econÃ³mico.', '2026-10-19 16:10:00', 'Pasajero'),
(14, 16, 5, 'Condujo con cuidado en el centro de Lima.', '2026-10-25 11:05:00', 'Pasajero'),
(15, 17, 4, 'Todo en orden.', '2026-11-03 14:30:00', 'Pasajero'),
(16, 18, 4, 'Buen servicio.', '2026-11-09 18:40:00', 'Pasajero'),
(17, 19, 5, 'Muy atento en la noche.', '2026-11-15 21:30:00', 'Pasajero'),

-- Viajes Conductor 6 (MEDotÃ¡): Jairo RamÃ­rez (Promedio ~4.83)
(18, 28, 5, 'Muy cordial, conocÃ­a bien la ruta por la SÃ©ptima.', '2026-10-11 08:45:00', 'Pasajero'),
(19, 29, 5, 'RÃ¡pido y atento en Chapinero.', '2026-10-17 13:45:00', 'Pasajero'),
(20, 30, 4, 'Buen viaje a pesar del trancÃ³n de la 93.', '2026-10-23 19:10:00', 'Pasajero'),
(21, 31, 5, 'Excelente para traslado de oficina.', '2026-11-01 10:20:00', 'Pasajero'),
(22, 32, 5, 'VehÃ­culo muy limpio, mÃºsica suave.', '2026-11-06 20:50:00', 'Pasajero'),
(23, 33, 5, 'SÃºper puntual para vuelo matutino en El Dorado.', '2026-11-12 06:10:00', 'Pasajero'),
(24, 34, 4, 'Todo correcto por el centro.', '2026-11-16 14:55:00', 'Pasajero'),

-- Viajes Conductor 7 (MEDotÃ¡): William CastaÃ±eda (Promedio ~5.00)
(25, 35, 5, 'BMW impecable, agua mineral de cortesÃ­a y gran profesionalismo.', '2026-10-13 07:30:00', 'Pasajero'),
(26, 36, 5, 'Servicio corporativo del mÃ¡s alto nivel.', '2026-10-21 13:40:00', 'Pasajero'),
(27, 37, 5, 'Excelente atenciÃ³n para invitados internacionales.', '2026-10-29 18:50:00', 'Pasajero'),
(28, 38, 5, 'Manejo seguro y silencioso.', '2026-11-04 11:20:00', 'Pasajero'),
(29, 39, 5, 'El mejor servicio ejecutivo en MEDotÃ¡.', '2026-11-10 17:20:00', 'Pasajero'),
(30, 40, 5, 'Excelente todo, 10 de 10.', '2026-11-15 22:40:00', 'Pasajero'),

-- Calificaciones emitidas por conductores a pasajeros
(31, 1, 5, 'Pasajera puntual y amable.', '2026-10-15 09:12:00', 'Conductor'),
(32, 2, 5, 'Usuario corporativo muy educado.', '2026-10-18 15:02:00', 'Conductor'),
(33, 28, 5, 'Excelente usuaria, lista al llegar.', '2026-10-11 08:46:00', 'Conductor'),
(34, 35, 5, 'Pasajera ejecutiva muy respetuosa.', '2026-10-13 07:32:00', 'Conductor')
ON CONFLICT (id_calificacion) DO NOTHING;

-- Sincronizar secuencias de IDs para Supabase / PostgreSQL
SELECT setval('pais_id_pais_seq', (SELECT MAX(id_pais) FROM pais));
SELECT setval('tipo_servicio_id_tipo_servicio_seq', (SELECT MAX(id_tipo_servicio) FROM tipo_servicio));
SELECT setval('estado_viaje_id_estado_seq', (SELECT MAX(id_estado) FROM estado_viaje));
SELECT setval('empresa_id_empresa_seq', (SELECT MAX(id_empresa) FROM empresa));
SELECT setval('pasajero_id_pasajero_seq', (SELECT MAX(id_pasajero) FROM pasajero));
SELECT setval('empleado_empresa_id_empleado_seq', (SELECT MAX(id_empleado) FROM empleado_empresa));
SELECT setval('metodo_pago_id_metodo_pago_seq', (SELECT MAX(id_metodo_pago) FROM metodo_pago));
SELECT setval('direccion_favorita_id_direccion_seq', (SELECT MAX(id_direccion) FROM direccion_favorita));
SELECT setval('conductor_id_conductor_seq', (SELECT MAX(id_conductor) FROM conductor));
SELECT setval('vehiculo_id_vehiculo_seq', (SELECT MAX(id_vehiculo) FROM vehiculo));
SELECT setval('viaje_id_viaje_seq', (SELECT MAX(id_viaje) FROM viaje));
SELECT setval('historial_estado_viaje_id_historial_seq', (SELECT MAX(id_historial) FROM historial_estado_viaje));
SELECT setval('pago_id_pago_seq', (SELECT MAX(id_pago) FROM pago));
SELECT setval('calificacion_id_calificacion_seq', (SELECT MAX(id_calificacion) FROM calificacion));

