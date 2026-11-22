package com.rutaandina.repository;

import com.rutaandina.model.Calificacion;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface CalificacionRepository extends JpaRepository<Calificacion, Integer> {
    List<Calificacion> findByViaje_IdViaje(Integer idViaje);
    Optional<Calificacion> findByViaje_IdViajeAndTipoCalificador(Integer idViaje, String tipoCalificador);
}
