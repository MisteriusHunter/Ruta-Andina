package com.rutaandina.model;

import jakarta.persistence.*;
import java.io.Serializable;

@Entity
@Table(name = "pais")
public class Pais implements Serializable {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_pais")
    private Integer idPais;

    @Column(name = "nombre_pais", nullable = false, unique = true, length = 60)
    private String nombrePais;

    @Column(name = "moneda", nullable = false, length = 3)
    private String moneda; // 'PEN' o 'COP'

    @Column(name = "codigo_iso", nullable = false, unique = true, length = 2)
    private String codigoIso;

    @Column(name = "prefijo_telefonico", nullable = false, length = 5)
    private String prefijoTelefonico;

    public Pais() {}

    public Pais(Integer idPais, String nombrePais, String moneda, String codigoIso, String prefijoTelefonico) {
        this.idPais = idPais;
        this.nombrePais = nombrePais;
        this.moneda = moneda;
        this.codigoIso = codigoIso;
        this.prefijoTelefonico = prefijoTelefonico;
    }

    public Integer getIdPais() { return idPais; }
    public void setIdPais(Integer idPais) { this.idPais = idPais; }

    public String getNombrePais() { return nombrePais; }
    public void setNombrePais(String nombrePais) { this.nombrePais = nombrePais; }

    public String getMoneda() { return moneda; }
    public void setMoneda(String moneda) { this.moneda = moneda; }

    public String getCodigoIso() { return codigoIso; }
    public void setCodigoIso(String codigoIso) { this.codigoIso = codigoIso; }

    public String getPrefijoTelefonico() { return prefijoTelefonico; }
    public void setPrefijoTelefonico(String prefijoTelefonico) { this.prefijoTelefonico = prefijoTelefonico; }
}
