package com.rutaandina.dto;

import java.math.BigDecimal;

public class SolicitarViajeRequest {
    private Integer idPasajero;
    private Integer idTipoServicio;
    private Integer idPais;
    private Boolean esCorporativo = false;
    private String origen;
    private String destino;
    private BigDecimal distanciaKm;
    private BigDecimal tarifaTotal;
    private String moneda;
    private Integer idMetodoPago;

    public SolicitarViajeRequest() {}

    public Integer getIdPasajero() { return idPasajero; }
    public void setIdPasajero(Integer idPasajero) { this.idPasajero = idPasajero; }

    public Integer getIdTipoServicio() { return idTipoServicio; }
    public void setIdTipoServicio(Integer idTipoServicio) { this.idTipoServicio = idTipoServicio; }

    public Integer getIdPais() { return idPais; }
    public void setIdPais(Integer idPais) { this.idPais = idPais; }

    public Boolean getEsCorporativo() { return esCorporativo; }
    public void setEsCorporativo(Boolean esCorporativo) { this.esCorporativo = esCorporativo; }

    public String getOrigen() { return origen; }
    public void setOrigen(String origen) { this.origen = origen; }

    public String getDestino() { return destino; }
    public void setDestino(String destino) { this.destino = destino; }

    public BigDecimal getDistanciaKm() { return distanciaKm; }
    public void setDistanciaKm(BigDecimal distanciaKm) { this.distanciaKm = distanciaKm; }

    public BigDecimal getTarifaTotal() { return tarifaTotal; }
    public void setTarifaTotal(BigDecimal tarifaTotal) { this.tarifaTotal = tarifaTotal; }

    public String getMoneda() { return moneda; }
    public void setMoneda(String moneda) { this.moneda = moneda; }

    public Integer getIdMetodoPago() { return idMetodoPago; }
    public void setIdMetodoPago(Integer idMetodoPago) { this.idMetodoPago = idMetodoPago; }
}
