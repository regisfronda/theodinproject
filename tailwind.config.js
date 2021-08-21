module.exports = {
  purge: [],
  darkMode: false, // or 'media' or 'class'
  theme: {
    extend: {},
    colors: {
      'nav-link-read': 'rgba(74, 74, 74, 0.7)',
      'nav-link-unread': '#ce973e',
      'no-new-notification': 'rgba(74, 74, 74, 0.7)',
      'new-notification': 'rgba(59, 130, 246, 0.7)'
    }
  },
  purge: {
    content: ["./app/**/*.html.erb"],
  },
  variants: {
    extend: {},
  },
  corePlugins: {
    container: false,
  },
  plugins: [],
}
