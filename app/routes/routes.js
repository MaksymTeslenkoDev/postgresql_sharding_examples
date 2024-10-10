'use strict';
const { faker } = require('@faker-js/faker');

async function* generator(amount) {
  for (let i = 0; i < amount; i++) {
    const name = faker.commerce.productName();
    const price = faker.commerce.price(300, 1000, 2); // Price between $300 and $1000
    const amount = faker.number.int({ min: 10, max: 100 });
    const type = faker.number.int({ min: 1, max: 3 });
    yield { name, price, amount, type };
  }
}

module.exports = async function productsRoutes(fastify, opts) {
  fastify.route({
    method: 'POST',
    url: '/products/:count',
    handler: async function insertProductsHandler(request, reply) {
      fastify.log.info('params ', request.params);
      const { count } = request.params;

      if (!count) throw new Error('count not provided');
      const client = await fastify.pg.connect();
      fastify.log.info(`Start inserting ${count} products`);
      try {
        for await (let { name, price, amount, type } of generator(count)) {
          const id = await client.query(
            'INSERT INTO products(name, price, amount, product_type) VALUES($1,$2,$3,$4) RETURNING id',
            [name, price, amount, type],
          );
          fastify.log.info(`New row inserted: { id: ${id} }`);
        }
        fastify.log.info(`Finished`);
        return `Insertion of ${count} items finished`;
      } catch (err) {
        client.release();
        throw err;
      }
    },
  });
};
