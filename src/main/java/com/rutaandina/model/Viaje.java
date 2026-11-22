package com.rutaandina.model;

import jakarta.persistence.*;
import java.io.Serializable;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Entity
@Table(name = "viaje")
public class Viaje implements Serializable {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_viaje")
    private Integer idViaje;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "id_pasajero", nullable = false)
    private Pasajero pasajero;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "id_conductor")
    private Conductor conductor;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "id_vehiculo")
    private Vehiculo vehiculo;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "id_tipo_servicio", nullable = false)
    private TipoServicio tipoServicio;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "id_estado", nullable = false)
    private EstadoViaje estadoViaje;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "id_pais", nullable = false)
    private Pais pais;

    @Column(name = "es_corporativo", nullable = false)
    private Boolean esCorporativo = false;

    @Column(name = "origen", nullable = false, length = 255)
    private String origen;

    @Column(name = "destino", nullable = false, length = 255)
    private String destino;

    @Column(name = "fecha_solicitud", nullable = false)
    private LocalDateTime fechaSolicitud = LocalDateTime.now();

    @Column(name = "fecha_inicio")
    private LocalDateTime fechaInicio;

    @Column(name = "fecha_fin")
    private LocalDateTime fechaFin;

    @Column(name = "distancia_km", nullable = false, precision = 8, scale = 2)
    private BigDecimal distanciaKm;

    @Column(name = "tarifa_total", nullable = false, precision = 10, scale = 2)
    private BigDecimal tarifaTotal;

    @Column(name = "moneda", nullable = false, length = 3)
    private String moneda; // 'PEN' o 'COP'

    public Viaje() {}

    public Integer getIdViaje() { return idViaje; }
    public void setIdViaje(Integer idViaje) { this.idViaje = idViaje; }

    public Pasajero getPasajero() { return pasajero; }
    public void setPasajero(Pasajero pasajero) { this.pasajero = pasajero; }

    public Conductor getConductor() { return conductor; }
    public void setConductor(Conductor conductor) { this.conductor = conductor; }

    public Vehiculo getVehiculo() { return vehiculo; }
    public void setVehiculo(Vehiculo vehiculo) { this.vehiculo = vehiculo; }

    public TipoServicio getTipoServicio() { return tipoServicio; }
    public void setTipoServicio(TipoServicio tipoServicio) { this.tipoServicio = tipoServicio; }

    public EstadoViaje getEstadoViaje() { return estadoViaje; }
    public void setEstadoViaje(EstadoViaje estadoViaje) { this.estadoViaje = estadoViaje; }

    public Pais getPais() { return pais; }
    public void setPais(Pais pais) { this.pais = pais; }

    public Boolean getEsCorporativo() { return esCorporativo; }
    public void setEsCorporativo(Boolean esCorporativo) { this.esCorporativo = esCorporativo; }

    public String getOrigen() { return origen; }
    public void setOrigen(String origen) { this.origen = origen; }

    public String getDestino() { return destino; }
    public void setDestino(String destino) { this.destino = destino; }

    public LocalDateTime getFechaSolicitud() { return fechaSolicitud; }
    public void setFechaSolicitud(LocalDateTime fechaSolicitud) { this.fechaSolicitud = fechaSolicitud; }

    public LocalDateTime getFechaInicio() { return fechaInicio; }
    public void setFechaInicio(LocalDateTime fechaInicio) { this.fechaInicio = fechaInicio; }

    public LocalDateTime getFechaFin() { return fechaFin; }
    public void setFechaFin(LocalDateTime fechaFin) { this.fechaFin = fechaFin; }

    public BigDecimal getDistanciaKm() { return distanciaKm; }
    public void setDistanciaKm(BigDecimal distanciaKm) { this.distanciaKm = distanciaKm; }

    public BigDecimal getTarifaTotal() { return tarifaTotal; }
    public void setTarifaTotal(BigDecimal tarifaTotal) { this.tarifaTotal = tarifaTotal; }

    public String getMoneda() { return moneda; }
    public void setMoneda(String moneda) { this.moneda = moneda; }
}
