package com.rutaandina.repository;

import com.rutaandina.model.DireccionFavorita;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface DireccionFavoritaRepository extends JpaRepository<DireccionFavorita, Integer> {
    List<DireccionFavorita> findByPasajero_IdPasajero(Integer idPasajero);
}
