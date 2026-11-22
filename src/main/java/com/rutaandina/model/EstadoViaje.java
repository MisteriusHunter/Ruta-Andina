package com.rutaandina.model;

import jakarta.persistence.*;
import java.io.Serializable;

@Entity
@Table(name = "estado_viaje")
public class EstadoViaje implements Serializable {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_estado")
    private Integer idEstado;

    @Column(name = "nombre_estado", nullable = false, unique = true, length = 30)
    private String nombreEstado; // Solicitado, Aceptado, En Curso, Finalizado, Cancelado

    @Column(name = "descripcion", length = 150)
    private String descripcion;

    public EstadoViaje() {}

    public EstadoViaje(Integer idEstado, String nombreEstado, String descripcion) {
        this.idEstado = idEstado;
        this.nombreEstado = nombreEstado;
        this.descripcion = descripcion;
    }

    public Integer getIdEstado() { return idEstado; }
    public void setIdEstado(Integer idEstado) { this.idEstado = idEstado; }

    public String getNombreEstado() { return nombreEstado; }
    public void setNombreEstado(String nombreEstado) { this.nombreEstado = nombreEstado; }

    public String getDescripcion() { return descripcion; }
    public void setDescripcion(String descripcion) { this.descripcion = descripcion; }
}
