package com.rutaandina.dto;

public class CalificarViajeRequest {
    private Integer puntaje; // 1 a 5
    private String comentario;
    private String tipoCalificador = "Pasajero"; // 'Pasajero' o 'Conductor'

    public CalificarViajeRequest() {}

    public Integer getPuntaje() { return puntaje; }
    public void setPuntaje(Integer puntaje) { this.puntaje = puntaje; }

    public String getComentario() { return comentario; }
    public void setComentario(String comentario) { this.comentario = comentario; }

    public String getTipoCalificador() { return tipoCalificador; }
    public void setTipoCalificador(String tipoCalificador) { this.tipoCalificador = tipoCalificador; }
}
