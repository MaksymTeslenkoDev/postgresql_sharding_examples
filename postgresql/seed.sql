-- insert data
-- INSERT INTO products (name, price, amount, product_type) VALUES 
-- ('Iphone 12', 700, 20, 1),
-- ('Samsung Galaxy S21', 800, 15, 1),
-- ('Xiaomi Mi 11', 600, 25, 1),
-- ('OnePlus 9', 700, 20, 1),
-- ('Carpet', 920, 200, 2),
-- ('Sponge Holder', 810, 1200, 2),
-- ('Fleece', 400, 20, 3),
-- ('T-Shirt', 753, 120, 3),
-- ('Long sleeve', 700, 12, 3),
-- ('sweetshirt', 670, 87, 3);

-- SELECT * FROM products;

SELECT insert_data(1, 'Iphone 12', 700, 20);
SELECT insert_data(1, 'Samsung Galaxy S21', 800, 15);
SELECT insert_data(1, 'Xiaomi Mi 11', 600, 25);
SELECT insert_data(1, 'OnePlus 9', 700, 20);
SELECT insert_data(2, 'Carpet', 920, 200);
SELECT insert_data(2, 'Sponge Holder', 810, 1200);
SELECT insert_data(3, 'Fleece', 400, 20);
SELECT insert_data(3, 'T-Shirt', 753, 120);
SELECT insert_data(3, 'Long sleeve', 700, 12);
SELECT insert_data(3, 'sweetshirt', 670, 87);