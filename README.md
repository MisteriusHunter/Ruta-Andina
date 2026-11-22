# 🏔️ Ruta Andina — Plataforma Binacional de Movilidad Corporativa y Urbana
> **Proyecto Colaborativo Internacional COIL 2026**  
> Desarrollado conjuntamente por estudiantes de **TECSUP (Perú)** y la **Institución Universitaria Politécnico Grancolombiano (Colombia)**.  
> **Integrantes del Equipo:** Alexander Rojas (Perú), Mateo Atapoma (Perú) y Andres Grimaldos (Colombia).

---

## 🌟 1. Visión General del Proyecto
**Ruta Andina** es una plataforma de software de nivel producción diseñada para resolver los desafíos de transporte corporativo y movilidad urbana en dos de las principales ciudades de la región andina: **Lima (Perú - PEN S/)** y **Medellín (Colombia - COP $)**.

Diseñada con una estética visual de agencia de diseño de élite (estilo *Uber Black / Cabify Luxe / Linear App* con tema oscuro, acentos en **Oro Andino** y **Esmeralda**, microinteracciones fluidas y *Glassmorphism*), la plataforma incorpora una base de datos relacional modelada rigurosamente en **Tercera Forma Normal (3FN)** sobre **Supabase (PostgreSQL 15+)** y un backend en **Java 17+ con Spring Boot 3**.

---

## 🏗️ 2. Arquitectura del Sistema

```
                      +-----------------------------------------------+
                      |           FRONTEND WEB (SPA ES6+)             |
                      | HTML5 Semántico + CSS3 Moderno Glassmorphism  |
                      |   Plus Jakarta Sans + Lucide Icons + Fetch    |
                      +-----------------------+-----------------------+
                                              | REST JSON
                                              v
+-----------------------------------------------------------------------------------------+
|                                BACKEND SPRING BOOT 3                                    |
|                                                                                         |
|  [Controllers]        ViajeController  | ConductorController  | EmpresaController       |
|                       BiAnalyticsController | PasajeroController                        |
|                                              |                                          |
|  [Services]           ViajeService     | ConductorService     | EmpresaService          |
|                       BiAnalyticsService | PasajeroService                              |
|                                              |                                          |
|  [Repositories]       Spring Data JPA Repositories (14 Entidades 3FN)                   |
|                                              |                                          |
|  [Resilience Engine]  DynamicDataSourceConfig (Supabase Cloud + H2 Fallback)            |
+----------------------------------------------+------------------------------------------+
                                               | JDBC / SSL
                                               v
+-----------------------------------------------------------------------------------------+
|                               BASE DE DATOS (SUPABASE)                                  |
|                             PostgreSQL 15+ / 14 Entidades                               |
|                                                                                         |
|  • Triggers de Negocio: Validar Licencia/SOAT, Historial de Estados, Auto-Pago 15%     |
|  • Vista Analítica: vw_resumen_viaje_pasajero                                           |
|  • 8 Consultas de Business Intelligence indexadas y optimizadas                         |
+-----------------------------------------------------------------------------------------+
```

---

## 📐 3. Justificación de Normalización en Tercera Forma Normal (3FN)

El modelo de datos se compone de **14 entidades normalizadas** que garantizan integridad referencial absoluta, eliminando anomalías de inserción, actualización y borrado:

