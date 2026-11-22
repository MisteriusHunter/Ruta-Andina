package com.rutaandina.repository;

import com.rutaandina.model.Pais;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface PaisRepository extends JpaRepository<Pais, Integer> {
    Optional<Pais> findByMoneda(String moneda);
    Optional<Pais> findByCodigoIso(String codigoIso);
}
