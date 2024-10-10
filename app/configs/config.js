const fp = require('fastify-plugin');
require('dotenv').config({ path:'../.env' });

module.exports = fp(
  async function configLoader(fastify, opts) {
    fastify.decorate('config', {
      pg: {
        host: process.env.DB_HOST,
        port: process.env.DB_PORT,
        db: process.env.DB_NAME,
        user: process.env.DB_USER,
        password: process.env.DB_PASSWORD
      },
      server: {
        host: process.env.HOST,
        port: process.env.PORT,
      },
      path: {
        app: process.cwd(),
      },
    });
  },
  {
    name: 'application-config',
  },
);
