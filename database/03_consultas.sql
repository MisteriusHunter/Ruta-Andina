-- ============================================================================
-- PROYECTO COLABORATIVO COIL 2026: RUTA ANDINA
-- TECSUP (Perú) & Institución Universitaria Politécnico Grancolombiano (Colombia)
-- Integrantes: Alexander Rojas, Mateo Atapoma y equipo binacional COIL
-- Archivo: 03_consultas.sql - Las 8 Consultas Analíticas y de Negocio
-- Compatible con: Supabase (PostgreSQL 14 / 15 / 16)
-- ============================================================================

-- ============================================================================
-- CONSULTA 1: VIAJES FINALIZADOS POR CONDUCTOR EN EL ÚLTIMO MES
-- Objetivo de Negocio: Evaluar la productividad y actividad de los choferes en
-- el último periodo mensual cerrado/vigente para liquidación de incentivos.
-- ============================================================================
SELECT 
    c.id_conductor,
    c.nombres || ' ' || c.apellidos AS conductor,
    p.nombre_pais,
    v.moneda,
    COUNT(v.id_viaje) AS total_viajes_finalizados,
    ROUND(SUM(v.distancia_km), 2) AS total_km_recorridos,
    ROUND(SUM(v.tarifa_total), 2) AS facturacion_total_conductor,
    ROUND(AVG(v.tarifa_total), 2) AS ticket_promedio
FROM conductor c
JOIN viaje v ON c.id_conductor = v.id_conductor
JOIN estado_viaje ev ON v.id_estado = ev.id_estado
JOIN pais p ON c.id_pais = p.id_pais
WHERE ev.nombre_estado = 'Finalizado'
  AND v.fecha_fin >= (CURRENT_DATE - INTERVAL '30 days')
GROUP BY c.id_conductor, c.nombres, c.apellidos, p.nombre_pais, v.moneda
ORDER BY total_viajes_finalizados DESC, facturacion_total_conductor DESC;


-- ============================================================================
-- CONSULTA 2: INGRESOS TOTALES Y COMISIONES DE LA PLATAFORMA POR PAÍS Y MONEDA
-- Objetivo de Negocio: Consolidar los ingresos brutos operados (Gross Merchandise
-- Value - GMV) y el Net Revenue (comisión 15% de Ruta Andina) en PEN y COP.
-- ============================================================================
SELECT 
    p.nombre_pais AS pais,
    pag.moneda,
    COUNT(pag.id_pago) AS cantidad_transacciones,
    ROUND(SUM(pag.monto), 2) AS volumen_bruto_gmv,
    ROUND(SUM(pag.comision_plataforma), 2) AS comision_neta_plataforma,
    ROUND(AVG(pag.monto), 2) AS ticket_promedio_viaje,
    ROUND(AVG(pag.comision_plataforma), 2) AS comision_promedio_viaje
FROM pago pag
JOIN viaje v ON pag.id_viaje = v.id_viaje
JOIN pais p ON v.id_pais = p.id_pais
WHERE pag.estado = 'Completado'
GROUP BY p.nombre_pais, pag.moneda
ORDER BY volumen_bruto_gmv DESC;


-- ============================================================================
-- CONSULTA 3: TOP 5 CONDUCTORES POR CALIFICACIÓN PROMEDIO (MIN. 5 VIAJES)
-- Objetivo de Negocio: Reconocer a los mejores conductores según satisfacción del
-- cliente, asegurando representatividad estadística (mínimo 5 servicios evaluados).
-- ============================================================================
SELECT 
    c.id_conductor,
    c.nombres || ' ' || c.apellidos AS conductor,
    p.nombre_pais AS pais,
    veh.marca || ' ' || veh.modelo AS vehiculo,
    veh.placa,
    ts.nombre_servicio,
    COUNT(cal.id_calificacion) AS cantidad_calificaciones,
    ROUND(AVG(cal.puntaje)::numeric, 2) AS rating_promedio,
    COUNT(DISTINCT v.id_viaje) AS viajes_finalizados
