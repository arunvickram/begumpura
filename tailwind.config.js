/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    "./resources/templates/**/*.crotmp"
  ],
  theme: {
    extend: {
      fontFamily: {
        brand: "'Kuficality'"
      }
    },
  },
  plugins: [
    require('flowbite/plugin')
  ],
}

