'use strict'

const path = require('node:path')
const AutoLoad = require('@fastify/autoload')

module.exports = async function (fastify, opts) {
  await fastify.register(require('./configs/config'))
  fastify.log.info('Config loaded %o', fastify.config)

  fastify.register(AutoLoad, {
    dir: path.join(__dirname, 'plugins'),
    ignorePattern: /.*.no-load\.js/,
    indexPattern: /^no$/i,
    options: fastify.config
  })

  fastify.register(AutoLoad, {
    dir: path.join(__dirname, 'routes'),
    indexPattern: /.*routes(\.js|\.cjs)$/i,
    ignorePattern: /.*\.js/,
    autoHooksPattern: /.*hooks(\.js|\.cjs)$/i,
    autoHooks: true,
    cascadeHooks: true,
    options: fastify.config
  })
}

module.exports.options = require('./configs/server-options');
