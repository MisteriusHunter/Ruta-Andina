package com.rutaandina.repository;

import com.rutaandina.model.TipoServicio;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface TipoServicioRepository extends JpaRepository<TipoServicio, Integer> {
    List<TipoServicio> findByActivoTrue();
    Optional<TipoServicio> findByNombreServicio(String nombreServicio);
}
