package com.rutaandina.repository;

import com.rutaandina.model.Viaje;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ViajeRepository extends JpaRepository<Viaje, Integer> {
    List<Viaje> findByPasajero_IdPasajeroOrderByFechaSolicitudDesc(Integer idPasajero);
    List<Viaje> findByConductor_IdConductorOrderByFechaSolicitudDesc(Integer idConductor);
    List<Viaje> findByEstadoViaje_NombreEstado(String nombreEstado);
    List<Viaje> findByEstadoViaje_NombreEstadoAndPais_IdPais(String nombreEstado, Integer idPais);

    @Query("SELECT v FROM Viaje v WHERE v.estadoViaje.nombreEstado = 'Solicitado' AND v.pais.idPais = :idPais ORDER BY v.fechaSolicitud DESC")
    List<Viaje> findViajesPendientesPorPais(@Param("idPais") Integer idPais);

    @Query("SELECT v FROM Viaje v JOIN EmpleadoEmpresa ee ON v.pasajero.idPasajero = ee.pasajero.idPasajero WHERE ee.empresa.idEmpresa = :idEmpresa AND v.esCorporativo = true ORDER BY v.fechaSolicitud DESC")
    List<Viaje> findViajesPorEmpresaCorporativa(@Param("idEmpresa") Integer idEmpresa);
}
