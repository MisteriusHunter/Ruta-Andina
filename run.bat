@echo off
chcp 65001 > nul
echo =====================================================================
echo   RUTA ANDINA — Plataforma Binacional de Movilidad (COIL 2026)
echo   TECSUP (Peru) ^& Politecnico Grancolombiano (Colombia)
echo =====================================================================
echo.

if exist "C:\Program Files\Java\jdk-25.0.2" (
    set "JAVA_HOME=C:\Program Files\Java\jdk-25.0.2"
)

set "MAVEN_CMD=mvn"
if exist "C:\Program Files\Apache NetBeans\java\maven\bin\mvn.cmd" (
    set "MAVEN_CMD=C:\Program Files\Apache NetBeans\java\maven\bin\mvn.cmd"
)

echo [1/2] Verificando entorno Java y Maven...
echo JAVA_HOME: %JAVA_HOME%
echo.

echo [2/2] Iniciando aplicacion Spring Boot en puerto 8080...
echo.
"%MAVEN_CMD%" spring-boot:run

pause
