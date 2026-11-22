package com.rutaandina.repository;

import com.rutaandina.model.Conductor;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface ConductorRepository extends JpaRepository<Conductor, Integer> {
    List<Conductor> findByPais_IdPais(Integer idPais);
    List<Conductor> findByEstado(String estado);
    Optional<Conductor> findByCorreo(String correo);
}