| Entidad | Justificación y Cumplimiento 3FN |
| :--- | :--- |
| `pais` | **1FN, 2FN, 3FN:** Clave primaria atómica (`id_pais`). Monedas restringidas por `CHECK (moneda IN ('PEN', 'COP'))`. Previene duplicidad de factores monetarios. |
| `tipo_servicio` | Catálogo centralizado de tarifas base y por km. No depende de viajes individuales; evita redundancia en el cálculo de tarifas. |
| `estado_viaje` | Estados estrictos del ciclo de vida (`Solicitado`, `Aceptado`, `En Curso`, `Finalizado`, `Cancelado`). |
| `empresa` | Modela Operadoras, Clientes Corporativos (BCP, Bancolombia) y Flotas. Identificada unívocamente por RUC/NIT. |
| `empleado_empresa` | **Tabla asociativa:** Resuelve la relación muchos a muchos entre `empresa` y `pasajero`, gestionando cargos corporativos y límites mensuales de crédito sin acoplar datos personales. |
| `pasajero` | Datos atómicos de clientes (nombres, apellidos, tipo y número de documento, correo único). |
| `metodo_pago` | Tarjetas, cuentas corporativas o billeteras digitales (Yape, Plin, Nequi) aisladas en su propia entidad dependiente de `pasajero`. |
| `direccion_favorita` | Puntos habituales geolocalizados sin duplicar cadenas de texto en los registros de usuarios. |
| `conductor` | Identificación profesional con control estricto de licencias (`vencimiento_licencia`), categoría, estado y cuenta de liquidación. |
| `vehiculo` | Unidad física asignada a un chofer, con póliza de seguro (`vencimiento_seguro`) y categoría de servicio vinculada. |
| `viaje` | **Hecho Transaccional:** Registro del traslado (origen, destino, km, tarifa total y moneda). Llaves foráneas atómicas hacia pasajero, conductor, vehículo, tipo de servicio y estado. |
| `historial_estado_viaje` | Trazabilidad inmutable de cambios de estado alimentada automáticamente por disparadores SQL (`Trigger`). |
| `pago` | Transacción financiera 1 a 1 con `viaje`, registrando el monto cobrado y la deducción de la **comisión de plataforma (15%)**. |
| `calificacion` | Evaluación bidireccional (1 a 5 estrellas) con comentarios independientes del cobro. |

---

## ⚡ 4. Guía Rápida para Levantar la Base de Datos en Supabase (2 Minutos)

