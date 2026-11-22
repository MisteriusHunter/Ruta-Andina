package com.rutaandina.dto;

import java.math.BigDecimal;

public class CotizacionResponse {
    private Integer idTipoServicio;
    private String nombreServicio;
    private BigDecimal distanciaKm;
    private Integer tiempoEstimadoMinutos;
    private BigDecimal tarifaBase;
    private BigDecimal tarifaKm;
    private BigDecimal subtotal;
    private BigDecimal comisionPlataforma;
    private BigDecimal tarifaTotal;
    private String moneda;
    private String simboloMoneda;

    public CotizacionResponse() {}

    public Integer getIdTipoServicio() { return idTipoServicio; }
    public void setIdTipoServicio(Integer idTipoServicio) { this.idTipoServicio = idTipoServicio; }

    public String getNombreServicio() { return nombreServicio; }
    public void setNombreServicio(String nombreServicio) { this.nombreServicio = nombreServicio; }

    public BigDecimal getDistanciaKm() { return distanciaKm; }
    public void setDistanciaKm(BigDecimal distanciaKm) { this.distanciaKm = distanciaKm; }

    public Integer getTiempoEstimadoMinutos() { return tiempoEstimadoMinutos; }
    public void setTiempoEstimadoMinutos(Integer tiempoEstimadoMinutos) { this.tiempoEstimadoMinutos = tiempoEstimadoMinutos; }

    public BigDecimal getTarifaBase() { return tarifaBase; }
    public void setTarifaBase(BigDecimal tarifaBase) { this.tarifaBase = tarifaBase; }

    public BigDecimal getTarifaKm() { return tarifaKm; }
    public void setTarifaKm(BigDecimal tarifaKm) { this.tarifaKm = tarifaKm; }

    public BigDecimal getSubtotal() { return subtotal; }
    public void setSubtotal(BigDecimal subtotal) { this.subtotal = subtotal; }

    public BigDecimal getComisionPlataforma() { return comisionPlataforma; }
    public void setComisionPlataforma(BigDecimal comisionPlataforma) { this.comisionPlataforma = comisionPlataforma; }

    public BigDecimal getTarifaTotal() { return tarifaTotal; }
    public void setTarifaTotal(BigDecimal tarifaTotal) { this.tarifaTotal = tarifaTotal; }

    public String getMoneda() { return moneda; }
    public void setMoneda(String moneda) { this.moneda = moneda; }

    public String getSimboloMoneda() { return simboloMoneda; }
    public void setSimboloMoneda(String simboloMoneda) { this.simboloMoneda = simboloMoneda; }
}
