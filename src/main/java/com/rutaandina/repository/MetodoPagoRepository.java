package com.rutaandina.repository;

import com.rutaandina.model.MetodoPago;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface MetodoPagoRepository extends JpaRepository<MetodoPago, Integer> {
    List<MetodoPago> findByPasajero_IdPasajeroAndActivoTrue(Integer idPasajero);
    Optional<MetodoPago> findByPasajero_IdPasajeroAndPredeterminadoTrue(Integer idPasajero);
}
