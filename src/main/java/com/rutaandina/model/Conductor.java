package com.rutaandina.model;

import jakarta.persistence.*;
import java.io.Serializable;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Entity
@Table(name = "conductor")
public class Conductor implements Serializable {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_conductor")
    private Integer idConductor;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "id_empresa_flota")
    private Empresa empresaFlota;

    @Column(name = "nombres", nullable = false, length = 100)
    private String nombres;

    @Column(name = "apellidos", nullable = false, length = 100)
    private String apellidos;

    @Column(name = "tipo_documento", nullable = false, length = 20)
    private String tipoDocumento;

    @Column(name = "numero_documento", nullable = false, unique = true, length = 25)
    private String numeroDocumento;

    @Column(name = "telefono", nullable = false, length = 20)
    private String telefono;

    @Column(name = "correo", nullable = false, unique = true, length = 120)
    private String correo;

    @Column(name = "numero_licencia", nullable = false, unique = true, length = 50)
    private String numeroLicencia;

    @Column(name = "categoria_licencia", nullable = false, length = 20)
    private String categoriaLicencia;

    @Column(name = "vencimiento_licencia", nullable = false)
    private LocalDate vencimientoLicencia;

    @Column(name = "estado", nullable = false, length = 20)
    private String estado = "Disponible"; // Disponible, Ocupado, Inactivo, Suspendido

    @Column(name = "cuenta_pago", nullable = false, length = 50)
    private String cuentaPago;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "id_pais", nullable = false)
    private Pais pais;

    @Column(name = "fecha_registro")
    private LocalDateTime fechaRegistro = LocalDateTime.now();

    public Conductor() {}

    public Integer getIdConductor() { return idConductor; }
    public void setIdConductor(Integer idConductor) { this.idConductor = idConductor; }

    public Empresa getEmpresaFlota() { return empresaFlota; }
    public void setEmpresaFlota(Empresa empresaFlota) { this.empresaFlota = empresaFlota; }

    public String getNombres() { return nombres; }
    public void setNombres(String nombres) { this.nombres = nombres; }

    public String getApellidos() { return apellidos; }
    public void setApellidos(String apellidos) { this.apellidos = apellidos; }

    public String getNombreCompleto() { return nombres + " " + apellidos; }

    public String getTipoDocumento() { return tipoDocumento; }
    public void setTipoDocumento(String tipoDocumento) { this.tipoDocumento = tipoDocumento; }

    public String getNumeroDocumento() { return numeroDocumento; }
    public void setNumeroDocumento(String numeroDocumento) { this.numeroDocumento = numeroDocumento; }

    public String getTelefono() { return telefono; }
    public void setTelefono(String telefono) { this.telefono = telefono; }

    public String getCorreo() { return correo; }
    public void setCorreo(String correo) { this.correo = correo; }

    public String getNumeroLicencia() { return numeroLicencia; }
    public void setNumeroLicencia(String numeroLicencia) { this.numeroLicencia = numeroLicencia; }

    public String getCategoriaLicencia() { return categoriaLicencia; }
    public void setCategoriaLicencia(String categoriaLicencia) { this.categoriaLicencia = categoriaLicencia; }

    public LocalDate getVencimientoLicencia() { return vencimientoLicencia; }
    public void setVencimientoLicencia(LocalDate vencimientoLicencia) { this.vencimientoLicencia = vencimientoLicencia; }

    public String getEstado() { return estado; }
    public void setEstado(String estado) { this.estado = estado; }

    public String getCuentaPago() { return cuentaPago; }
    public void setCuentaPago(String cuentaPago) { this.cuentaPago = cuentaPago; }

    public Pais getPais() { return pais; }
    public void setPais(Pais pais) { this.pais = pais; }

    public LocalDateTime getFechaRegistro() { return fechaRegistro; }
    public void setFechaRegistro(LocalDateTime fechaRegistro) { this.fechaRegistro = fechaRegistro; }

    public boolean isLicenciaVencida() {
        return vencimientoLicencia != null && vencimientoLicencia.isBefore(LocalDate.now());
    }

    public long getDiasParaVencerLicencia() {
        if (vencimientoLicencia == null) return 0;
        return java.time.temporal.ChronoUnit.DAYS.between(LocalDate.now(), vencimientoLicencia);
    }
}
