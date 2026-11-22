package com.rutaandina.controller;

import com.rutaandina.dto.ActualizarEstadoRequest;
import com.rutaandina.dto.CalificarViajeRequest;
import com.rutaandina.dto.CotizacionRequest;
import com.rutaandina.dto.CotizacionResponse;
import com.rutaandina.dto.SolicitarViajeRequest;
import com.rutaandina.model.Calificacion;
import com.rutaandina.model.Viaje;
import com.rutaandina.service.ViajeService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/viajes")
@CrossOrigin(origins = "*")
public class ViajeController {

    private final ViajeService viajeService;

    public ViajeController(ViajeService viajeService) {
        this.viajeService = viajeService;
    }

    @PostMapping("/cotizar")
    public ResponseEntity<CotizacionResponse> cotizar(@RequestBody CotizacionRequest request) {
        return ResponseEntity.ok(viajeService.cotizar(request));
    }

    @PostMapping("/solicitar")
    public ResponseEntity<Viaje> solicitarViaje(@RequestBody SolicitarViajeRequest request) {
        Viaje creado = viajeService.solicitarViaje(request);
        return ResponseEntity.status(HttpStatus.CREATED).body(creado);
    }

    @GetMapping("/pendientes")
    public ResponseEntity<List<Viaje>> listarPendientes(@RequestParam(required = false) Integer idPais) {
        return ResponseEntity.ok(viajeService.listarPendientes(idPais));
    }

    @GetMapping("/pasajero/{idPasajero}")
    public ResponseEntity<List<Viaje>> listarPorPasajero(@PathVariable Integer idPasajero) {
        return ResponseEntity.ok(viajeService.listarPorPasajero(idPasajero));
    }

    @GetMapping("/conductor/{idConductor}")
    public ResponseEntity<List<Viaje>> listarPorConductor(@PathVariable Integer idConductor) {
        return ResponseEntity.ok(viajeService.listarPorConductor(idConductor));
    }

    @GetMapping("/{id}")
    public ResponseEntity<Viaje> buscarPorId(@PathVariable Integer id) {
        return viajeService.buscarPorId(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @PutMapping("/{id}/estado")
    public ResponseEntity<Viaje> actualizarEstado(@PathVariable Integer id,
                                                  @RequestBody ActualizarEstadoRequest request) {
        Viaje actualizado = viajeService.actualizarEstado(id, request);
        return ResponseEntity.ok(actualizado);
    }

    @PostMapping("/{id}/calificar")
    public ResponseEntity<Calificacion> calificarViaje(@PathVariable Integer id,
                                                       @RequestBody CalificarViajeRequest request) {
        Calificacion cal = viajeService.calificarViaje(id, request);
        return ResponseEntity.status(HttpStatus.CREATED).body(cal);
    }
}
