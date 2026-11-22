/**
 * APP PRINCIPAL — Ruta Andina
 * Orquestador Global de Estado, Navegación SPA y Switcher Binacional
 * COIL 2026: TECSUP (Perú) & Politécnico Grancolombiano (Colombia)
 */

const AppState = {
  country: 'PE',       // 'PE' o 'CO'
  currency: 'PEN',      // 'PEN' o 'COP'
  city: 'Lima',         // 'Lima' o 'Medellín'
  activeTab: 'passenger',
  activePassengerId: 1, // Luciana Vargas
  activeDriverId: 1,    // Carlos Mendoza
  activeCompanyId: 3    // BCP
};

const App = {
  init() {
    this.bindNavigation();
    this.bindCountryToggle();
    this.bindDemoModal();
    this.checkDatabaseHealth();

    // Inicializar submódulos
    PassengerView.init();
    DriverView.init();
    CorporateView.init();
    AnalyticsView.init();

    this.renderLucideIcons();
  },

  renderLucideIcons() {
    if (window.lucide) {
      window.lucide.createIcons();
    }
  },

  bindNavigation() {
    document.querySelectorAll('.nav-pill-btn').forEach(btn => {
      btn.addEventListener('click', (e) => {
        const tab = e.currentTarget.getAttribute('data-tab');
        this.switchTab(tab);
      });
    });

    const brandBtn = document.getElementById('brandHomeBtn');
    if (brandBtn) {
      brandBtn.addEventListener('click', () => this.switchTab('passenger'));
    }
  },

  switchTab(tabName) {
    AppState.activeTab = tabName;

    // Actualizar botones de navegación
    document.querySelectorAll('.nav-pill-btn').forEach(btn => {
      btn.classList.toggle('active', btn.getAttribute('data-tab') === tabName);
    });

    // Actualizar paneles
    document.querySelectorAll('.view-panel').forEach(panel => {
      panel.classList.toggle('active', panel.id === `view-${tabName}`);
    });

    // Refrescar vistas según pestaña activa
    if (tabName === 'passenger') PassengerView.loadHistory();
    if (tabName === 'driver') DriverView.loadRadarTrips();
    if (tabName === 'corporate') CorporateView.renderTripsTable();

    window.scrollTo({ top: 0, behavior: 'smooth' });
    this.renderLucideIcons();
  },

  bindCountryToggle() {
    document.querySelectorAll('.currency-seg-btn').forEach(btn => {
      btn.addEventListener('click', (e) => {
        const country = e.currentTarget.getAttribute('data-country');
        const currency = e.currentTarget.getAttribute('data-currency');
        const city = e.currentTarget.getAttribute('data-city');
        this.setCountry(country, currency, city);
      });
    });
  },

  setCountry(country, currency, city) {
    AppState.country = country;
    AppState.currency = currency;
    AppState.city = city;

    // Actualizar botones del toggle
    document.querySelectorAll('.currency-seg-btn').forEach(btn => {
      btn.classList.toggle('active', btn.getAttribute('data-country') === country);
    });

    // Actualizar textos globales
    document.getElementById('heroCityName').textContent = `${city} & ${country === 'PE' ? 'Medellín' : 'Lima'}`;
    document.getElementById('metricGmv').textContent = country === 'PE' ? 'S/ 48.5K' : '$ 52.8M';
    document.getElementById('passengerActiveBadge').textContent = country === 'PE' ? '🇵🇪 Lima' : '🇨🇴 Medellín';

    // Notificar submódulos
    PassengerView.renderQuickChips();
    PassengerView.renderServicesCatalog();
    PassengerView.recalculateQuote();
    PassengerView.loadHistory();

    DriverView.currentDriverId = country === 'PE' ? 1 : 7;
    DriverView.renderDriverProfile();
    DriverView.loadRadarTrips();

    CorporateView.currentCompanyId = country === 'PE' ? 3 : 4;
    const corpSelect = document.getElementById('corporateCompanySelect');
    if (corpSelect) corpSelect.value = CorporateView.currentCompanyId;
    CorporateView.renderKpis();
    CorporateView.renderTripsTable();

    this.showToast(`Modo binacional cambiado a: ${country === 'PE' ? '🇵🇪 Lima (Soles PEN)' : '🇨🇴 Medellín (Pesos COP)'}`, 'info');
    this.renderLucideIcons();
  },

  bindDemoModal() {
    const modal = document.getElementById('demoModal');
    const openBtn = document.getElementById('openDemoModalBtn');
    const closeBtn = document.getElementById('closeDemoModalBtn');

    if (openBtn) openBtn.addEventListener('click', () => modal.classList.add('open'));
    if (closeBtn) closeBtn.addEventListener('click', () => modal.classList.remove('open'));

    // Personas demo
    document.querySelectorAll('.demo-persona-btn').forEach(btn => {
      btn.addEventListener('click', (e) => {
        const persona = e.currentTarget.getAttribute('data-persona');
        this.applyPersona(persona);
        modal.classList.remove('open');
      });
    });
  },

  applyPersona(persona) {
    if (persona === 'pasajero-lima') {
      this.setCountry('PE', 'PEN', 'Lima');
      AppState.activePassengerId = 1;
      this.switchTab('passenger');
      this.showToast('Sesión activada: Luciana Vargas (Lima)', 'success');
    } else if (persona === 'pasajero-medellin') {
      this.setCountry('CO', 'COP', 'Medellín');
      AppState.activePassengerId = 11;
      this.switchTab('passenger');
      this.showToast('Sesión activada: Juliana Gómez (Medellín - Bancolombia)', 'success');
    } else if (persona === 'conductor-lima') {
      this.setCountry('PE', 'PEN', 'Lima');
      DriverView.currentDriverId = 1;
      this.switchTab('driver');
      DriverView.renderDriverProfile();
      this.showToast('Conductor activo: Carlos Mendoza (Lima)', 'success');
    } else if (persona === 'conductor-medellin') {
      this.setCountry('CO', 'COP', 'Medellín');
      DriverView.currentDriverId = 7;
      this.switchTab('driver');
      DriverView.renderDriverProfile();
      this.showToast('Conductor activo: William Castañeda (Medellín - Alerta SOAT)', 'warning');
    } else if (persona === 'empresa-bcp') {
      this.setCountry('PE', 'PEN', 'Lima');
      CorporateView.currentCompanyId = 3;
      this.switchTab('corporate');
      CorporateView.renderKpis();
      CorporateView.renderTripsTable();
      this.showToast('Acceso Ejecutivo: Banco de Crédito BCP', 'success');
    } else if (persona === 'empresa-bancolombia') {
      this.setCountry('CO', 'COP', 'Medellín');
      CorporateView.currentCompanyId = 4;
      this.switchTab('corporate');
      CorporateView.renderKpis();
      CorporateView.renderTripsTable();
      this.showToast('Acceso Ejecutivo: Bancolombia S.A.', 'success');
    }
  },

  async checkDatabaseHealth() {
    const health = await Api.checkHealth();
    const pill = document.getElementById('dbStatusPill');
    const text = document.getElementById('dbStatusText');

    if (health.supabaseConnected) {
      pill.style.borderColor = 'rgba(16, 185, 129, 0.4)';
      text.textContent = 'Supabase PostgreSQL 15+';
    } else {
      pill.style.borderColor = 'rgba(212, 175, 55, 0.4)';
      text.textContent = health.databaseType || 'DB Cloud Ready';
    }
  },

  showToast(message, type = 'info') {
    const container = document.getElementById('toastContainer');
    if (!container) return;

    const toast = document.createElement('div');
    toast.className = `toast-pill ${type}`;
    
    let iconName = 'info';
    if (type === 'success') iconName = 'check-circle';
    if (type === 'error') iconName = 'alert-triangle';
    if (type === 'warning') iconName = 'alert-circle';

    toast.innerHTML = `
      <i data-lucide="${iconName}" style="width:16px; height:16px; flex-shrink:0;"></i>
      <span>${message}</span>
    `;

    container.appendChild(toast);
    this.renderLucideIcons();

    setTimeout(() => {
      toast.style.opacity = '0';
      toast.style.transform = 'translateY(10px)';
      toast.style.transition = 'all 0.25s ease';
      setTimeout(() => toast.remove(), 250);
    }, 3800);
  }
};

document.addEventListener('DOMContentLoaded', () => {
  App.init();
});
