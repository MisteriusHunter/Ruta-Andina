package com.rutaandina.repository;

import com.rutaandina.model.Pasajero;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface PasajeroRepository extends JpaRepository<Pasajero, Integer> {
    Optional<Pasajero> findByCorreo(String correo);
    List<Pasajero> findByPais_IdPais(Integer idPais);
}
