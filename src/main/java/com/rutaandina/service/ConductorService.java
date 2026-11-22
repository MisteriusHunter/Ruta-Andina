package com.rutaandina.service;

import com.rutaandina.model.Conductor;
import com.rutaandina.model.Vehiculo;
import com.rutaandina.repository.ConductorRepository;
import com.rutaandina.repository.VehiculoRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

@Service
@Transactional(readOnly = true)
public class ConductorService {

    private final ConductorRepository conductorRepository;
    private final VehiculoRepository vehiculoRepository;

    public ConductorService(ConductorRepository conductorRepository,
                            VehiculoRepository vehiculoRepository) {
        this.conductorRepository = conductorRepository;
        this.vehiculoRepository = vehiculoRepository;
    }

    public List<Conductor> listarTodos() {
        return conductorRepository.findAll();
    }

    public List<Conductor> listarPorPais(Integer idPais) {
        return conductorRepository.findByPais_IdPais(idPais);
    }

    public Optional<Conductor> buscarPorId(Integer idConductor) {
        return conductorRepository.findById(idConductor);
    }

    public Optional<Vehiculo> obtenerVehiculoDeConductor(Integer idConductor) {
        return vehiculoRepository.findByConductor_IdConductor(idConductor);
    }

    public Map<String, Object> obtenerEstadoDocumentos(Integer idConductor) {
        Conductor conductor = conductorRepository.findById(idConductor)
                .orElseThrow(() -> new IllegalArgumentException("Conductor no encontrado"));
        
        Optional<Vehiculo> vehiculoOpt = vehiculoRepository.findByConductor_IdConductor(idConductor);

        Map<String, Object> res = new HashMap<>();
        res.put("conductor", conductor);
        res.put("diasLicencia", conductor.getDiasParaVencerLicencia());
        res.put("licenciaVencida", conductor.isLicenciaVencida());
        res.put("licenciaAlerta30Dias", conductor.getDiasParaVencerLicencia() <= 30 && conductor.getDiasParaVencerLicencia() > 0);

        if (vehiculoOpt.isPresent()) {
            Vehiculo vehiculo = vehiculoOpt.get();
            res.put("vehiculo", vehiculo);
            res.put("diasSeguro", vehiculo.getDiasParaVencerSeguro());
            res.put("seguroVencido", vehiculo.isSeguroVencido());
            res.put("seguroAlerta30Dias", vehiculo.getDiasParaVencerSeguro() <= 30 && vehiculo.getDiasParaVencerSeguro() > 0);
        } else {
            res.put("vehiculo", null);
            res.put("diasSeguro", 0);
            res.put("seguroVencido", false);
            res.put("seguroAlerta30Dias", false);
        }

        return res;
    }
}
