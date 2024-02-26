/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    "./resources/templates/**/*.crotmp",
    "./node_modules/flowbite/**/*.js"
  ],
  theme: {
    extend: {
      fontFamily: {
        brand: "'Kuficality'",
        text: "'Martian Mono'"
      }
    },
  },
  plugins: [
    require('flowbite/plugin')
  ],
}

