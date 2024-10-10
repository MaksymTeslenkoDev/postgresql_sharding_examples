SELECT insert_product('Iphone 12', 700, 20, 1);
SELECT insert_product('Samsung Galaxy S21', 800, 15, 1);
SELECT insert_product('Xiaomi Mi 11', 600, 25, 1);
SELECT insert_product('OnePlus 9', 700, 20, 1);
SELECT insert_product('Carpet', 920, 200, 2);
SELECT insert_product('Sponge Holder', 810, 1200, 2);
SELECT insert_product('Fleece', 400, 20, 3);
SELECT insert_product('T-Shirt', 753, 120,3);
SELECT insert_product('Long sleeve', 700, 12, 3);
SELECT insert_product('sweetshirt', 670, 87, 3);

-- Get products of type 1, limit 2, offset 1
SELECT * FROM get_product_by_type(1, 2, 1);

-- Get products with amount between 10 and 100, price between 600 and 800, limit 5, offset 0
SELECT * FROM get_products_filtered(10, 100, 600, 800, 5, 0);
-- Due to the RUN ON ALL, you may receive up to 5 products per shard.