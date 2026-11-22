package com.rutaandina.model;

import jakarta.persistence.*;
import java.io.Serializable;
import java.time.LocalDate;

@Entity
@Table(name = "vehiculo")
public class Vehiculo implements Serializable {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_vehiculo")
    private Integer idVehiculo;

    @OneToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "id_conductor", nullable = false)
    private Conductor conductor;

    @Column(name = "placa", nullable = false, unique = true, length = 15)
    private String placa;

    @Column(name = "marca", nullable = false, length = 50)
    private String marca;

    @Column(name = "modelo", nullable = false, length = 50)
    private String modelo;

    @Column(name = "anio", nullable = false)
    private Integer anio;

    @Column(name = "color", nullable = false, length = 30)
    private String color;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "id_tipo_servicio", nullable = false)
    private TipoServicio tipoServicio;

    @Column(name = "seguro", nullable = false, length = 50)
    private String seguro;

    @Column(name = "vencimiento_seguro", nullable = false)
    private LocalDate vencimientoSeguro;

    @Column(name = "estado", nullable = false, length = 20)
    private String estado = "Activo"; // Activo, Mantenimiento, Inactivo

    public Vehiculo() {}

    public Integer getIdVehiculo() { return idVehiculo; }
    public void setIdVehiculo(Integer idVehiculo) { this.idVehiculo = idVehiculo; }

    public Conductor getConductor() { return conductor; }
    public void setConductor(Conductor conductor) { this.conductor = conductor; }

    public String getPlaca() { return placa; }
    public void setPlaca(String placa) { this.placa = placa; }

    public String getMarca() { return marca; }
    public void setMarca(String marca) { this.marca = marca; }

    public String getModelo() { return modelo; }
    public void setModelo(String modelo) { this.modelo = modelo; }

    public String getDescripcionVehiculo() { return marca + " " + modelo + " (" + anio + ")"; }

    public Integer getAnio() { return anio; }
    public void setAnio(Integer anio) { this.anio = anio; }

    public String getColor() { return color; }
    public void setColor(String color) { this.color = color; }

    public TipoServicio getTipoServicio() { return tipoServicio; }
    public void setTipoServicio(TipoServicio tipoServicio) { this.tipoServicio = tipoServicio; }

    public String getSeguro() { return seguro; }
    public void setSeguro(String seguro) { this.seguro = seguro; }

    public LocalDate getVencimientoSeguro() { return vencimientoSeguro; }
    public void setVencimientoSeguro(LocalDate vencimientoSeguro) { this.vencimientoSeguro = vencimientoSeguro; }

    public String getEstado() { return estado; }
    public void setEstado(String estado) { this.estado = estado; }

    public boolean isSeguroVencido() {
        return vencimientoSeguro != null && vencimientoSeguro.isBefore(LocalDate.now());
    }

    public long getDiasParaVencerSeguro() {
        if (vencimientoSeguro == null) return 0;
        return java.time.temporal.ChronoUnit.DAYS.between(LocalDate.now(), vencimientoSeguro);
    }
}