FROM conductor c
JOIN vehiculo veh ON c.id_conductor = veh.id_conductor
JOIN tipo_servicio ts ON veh.id_tipo_servicio = ts.id_tipo_servicio
JOIN pais p ON c.id_pais = p.id_pais
JOIN viaje v ON c.id_conductor = v.id_conductor
JOIN calificacion cal ON v.id_viaje = cal.id_viaje
WHERE cal.tipo_calificador = 'Pasajero'
GROUP BY c.id_conductor, c.nombres, c.apellidos, p.nombre_pais, veh.marca, veh.modelo, veh.placa, ts.nombre_servicio
HAVING COUNT(DISTINCT v.id_viaje) >= 5
ORDER BY rating_promedio DESC, cantidad_calificaciones DESC
LIMIT 5;


-- ============================================================================
-- CONSULTA 4: CONSUMO MENSUAL DETALLADO DE CADA EMPRESA CLIENTE CORPORATIVA
-- Objetivo de Negocio: Emitir el estado de cuenta y facturación corporativa B2B
-- mensual desglosando viajes por empleado, gasto total y cupo disponible.
-- ============================================================================
SELECT 
    emp.id_empresa,
    emp.ruc_nit,
    emp.razon_social AS empresa_cliente,
    p.nombre_pais AS pais,
    v.moneda,
    TO_CHAR(v.fecha_solicitud, 'YYYY-MM') AS periodo_mes,
    COUNT(DISTINCT v.id_viaje) AS total_viajes_corporativos,
    COUNT(DISTINCT ee.id_empleado) AS empleados_activos,
    ROUND(SUM(v.tarifa_total), 2) AS consumo_total_mes,
    ROUND(AVG(v.tarifa_total), 2) AS costo_promedio_viaje
FROM empresa emp
JOIN empleado_empresa ee ON emp.id_empresa = ee.id_empresa
JOIN pasajero pas ON ee.id_pasajero = pas.id_pasajero
JOIN viaje v ON pas.id_pasajero = v.id_pasajero AND v.es_corporativo = TRUE
JOIN estado_viaje ev ON v.id_estado = ev.id_estado
JOIN pais p ON emp.id_pais = p.id_pais
WHERE emp.tipo_empresa = 'Cliente_Corporativo'
  AND ev.nombre_estado = 'Finalizado'
GROUP BY emp.id_empresa, emp.ruc_nit, emp.razon_social, p.nombre_pais, v.moneda, TO_CHAR(v.fecha_solicitud, 'YYYY-MM')
ORDER BY consumo_total_mes DESC;


-- ============================================================================
-- CONSULTA 5: ALERTA DE CONDUCTORES CON LICENCIA O SEGURO POR VENCER (< 30 DÍAS)
-- Objetivo de Negocio: Sistema preventivo de cumplimiento legal y seguridad vial
-- para notificar al conductor y suspender asignación si no renueva a tiempo.
-- ============================================================================
SELECT 
    c.id_conductor,
    c.nombres || ' ' || c.apellidos AS conductor,
    c.telefono,
    c.correo,
    p.nombre_pais AS pais,
    veh.placa,
    veh.marca || ' ' || veh.modelo AS vehiculo,
    c.numero_licencia,
    c.vencimiento_licencia,
    (c.vencimiento_licencia - CURRENT_DATE) AS dias_para_vencer_licencia,
    veh.seguro AS entidad_seguro,
    veh.vencimiento_seguro,
    (veh.vencimiento_seguro - CURRENT_DATE) AS dias_para_vencer_seguro,
    CASE 
        WHEN (c.vencimiento_licencia - CURRENT_DATE) <= 0 THEN 'CRÍTICO: Licencia Vencida'
        WHEN (veh.vencimiento_seguro - CURRENT_DATE) <= 0 THEN 'CRÍTICO: Seguro Vencido'
        WHEN (c.vencimiento_licencia - CURRENT_DATE) <= 30 AND (veh.vencimiento_seguro - CURRENT_DATE) <= 30 THEN 'ALERTA ALTA: Ambos por vencer en <30 días'
        WHEN (c.vencimiento_licencia - CURRENT_DATE) <= 30 THEN 'ALERTA: Licencia por vencer en <30 días'
        WHEN (veh.vencimiento_seguro - CURRENT_DATE) <= 30 THEN 'ALERTA: Seguro por vencer en <30 días'
        ELSE 'Vigente'
    END AS estado_alerta
