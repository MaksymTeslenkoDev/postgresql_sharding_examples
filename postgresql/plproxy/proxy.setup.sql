-- setup
CREATE EXTENSION IF NOT EXISTS plproxy;
CREATE SCHEMA IF NOT EXISTS plproxy;

CREATE TYPE products AS (
    id INT,
    name VARCHAR(255),
    price NUMERIC(10, 2),
    amount INT,
    product_type INT
);

CREATE OR REPLACE FUNCTION plproxy.get_cluster_config(
    IN cluster_name text,
    OUT key text,
    OUT val text)
RETURNS SETOF record AS $$
BEGIN
    -- lets use same config for all clusters
    key := 'connection_lifetime';
    val := 30*60; -- 30m
    RETURN NEXT;
    RETURN;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION plproxy.get_cluster_partitions(cluster_name text)
RETURNS SETOF TEXT AS $$
BEGIN
    IF cluster_name = 'products_cluster' THEN
        RETURN NEXT 'host=plproxy_store_shard1 port=5432 dbname=store user=marcus password=marcus';
        RETURN NEXT 'host=plproxy_store_shard1 port=5432 dbname=store user=marcus password=marcus';
        RETURN NEXT 'host=plproxy_store_shard2 port=5432 dbname=store user=marcus password=marcus';
        RETURN NEXT 'host=plproxy_store_shard3 port=5432 dbname=store user=marcus password=marcus';
        RETURN;
    END IF;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION plproxy.get_cluster_version(cluster_name text)
RETURNS int4 AS $$
BEGIN
    IF cluster_name = 'products_cluster' THEN
        RETURN 1;
    END IF;
    RAISE EXCEPTION 'Unknown cluster';
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION partition_function(key int)
RETURNS INTEGER AS $$
BEGIN
    RETURN key;
END;
$$ LANGUAGE plpgsql IMMUTABLE STRICT;

CREATE OR REPLACE FUNCTION insert_product(name text, price numeric, amount int, product_type int) RETURNS int AS $$
    CLUSTER 'products_cluster';
    RUN ON partition_function(product_type);
$$ LANGUAGE plproxy;

CREATE OR REPLACE FUNCTION get_product_by_type(product_type INT, limit_param INT, offset_param INT)
RETURNS SETOF products AS $$
    CLUSTER 'products_cluster';
    RUN ON partition_function(product_type);
$$ LANGUAGE plproxy;

-- Having 3 shards and specify LIMIT 10, we may receive up to 30 rows in total (10 from each shard).
CREATE OR REPLACE FUNCTION get_products_filtered(product_type INT, amount_min NUMERIC, amount_max NUMERIC, price_min NUMERIC, price_max NUMERIC, limit_param INT, offset_param INT)
RETURNS SETOF products AS $$
    CLUSTER 'products_cluster';
    RUN ON partition_function(product_type);
$$ LANGUAGE plproxy;