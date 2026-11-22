package com.rutaandina.service;

import com.rutaandina.dto.ActualizarEstadoRequest;
import com.rutaandina.dto.CalificarViajeRequest;
import com.rutaandina.dto.CotizacionRequest;
import com.rutaandina.dto.CotizacionResponse;
import com.rutaandina.dto.SolicitarViajeRequest;
import com.rutaandina.exception.BusinessValidationException;
import com.rutaandina.model.*;
import com.rutaandina.repository.*;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Service
@Transactional
public class ViajeService {

    private final ViajeRepository viajeRepository;
    private final PasajeroRepository pasajeroRepository;
    private final ConductorRepository conductorRepository;
    private final VehiculoRepository vehiculoRepository;
    private final TipoServicioRepository tipoServicioRepository;
    private final EstadoViajeRepository estadoViajeRepository;
    private final PaisRepository paisRepository;
    private final HistorialEstadoViajeRepository historialRepository;
    private final PagoRepository pagoRepository;
    private final CalificacionRepository calificacionRepository;
    private final MetodoPagoRepository metodoPagoRepository;

    public ViajeService(ViajeRepository viajeRepository,
                        PasajeroRepository pasajeroRepository,
                        ConductorRepository conductorRepository,
                        VehiculoRepository vehiculoRepository,
                        TipoServicioRepository tipoServicioRepository,
                        EstadoViajeRepository estadoViajeRepository,
                        PaisRepository paisRepository,
                        HistorialEstadoViajeRepository historialRepository,
                        PagoRepository pagoRepository,
                        CalificacionRepository calificacionRepository,
                        MetodoPagoRepository metodoPagoRepository) {
        this.viajeRepository = viajeRepository;
        this.pasajeroRepository = pasajeroRepository;
        this.conductorRepository = conductorRepository;
        this.vehiculoRepository = vehiculoRepository;
        this.tipoServicioRepository = tipoServicioRepository;
        this.estadoViajeRepository = estadoViajeRepository;
        this.paisRepository = paisRepository;
        this.historialRepository = historialRepository;
        this.pagoRepository = pagoRepository;
        this.calificacionRepository = calificacionRepository;
        this.metodoPagoRepository = metodoPagoRepository;
    }

    @Transactional(readOnly = true)
    public CotizacionResponse cotizar(CotizacionRequest req) {
        TipoServicio servicio = tipoServicioRepository.findById(req.getIdTipoServicio())
                .orElseThrow(() -> new IllegalArgumentException("Tipo de servicio no encontrado"));

        BigDecimal distancia = req.getDistanciaKm() != null ? req.getDistanciaKm() : BigDecimal.valueOf(5.0);
        String moneda = req.getMoneda() != null ? req.getMoneda().toUpperCase() : "PEN";

        // Multiplicador de escala cambiaria realista para Colombia (COP)
        // Ejemplo: PEN 1.00 ~= COP 1,000 en tarifas proporcionales de movilidad
        BigDecimal factorMoneda = "COP".equals(moneda) ? new BigDecimal("1000") : BigDecimal.ONE;

        BigDecimal base = servicio.getTarifaBase().multiply(factorMoneda).setScale(2, RoundingMode.HALF_UP);
        BigDecimal porKm = servicio.getTarifaKm().multiply(factorMoneda).setScale(2, RoundingMode.HALF_UP);
        BigDecimal subtotal = base.add(porKm.multiply(distancia)).setScale(2, RoundingMode.HALF_UP);
        BigDecimal comision = subtotal.multiply(new BigDecimal("0.15")).setScale(2, RoundingMode.HALF_UP);
        BigDecimal total = subtotal;

        // Estimación de tiempo: aprox. 3.2 minutos por km en tráfico urbano de Lima o Medellín
        int tiempoMin = Math.max(8, (int) Math.round(distancia.doubleValue() * 3.2));

        CotizacionResponse res = new CotizacionResponse();
        res.setIdTipoServicio(servicio.getIdTipoServicio());
        res.setNombreServicio(servicio.getNombreServicio());
        res.setDistanciaKm(distancia);
        res.setTiempoEstimadoMinutos(tiempoMin);
        res.setTarifaBase(base);
        res.setTarifaKm(porKm);
        res.setSubtotal(subtotal);
        res.setComisionPlataforma(comision);
        res.setTarifaTotal(total);
        res.setMoneda(moneda);
        res.setSimboloMoneda("COP".equals(moneda) ? "COP $" : "PEN S/");

        return res;
    }