FROM conductor c
JOIN vehiculo veh ON c.id_conductor = veh.id_conductor
JOIN pais p ON c.id_pais = p.id_pais
WHERE (c.vencimiento_licencia - CURRENT_DATE) <= 30
   OR (veh.vencimiento_seguro - CURRENT_DATE) <= 30
ORDER BY LEAST(c.vencimiento_licencia - CURRENT_DATE, veh.vencimiento_seguro - CURRENT_DATE) ASC;


-- ============================================================================
-- CONSULTA 6: TASA DE CANCELACIÓN PORCENTUAL POR TIPO DE SERVICIO
-- Objetivo de Negocio: Medir fricción y calidad del matching para ajustar
-- tarifas de espera, tiempos de arribo y optimización de despachos.
-- ============================================================================
SELECT 
    ts.id_tipo_servicio,
    ts.nombre_servicio,
    COUNT(v.id_viaje) AS total_viajes_solicitados,
    SUM(CASE WHEN ev.nombre_estado = 'Cancelado' THEN 1 ELSE 0 END) AS total_viajes_cancelados,
    SUM(CASE WHEN ev.nombre_estado = 'Finalizado' THEN 1 ELSE 0 END) AS total_viajes_finalizados,
    ROUND(
        (SUM(CASE WHEN ev.nombre_estado = 'Cancelado' THEN 1 ELSE 0 END)::numeric / NULLIF(COUNT(v.id_viaje), 0)) * 100, 
        2
    ) AS tasa_cancelacion_pct
FROM tipo_servicio ts
LEFT JOIN viaje v ON ts.id_tipo_servicio = v.id_tipo_servicio
LEFT JOIN estado_viaje ev ON v.id_estado = ev.id_estado
GROUP BY ts.id_tipo_servicio, ts.nombre_servicio
ORDER BY tasa_cancelacion_pct DESC;


-- ============================================================================
-- CONSULTA 7: LISTADO DE PASAJEROS QUE FINALIZARON VIAJES PERO NUNCA CALIFICARON
-- Objetivo de Negocio: Identificar usuarios con potencial falta de feedback
-- para enviar campañas de fidelización o recordatorios push in-app.
-- ============================================================================
SELECT 
    pas.id_pasajero,
    pas.nombres || ' ' || pas.apellidos AS pasajero,
    pas.correo,
    pas.telefono,
    p.nombre_pais AS pais,
    COUNT(v.id_viaje) AS viajes_finalizados_sin_calificar,
    MAX(v.fecha_fin) AS fecha_ultimo_viaje_sin_calificar
FROM pasajero pas
JOIN pais p ON pas.id_pais = p.id_pais
JOIN viaje v ON pas.id_pasajero = v.id_pasajero
JOIN estado_viaje ev ON v.id_estado = ev.id_estado
WHERE ev.nombre_estado = 'Finalizado'
  AND NOT EXISTS (
      SELECT 1 
      FROM calificacion cal 
      WHERE cal.id_viaje = v.id_viaje 
        AND cal.tipo_calificador = 'Pasajero'
  )
GROUP BY pas.id_pasajero, pas.nombres, pas.apellidos, pas.correo, pas.telefono, p.nombre_pais
ORDER BY viajes_finalizados_sin_calificar DESC, fecha_ultimo_viaje_sin_calificar DESC;


-- ============================================================================
-- CONSULTA 8: VISTA RESUMEN COMPLETO DE VIAJE PARA EL PASAJERO
-- Objetivo de Negocio: Presentar al usuario un recibo/tarjeta digital claro con
-- todos los detalles de su traslado, conductor, vehículo, cobro y calificación.
-- ============================================================================
CREATE OR REPLACE VIEW vw_resumen_viaje_pasajero AS
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

COMMENT ON VIEW vw_resumen_viaje_pasajero IS 'Vista enriquecida con el resumen consolidado de cada viaje para el pasajero';

-- Prueba de consulta sobre la vista creada:
SELECT * 
FROM vw_resumen_viaje_pasajero 
ORDER BY id_viaje DESC 
LIMIT 10;
