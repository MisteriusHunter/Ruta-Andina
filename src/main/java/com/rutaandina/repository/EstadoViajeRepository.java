package com.rutaandina.repository;

import com.rutaandina.model.EstadoViaje;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface EstadoViajeRepository extends JpaRepository<EstadoViaje, Integer> {
    Optional<EstadoViaje> findByNombreEstado(String nombreEstado);
}