    public Viaje solicitarViaje(SolicitarViajeRequest req) {
        Pasajero pasajero = pasajeroRepository.findById(req.getIdPasajero())
                .orElseThrow(() -> new IllegalArgumentException("Pasajero no encontrado"));

        TipoServicio servicio = tipoServicioRepository.findById(req.getIdTipoServicio())
                .orElseThrow(() -> new IllegalArgumentException("Tipo de servicio no encontrado"));

        Pais pais = paisRepository.findById(req.getIdPais())
                .orElse(pasajero.getPais());

        EstadoViaje estadoSolicitado = estadoViajeRepository.findByNombreEstado("Solicitado")
                .orElseGet(() -> estadoViajeRepository.findById(1).orElseThrow());

        Viaje viaje = new Viaje();
        viaje.setPasajero(pasajero);
        viaje.setTipoServicio(servicio);
        viaje.setEstadoViaje(estadoSolicitado);
        viaje.setPais(pais);
        viaje.setEsCorporativo(Boolean.TRUE.equals(req.getEsCorporativo()));
        viaje.setOrigen(req.getOrigen());
        viaje.setDestino(req.getDestino());
        viaje.setDistanciaKm(req.getDistanciaKm());
        viaje.setTarifaTotal(req.getTarifaTotal());
        viaje.setMoneda(req.getMoneda() != null ? req.getMoneda() : pais.getMoneda());
        viaje.setFechaSolicitud(LocalDateTime.now());

        Viaje guardado = viajeRepository.save(viaje);

        // Registrar auditoría en historial
        historialRepository.save(new HistorialEstadoViaje(guardado, null, "Solicitado"));

        return guardado;
    }

