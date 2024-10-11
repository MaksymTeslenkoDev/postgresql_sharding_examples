'use strict';
const fp = require('fastify-plugin');

class NativeQueryBuilder {
  static insert() {
    return 'INSERT INTO products(name, price, amount, product_type) VALUES($1,$2,$3,$4)';
  }
  static filter() {
    return `SELECT * FROM products
                WHERE product_type = $1
                    AND amount BETWEEN $2 AND $3
                AND price BETWEEN $4 AND $5
                LIMIT $6 OFFSET $7;`;
  }
}
class ProxyQueryBuilder {
  static insert() {
    return 'SELECT insert_product($1, $2, $3, $4)';
  }
  static filter() {
    return `SELECT * FROM get_products_filtered($1, $2, $3, $4, $5, $6, $7);`;
  }
}

function getQueryBuilder(type) {
  switch (type) {
    case 'native':
      return NativeQueryBuilder;
    case 'proxy':
      return ProxyQueryBuilder;
    default:
      return null;
  }
}

const type = 'native';
module.exports = fp(async function productAutoHooks(fastify, opts) {
  const queryBuilder = getQueryBuilder(type);

  if (!queryBuilder)
    throw new Error(
      "Query type not valid, available options are 'native' or 'proxy'",
    );

  fastify.decorate('queryBuilder', queryBuilder);
});
