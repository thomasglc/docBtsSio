# Travaux Pratiques

<div class="tp-grid">

  <div class="tp-card">
    <div class="tp-card-header">
      <span class="tp-icon">🐘</span>
      <h2>PHP</h2>
    </div>
    <ul>
      <li><a href="/tp/php/1-condition">1 — Les conditions</a></li>
      <li><a href="/tp/php/2-tableaux">2 — Les tableaux associatifs</a></li>
      <li><a href="/tp/php/3-get-post">3 — $_GET et $_POST</a></li>
      <li><a href="/tp/php/4-session-cookies">4 — $_SESSION et $_COOKIES</a></li>
      <li><a href="/tp/php/5-pdo">5 — Découverte de PDO</a></li>
    </ul>
  </div>

  <div class="tp-card">
    <div class="tp-card-header">
      <span class="tp-icon">🧪</span>
      <h2>Tests unitaires</h2>
    </div>
    <ul>
      <li><a href="/tp/testUnitaire/1-decouverte">1 — Les bases</a></li>
      <li><a href="/tp/testUnitaire/2-decouverte">2 — Avec des tableaux</a></li>
      <li><a href="/tp/testUnitaire/jest/1-jest">3 — Découverte de Jest</a></li>
      <li><a href="/tp/testUnitaire/jest/2-jest">4 — Jest et le DOM</a></li>
      <li><a href="/tp/testUnitaire/jest/3-bonus">5 — Bonus</a></li>
    </ul>
  </div>

  <div class="tp-card">
    <div class="tp-card-header">
      <span class="tp-icon">🌿</span>
      <h2>Git</h2>
    </div>
    <ul>
      <li><a href="/tp/git/1-decouverte">1 — Découverte</a></li>
      <li><a href="/tp/git/2-gitAndGithub">2 — Git et Github</a></li>
    </ul>
  </div>

  <div class="tp-card">
    <div class="tp-card-header">
      <span class="tp-icon">🖥️</span>
      <h2>Système</h2>
    </div>
    <ul>
      <li><a href="/tp/systeme/1-lamp">1 — Mise en place LAMP</a></li>
      <li><a href="/tp/systeme/2-wordpress">2 — Configuration WordPress</a></li>
    </ul>
  </div>

  <div class="tp-card">
    <div class="tp-card-header">
      <span class="tp-icon">⚡</span>
      <h2>PowerShell</h2>
    </div>
    <ul>
      <li><a href="/tp/powershell/1-initiation">1 — Initiation</a></li>
    </ul>
  </div>

  <div class="tp-card">
    <div class="tp-card-header">
      <span class="tp-icon">🌐</span>
      <h2>Réseau</h2>
    </div>
    <ul>
      <li><a href="/tp/reseau/1-acl">1 — Configuration ACL</a></li>
      <li><a href="/tp/reseau/3-pfsense">2 — Mise en place de pfSense</a></li>
      <li><a href="/tp/reseau/4-pfsense-dmz">3 — DMZ & Règles de pare-feu</a></li>
    </ul>
  </div>

</div>

<style>
.tp-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(260px, 1fr));
  gap: 1.2rem;
  margin-top: 2rem;
}

.tp-card {
  border: 1px solid var(--vp-c-divider);
  border-radius: 12px;
  padding: 1.2rem 1.4rem;
  background: var(--vp-c-bg-soft);
  transition: box-shadow 0.2s, border-color 0.2s;
}

.tp-card:hover {
  border-color: var(--vp-c-brand-1);
  box-shadow: 0 4px 16px rgba(0,0,0,0.08);
}

.tp-card-header {
  display: flex;
  align-items: center;
  gap: 0.6rem;
  margin-bottom: 0.8rem;
}

.tp-card-header h2 {
  margin: 0;
  padding: 0;
  border: none;
  font-size: 1.1rem;
  font-weight: 600;
}

.tp-icon {
  font-size: 1.4rem;
}

.tp-card ul {
  margin: 0;
  padding-left: 1.1rem;
}

.tp-card ul li {
  margin: 0.3rem 0;
  font-size: 0.92rem;
}
</style>
