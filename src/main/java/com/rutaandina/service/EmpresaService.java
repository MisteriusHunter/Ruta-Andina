package com.rutaandina.service;

import com.rutaandina.dto.DashboardKpiDto;
import com.rutaandina.model.Empresa;
import com.rutaandina.model.Viaje;
import com.rutaandina.repository.EmpleadoEmpresaRepository;
import com.rutaandina.repository.EmpresaRepository;
import com.rutaandina.repository.ViajeRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

@Service
@Transactional(readOnly = true)
public class EmpresaService {

    private final EmpresaRepository empresaRepository;
    private final EmpleadoEmpresaRepository empleadoEmpresaRepository;
    private final ViajeRepository viajeRepository;

    public EmpresaService(EmpresaRepository empresaRepository,
                          EmpleadoEmpresaRepository empleadoEmpresaRepository,
                          ViajeRepository viajeRepository) {
        this.empresaRepository = empresaRepository;
        this.empleadoEmpresaRepository = empleadoEmpresaRepository;
        this.viajeRepository = viajeRepository;
    }

    public List<Empresa> listarClientesCorporativos() {
        return empresaRepository.findByTipoEmpresa("Cliente_Corporativo");
    }

    public List<Empresa> listarTodas() {
        return empresaRepository.findAll();
    }

    public Optional<Empresa> buscarPorId(Integer idEmpresa) {
        return empresaRepository.findById(idEmpresa);
    }

    public List<Viaje> listarViajesCorporativos(Integer idEmpresa) {
        return viajeRepository.findViajesPorEmpresaCorporativa(idEmpresa);
    }

    public DashboardKpiDto obtenerKpisCorporativos(Integer idEmpresa) {
        Empresa empresa = empresaRepository.findById(idEmpresa)
                .orElseThrow(() -> new IllegalArgumentException("Empresa no encontrada"));

        List<Viaje> viajes = viajeRepository.findViajesPorEmpresaCorporativa(idEmpresa);
        long empleadosActivos = empleadoEmpresaRepository.findByEmpresa_IdEmpresa(idEmpresa).stream()
                .filter(e -> Boolean.TRUE.equals(e.getActivo()))
                .count();

        BigDecimal gastoTotal = BigDecimal.ZERO;
        Map<String, Long> porServicio = new HashMap<>();

        for (Viaje v : viajes) {
            if ("Finalizado".equalsIgnoreCase(v.getEstadoViaje().getNombreEstado())) {
                gastoTotal = gastoTotal.add(v.getTarifaTotal());
            }
            String srv = v.getTipoServicio().getNombreServicio();
            porServicio.put(srv, porServicio.getOrDefault(srv, 0L) + 1L);
        }

        long totalViajes = viajes.size();
        BigDecimal ticketPromedio = totalViajes > 0
                ? gastoTotal.divide(BigDecimal.valueOf(totalViajes), 2, RoundingMode.HALF_UP)
                : BigDecimal.ZERO;

        // Ahorro corporativo estimado negociado: 12% vs tarifas públicas regulares
        BigDecimal ahorro = gastoTotal.multiply(new BigDecimal("0.12")).setScale(2, RoundingMode.HALF_UP);

        DashboardKpiDto kpi = new DashboardKpiDto();
        kpi.setEmpresaNombre(empresa.getRazonSocial());
        kpi.setPais(empresa.getPais().getNombrePais());
        kpi.setMoneda(empresa.getPais().getMoneda());
        kpi.setGastoTotalMes(gastoTotal);
        kpi.setTotalViajes(totalViajes);
        kpi.setTicketPromedio(ticketPromedio);
        kpi.setAhorroEstimadoCorporativo(ahorro);
        kpi.setEmpleadosActivos(empleadosActivos);
        kpi.setViajesPorServicio(porServicio);

        return kpi;
    }
}
