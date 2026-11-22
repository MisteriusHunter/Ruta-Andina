package com.rutaandina.model;

import jakarta.persistence.*;
import java.io.Serializable;
import java.math.BigDecimal;

@Entity
@Table(name = "tipo_servicio")
public class TipoServicio implements Serializable {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_tipo_servicio")
    private Integer idTipoServicio;

    @Column(name = "nombre_servicio", nullable = false, unique = true, length = 50)
    private String nombreServicio;

    @Column(name = "descripcion", nullable = false, length = 255)
    private String descripcion;

    @Column(name = "tarifa_base", nullable = false, precision = 10, scale = 2)
    private BigDecimal tarifaBase;

    @Column(name = "tarifa_km", nullable = false, precision = 10, scale = 2)
    private BigDecimal tarifaKm;

    @Column(name = "capacidad_pasajeros", nullable = false)
    private Integer capacidadPasajeros = 4;

    @Column(name = "activo", nullable = false)
    private Boolean activo = true;

    public TipoServicio() {}

    public Integer getIdTipoServicio() { return idTipoServicio; }
    public void setIdTipoServicio(Integer idTipoServicio) { this.idTipoServicio = idTipoServicio; }

    public String getNombreServicio() { return nombreServicio; }
    public void setNombreServicio(String nombreServicio) { this.nombreServicio = nombreServicio; }

    public String getDescripcion() { return descripcion; }
    public void setDescripcion(String descripcion) { this.descripcion = descripcion; }

    public BigDecimal getTarifaBase() { return tarifaBase; }
    public void setTarifaBase(BigDecimal tarifaBase) { this.tarifaBase = tarifaBase; }

    public BigDecimal getTarifaKm() { return tarifaKm; }
    public void setTarifaKm(BigDecimal tarifaKm) { this.tarifaKm = tarifaKm; }

    public Integer getCapacidadPasajeros() { return capacidadPasajeros; }
    public void setCapacidadPasajeros(Integer capacidadPasajeros) { this.capacidadPasajeros = capacidadPasajeros; }

    public Boolean getActivo() { return activo; }
    public void setActivo(Boolean activo) { this.activo = activo; }
}