    public Viaje actualizarEstado(Integer idViaje, ActualizarEstadoRequest req) {
        Viaje viaje = viajeRepository.findById(idViaje)
                .orElseThrow(() -> new IllegalArgumentException("Viaje no encontrado"));

        String estadoAnterior = viaje.getEstadoViaje().getNombreEstado();
        String nuevoEstado = req.getNuevoEstado();

        EstadoViaje estadoObj = estadoViajeRepository.findByNombreEstado(nuevoEstado)
                .orElseThrow(() -> new IllegalArgumentException("Estado no válido: " + nuevoEstado));

        // Regla de Negocio COIL: Si se acepta el viaje o se asigna conductor, validar documentos
        if ("Aceptado".equalsIgnoreCase(nuevoEstado) || req.getIdConductor() != null) {
            Integer idConductor = req.getIdConductor() != null 
                    ? req.getIdConductor() 
                    : (viaje.getConductor() != null ? viaje.getConductor().getIdConductor() : null);

            if (idConductor != null) {
                Conductor conductor = conductorRepository.findById(idConductor)
                        .orElseThrow(() -> new IllegalArgumentException("Conductor no encontrado"));

                // Validación estricta de licencia
                if (conductor.getVencimientoLicencia().isBefore(LocalDate.now())) {
                    throw new BusinessValidationException(
                            "Regla COIL: No se puede asignar el viaje. La licencia de conducir del chofer " 
                            + conductor.getNombreCompleto() + " está vencida (" + conductor.getVencimientoLicencia() + ")."
                    );
                }

                if ("Suspendido".equalsIgnoreCase(conductor.getEstado())) {
                    throw new BusinessValidationException(
                            "Regla COIL: El conductor " + conductor.getNombreCompleto() + " está Suspendido."
                    );
                }

                viaje.setConductor(conductor);
                conductor.setEstado("Ocupado");
                conductorRepository.save(conductor);

                // Asignar o validar vehículo
                Optional<Vehiculo> vehiculoOpt = vehiculoRepository.findByConductor_IdConductor(conductor.getIdConductor());
                if (vehiculoOpt.isPresent()) {
                    Vehiculo veh = vehiculoOpt.get();
                    if (veh.getVencimientoSeguro().isBefore(LocalDate.now())) {
                        throw new BusinessValidationException(
                                "Regla COIL: El seguro vehicular (SOAT) del auto " + veh.getPlaca() 
                                + " está vencido (" + veh.getVencimientoSeguro() + "). No puede operar."
                        );
                    }
                    viaje.setVehiculo(veh);
                }
            }
        }

        if ("En Curso".equalsIgnoreCase(nuevoEstado)) {
            viaje.setFechaInicio(LocalDateTime.now());
            if (viaje.getConductor() != null) {
                viaje.getConductor().setEstado("Ocupado");
            }
        } else if ("Finalizado".equalsIgnoreCase(nuevoEstado)) {
            viaje.setFechaFin(LocalDateTime.now());
            if (viaje.getConductor() != null) {
                viaje.getConductor().setEstado("Disponible");
                conductorRepository.save(viaje.getConductor());
            }

            // Generar pago automáticamente si no existe (15% comisión)
            if (pagoRepository.findByViaje_IdViaje(viaje.getIdViaje()).isEmpty()) {
                BigDecimal comision = viaje.getTarifaTotal().multiply(new BigDecimal("0.15")).setScale(2, RoundingMode.HALF_UP);
                MetodoPago metodo = metodoPagoRepository.findByPasajero_IdPasajeroAndPredeterminadoTrue(viaje.getPasajero().getIdPasajero())
                        .orElse(null);

                Pago pago = new Pago();
                pago.setViaje(viaje);
                pago.setMetodoPago(metodo);
                pago.setMonto(viaje.getTarifaTotal());
                pago.setMoneda(viaje.getMoneda());
                pago.setFechaPago(LocalDateTime.now());
                pago.setEstado("Completado");
                pago.setComisionPlataforma(comision);
                pagoRepository.save(pago);
            }
        } else if ("Cancelado".equalsIgnoreCase(nuevoEstado)) {
            if (viaje.getConductor() != null) {
                viaje.getConductor().setEstado("Disponible");
                conductorRepository.save(viaje.getConductor());
            }
        }

        viaje.setEstadoViaje(estadoObj);
        Viaje actualizado = viajeRepository.save(viaje);

        // Guardar trazabilidad inmutable
        historialRepository.save(new HistorialEstadoViaje(actualizado, estadoAnterior, nuevoEstado));

        return actualizado;
    }

    public Calificacion calificarViaje(Integer idViaje, CalificarViajeRequest req) {
        Viaje viaje = viajeRepository.findById(idViaje)
                .orElseThrow(() -> new IllegalArgumentException("Viaje no encontrado"));

        if (req.getPuntaje() == null || req.getPuntaje() < 1 || req.getPuntaje() > 5) {
            throw new BusinessValidationException("El puntaje debe ser un valor entero entre 1 y 5 estrellas.");
        }

        Calificacion cal = new Calificacion();
        cal.setViaje(viaje);
        cal.setPuntaje(req.getPuntaje());
        cal.setComentario(req.getComentario());
        cal.setTipoCalificador(req.getTipoCalificador() != null ? req.getTipoCalificador() : "Pasajero");
        cal.setFechaCalificacion(LocalDateTime.now());

        return calificacionRepository.save(cal);
    }

    @Transactional(readOnly = true)
    public List<Viaje> listarPendientes(Integer idPais) {
        if (idPais != null) {
            return viajeRepository.findViajesPendientesPorPais(idPais);
        }
        return viajeRepository.findByEstadoViaje_NombreEstado("Solicitado");
    }

    @Transactional(readOnly = true)
    public List<Viaje> listarPorPasajero(Integer idPasajero) {
        return viajeRepository.findByPasajero_IdPasajeroOrderByFechaSolicitudDesc(idPasajero);
    }

    @Transactional(readOnly = true)
    public List<Viaje> listarPorConductor(Integer idConductor) {
        return viajeRepository.findByConductor_IdConductorOrderByFechaSolicitudDesc(idConductor);
    }

    @Transactional(readOnly = true)
    public Optional<Viaje> buscarPorId(Integer idViaje) {
        return viajeRepository.findById(idViaje);
    }
}
