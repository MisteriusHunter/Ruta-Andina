package com.rutaandina.service;

import com.rutaandina.dto.BiQueryResultDto;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import javax.sql.DataSource;
import java.sql.*;
import java.util.*;

@Service
public class BiAnalyticsService {

    private static final Logger log = LoggerFactory.getLogger(BiAnalyticsService.class);
    private final DataSource dataSource;

    public static class QueryDefinition {
        private final int id;
        private final String title;
        private final String description;
        private final String sql;

        public QueryDefinition(int id, String title, String description, String sql) {
            this.id = id;
            this.title = title;
            this.description = description;
            this.sql = sql;
        }

        public int getId() { return id; }
        public String getTitle() { return title; }
        public String getDescription() { return description; }
        public String getSql() { return sql; }
    }

    private final Map<Integer, QueryDefinition> queryCatalog = new LinkedHashMap<>();

    public BiAnalyticsService(DataSource dataSource) {
        this.dataSource = dataSource;
        initQueries();
    }

    private void initQueries() {
        queryCatalog.put(1, new QueryDefinition(
                1,
                "Viajes Finalizados por Conductor en el Último Mes",
                "Evalúa la productividad y facturación individual de cada chofer en los últimos 30 días para liquidaciones y reconocimientos.",
                "SELECT c.id_conductor, c.nombres || ' ' || c.apellidos AS conductor, p.nombre_pais AS pais, v.moneda, " +
                "COUNT(v.id_viaje) AS total_viajes_finalizados, ROUND(SUM(v.distancia_km), 2) AS total_km_recorridos, " +
                "ROUND(SUM(v.tarifa_total), 2) AS facturacion_total_conductor, ROUND(AVG(v.tarifa_total), 2) AS ticket_promedio " +
                "FROM conductor c " +
                "JOIN viaje v ON c.id_conductor = v.id_conductor " +
                "JOIN estado_viaje ev ON v.id_estado = ev.id_estado " +
                "JOIN pais p ON c.id_pais = p.id_pais " +
                "WHERE ev.nombre_estado = 'Finalizado' AND v.fecha_fin >= (CURRENT_DATE - INTERVAL '30' DAY) " +
                "GROUP BY c.id_conductor, c.nombres, c.apellidos, p.nombre_pais, v.moneda " +
                "ORDER BY total_viajes_finalizados DESC, facturacion_total_conductor DESC"
        ));

        queryCatalog.put(2, new QueryDefinition(
                2,
                "Ingresos Totales y Comisiones por País y Moneda",
                "Consolida el volumen bruto operado (GMV) y los ingresos netos por comisiones (15%) agrupados por Perú (PEN) y Colombia (COP).",
                "SELECT p.nombre_pais AS pais, pag.moneda, COUNT(pag.id_pago) AS cantidad_transacciones, " +
                "ROUND(SUM(pag.monto), 2) AS volumen_bruto_gmv, ROUND(SUM(pag.comision_plataforma), 2) AS comision_neta_plataforma, " +
                "ROUND(AVG(pag.monto), 2) AS ticket_promedio_viaje, ROUND(AVG(pag.comision_plataforma), 2) AS comision_promedio_viaje " +
                "FROM pago pag " +
                "JOIN viaje v ON pag.id_viaje = v.id_viaje " +
                "JOIN pais p ON v.id_pais = p.id_pais " +
                "WHERE pag.estado = 'Completado' " +
                "GROUP BY p.nombre_pais, pag.moneda " +
                "ORDER BY volumen_bruto_gmv DESC"
        ));

        queryCatalog.put(3, new QueryDefinition(
                3,
                "Top 5 Conductores por Calificación Promedio (Mín. 5 Viajes)",
                "Ranking de excelencia en servicio al cliente para choferes con muestra estadísticamente válida (al menos 5 evaluaciones).",
                "SELECT c.id_conductor, c.nombres || ' ' || c.apellidos AS conductor, p.nombre_pais AS pais, " +
                "veh.marca || ' ' || veh.modelo AS vehiculo, veh.placa, ts.nombre_servicio, " +
                "COUNT(cal.id_calificacion) AS cantidad_calificaciones, " +
                "ROUND(AVG(cal.puntaje), 2) AS rating_promedio, " +
                "COUNT(DISTINCT v.id_viaje) AS viajes_finalizados " +
                "FROM conductor c " +
                "JOIN vehiculo veh ON c.id_conductor = veh.id_conductor " +
                "JOIN tipo_servicio ts ON veh.id_tipo_servicio = ts.id_tipo_servicio " +
                "JOIN pais p ON c.id_pais = p.id_pais " +
                "JOIN viaje v ON c.id_conductor = v.id_conductor " +
                "JOIN calificacion cal ON v.id_viaje = cal.id_viaje " +
                "WHERE cal.tipo_calificador = 'Pasajero' " +
                "GROUP BY c.id_conductor, c.nombres, c.apellidos, p.nombre_pais, veh.marca, veh.modelo, veh.placa, ts.nombre_servicio " +
                "HAVING COUNT(DISTINCT v.id_viaje) >= 5 " +
                "ORDER BY rating_promedio DESC, cantidad_calificaciones DESC " +
                "LIMIT 5"
        ));

        queryCatalog.put(4, new QueryDefinition(
                4,
                "Consumo Mensual Detallado de Clientes Corporativos",
                "Reporte consolidado B2B de facturación para cuentas corporativas como Banco de Crédito BCP y Bancolombia.",
                "SELECT emp.id_empresa, emp.ruc_nit, emp.razon_social AS empresa_cliente, p.nombre_pais AS pais, v.moneda, " +
                "COUNT(DISTINCT v.id_viaje) AS total_viajes_corporativos, COUNT(DISTINCT ee.id_empleado) AS empleados_activos, " +
                "ROUND(SUM(v.tarifa_total), 2) AS consumo_total_mes, ROUND(AVG(v.tarifa_total), 2) AS costo_promedio_viaje " +
                "FROM empresa emp " +
                "JOIN empleado_empresa ee ON emp.id_empresa = ee.id_empresa " +
                "JOIN pasajero pas ON ee.id_pasajero = pas.id_pasajero " +
                "JOIN viaje v ON pas.id_pasajero = v.id_pasajero AND v.es_corporativo = true " +
                "JOIN estado_viaje ev ON v.id_estado = ev.id_estado " +
                "JOIN pais p ON emp.id_pais = p.id_pais " +
                "WHERE emp.tipo_empresa = 'Cliente_Corporativo' AND ev.nombre_estado = 'Finalizado' " +
                "GROUP BY emp.id_empresa, emp.ruc_nit, emp.razon_social, p.nombre_pais, v.moneda " +
                "ORDER BY consumo_total_mes DESC"
        ));

        queryCatalog.put(5, new QueryDefinition(
                5,
                "Alerta de Vencimiento de Licencias o Seguros (< 30 Días)",
                "Módulo preventivo de seguridad vial para alertar choferes cuyos documentos vencerán pronto o ya vencieron.",
                "SELECT c.id_conductor, c.nombres || ' ' || c.apellidos AS conductor, c.telefono, c.correo, p.nombre_pais AS pais, " +
                "veh.placa, veh.marca || ' ' || veh.modelo AS vehiculo, c.numero_licencia, c.vencimiento_licencia, " +
                "DATEDIFF('DAY', CURRENT_DATE, c.vencimiento_licencia) AS dias_para_vencer_licencia, " +
                "veh.seguro AS entidad_seguro, veh.vencimiento_seguro, " +
                "DATEDIFF('DAY', CURRENT_DATE, veh.vencimiento_seguro) AS dias_para_vencer_seguro, " +
                "CASE " +
                "  WHEN c.vencimiento_licencia < CURRENT_DATE THEN 'CRÍTICO: Licencia Vencida' " +
                "  WHEN veh.vencimiento_seguro < CURRENT_DATE THEN 'CRÍTICO: Seguro Vencido' " +
                "  WHEN DATEDIFF('DAY', CURRENT_DATE, c.vencimiento_licencia) <= 30 AND DATEDIFF('DAY', CURRENT_DATE, veh.vencimiento_seguro) <= 30 THEN 'ALERTA ALTA: Ambos vencen en <30 días' " +
                "  WHEN DATEDIFF('DAY', CURRENT_DATE, c.vencimiento_licencia) <= 30 THEN 'ALERTA: Licencia vence en <30 días' " +
                "  WHEN DATEDIFF('DAY', CURRENT_DATE, veh.vencimiento_seguro) <= 30 THEN 'ALERTA: Seguro vence en <30 días' " +
                "  ELSE 'Vigente' " +
                "END AS estado_alerta " +
                "FROM conductor c " +
                "JOIN vehiculo veh ON c.id_conductor = veh.id_conductor " +
                "JOIN pais p ON c.id_pais = p.id_pais " +
                "WHERE DATEDIFF('DAY', CURRENT_DATE, c.vencimiento_licencia) <= 30 " +
                "   OR DATEDIFF('DAY', CURRENT_DATE, veh.vencimiento_seguro) <= 30 " +
                "ORDER BY LEAST(DATEDIFF('DAY', CURRENT_DATE, c.vencimiento_licencia), DATEDIFF('DAY', CURRENT_DATE, veh.vencimiento_seguro)) ASC"
        ));

        queryCatalog.put(6, new QueryDefinition(
                6,
                "Tasa de Cancelación Porcentual por Tipo de Servicio",
                "Métrica clave de fricción de mercado para analizar en qué segmento se presentan mayor índice de cancelaciones.",
                "SELECT ts.id_tipo_servicio, ts.nombre_servicio, COUNT(v.id_viaje) AS total_viajes_solicitados, " +
                "SUM(CASE WHEN ev.nombre_estado = 'Cancelado' THEN 1 ELSE 0 END) AS total_viajes_cancelados, " +
                "SUM(CASE WHEN ev.nombre_estado = 'Finalizado' THEN 1 ELSE 0 END) AS total_viajes_finalizados, " +
                "ROUND((CAST(SUM(CASE WHEN ev.nombre_estado = 'Cancelado' THEN 1 ELSE 0 END) AS NUMERIC) / NULLIF(COUNT(v.id_viaje), 0)) * 100, 2) AS tasa_cancelacion_pct " +
                "FROM tipo_servicio ts " +
                "LEFT JOIN viaje v ON ts.id_tipo_servicio = v.id_tipo_servicio " +
                "LEFT JOIN estado_viaje ev ON v.id_estado = ev.id_estado " +
                "GROUP BY ts.id_tipo_servicio, ts.nombre_servicio " +
                "ORDER BY tasa_cancelacion_pct DESC"
        ));

        queryCatalog.put(7, new QueryDefinition(
                7,
                "Pasajeros que Finalizaron Viajes pero Nunca Calificaron",
                "Detección de usuarios con falta de feedback para activación de campañas de reenganche o notificaciones in-app.",
                "SELECT pas.id_pasajero, pas.nombres || ' ' || pas.apellidos AS pasajero, pas.correo, pas.telefono, p.nombre_pais AS pais, " +
                "COUNT(v.id_viaje) AS viajes_sin_calificar, MAX(v.fecha_fin) AS fecha_ultimo_viaje " +
                "FROM pasajero pas " +
                "JOIN pais p ON pas.id_pais = p.id_pais " +
                "JOIN viaje v ON pas.id_pasajero = v.id_pasajero " +
                "JOIN estado_viaje ev ON v.id_estado = ev.id_estado " +
                "WHERE ev.nombre_estado = 'Finalizado' " +
                "  AND NOT EXISTS (SELECT 1 FROM calificacion cal WHERE cal.id_viaje = v.id_viaje AND cal.tipo_calificador = 'Pasajero') " +
                "GROUP BY pas.id_pasajero, pas.nombres, pas.apellidos, pas.correo, pas.telefono, p.nombre_pais " +
                "ORDER BY viajes_sin_calificar DESC"
        ));

        queryCatalog.put(8, new QueryDefinition(
                8,
                "Vista de Resumen Completo de Viaje (vw_resumen_viaje_pasajero)",
                "Consulta de los últimos registros consolidados generados por la vista `vw_resumen_viaje_pasajero` para los pasajeros.",
                "SELECT id_viaje, id_pasajero, nombre_pasajero, pais, nombre_servicio, estado_viaje, origen, destino, " +
                "fecha_solicitud, distancia_km, tarifa_total, moneda, nombre_conductor, placa, vehiculo, estado_pago, " +
                "calificacion_otorgada, comentario_calificacion " +
                "FROM vw_resumen_viaje_pasajero " +
                "ORDER BY id_viaje DESC " +
                "LIMIT 15"
        ));
    }

