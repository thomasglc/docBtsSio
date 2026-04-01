# Mémos

Les aides mémoires sont des fiches synthétiques qui vous permettront de vous rappeler les commandes et les syntaxes les plus utilisées. Elles vous seront utiles dans le cadre des cours, TP et révisions lors des examens.

<div class="tp-grid">

  <div class="tp-card">
    <div class="tp-card-header">
      <span class="tp-icon">🌐</span>
      <h2>Web</h2>
    </div>
    <ul>
      <li><a href="/memo/html">HTML</a></li>
      <li><a href="/memo/css">CSS</a></li>
      <li><a href="/memo/js">JavaScript</a></li>
      <li><a href="/memo/php">PHP</a></li>
    </ul>
  </div>

  <div class="tp-card">
    <div class="tp-card-header">
      <span class="tp-icon">🔧</span>
      <h2>Outils</h2>
    </div>
    <ul>
      <li><a href="/memo/git">Git</a></li>
      <li><a href="/memo/powershell">PowerShell</a></li>
      <li><a href="/memo/wordpress">WordPress</a></li>
    </ul>
  </div>

  <div class="tp-card">
    <div class="tp-card-header">
      <span class="tp-icon">🌿</span>
      <h2>Réseau</h2>
    </div>
    <ul>
      <li><a href="/memo/switch">Switch</a></li>
      <li><a href="/memo/routeur">Routeur</a></li>
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
