package com.rutaandina.dto;

public class ActualizarEstadoRequest {
    private String nuevoEstado; // 'Aceptado', 'En Curso', 'Finalizado', 'Cancelado'
    private Integer idConductor;
    private Integer idVehiculo;

    public ActualizarEstadoRequest() {}

    public String getNuevoEstado() { return nuevoEstado; }
    public void setNuevoEstado(String nuevoEstado) { this.nuevoEstado = nuevoEstado; }

    public Integer getIdConductor() { return idConductor; }
    public void setIdConductor(Integer idConductor) { this.idConductor = idConductor; }

    public Integer getIdVehiculo() { return idVehiculo; }
    public void setIdVehiculo(Integer idVehiculo) { this.idVehiculo = idVehiculo; }
}
