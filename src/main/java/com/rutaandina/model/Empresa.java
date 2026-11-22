package com.rutaandina.model;

import jakarta.persistence.*;
import java.io.Serializable;
import java.time.LocalDateTime;

@Entity
@Table(name = "empresa")
public class Empresa implements Serializable {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_empresa")
    private Integer idEmpresa;

    @Column(name = "ruc_nit", nullable = false, unique = true, length = 20)
    private String rucNit;

    @Column(name = "razon_social", nullable = false, length = 150)
    private String razonSocial;

    @Column(name = "tipo_empresa", nullable = false, length = 30)
    private String tipoEmpresa; // Operadora, Cliente_Corporativo, Flota

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "id_pais", nullable = false)
    private Pais pais;

    @Column(name = "contacto", nullable = false, length = 100)
    private String contacto;

    @Column(name = "correo_contacto", nullable = false, length = 120)
    private String correoContacto;

    @Column(name = "telefono_contacto", nullable = false, length = 25)
    private String telefonoContacto;

    @Column(name = "direccion_fiscal", nullable = false, length = 255)
    private String direccionFiscal;

    @Column(name = "fecha_registro")
    private LocalDateTime fechaRegistro = LocalDateTime.now();

    public Empresa() {}

    public Integer getIdEmpresa() { return idEmpresa; }
    public void setIdEmpresa(Integer idEmpresa) { this.idEmpresa = idEmpresa; }

    public String getRucNit() { return rucNit; }
    public void setRucNit(String rucNit) { this.rucNit = rucNit; }

    public String getRazonSocial() { return razonSocial; }
    public void setRazonSocial(String razonSocial) { this.razonSocial = razonSocial; }

    public String getTipoEmpresa() { return tipoEmpresa; }
    public void setTipoEmpresa(String tipoEmpresa) { this.tipoEmpresa = tipoEmpresa; }

    public Pais getPais() { return pais; }
    public void setPais(Pais pais) { this.pais = pais; }

    public String getContacto() { return contacto; }
    public void setContacto(String contacto) { this.contacto = contacto; }

    public String getCorreoContacto() { return correoContacto; }
    public void setCorreoContacto(String correoContacto) { this.correoContacto = correoContacto; }

    public String getTelefonoContacto() { return telefonoContacto; }
    public void setTelefonoContacto(String telefonoContacto) { this.telefonoContacto = telefonoContacto; }

    public String getDireccionFiscal() { return direccionFiscal; }
    public void setDireccionFiscal(String direccionFiscal) { this.direccionFiscal = direccionFiscal; }

    public LocalDateTime getFechaRegistro() { return fechaRegistro; }
    public void setFechaRegistro(LocalDateTime fechaRegistro) { this.fechaRegistro = fechaRegistro; }
}
