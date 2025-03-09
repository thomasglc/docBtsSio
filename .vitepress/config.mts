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
            text: 'Travaux pratiques',
            collapsed: false,
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
                text: 'Git',
                collapsed: true,

                items: [
                  { text: '1 - Découverte', link: '/tp/git/1-decouverte.md' },
                  { text: '2 - Git et Github', link: '/tp/git/2-gitAndGithub.md' },
                ]
              }
            ]
          },
        ]
      },
      {
        items: [
          {
            text: 'Mémos',
            collapsed: false,
            items: [
              { text: 'HTML', link: '/memo/html.md' },
              { text: 'CSS', link: '/memo/css.md' },
              { text: 'JS', link: '/memo/js.md' },
              { text: 'PHP', link: '/memo/php.md' },
              { text: 'Git', link: '/memo/git.md' },

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
