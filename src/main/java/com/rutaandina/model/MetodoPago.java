package com.rutaandina.model;

import jakarta.persistence.*;
import java.io.Serializable;

@Entity
@Table(name = "metodo_pago")
public class MetodoPago implements Serializable {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_metodo_pago")
    private Integer idMetodoPago;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_pasajero", nullable = false)
    private Pasajero pasajero;

    @Column(name = "tipo_metodo", nullable = false, length = 50)
    private String tipoMetodo; // Tarjeta_Credito, Tarjeta_Debito, Efectivo, Cuenta_Corporativa, Billetera_Digital

    @Column(name = "numero_referencia", nullable = false, length = 50)
    private String numeroReferencia;

    @Column(name = "titular", nullable = false, length = 120)
    private String titular;

    @Column(name = "predeterminado", nullable = false)
    private Boolean predeterminado = false;

    @Column(name = "activo", nullable = false)
    private Boolean activo = true;

    public MetodoPago() {}

    public Integer getIdMetodoPago() { return idMetodoPago; }
    public void setIdMetodoPago(Integer idMetodoPago) { this.idMetodoPago = idMetodoPago; }

    public Pasajero getPasajero() { return pasajero; }
    public void setPasajero(Pasajero pasajero) { this.pasajero = pasajero; }

    public String getTipoMetodo() { return tipoMetodo; }
    public void setTipoMetodo(String tipoMetodo) { this.tipoMetodo = tipoMetodo; }

    public String getNumeroReferencia() { return numeroReferencia; }
    public void setNumeroReferencia(String numeroReferencia) { this.numeroReferencia = numeroReferencia; }

    public String getTitular() { return titular; }
    public void setTitular(String titular) { this.titular = titular; }

    public Boolean getPredeterminado() { return predeterminado; }
    public void setPredeterminado(Boolean predeterminado) { this.predeterminado = predeterminado; }

    public Boolean getActivo() { return activo; }
    public void setActivo(Boolean activo) { this.activo = activo; }
}
