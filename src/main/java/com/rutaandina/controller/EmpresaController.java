package com.rutaandina.controller;

import com.rutaandina.dto.DashboardKpiDto;
import com.rutaandina.model.Empresa;
import com.rutaandina.model.Viaje;
import com.rutaandina.service.EmpresaService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/empresas")
@CrossOrigin(origins = "*")
public class EmpresaController {

    private final EmpresaService empresaService;

    public EmpresaController(EmpresaService empresaService) {
        this.empresaService = empresaService;
    }

    @GetMapping
    public ResponseEntity<List<Empresa>> listar(@RequestParam(required = false, defaultValue = "true") boolean soloClientes) {
        if (soloClientes) {
            return ResponseEntity.ok(empresaService.listarClientesCorporativos());
        }
        return ResponseEntity.ok(empresaService.listarTodas());
    }

    @GetMapping("/{id}")
    public ResponseEntity<Empresa> buscarPorId(@PathVariable Integer id) {
        return empresaService.buscarPorId(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @GetMapping("/{id}/viajes")
    public ResponseEntity<List<Viaje>> listarViajesCorporativos(@PathVariable Integer id) {
        return ResponseEntity.ok(empresaService.listarViajesCorporativos(id));
    }

    @GetMapping("/{id}/kpis")
    public ResponseEntity<DashboardKpiDto> obtenerKpis(@PathVariable Integer id) {
        return ResponseEntity.ok(empresaService.obtenerKpisCorporativos(id));
    }
}
