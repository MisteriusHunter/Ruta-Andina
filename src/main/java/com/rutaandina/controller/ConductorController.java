package com.rutaandina.controller;

import com.rutaandina.model.Conductor;
import com.rutaandina.service.ConductorService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/conductores")
@CrossOrigin(origins = "*")
public class ConductorController {

    private final ConductorService conductorService;

    public ConductorController(ConductorService conductorService) {
        this.conductorService = conductorService;
    }

    @GetMapping
    public ResponseEntity<List<Conductor>> listar(@RequestParam(required = false) Integer idPais) {
        if (idPais != null) {
            return ResponseEntity.ok(conductorService.listarPorPais(idPais));
        }
        return ResponseEntity.ok(conductorService.listarTodos());
    }

    @GetMapping("/{id}")
    public ResponseEntity<Conductor> buscarPorId(@PathVariable Integer id) {
        return conductorService.buscarPorId(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @GetMapping("/{id}/documentos")
    public ResponseEntity<Map<String, Object>> obtenerDocumentos(@PathVariable Integer id) {
        return ResponseEntity.ok(conductorService.obtenerEstadoDocumentos(id));
    }
}
