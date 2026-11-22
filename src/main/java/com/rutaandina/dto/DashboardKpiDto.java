package com.rutaandina.dto;

import java.math.BigDecimal;
import java.util.Map;

public class DashboardKpiDto {
    private String empresaNombre;
    private String pais;
    private String moneda;
    private BigDecimal gastoTotalMes;
    private Long totalViajes;
    private BigDecimal ticketPromedio;
    private BigDecimal ahorroEstimadoCorporativo;
    private Long empleadosActivos;
    private Map<String, Long> viajesPorServicio;

    public DashboardKpiDto() {}

    public String getEmpresaNombre() { return empresaNombre; }
    public void setEmpresaNombre(String empresaNombre) { this.empresaNombre = empresaNombre; }

    public String getPais() { return pais; }
    public void setPais(String pais) { this.pais = pais; }

    public String getMoneda() { return moneda; }
    public void setMoneda(String moneda) { this.moneda = moneda; }

    public BigDecimal getGastoTotalMes() { return gastoTotalMes; }
    public void setGastoTotalMes(BigDecimal gastoTotalMes) { this.gastoTotalMes = gastoTotalMes; }

    public Long getTotalViajes() { return totalViajes; }
    public void setTotalViajes(Long totalViajes) { this.totalViajes = totalViajes; }

    public BigDecimal getTicketPromedio() { return ticketPromedio; }
    public void setTicketPromedio(BigDecimal ticketPromedio) { this.ticketPromedio = ticketPromedio; }

    public BigDecimal getAhorroEstimadoCorporativo() { return ahorroEstimadoCorporativo; }
    public void setAhorroEstimadoCorporativo(BigDecimal ahorroEstimadoCorporativo) { this.ahorroEstimadoCorporativo = ahorroEstimadoCorporativo; }

    public Long getEmpleadosActivos() { return empleadosActivos; }
    public void setEmpleadosActivos(Long empleadosActivos) { this.empleadosActivos = empleadosActivos; }

    public Map<String, Long> getViajesPorServicio() { return viajesPorServicio; }
    public void setViajesPorServicio(Map<String, Long> viajesPorServicio) { this.viajesPorServicio = viajesPorServicio; }
}
