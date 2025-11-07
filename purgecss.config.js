module.exports = {
  content: ['./index.html'],
  css: ['./tailwind-purged.css'],
  safelist: {
    standard: [
      /^md:/,
      /^lg:/,
      /^sm:/,
      /^xl:/,
      /^hover:/,
      /^focus:/,
      /^active:/,
      /^group-/,
      /^gap-/,
      /^grid-cols-/,
      /^space-/,
      /^transform/,
      /^translate/,
      /^scale/,
      /^rotate/
    ]
  }
}
