package com.rutaandina.controller;

import com.rutaandina.config.DynamicDataSourceConfig;
import com.rutaandina.dto.BiQueryResultDto;
import com.rutaandina.service.BiAnalyticsService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/analytics")
@CrossOrigin(origins = "*")
public class BiAnalyticsController {

    private final BiAnalyticsService biAnalyticsService;
    private final DynamicDataSourceConfig dynamicDataSourceConfig;

    public BiAnalyticsController(BiAnalyticsService biAnalyticsService,
                                 DynamicDataSourceConfig dynamicDataSourceConfig) {
        this.biAnalyticsService = biAnalyticsService;
        this.dynamicDataSourceConfig = dynamicDataSourceConfig;
    }

    @GetMapping("/queries")
    public ResponseEntity<List<Map<String, Object>>> listarCatalogoConsultas() {
        return ResponseEntity.ok(biAnalyticsService.getCatalogList());
    }

    @GetMapping("/queries/{id}")
    public ResponseEntity<BiQueryResultDto> ejecutarConsulta(@PathVariable int id) {
        return ResponseEntity.ok(biAnalyticsService.executeQuery(id));
    }

    @GetMapping("/health")
    public ResponseEntity<Map<String, Object>> checkHealth() {
        Map<String, Object> status = new HashMap<>();
        status.put("status", "UP");
        status.put("timestamp", System.currentTimeMillis());
        status.put("supabaseConnected", dynamicDataSourceConfig.isSupabaseConnected());
        status.put("databaseType", dynamicDataSourceConfig.getActiveDatabaseType());
        status.put("project", "Ruta Andina - COIL 2026 (TECSUP & Politécnico Grancolombiano)");
        return ResponseEntity.ok(status);
    }
}
