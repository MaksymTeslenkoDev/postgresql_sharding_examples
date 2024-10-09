-- setup
CREATE EXTENSION IF NOT EXISTS plproxy;
CREATE SCHEMA IF NOT EXISTS plproxy;

CREATE OR REPLACE FUNCTION plproxy.get_cluster_partitions(cluster_name text)
RETURNS SETOF text AS $$
BEGIN
    IF cluster_name = 'products_cluster' THEN
        RETURN NEXT 'host=store_main port=5432 dbname=store user=marcus';
        RETURN NEXT 'host=plproxy_store_shard2 port=5432 dbname=store user=marcus';
        RETURN NEXT 'host=plproxy_store_shard3 port=5432 dbname=store user=marcus';
    END IF;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION plproxy.partition_function(product_type integer)
RETURNS integer AS $$
BEGIN
    IF product_type = 2 THEN
        RETURN 2;
    ELSIF product_type = 3 THEN
        RETURN 3;
    ELSE
        RETURN 1;
    END IF;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION insert_data(product_type integer, name text, price numeric, amount int) RETURNS void AS $$
    CLUSTER 'products_cluster';
    RUN ON partition_function(product_type);
$$ LANGUAGE plproxy;