### Paso 1: Crear o ingresar a tu proyecto en Supabase
1. Ingresa a [https://supabase.com](https://supabase.com) e inicia sesión.
2. Crea un nuevo proyecto (ej. `ruta-andina-coil`) seleccionando la región más cercana (ej. *South America - São Paulo* o *US East*).

### Paso 2: Ejecutar los Scripts SQL en el SQL Editor de Supabase
En el panel lateral izquierdo de Supabase, abre la sección **SQL Editor** y ejecuta los 3 archivos ubicados en la carpeta `/database` del proyecto en este orden estricto:

1. **`01_ddl.sql`**: Crea las 14 tablas, restricciones (`PRIMARY KEY`, `FOREIGN KEY`, `CHECK`, `UNIQUE`), índices y los 3 triggers en PostgreSQL:
   * `fn_validar_documentos_viaje`: Impide asignar viajes a choferes con brevete o SOAT vencido.
   * `fn_registrar_historial_estado`: Audita transiciones de estado de cada servicio.
   * `fn_procesar_viaje_finalizado`: Calcula la comisión de la plataforma y crea el registro en `pago`.
2. **`02_dml.sql`**: Inserta los datos de prueba realistas distribuidos equitativamente entre Lima y Medellín:
   * 20 pasajeros (10 Perú / 10 Colombia).
   * 10 conductores certificados y 10 vehículos modernos.
   * 6 empresas (Operadoras Ruta Andina, BCP Corporativo, Bancolombia, Flotas).
   * 54 viajes en diversos estados, con sus pagos, calificaciones y métodos.
3. **`03_consultas.sql`**: Crea la vista analítica `vw_resumen_viaje_pasajero` y deja probadas las 8 consultas de negocio.

---

## ⚙️ 5. Configuración de Credenciales en `application.properties`

Abre el archivo [src/main/resources/application.properties](file:///c:/Users/Nathalia/Downloads/Ruta%20Andina/src/main/resources/application.properties) y configura tu conexión:

En Supabase, dirígete a:  
👉 **Project Settings** ➔ **Database** ➔ **Connection Parameters** / **Connection String (URI / JDBC)**.

Pega tus valores en:

```properties
# Reemplaza [TU_PASSWORD] y [TU_PROYECTO_ID] con los de tu consola Supabase:
spring.datasource.url=jdbc:postgresql://db.[TU_PROYECTO_ID].supabase.co:5432/postgres?sslmode=require
spring.datasource.username=postgres
spring.datasource.password=[TU_PASSWORD_DE_SUPABASE]
spring.datasource.driver-class-name=org.postgresql.Driver

spring.jpa.database-platform=org.hibernate.dialect.PostgreSQLDialect
spring.jpa.hibernate.ddl-auto=none
server.port=8080
```

> **Nota de Resiliencia Inteligente:** Si deseas evaluar la interfaz visual y la API de inmediato antes de configurar Supabase, el backend cuenta con un **Mecanismo de Detección Dinámica** (`DynamicDataSourceConfig`) que inicializa automáticamente un motor local en memoria con el mismo esquema y datos, permitiendo explorar todas las funcionalidades sin interrupción. Al ingresar las credenciales reales de Supabase, la luz del indicador pasará a verde: `Supabase PostgreSQL 15+`.

---

## 🚀 6. Ejecución del Proyecto

### En Windows (1 Clic):
Haz doble clic sobre el archivo ejecutable `run.bat` ubicado en la raíz del proyecto, o ejecuta en PowerShell:
```powershell
.\run.bat
```

### Mediante Maven CLI:
```bash
mvn spring-boot:run
```

Abre tu navegador web en:  
👉 **[http://localhost:8080](http://localhost:8080)**

---

## 📊 7. Las 8 Consultas de Business Intelligence (COIL 2026)

El sistema incluye en el menú de navegación la pestaña **"Business Intelligence"**, donde el jurado evaluador puede ejecutar con un solo clic y auditar los resultados reales y tiempos de respuesta de cada consulta sobre la base de datos:

1. **Viajes finalizados por conductor en el último mes:** Productividad, kilometraje y facturación de choferes.
2. **Ingresos totales y comisiones de plataforma:** Consolidación de Gross Merchandise Value (GMV) e ingresos netos por comisión (15%) en Soles (PEN) y Pesos (COP).
3. **Top 5 conductores por calificación promedio:** Ranking con muestra representativa mínima de 5 servicios evaluados por pasajeros.
4. **Consumo mensual detallado de empresas corporativas:** Estado de cuenta B2B para clientes corporativos (Banco de Crédito BCP y Bancolombia).
5. **Alerta preventiva de vencimiento de documentos (< 30 días):** Detección temprana de brevetes o seguros vehiculares (SOAT) por vencer o vencidos.
6. **Tasa de cancelación porcentual por tipo de servicio:** Métrica de fricción y optimización de despachos.
7. **Pasajeros que finalizaron viajes pero nunca calificaron:** Segmentación de clientes para campañas de retroalimentación in-app.
8. **Vista resumida `vw_resumen_viaje_pasajero`:** Resumen consolidado para recibos digitales del pasajero.

---

## ⚡ 8. Modo "Acceso Demo"
Para facilitar la revisión sin requerir digitación ni registros manuales, la barra superior cuenta con el botón **"Acceso Demo"**, que permite alternar al instante entre 6 perfiles completos:
* 🇵🇪 **Luciana Vargas:** Pasajera en Lima (Miraflores, pago con Visa en Soles).
* 🇨🇴 **Juliana Gómez:** Pasajera corporativa en Medellín (El Poblado, cargo a cuenta Bancolombia en Pesos).
* 🚘 **Carlos Mendoza:** Conductor en Lima (Toyota Corolla Hybrid BAP-842, documentos al día).
* 🚘 **William Castañeda:** Conductor en Medellín (BMW Serie 3 KMS-811, con alerta de SOAT que vence en 25 días).
* 🏢 **Banco de Crédito BCP:** Dashboard financiero y facturación empresarial en Lima.
* 🏢 **Bancolombia S.A.:** Dashboard ejecutivo y gastos corporativos en Medellín.

---
**Proyecto Colaborativo Internacional COIL 2026** — *TECSUP & Institución Universitaria Politécnico Grancolombiano.*
