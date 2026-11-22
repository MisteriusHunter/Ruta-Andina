package com.rutaandina;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class RutaAndinaApplication {
    public static void main(String[] args) {
        SpringApplication.run(RutaAndinaApplication.class, args);
        System.out.println("==================================================================");
        System.out.println("  RUTA ANDINA (Lima & Medellín) - COIL 2026 INICIADO CORRECTAMENTE  ");
        System.out.println("  Accede a la interfaz web en: http://localhost:8080/             ");
        System.out.println("==================================================================");
    }
}
