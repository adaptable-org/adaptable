module.exports = {
  purge: {
    enabled: false,
    content: [
      './app/**/*.html',
      './app/**/*.html.erb',
      './app/**/*._helper.rb',
    ],
  },
  theme: {
    fontFamily: {
      display: ['Helvetica', 'Arial', 'sans-serif'],
      body: ['Georgia', 'Times', 'serif'],
    },
    extend: {
      colors: {
        'adpt-navy': '#111c4c',
        'adpt-turquoise': '#32cc97',
        'adpt-dark-turquoise': '#228f69',
        'adpt-green': '#aacf01',
        'adpt-dark-green': '#779100',
        'adpt-pink': '#ff3571',
        'adpt-dark-pink': '#b3254f',
        'adpt-purple': '#dc38b1',
        'adpt-dark-purple': '#9a287c',
        'adpt-cornflower': '#677de6',
        'adpt-dark-cornflower': '#4858a0',
      },
    },
  },
  variants: {},
  plugins: [require('@tailwindcss/ui')],
}
