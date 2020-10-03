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
        'adpt-teal': '#32cc97',
        'adpt-dark-teal': '#228f69',
        'adpt-lime': '#aacf01',
        'adpt-dark-lime': '#779100',
        'adpt-red': '#ff3571',
        'adpt-dark-red': '#b3254f',
        'adpt-pink': '#dc38b1',
        'adpt-dark-pink': '#9a287c',
        'adpt-blurple': '#677de6',
        'adpt-dark-blurple': '#4858a0',
      },
    },
  },
  variants: {},
  future: {
    purgeLayersByDefault: true,
    removeDeprecatedGapUtilities: true,
  },
  plugins: [require('@tailwindcss/ui')],
}