    public List<Map<String, Object>> getCatalogList() {
        List<Map<String, Object>> list = new ArrayList<>();
        queryCatalog.forEach((id, q) -> {
            Map<String, Object> m = new HashMap<>();
            m.put("id", q.getId());
            m.put("title", q.getTitle());
            m.put("description", q.getDescription());
            m.put("sql", q.getSql());
            list.add(m);
        });
        return list;
    }

    public BiQueryResultDto executeQuery(int queryId) {
        QueryDefinition q = queryCatalog.get(queryId);
        if (q == null) {
            throw new IllegalArgumentException("Consulta BI no encontrada con ID: " + queryId);
        }

        long start = System.currentTimeMillis();
        List<String> columnNames = new ArrayList<>();
        List<Map<String, Object>> rows = new ArrayList<>();

        try (Connection conn = dataSource.getConnection();
             PreparedStatement ps = conn.prepareStatement(q.getSql());
             ResultSet rs = ps.executeQuery()) {

            ResultSetMetaData meta = rs.getMetaData();
            int colCount = meta.getColumnCount();
            for (int i = 1; i <= colCount; i++) {
                columnNames.add(meta.getColumnLabel(i));
            }

            while (rs.next()) {
                Map<String, Object> row = new LinkedHashMap<>();
                for (int i = 1; i <= colCount; i++) {
                    Object val = rs.getObject(i);
                    row.put(meta.getColumnLabel(i), val);
                }
                rows.add(row);
            }

        } catch (SQLException e) {
            log.error("Error al ejecutar consulta BI {}: {}", queryId, e.getMessage(), e);
            throw new RuntimeException("Error en base de datos al ejecutar consulta " + queryId + ": " + e.getMessage());
        }

        long elapsed = System.currentTimeMillis() - start;

        BiQueryResultDto result = new BiQueryResultDto();
        result.setQueryId(q.getId());
        result.setTitle(q.getTitle());
        result.setDescription(q.getDescription());
        result.setSql(q.getSql());
        result.setColumns(columnNames);
        result.setRows(rows);
        result.setExecutionTimeMs(elapsed);
        result.setTotalRows(rows.size());

        return result;
    }
}
