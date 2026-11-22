package com.rutaandina.controller;

import com.rutaandina.model.DireccionFavorita;
import com.rutaandina.model.MetodoPago;
import com.rutaandina.model.Pasajero;
import com.rutaandina.service.PasajeroService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/pasajeros")
@CrossOrigin(origins = "*")
public class PasajeroController {

    private final PasajeroService pasajeroService;

    public PasajeroController(PasajeroService pasajeroService) {
        this.pasajeroService = pasajeroService;
    }

    @GetMapping
    public ResponseEntity<List<Pasajero>> listar(@RequestParam(required = false) Integer idPais) {
        if (idPais != null) {
            return ResponseEntity.ok(pasajeroService.listarPorPais(idPais));
        }
        return ResponseEntity.ok(pasajeroService.listarTodos());
    }

    @GetMapping("/{id}")
    public ResponseEntity<Pasajero> buscarPorId(@PathVariable Integer id) {
        return pasajeroService.buscarPorId(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @GetMapping("/{id}/metodos-pago")
    public ResponseEntity<List<MetodoPago>> listarMetodosPago(@PathVariable Integer id) {
        return ResponseEntity.ok(pasajeroService.listarMetodosPago(id));
    }

    @GetMapping("/{id}/direcciones-favoritas")
    public ResponseEntity<List<DireccionFavorita>> listarDirecciones(@PathVariable Integer id) {
        return ResponseEntity.ok(pasajeroService.listarDireccionesFavoritas(id));
    }
}
