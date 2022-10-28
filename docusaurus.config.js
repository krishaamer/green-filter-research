// @ts-check
// Note: type annotations allow type checking and IDEs autocompletion

const lightCodeTheme = require("prism-react-renderer/themes/github");
const darkCodeTheme = require("prism-react-renderer/themes/dracula");

/** @type {import('@docusaurus/types').Config} */
const config = {
  title: "Green Filter",
  tagline:
    "How can people build closer relationships with sustainability-focused companies? A research project for designing a sustainable shopping, savings, and investing companion.",
  url: "https://www.greenfilter.app/",
  baseUrl: "/",
  onBrokenLinks: "throw",
  onBrokenMarkdownLinks: "warn",
  favicon: "img/favicon.ico",
  i18n: {
    defaultLocale: "en",
    locales: ["en"],
  },

  presets: [
    [
      "classic",
      /** @type {import('@docusaurus/preset-classic').Options} */
      ({
        docs: {
          path: "research",
          routeBasePath: "research",
          sidebarPath: require.resolve("./sidebars.js"),
          /*editUrl:
            "https://github.com/krishaamer/green-filter-research/blob/main/",*/
          showLastUpdateAuthor: true,
          showLastUpdateTime: true,
        },
        blog: {
          showReadingTime: true,
          /*editUrl:
            "https://github.com/krishaamer/green-filter-research/blob/main/",*/
        },
        theme: {
          customCss: require.resolve("./src/css/custom.css"),
        },
        gtag: {
          trackingID: "G-7N4XR6H9HF",
          anonymizeIP: false,
        },
      }),
    ],
  ],

  plugins: [
    [
      "@docusaurus/plugin-ideal-image",
      {
        quality: 95,
        max: 1980, // max resized image's size.
        min: 1600, // min resized image's size. if original is lower, use that size.
        steps: 3, // the max number of images generated between min and max (inclusive)
        disableInDev: true,
      },
    ],
    [
      "@docusaurus/plugin-content-docs",
      {
        id: "prototypes",
        path: "prototypes",
        routeBasePath: "prototypes",
        sidebarPath: require.resolve("./sidebars.js"),
      },
    ],
    [
      "@docusaurus/plugin-content-docs",
      {
        id: "surveys",
        path: "surveys",
        routeBasePath: "surveys",
        sidebarPath: require.resolve("./sidebars.js"),
      },
    ],
  ],

  themeConfig:
    /** @type {import('@docusaurus/preset-classic').ThemeConfig} */
    ({
      navbar: {
        title: "Green Filter",
        items: [
          {
            type: "doc",
            docId: "abstract/index",
            position: "left",
            label: "Research",
          },
          { to: "/prototypes", label: "Prototypes", position: "left" },
          { to: "/surveys", label: "Surveys", position: "left" },
          { to: "/database", label: "Database", position: "left" },
          { to: "/blog", label: "Blog", position: "left" },
        ],
      },
      footer: {
        style: "light",
        copyright: `The Journey from Consumer to Investor: Designing a Financial AI Companion for Young Adults to Help with Sustainable Shopping, Savings, and Investing <br />Copyright © ${new Date().getFullYear()} GreenFilter.app `,
      },
      prism: {
        theme: lightCodeTheme,
        darkTheme: darkCodeTheme,
      },
    }),
};

module.exports = config;
