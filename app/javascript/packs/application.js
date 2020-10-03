// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

// Rails JS
require('@rails/ujs').start()
require('turbolinks').start()
require('@rails/activestorage').start()
require('channels')

// Handle images in app/javascript/images via webpacker
// Rails: <%= image_pack_tag 'rails.png' %>)
// JavaScript: `imagePath` JavaScript helper below.
const images = require.context('../images', true)
const imagePath = (name) => images(name, true)

// Tailwind CSS
import 'tailwind/tailwind'
import 'stylesheets/application'
