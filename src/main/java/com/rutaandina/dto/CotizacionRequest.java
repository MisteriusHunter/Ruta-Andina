package com.rutaandina.dto;

import java.math.BigDecimal;

public class CotizacionRequest {
    private Integer idTipoServicio;
    private String origen;
    private String destino;
    private BigDecimal distanciaKm;
    private String moneda; // 'PEN' o 'COP'

    public CotizacionRequest() {}

    public Integer getIdTipoServicio() { return idTipoServicio; }
    public void setIdTipoServicio(Integer idTipoServicio) { this.idTipoServicio = idTipoServicio; }

    public String getOrigen() { return origen; }
    public void setOrigen(String origen) { this.origen = origen; }

    public String getDestino() { return destino; }
    public void setDestino(String destino) { this.destino = destino; }

    public BigDecimal getDistanciaKm() { return distanciaKm; }
    public void setDistanciaKm(BigDecimal distanciaKm) { this.distanciaKm = distanciaKm; }

    public String getMoneda() { return moneda; }
    public void setMoneda(String moneda) { this.moneda = moneda; }
}
