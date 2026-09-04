import { groupIconMdPlugin, groupIconVitePlugin } from 'vitepress-plugin-group-icons'
import { withMermaid } from 'vitepress-plugin-mermaid'

// https://vitepress.dev/reference/site-config
export default withMermaid ({
  title: "Bts SIO",
  description: "Documentation pour le bts sio",
  head: [
    ['link', { rel: "icon", type: "image/png", href: "/icons/alien.png" }],
  ],
  markdown: {
    lineNumbers: true,
    image: {
      lazyLoading: true
    },
    config(md) {
      md.use(groupIconMdPlugin)
    },
  },
  vite: {
    plugins: [
      groupIconVitePlugin()
    ],
  },
  lang: 'fr-FR',
  themeConfig: {
    // https://vitepress.dev/reference/default-theme-config
    nav: [
      { text: 'Accueil', link: '/' },
    ],
    logo: '/icons/alien.png',
    outline: {
      label: "Sommaire"
    },
    search: {
      provider: 'local'
    },
    docFooter: {
      prev: false,
      next: false
    },
    sidebar: [
      {
        items: [
          {
            text: 'Programmation C#',
            collapsed: true,
            items: [
              { text: 'TP 1 — Prise en main', link: '/tp/csharp/1-prise-en-main.md' },
            ]
          },
        ]
      },
      {
        items: [
          {
            text: 'Développement web',
            collapsed: true,
            items: [
              {
                text: 'PHP',
                collapsed: true,
                items: [
                  { text: '1 - Les conditions', link: '/tp/php/1-condition.md' },
                  { text: '2 - Les tableaux associatifs', link: '/tp/php/2-tableaux.md' },
                  { text: '3 - $_GET et $_POST', link: '/tp/php/3-get-post.md' },
                  { text: '4 - $_SESSION et $_COOKIES', link: '/tp/php/4-session-cookies.md' },
                  { text: '5 - PDO', link: '/tp/php/5-pdo.md' },
                ]
              },
              {
                text: 'Tests unitaires',
                collapsed: true,
                items: [
                  { text: '1 - Découverte', link: '/tp/testUnitaire/1-decouverte.md' },
                  { text: '2 - Découverte', link: '/tp/testUnitaire/2-decouverte.md' },
                  { text: '3 - Jest', link: '/tp/testUnitaire/jest/1-jest.md' },
                  { text: '4 - Jest et le DOM', link: '/tp/testUnitaire/jest/2-jest.md' },
                  { text: '5 - Bonus', link: '/tp/testUnitaire/jest/3-bonus.md' },
                ]
              },
              {
                text: 'Sécurité Web',
                collapsed: true,
                items: [
                  { text: '1 - Observer le trafic HTTP', link: '/tp/cybersecurite/1-http-devtools.md' },
                ]
              },
              {
                text: 'Git',
                collapsed: true,
                items: [
                  { text: '1 - Découverte', link: '/tp/git/1-decouverte.md' },
                  { text: '2 - Git et Github', link: '/tp/git/2-gitAndGithub.md' },
                ]
              },
            ]
          },
        ]
      },
      {
        items: [
          {
            text: 'Infrastructure & Systèmes',
            collapsed: true,
            items: [
              {
                text: 'Système',
                collapsed: true,
                items: [
                  { text: '1 - Mise en place LAMP', link: '/tp/systeme/1-lamp.md' },
                  { text: '2 - Configuration WordPress', link: '/tp/systeme/2-wordpress.md' },
                ]
              },
              {
                text: 'Docker',
                collapsed: true,
                items: [
                  { text: '1 - Découverte de Docker', link: '/tp/docker/1-decouverte.md' },
                  { text: '1.5 - Construire ses propres images', link: '/tp/docker/1.5-construire-images.md' },
                  { text: '2 - Compose et WordPress', link: '/tp/docker/2-compose-wordpress.md' },
                ]
              },
              {
                text: 'Active Directory',
                collapsed: true,
                items: [
                  { text: '1 - Installation', link: '/tp/activeDirectory/1-installation.md' },
                  { text: '2 - Utilisateurs, groupes et jonction au domaine', link: '/tp/activeDirectory/2-configuration.md' },
                  { text: '3 - Stratégies de groupe (GPO)', link: '/tp/activeDirectory/3-gpo.md' },
                  { text: '4 - Partages réseau et permissions NTFS', link: '/tp/activeDirectory/4-partages-ntfs.md' },
                ]
              },
              {
                text: 'GLPI',
                collapsed: true,
                items: [
                  { text: '1 - Installation', link: '/tp/glpi/1-installation.md' },
                  { text: '2 - Gestion d\'un inventaire', link: '/tp/glpi/2-inventaire.md' },
                  { text: '3 - Gestion des tickets', link: '/tp/glpi/3-tickets.md' },
                ]
              },
              {
                text: 'PowerShell',
                collapsed: true,
                items: [
                  { text: '1 - Initiation', link: '/tp/powershell/1-initiation.md' },
                ]
              },
            ]
          },
        ]
      },
      {
        items: [
          {
            text: 'Réseau & Sécurité',
            collapsed: true,
            items: [
              {
                text: 'Réseau',
                collapsed: true,
                items: [
                  { text: '1 - Configuration ACL', link: '/tp/reseau/1-acl.md' },
                  { text: '2 - Mise en place de pfSense', link: '/tp/reseau/3-pfsense.md' },
                  { text: '3 - DMZ & Règles de pare-feu', link: '/tp/reseau/4-pfsense-dmz.md' },
                ]
              },
            ]
          },
        ]
      },
      {
        items: [
          {
            text: 'Mémos',
            collapsed: true,
            items: [
              { text: 'HTML', link: '/memo/html.md' },
              { text: 'CSS', link: '/memo/css.md' },
              { text: 'JS', link: '/memo/js.md' },
              { text: 'PHP', link: '/memo/php.md' },
              { text: 'Git', link: '/memo/git.md' },
              { text: 'Switch', link: '/memo/switch.md' },
              { text: 'Routeur', link: '/memo/routeur.md' },
              { text: 'PowerShell', link: '/memo/powershell.md' },
              { text: 'WordPress', link: '/memo/wordpress.md' },
              { text: 'Docker', link: '/memo/docker.md' },
            ]
          },
        ]
      }
    ],

    // socialLinks: [
    //   { icon: 'github', link: 'https://github.com/vuejs/vitepress' }
    // ]
  }
})
