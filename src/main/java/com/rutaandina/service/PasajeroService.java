package com.rutaandina.service;

import com.rutaandina.model.DireccionFavorita;
import com.rutaandina.model.MetodoPago;
import com.rutaandina.model.Pasajero;
import com.rutaandina.repository.DireccionFavoritaRepository;
import com.rutaandina.repository.MetodoPagoRepository;
import com.rutaandina.repository.PasajeroRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Service
@Transactional(readOnly = true)
public class PasajeroService {

    private final PasajeroRepository pasajeroRepository;
    private final MetodoPagoRepository metodoPagoRepository;
    private final DireccionFavoritaRepository direccionFavoritaRepository;

    public PasajeroService(PasajeroRepository pasajeroRepository,
                           MetodoPagoRepository metodoPagoRepository,
                           DireccionFavoritaRepository direccionFavoritaRepository) {
        this.pasajeroRepository = pasajeroRepository;
        this.metodoPagoRepository = metodoPagoRepository;
        this.direccionFavoritaRepository = direccionFavoritaRepository;
    }

    public List<Pasajero> listarTodos() {
        return pasajeroRepository.findAll();
    }

    public List<Pasajero> listarPorPais(Integer idPais) {
        return pasajeroRepository.findByPais_IdPais(idPais);
    }

    public Optional<Pasajero> buscarPorId(Integer idPasajero) {
        return pasajeroRepository.findById(idPasajero);
    }

    public List<MetodoPago> listarMetodosPago(Integer idPasajero) {
        return metodoPagoRepository.findByPasajero_IdPasajeroAndActivoTrue(idPasajero);
    }

    public List<DireccionFavorita> listarDireccionesFavoritas(Integer idPasajero) {
        return direccionFavoritaRepository.findByPasajero_IdPasajero(idPasajero);
    }
}
