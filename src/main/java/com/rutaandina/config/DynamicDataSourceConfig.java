package com.rutaandina.config;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.jdbc.DataSourceBuilder;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Primary;
import org.springframework.core.io.ClassPathResource;
import org.springframework.jdbc.datasource.init.ResourceDatabasePopulator;

import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.DriverManager;

@Configuration
public class DynamicDataSourceConfig {

    private static final Logger log = LoggerFactory.getLogger(DynamicDataSourceConfig.class);

    @Value("${spring.datasource.url:}")
    private String dbUrl;

    @Value("${spring.datasource.username:postgres}")
    private String dbUser;

    @Value("${spring.datasource.password:}")
    private String dbPassword;

    private boolean supabaseConnected = false;
    private String activeDatabaseType = "H2 PostgreSQL-Mode (Local)";

    @Bean
    @Primary
    public DataSource dataSource() {
        boolean trySupabase = dbUrl != null && !dbUrl.isBlank() 
                && !dbUrl.contains("YOUR_PROJECT_ID") 
                && !dbUrl.contains("YOUR_SUPABASE_PASSWORD");

        if (trySupabase) {
            try {
                log.info("Verificando conexión con Supabase PostgreSQL en {}...", dbUrl);
                // Prueba rápida de conectividad
                try (Connection conn = DriverManager.getConnection(dbUrl, dbUser, dbPassword)) {
                    if (conn.isValid(5)) {
                        log.info(">>> CONEXIÓN EXITOSA CON SUPABASE (PostgreSQL) <<<");
                        this.supabaseConnected = true;
                        this.activeDatabaseType = "Supabase (PostgreSQL Cloud)";
                        return DataSourceBuilder.create()
                                .url(dbUrl)
                                .username(dbUser)
                                .password(dbPassword)
                                .driverClassName("org.postgresql.Driver")
                                .build();
                    }
                }
            } catch (Exception e) {
                log.warn("No se pudo conectar a Supabase directamente ({}). Activando modo local de contingencia.", e.getMessage());
            }
        } else {
            log.info("Credenciales de Supabase no configuradas o con valor por defecto. Iniciando base de datos local en memoria.");
        }

        // Base de datos de contingencia en memoria (Modo PostgreSQL de H2)
        log.info(">>> INICIANDO MODO CONTINGENCIA / EVALUACIÓN INMEDIATA (H2 Modo PostgreSQL) <<<");
        this.supabaseConnected = false;
        this.activeDatabaseType = "H2 Local (Modo PostgreSQL)";

        DataSource localDs = DataSourceBuilder.create()
                .url("jdbc:h2:mem:rutaandina;MODE=PostgreSQL;DATABASE_TO_LOWER=TRUE;DEFAULT_NULL_ORDERING=HIGH")
                .username("sa")
                .password("")
                .driverClassName("org.h2.Driver")
                .build();

        try {
            ResourceDatabasePopulator populator = new ResourceDatabasePopulator();
            populator.addScript(new ClassPathResource("schema-fallback.sql"));
            populator.addScript(new ClassPathResource("data-fallback.sql"));
            populator.execute(localDs);
            log.info("Esquema y datos de prueba precargados exitosamente en modo contingencia.");
        } catch (Exception e) {
            log.error("Error al inicializar datos locales: {}", e.getMessage(), e);
        }

        return localDs;
    }

    public boolean isSupabaseConnected() {
        return supabaseConnected;
    }

    public String getActiveDatabaseType() {
        return activeDatabaseType;
    }
}
