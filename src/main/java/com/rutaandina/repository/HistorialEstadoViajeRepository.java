package com.rutaandina.repository;

import com.rutaandina.model.HistorialEstadoViaje;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface HistorialEstadoViajeRepository extends JpaRepository<HistorialEstadoViaje, Integer> {
    List<HistorialEstadoViaje> findByViaje_IdViajeOrderByFechaCambioAsc(Integer idViaje);
}
