/**
 * VISTA CONDUCTOR — Ruta Andina
 * Document Health Guard, Radar de Viajes Pendientes y Ciclo de Estados
 */

const DriverView = {
  currentDriverId: 1, // Carlos Mendoza (Lima) por defecto
  activeTrip: null,

  driverProfiles: {
    1: {
      id: 1,
      nombre: 'Carlos Mendoza Paredes',
      categoria: 'A-IIb • Flota Andina Express Lima',
      avatar: 'CM',
      pais: 'PE',
      licencia: { nro: 'Q-10293847-A2B', venc: '2028-05-15', dias: 540, estado: 'healthy' },
      seguro: { entidad: 'Pacífico Seguros Todo Riesgo', venc: '2026-12-08', dias: 18, estado: 'warning' },
      gananciasHoy: 'S/ 245.80',
      viajesHoy: 6
    },
    7: {
      id: 7,
      nombre: 'William Castañeda Gómez',
      categoria: 'C2 • Transportes Ejecutivos Medellín',
      avatar: 'WC',
      pais: 'CO',
      licencia: { nro: 'C1-80123456-MED', venc: '2027-09-18', dias: 302, estado: 'healthy' },
      seguro: { entidad: 'Sura Todo Riesgo Corporativo', venc: '2026-12-15', dias: 25, estado: 'warning' },
      gananciasHoy: '$ 284.500',
      viajesHoy: 5
    }
  },

  init() {
    this.currentDriverId = AppState.country === 'PE' ? 1 : 7;
    this.renderDriverProfile();
    this.loadRadarTrips();
    this.bindEvents();
  },

  renderDriverProfile() {
    const prof = this.driverProfiles[this.currentDriverId] || this.driverProfiles[1];
    
    document.getElementById('driverAvatarInitial').textContent = prof.avatar;
    document.getElementById('driverProfileName').textContent = prof.nombre;
    document.getElementById('driverCategoryInfo').textContent = prof.categoria;
    document.getElementById('driverCityRadar').textContent = prof.pais === 'PE' ? 'Lima' : 'Medellín';
    document.getElementById('driverTodayEarnings').textContent = prof.gananciasHoy;

    // Licencia
    const lic = prof.licencia;
    const licCard = document.getElementById('driverLicenseCard');
    const licBadge = document.getElementById('driverLicenseBadge');
    document.getElementById('driverLicenseDetails').textContent = `N° ${lic.nro} • Vence: ${lic.venc}`;
    if (lic.dias <= 0) {
      licCard.className = 'document-health-item critical';
      licBadge.textContent = 'CRÍTICO: Vencida';
      licBadge.className = 'badge-state badge-cancelado';
    } else if (lic.dias <= 30) {
      licCard.className = 'document-health-item warning';
      licBadge.textContent = `Alerta: ${lic.dias}d`;
      licBadge.className = 'badge-state badge-aceptado';
    } else {
      licCard.className = 'document-health-item';
      licBadge.textContent = `Vigente (${lic.dias}d)`;
      licBadge.className = 'badge-state badge-encurso';
    }

    // Seguro SOAT
    const seg = prof.seguro;
    const segCard = document.getElementById('driverInsuranceCard');
    const segBadge = document.getElementById('driverInsuranceBadge');
    document.getElementById('driverInsuranceDetails').textContent = `${seg.entidad} • Vence: ${seg.venc}`;
    if (seg.dias <= 0) {
      segCard.className = 'document-health-item critical';
      segBadge.textContent = 'CRÍTICO: Vencido';
      segBadge.className = 'badge-state badge-cancelado';
    } else if (seg.dias <= 30) {
      segCard.className = 'document-health-item warning';
      segBadge.textContent = `Alerta: ${seg.dias}d`;
      segBadge.className = 'badge-state badge-aceptado';
    } else {
      segCard.className = 'document-health-item';
      segBadge.textContent = `Vigente (${seg.dias}d)`;
      segBadge.className = 'badge-state badge-encurso';
    }
  },

  loadRadarTrips() {
    const container = document.getElementById('radarTripsContainer');
    if (!container) return;

    const isPE = AppState.country === 'PE';

    const pendingPE = [
      { id: 51, pasajero: 'Mariana Paz Soldán', origen: 'Av. Benavides 2150, Miraflores', dest: 'Jockey Plaza Mall, Surco', dist: '7.3 km', fare: 'S/ 19.14', srv: 'Andina Estándar' },
      { id: 55, pasajero: 'Diego Alva (BCP Corp)', origen: 'Calle Centenario 156, La Molina', dest: 'Centro Financiero San Isidro', dist: '11.2 km', fare: 'S/ 36.50', srv: 'Andina Confort' }
    ];

    const pendingCO = [
      { id: 52, pasajero: 'Daniela Cardona', origen: 'Calle 93 # 12-40, Chicó Norte', dest: 'Calle 116 con Autopista Norte', dist: '5.5 km', fare: '$ 22.700', srv: 'Andina Confort' },
      { id: 56, pasajero: 'Santiago Herrera (Bancolombia)', origen: 'Torre Bancolombia, Cra 7 # 71', dest: 'Aeropuerto El Dorado T1', dist: '16.5 km', fare: '$ 78.400', srv: 'Executive Black' }
    ];

    const trips = isPE ? pendingPE : pendingCO;

    container.innerHTML = trips.map(t => `
      <div class="radar-item-row" id="radar-trip-${t.id}">
        <div>
          <div style="display:flex; align-items:center; gap:8px; margin-bottom:4px;">
            <span class="badge-state badge-solicitado">#${t.id}</span>
            <span class="chip-btn">${t.srv}</span>
            <strong style="color:var(--text-white); font-size:0.85rem;">${t.pasajero}</strong>
          </div>
          <p style="font-size:0.75rem; color:var(--text-secondary);">${t.origen} ➔ ${t.dest} (${t.dist})</p>
          <small style="color:var(--gold-300); font-family:var(--font-mono); font-weight:700;">Tarifa: ${t.fare}</small>
        </div>
        <div>
          <button class="btn-status-action accept" onclick="DriverView.acceptTrip(${t.id}, '${t.pasajero}', '${t.origen} ➔ ${t.dest}', '${t.fare}')">
            Aceptar Viaje 🚕
          </button>
        </div>
      </div>
    `).join('');
  },

  acceptTrip(tripId, passenger, route, fare) {
    const prof = this.driverProfiles[this.currentDriverId] || this.driverProfiles[1];
    if (prof.licencia.dias <= 0) {
      App.showToast('Regla COIL: Tu licencia está vencida. Despacho bloqueado.', 'error');
      return;
    }
    if (prof.seguro.dias <= 0) {
      App.showToast('Regla COIL: El seguro SOAT está vencido. Despacho bloqueado.', 'error');
      return;
    }

    this.activeTrip = { id: tripId, passenger, route, fare, state: 'Aceptado' };
    
    const elem = document.getElementById(`radar-trip-${tripId}`);
    if (elem) elem.style.display = 'none';

    document.getElementById('driverActiveTripPassenger').textContent = passenger;
    document.getElementById('driverActiveTripRoute').textContent = route;
    document.getElementById('driverActiveTripFare').textContent = `Tarifa: ${fare}`;
    document.getElementById('driverActiveTripState').textContent = 'Aceptado';
    document.getElementById('driverActiveTripState').className = 'badge-state badge-aceptado';
    document.getElementById('driverAvailabilityBadge').textContent = 'Ocupado';
    document.getElementById('driverAvailabilityBadge').className = 'badge-state badge-aceptado';

    App.showToast(`¡Viaje #${tripId} Aceptado! Dirígete a recoger al pasajero.`, 'success');
  },

  async startRide() {
    if (!this.activeTrip) {
      App.showToast('No tienes ningún viaje asignado para iniciar', 'error');
      return;
    }

    App.showToast('Iniciando viaje en tiempo real...', 'info');
    await Api.actualizarEstadoViaje(this.activeTrip.id, {
      nuevoEstado: 'En Curso',
      idConductor: this.currentDriverId
    });

    this.activeTrip.state = 'En Curso';
    document.getElementById('driverActiveTripState').textContent = 'En Curso';
    document.getElementById('driverActiveTripState').className = 'badge-state badge-encurso';
    App.showToast('Viaje en curso. Conduce con precaución hacia el destino.', 'success');
  },

  async finishRide() {
    if (!this.activeTrip) {
      App.showToast('No hay viaje activo para finalizar', 'error');
      return;
    }

    App.showToast('Finalizando viaje y liquidando comisión con Supabase...', 'info');
    await Api.actualizarEstadoViaje(this.activeTrip.id, {
      nuevoEstado: 'Finalizado',
      idConductor: this.currentDriverId
    });

    document.getElementById('driverActiveTripState').textContent = 'Finalizado';
    document.getElementById('driverActiveTripState').className = 'badge-state badge-finalizado';
    document.getElementById('driverAvailabilityBadge').textContent = 'Disponible';
    document.getElementById('driverAvailabilityBadge').className = 'badge-state badge-encurso';

    App.showToast('¡Viaje completado! Comisión del 15% registrada automáticamente.', 'success');
    this.activeTrip = null;
  },

  bindEvents() {
    const btnRefresh = document.getElementById('btnRefreshDriverRadar');
    if (btnRefresh) {
      btnRefresh.addEventListener('click', () => {
        this.loadRadarTrips();
        App.showToast('Radar de viajes pendientes actualizado', 'info');
      });
    }

    const btnStart = document.getElementById('btnDriverStartRide');
    if (btnStart) {
      btnStart.addEventListener('click', () => this.startRide());
    }

    const btnFinish = document.getElementById('btnDriverFinishRide');
    if (btnFinish) {
      btnFinish.addEventListener('click', () => this.finishRide());
    }
  }
};
