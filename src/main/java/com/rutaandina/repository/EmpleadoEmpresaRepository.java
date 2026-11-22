package com.rutaandina.repository;

import com.rutaandina.model.EmpleadoEmpresa;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface EmpleadoEmpresaRepository extends JpaRepository<EmpleadoEmpresa, Integer> {
    List<EmpleadoEmpresa> findByEmpresa_IdEmpresa(Integer idEmpresa);
    Optional<EmpleadoEmpresa> findByPasajero_IdPasajeroAndActivoTrue(Integer idPasajero);
}
