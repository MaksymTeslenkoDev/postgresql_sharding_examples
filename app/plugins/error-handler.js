'use-strict';

const fp = require('fastify-plugin');
module.exports = fp(function (fastify, opts, next) {
  fastify.setErrorHandler((err, req, reply) => {
    if (err.validation) {
      const { validation, message } = err;
      fastify.log.warn({ validationError: validation });
      reply.status(422).send({ message });
      return;
    }
    if (reply.statusCode >= 500) {
      req.log.error({ req, res: reply, err: err }, err?.message);
      reply.send(`Fatal error. Contact the support team. Id ${req.id}`);
      return;
    }
    req.log.info({ req, res: reply, err: err }, err?.message);
    reply.send(err);
  });
  next();
});
