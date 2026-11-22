/**
 * VISTA EMPRESA CORPORATIVA & FLOTAS — Ruta Andina
 * KPIs Financieros, Auditoría de Empleados y Exportación CSV
 */

const CorporateView = {
  currentCompanyId: 3, // BCP Lima por defecto

  companyData: {
    3: {
      id: 3,
      nombre: 'Banco de Crédito del Perú BCP - Corporativo',
      ruc: '20100047218',
      pais: 'Perú',
      moneda: 'PEN',
      gastoTotal: 'S/ 38,420.00',
      totalViajes: 148,
      ahorro: 'S/ 4,610.40',
      empleadosActivos: 42,
      trips: [
        { id: 2, fecha: '2026-10-18 14:10', empleado: 'Rodrigo Quispe Navarro', cargo: 'Gerente Adjunto Finanzas', ruta: 'La Molina ➔ San Isidro', srv: 'Andina Confort', chofer: 'Carlos Mendoza', placa: 'BAP-842', monto: 'S/ 38.30', estado: 'Finalizado' },
        { id: 4, fecha: '2026-11-02 08:15', empleado: 'Diego Alva Centeno', cargo: 'Auditor Senior Riesgos', ruta: 'San Borja ➔ Centro Real', srv: 'Andina Confort', chofer: 'Carlos Mendoza', placa: 'BAP-842', monto: 'S/ 33.02', estado: 'Finalizado' },
        { id: 6, fecha: '2026-11-10 05:30', empleado: 'Camila Ramos Salazar', cargo: 'Subgerente Banca Corp', ruta: 'La Molina ➔ Aeropuerto Callao', srv: 'Andina Confort', chofer: 'Carlos Mendoza', placa: 'BAP-842', monto: 'S/ 73.10', estado: 'Finalizado' },
        { id: 8, fecha: '2026-10-12 18:30', empleado: 'Rodrigo Quispe Navarro', cargo: 'Gerente Adjunto Finanzas', ruta: 'San Isidro ➔ Golf Los Incas', srv: 'Executive Black', chofer: 'Julio César Paredes', placa: 'CFX-195', monto: 'S/ 69.96', estado: 'Finalizado' },
        { id: 9, fecha: '2026-10-20 06:00', empleado: 'Diego Alva Centeno', cargo: 'Auditor Senior Riesgos', ruta: 'Westin Lima ➔ Aeropuerto', srv: 'Executive Black', chofer: 'Julio César Paredes', placa: 'CFX-195', monto: 'S/ 99.60', estado: 'Finalizado' },
        { id: 11, fecha: '2026-11-04 09:00', empleado: 'Rodrigo Quispe Navarro', cargo: 'Gerente Adjunto Finanzas', ruta: 'La Molina ➔ San Isidro', srv: 'Executive Black', chofer: 'Julio César Paredes', placa: 'CFX-195', monto: 'S/ 59.70', estado: 'Finalizado' },
        { id: 20, fecha: '2026-10-14 07:45', empleado: 'Rodrigo Quispe Navarro', cargo: 'Gerente Adjunto Finanzas', ruta: 'La Molina ➔ Convenciones San Borja', srv: 'Van Corporativa', chofer: 'Hernán Soto', placa: 'BKR-308', monto: 'S/ 80.25', estado: 'Finalizado' },
        { id: 22, fecha: '2026-11-06 04:30', empleado: 'Camila Ramos Salazar', cargo: 'Subgerente Banca Corp', ruta: 'Torre BCP ➔ Aeropuerto (Delegación)', srv: 'Van Corporativa', chofer: 'Hernán Soto', placa: 'BKR-308', monto: 'S/ 156.70', estado: 'Finalizado' }
      ]
    },
    4: {
      id: 4,
      nombre: 'Bancolombia S.A. - División Corporativa',
      ruc: '890903938-8',
      pais: 'Colombia',
      moneda: 'COP',
      gastoTotal: '$ 42.850.000',
      totalViajes: 162,
      ahorro: '$ 5.142.000',
      empleadosActivos: 58,
      trips: [
        { id: 28, fecha: '2026-10-11 08:00', empleado: 'Juliana Gómez Jaramillo', cargo: 'Directora Banca Mayorista', ruta: 'Chapinero ➔ Chicó Norte', srv: 'Andina Estándar', chofer: 'Jairo Ramírez', placa: 'WLM-492', monto: '$ 17.160', estado: 'Finalizado' },
        { id: 31, fecha: '2026-11-01 09:30', empleado: 'Santiago Herrera Pardo', cargo: 'Especialista en Tesorería', ruta: 'Torre Bancolombia ➔ WTC Calle 100', srv: 'Andina Estándar', chofer: 'Jairo Ramírez', placa: 'WLM-492', monto: '$ 16.440', estado: 'Finalizado' },
        { id: 35, fecha: '2026-10-13 06:15', empleado: 'Juliana Gómez Jaramillo', cargo: 'Directora Banca Mayorista', ruta: 'Torre Bancolombia ➔ Aeropuerto VIP', srv: 'Executive Black', chofer: 'William Castañeda', placa: 'KMS-811', monto: '$ 80.600', estado: 'Finalizado' },
        { id: 36, fecha: '2026-10-21 12:45', empleado: 'Santiago Herrera Pardo', cargo: 'Especialista en Tesorería', ruta: 'Club El Nogal ➔ Torre Colpatria', srv: 'Executive Black', chofer: 'William Castañeda', placa: 'KMS-811', monto: '$ 45.640', estado: 'Finalizado' },
        { id: 37, fecha: '2026-10-29 17:30', empleado: 'Catalina Restrepo Mejía', cargo: 'Gerente Transformación', ruta: 'Santa Bárbara ➔ Hotel Grand Hyatt', srv: 'Executive Black', chofer: 'William Castañeda', placa: 'KMS-811', monto: '$ 67.300', estado: 'Finalizado' },
        { id: 38, fecha: '2026-11-04 10:00', empleado: 'Felipe Beltrán Cifuentes', cargo: 'Líder Técnico Arquitectura', ruta: 'Torre Bancolombia ➔ Zona Franca', srv: 'Executive Black', chofer: 'William Castañeda', placa: 'KMS-811', monto: '$ 73.760', estado: 'Finalizado' },
        { id: 39, fecha: '2026-11-10 16:00', empleado: 'Juliana Gómez Jaramillo', cargo: 'Directora Banca Mayorista', ruta: 'Casa Medina ➔ Aeropuerto VIP', srv: 'Executive Black', chofer: 'William Castañeda', placa: 'KMS-811', monto: '$ 79.840', estado: 'Finalizado' }
      ]
    }
  },

  init() {
    this.currentCompanyId = AppState.country === 'PE' ? 3 : 4;
    const sel = document.getElementById('corporateCompanySelect');
    if (sel) sel.value = this.currentCompanyId;

    this.renderKpis();
    this.renderTripsTable();
    this.bindEvents();
  },

  renderKpis() {
    const data = this.companyData[this.currentCompanyId] || this.companyData[3];
    document.getElementById('kpiTotalSpend').textContent = data.gastoTotal;
    document.getElementById('kpiTotalTrips').textContent = data.totalViajes;
    document.getElementById('kpiTotalSavings').textContent = data.ahorro;
    document.getElementById('kpiActiveEmployees').textContent = data.empleadosActivos;
  },

  renderTripsTable(filterText = '') {
    const tbody = document.getElementById('corporateTripsTbody');
    if (!tbody) return;

    const data = this.companyData[this.currentCompanyId] || this.companyData[3];
    let filtered = data.trips;

    if (filterText) {
      const q = filterText.toLowerCase();
      filtered = filtered.filter(t => 
        t.empleado.toLowerCase().includes(q) ||
        t.cargo.toLowerCase().includes(q) ||
        t.ruta.toLowerCase().includes(q) ||
        t.chofer.toLowerCase().includes(q)
      );
    }

    tbody.innerHTML = filtered.map(t => `
      <tr>
        <td><span style="font-family:var(--font-mono); color:var(--text-tertiary);">#${t.id}</span></td>
        <td><small style="color:var(--text-tertiary); font-family:var(--font-mono);">${t.fecha}</small></td>
        <td><strong>${t.empleado}</strong></td>
        <td><small style="color:var(--text-tertiary);">${t.cargo}</small></td>
        <td>${t.ruta}</td>
        <td><span class="chip-btn">${t.srv}</span></td>
        <td>${t.chofer} <small style="color:var(--text-tertiary); font-family:var(--font-mono);">(${t.placa})</small></td>
        <td><span class="fare-highlight">${t.monto}</span></td>
        <td><span class="badge-state badge-finalizado">${t.estado}</span></td>
      </tr>
    `).join('');
  },

  exportToCsv() {
    const data = this.companyData[this.currentCompanyId] || this.companyData[3];
    const headers = ['ID_Viaje', 'Fecha', 'Empleado', 'Cargo', 'Trayecto', 'Servicio', 'Conductor', 'Placa', 'Monto', 'Estado'];
    
    const rows = data.trips.map(t => [
      t.id,
      `"${t.fecha}"`,
      `"${t.empleado}"`,
      `"${t.cargo}"`,
      `"${t.ruta}"`,
      `"${t.srv}"`,
      `"${t.chofer}"`,
      `"${t.placa}"`,
      `"${t.monto}"`,
      `"${t.estado}"`
    ]);

    const csvContent = 'data:text/csv;charset=utf-8,\uFEFF' 
      + [headers.join(','), ...rows.map(r => r.join(','))].join('\n');

    const encodedUri = encodeURI(csvContent);
    const link = document.createElement('a');
    link.setAttribute('href', encodedUri);
    link.setAttribute('download', `RutaAndina_Reporte_Consumo_${data.nombre.split(' ')[0]}.csv`);
    document.body.appendChild(link);
    link.click();
    document.body.removeChild(link);

    App.showToast('Informe exportado a CSV exitosamente 📊', 'success');
  },

  bindEvents() {
    const sel = document.getElementById('corporateCompanySelect');
    if (sel) {
      sel.addEventListener('change', (e) => {
        this.currentCompanyId = parseInt(e.target.value);
        this.renderKpis();
        this.renderTripsTable();
        App.showToast(`Cargando métricas de ${sel.options[sel.selectedIndex].text.split('(')[0]}`, 'info');
      });
    }

    const searchInput = document.getElementById('searchCorporateTable');
    if (searchInput) {
      searchInput.addEventListener('input', (e) => {
        this.renderTripsTable(e.target.value);
      });
    }

    const btnExport = document.getElementById('btnExportCorporateCsv');
    if (btnExport) {
      btnExport.addEventListener('click', () => this.exportToCsv());
    }
  }
};
