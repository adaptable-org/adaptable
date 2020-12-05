// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/webpacker and only use these pack files to reference
// that code so it'll be compiled.

// Rails JS
require('@rails/ujs').start()
require('turbolinks').start()
require('@rails/activestorage').start()
require('channels')

// Handle fonts in app/webpacker/stylesheets via webpacker
// Rails: <%= asset_pack_tag 'font.woff2' %>)
// CSS: <%= url('font.woff2') %>)
// require.context('../stylesheets/application.scss');
require.context('../fonts', true)

// Handle images in app/webpacker/images via webpacker
// Rails: <%= image_pack_tag 'rails.png' %>)
// JavaScript: `imagePath` JavaScript helper below.
const images = require.context('../images', true)
const imagePath = (name) => images(name, true)
