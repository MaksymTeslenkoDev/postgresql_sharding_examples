'use-strict';

const fp = require('fastify-plugin');

module.exports = fp(
  async function configPostgresql(fastify, opts) {
    await fastify.register(require('@fastify/postgres'), {
      connectionString: `postgres://${opts.pg.user}:${opts.pg.password}@${opts.pg.host}/${opts.pg.db}`,
    });
  },
  {
    name: 'postgresql-config',
  },
);
