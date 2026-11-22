/**
 * VISTA PASAJERO — Ruta Andina
 * Cotizador, Solicitud, Seguimiento en Vivo e Historial de Viajes
 */

const PassengerView = {
  currentServiceId: 2, // Confort por defecto
  currentDistance: 8.5,
  selectedRideForRating: null,

  services: [
    { id: 1, name: 'Andina Estándar', desc: 'Sedán ágil, moderno y económico', icon: '🚙', capacity: 4, basePEN: 6.00, kmPEN: 1.80 },
    { id: 2, name: 'Andina Confort', desc: 'Espacioso, A/C, chofer top rated', icon: '⭐', capacity: 4, basePEN: 9.50, kmPEN: 2.40 },
    { id: 3, name: 'Executive Black', desc: 'Gama alta, chofer bilingüe de traje', icon: '👑', capacity: 4, basePEN: 16.00, kmPEN: 3.80 },
    { id: 4, name: 'Van Corporativa', desc: 'Grupos ejecutivos y traslados (7 pax)', icon: '🚐', capacity: 7, basePEN: 28.00, kmPEN: 5.50 },
    { id: 5, name: 'Envío Express', desc: 'Documentos y paquetes urgentes', icon: '📦', capacity: 1, basePEN: 5.00, kmPEN: 1.50 }
  ],

  cityAddresses: {
    PE: {
      origins: [
        'Av. Malecón de la Reserva 729, Miraflores',
        'Calle Centenario 156, La Molina (BCP)',
        'Av. Javier Prado Este 3200, San Borja',
        'Av. Larco 1000, Miraflores'
      ],
      destinations: [
        'Av. Canaval y Moreyra 480, San Isidro',
        'Aeropuerto Internacional Jorge Chávez',
        'Centro Financiero San Isidro',
        'Jockey Plaza Shopping Center, Surco'
      ]
    },
    CO: {
      origins: [
        'Carrera 43A # 1-50, El Poblado (Torre Bancolombia)',
        'Parque Lleras, El Poblado',
        'Calle 10 # 43E-20 (Campus EAFIT)',
        'Carrera 76 # 32BB-15, Laureles'
      ],
      destinations: [
        'Aeropuerto Internacional José María Córdova (MDE)',
        'Ruta N Complejo de Innovación, Medellín',
        'Centro Comercial El Tesoro, El Poblado',
        'Hotel InterContinental Medellín, El Poblado'
      ]
    }
  },

  init() {
    this.renderQuickChips();
    this.renderServicesCatalog();
    this.bindEvents();
    this.recalculateQuote();
    this.loadHistory();
  },

  renderQuickChips() {
    const isPE = AppState.country === 'PE';
    const data = isPE ? this.cityAddresses.PE : this.cityAddresses.CO;

    const originContainer = document.getElementById('originQuickChips');
    const destContainer = document.getElementById('destQuickChips');
    if (!originContainer || !destContainer) return;

    originContainer.innerHTML = data.origins.map(addr => {
      const short = addr.split(',')[0].split('(')[0].trim();
      return `<button class="chip-btn" onclick="PassengerView.setOrigin('${addr.replace(/'/g, "\\'")}')">${short}</button>`;
    }).join('');

    destContainer.innerHTML = data.destinations.map(addr => {
      const short = addr.split(',')[0].split('(')[0].trim();
      return `<button class="chip-btn" onclick="PassengerView.setDestination('${addr.replace(/'/g, "\\'")}')">${short}</button>`;
    }).join('');
  },

  setOrigin(addr) {
    document.getElementById('tripOrigin').value = addr;
    this.recalculateQuote();
  },

  setDestination(addr) {
    document.getElementById('tripDestination').value = addr;
    this.recalculateQuote();
  },

  renderServicesCatalog() {
    const container = document.getElementById('servicesCatalogContainer');
    if (!container) return;

    const isCOP = AppState.currency === 'COP';
    const factor = isCOP ? 1000 : 1;

    container.innerHTML = this.services.map(s => {
      const selectedClass = s.id === this.currentServiceId ? 'selected' : '';
      const estimatedPrice = Math.round((s.basePEN * factor + s.kmPEN * factor * this.currentDistance) * 100) / 100;
      const formattedPrice = isCOP
        ? `$ ${estimatedPrice.toLocaleString('es-CO')}`
        : `S/ ${estimatedPrice.toFixed(2)}`;

      return `
        <div class="service-card-item ${selectedClass}" onclick="PassengerView.selectService(${s.id})">
          <div class="service-left">
            <div class="service-icon-frame">${s.icon}</div>
            <div>
              <div class="service-name">${s.name} <small style="color:var(--text-tertiary); font-size:0.7rem;">(${s.capacity} pax)</small></div>
              <div class="service-meta">${s.desc}</div>
            </div>
          </div>
          <div class="service-right">
            <div class="service-fare-value">${formattedPrice}</div>
            <div class="service-fare-eta">3-5 min</div>
          </div>
        </div>
      `;
    }).join('');
  },

  selectService(id) {
    this.currentServiceId = id;
    this.renderServicesCatalog();
    this.recalculateQuote();
  },

  async recalculateQuote() {
    const origin = document.getElementById('tripOrigin').value;
    const dest = document.getElementById('tripDestination').value;
    
    // Distancia aproximada según ruta
    const dist = Math.max(3.2, Math.min(28.0, (origin.length + dest.length) % 20 + 4.5));
    this.currentDistance = Math.round(dist * 10) / 10;

    const quote = await Api.cotizar({
      idTipoServicio: this.currentServiceId,
      origen: origin,
      destino: dest,
      distanciaKm: this.currentDistance,
      moneda: AppState.currency
    });

    const isCOP = AppState.currency === 'COP';
    const fmt = num => isCOP ? `$ ${Math.round(num).toLocaleString('es-CO')}` : `S/ ${num.toFixed(2)}`;

    document.getElementById('quoteDistance').textContent = `${quote.distanciaKm} km`;
    document.getElementById('quoteEta').textContent = `${quote.tiempoEstimadoMinutos} mins`;
    document.getElementById('quoteSubtotal').textContent = fmt(quote.subtotal);
    document.getElementById('quoteCommission').textContent = fmt(quote.comisionPlataforma);
    document.getElementById('quoteTotal').textContent = fmt(quote.tarifaTotal);
  },

  bindEvents() {
    const btnRequest = document.getElementById('btnRequestRide');
    if (btnRequest) {
      btnRequest.addEventListener('click', () => this.handleRideRequest());
    }

    const btnRefreshHistory = document.getElementById('btnRefreshPassengerHistory');
    if (btnRefreshHistory) {
      btnRefreshHistory.addEventListener('click', () => {
        this.loadHistory();
        App.showToast('Historial de viajes sincronizado con Supabase', 'info');
      });
    }

    const btnSimulate = document.getElementById('btnSimulatePassengerRideProgress');
    if (btnSimulate) {
      btnSimulate.addEventListener('click', () => this.progressActiveRide());
    }

    // Modal de Calificación
    const closeRateBtn = document.getElementById('closeRateModalBtn');
    if (closeRateBtn) {
      closeRateBtn.addEventListener('click', () => {
        document.getElementById('rateModal').classList.remove('open');
      });
    }

    const submitRateBtn = document.getElementById('btnSubmitRating');
    if (submitRateBtn) {
      submitRateBtn.addEventListener('click', () => this.submitRating());
    }

    // Estrellas
    document.querySelectorAll('.star-rating-item').forEach(star => {
      star.addEventListener('click', (e) => {
        const val = parseInt(e.target.getAttribute('data-val'));
        this.setStarScore(val);
      });
    });
  },

  selectedScore: 5,
  setStarScore(score) {
    this.selectedScore = score;
    document.querySelectorAll('.star-rating-item').forEach((star, idx) => {
      star.style.opacity = (idx < score) ? '1' : '0.25';
      star.style.transform = (idx < score) ? 'scale(1.15)' : 'scale(1)';
    });
  },

  async handleRideRequest() {
    const origin = document.getElementById('tripOrigin').value;
    const dest = document.getElementById('tripDestination').value;
    const isCorp = document.getElementById('chkCorporateTrip').checked;
    const totalTxt = document.getElementById('quoteTotal').textContent.replace(/[^\d.]/g, '');
    const totalVal = parseFloat(totalTxt) || 29.90;

    App.showToast('Solicitando traslado en tiempo real...', 'info');

    const viaje = await Api.solicitarViaje({
      idPasajero: AppState.activePassengerId,
      idTipoServicio: this.currentServiceId,
      idPais: AppState.country === 'PE' ? 1 : 2,
      esCorporativo: isCorp,
      origen: origin,
      destino: dest,
      distanciaKm: this.currentDistance,
      tarifaTotal: totalVal,
      moneda: AppState.currency
    });

    // Actualizar panel de seguimiento activo
    document.getElementById('activeRideTracker').style.display = 'block';
    document.getElementById('activeRideStateBadge').textContent = 'Solicitado';
    document.getElementById('activeRideStateBadge').className = 'badge-state badge-solicitado';
    document.getElementById('activeRideRoute').textContent = `${origin.split(',')[0]} ➔ ${dest.split(',')[0]}`;
    document.getElementById('activeRideFare').textContent = document.getElementById('quoteTotal').textContent;
    document.getElementById('activeRideDriver').textContent = 'Buscando chofer cercano...';
    document.getElementById('activeRidePlate').textContent = 'Placa: Asignando...';

    App.showToast('¡Viaje solicitado! Disponible en el radar de choferes.', 'success');

    document.getElementById('activeRideTracker').scrollIntoView({ behavior: 'smooth', block: 'nearest' });
    this.loadHistory();
  },

  progressActiveRide() {
    const badge = document.getElementById('activeRideStateBadge');
    const cur = badge.textContent;
    if (cur.includes('Solicitado')) {
      badge.textContent = 'Aceptado';
      badge.className = 'badge-state badge-aceptado';
      document.getElementById('activeRideDriver').textContent = AppState.country === 'PE' ? 'Carlos Mendoza (Toyota Corolla)' : 'Jairo Ramírez (Renault Logan)';
      document.getElementById('activeRidePlate').textContent = AppState.country === 'PE' ? 'Placa: BAP-842' : 'Placa: WLM-492';
      App.showToast('¡Conductor asignado! En camino a recogerte.', 'success');
    } else if (cur.includes('Aceptado')) {
      badge.textContent = 'En Curso';
      badge.className = 'badge-state badge-encurso';
      App.showToast('Viaje iniciado. En trayecto al destino.', 'info');
    } else {
      badge.textContent = 'Finalizado';
      badge.className = 'badge-state badge-finalizado';
      App.showToast('¡Has llegado a tu destino! Tarifa liquidada con éxito.', 'success');
      this.openRateModal(99, 'Recorrido Reciente');
      this.loadHistory();
    }
  },

  loadHistory() {
    const tbody = document.getElementById('passengerHistoryTbody');
    if (!tbody) return;

    const isPE = AppState.country === 'PE';
    
    const mockTripsPE = [
      { id: 6, fecha: '2026-11-10 05:30', ruta: 'La Molina ➔ Aeropuerto Jorge Chávez', srv: 'Andina Confort', chofer: 'Carlos Mendoza', veh: 'Toyota Corolla (BAP-842)', monto: 'S/ 73.10', estado: 'Finalizado', rating: 5, rated: true },
      { id: 4, fecha: '2026-11-02 08:15', ruta: 'San Borja ➔ San Isidro Real', srv: 'Andina Confort', chofer: 'Carlos Mendoza', veh: 'Toyota Corolla (BAP-842)', monto: 'S/ 33.02', estado: 'Finalizado', rating: 5, rated: true },
      { id: 7, fecha: '2026-11-14 13:20', ruta: 'Jesús María ➔ San Isidro Pardo', srv: 'Andina Confort', chofer: 'Carlos Mendoza', veh: 'Toyota Corolla (BAP-842)', monto: 'S/ 22.94', estado: 'Finalizado', rating: 0, rated: false },
      { id: 13, fecha: '2026-11-12 16:00', ruta: 'Miraflores ➔ Jockey Plaza', srv: 'Executive Black', chofer: 'Julio César Paredes', veh: 'Mercedes C-200 (CFX-195)', monto: 'S/ 54.76', estado: 'Finalizado', rating: 0, rated: false },
      { id: 19, fecha: '2026-11-15 21:00', ruta: 'Miraflores ➔ Larcomar', srv: 'Andina Estándar', chofer: 'Miguel Ángel Cárdenas', veh: 'Hyundai Elantra (AYZ-610)', monto: 'S/ 10.32', estado: 'Finalizado', rating: 5, rated: true }
    ];

    const mockTripsCO = [
      { id: 39, fecha: '2026-11-10 16:00', ruta: 'Four Seasons ➔ Aeropuerto El Dorado', srv: 'Executive Black', chofer: 'William Castañeda', veh: 'BMW Serie 3 (KMS-811)', monto: '$ 79.840', estado: 'Finalizado', rating: 5, rated: true },
      { id: 31, fecha: '2026-11-01 09:30', ruta: 'Torre Bancolombia ➔ WTC Calle 100', srv: 'Andina Estándar', chofer: 'Jairo Ramírez', veh: 'Renault Logan (WLM-492)', monto: '$ 16.440', estado: 'Finalizado', rating: 5, rated: true },
      { id: 44, fecha: '2026-11-11 13:00', ruta: 'Cedritos ➔ Hacienda Santa Bárbara', srv: 'Andina Confort', chofer: 'Albeiro Montoya', veh: 'Toyota Yaris (FNT-324)', monto: '$ 19.100', estado: 'Finalizado', rating: 0, rated: false },
      { id: 33, fecha: '2026-11-12 05:00', ruta: 'Chicó ➔ Aeropuerto El Dorado T1', srv: 'Andina Estándar', chofer: 'Jairo Ramírez', veh: 'Renault Logan (WLM-492)', monto: '$ 35.700', estado: 'Finalizado', rating: 5, rated: true }
    ];

    const list = isPE ? mockTripsPE : mockTripsCO;

    tbody.innerHTML = list.map(t => {
      const stateBadge = `<span class="badge-state badge-finalizado">${t.estado}</span>`;
      const ratingAction = t.rated
        ? `<span style="color:var(--gold-300); font-weight:700;">⭐ ${t.rating}.0</span>`
        : `<button class="chip-btn" style="color:var(--gold-primary); border-color:var(--gold-primary);" onclick="PassengerView.openRateModal(${t.id}, '${t.ruta}')">⭐ Calificar</button>`;

      return `
        <tr>
          <td><span style="font-family:var(--font-mono); color:var(--text-tertiary);">#${t.id}</span></td>
          <td><small style="color:var(--text-tertiary); font-family:var(--font-mono);">${t.fecha}</small></td>
          <td><strong>${t.ruta}</strong></td>
          <td><span class="chip-btn">${t.srv}</span></td>
          <td>${t.chofer} <small style="color:var(--text-tertiary);">(${t.veh})</small></td>
          <td><span class="fare-highlight">${t.monto}</span></td>
          <td>${stateBadge}</td>
          <td>${ratingAction}</td>
        </tr>
      `;
    }).join('');
  },

  openRateModal(tripId, route) {
    this.selectedRideForRating = tripId;
    document.getElementById('rateModalRideInfo').textContent = `Viaje #${tripId} • ${route}`;
    document.getElementById('rateCommentInput').value = '';
    this.setStarScore(5);
    document.getElementById('rateModal').classList.add('open');
  },

  async submitRating() {
    const comment = document.getElementById('rateCommentInput').value;
    App.showToast('Guardando calificación en Supabase...', 'info');

    await Api.calificarViaje(this.selectedRideForRating, {
      puntaje: this.selectedScore,
      comentario: comment || 'Excelente experiencia de traslado.',
      tipoCalificador: 'Pasajero'
    });

    document.getElementById('rateModal').classList.remove('open');
    App.showToast(`¡Gracias! Has calificado el viaje con ${this.selectedScore} estrellas ⭐`, 'success');
    this.loadHistory();
  }
};
