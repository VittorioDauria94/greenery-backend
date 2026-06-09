CREATE DATABASE IF NOT EXISTS greenery_db;

USE greenery_db;

DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS partners;
DROP TABLE IF EXISTS categories;

CREATE TABLE categories (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  slug VARCHAR(120) NOT NULL UNIQUE,
  description TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE partners (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(120) NOT NULL,
  slug VARCHAR(150) NOT NULL UNIQUE,
  description TEXT,
  website VARCHAR(255),
  logo VARCHAR(255),
  is_verified BOOLEAN NOT NULL DEFAULT FALSE,
  sustainability_note TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE products (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  category_id INT UNSIGNED,
  partner_id INT UNSIGNED,
  name VARCHAR(150) NOT NULL,
  slug VARCHAR(180) NOT NULL UNIQUE,
  description TEXT NOT NULL,
  material VARCHAR(150),
  packaging VARCHAR(150),
  certification VARCHAR(150),
  eco_badge VARCHAR(100),
  origin VARCHAR(120),
  price DECIMAL(10, 2) NOT NULL,
  image VARCHAR(255),
  stock INT UNSIGNED NOT NULL DEFAULT 0,
  is_featured BOOLEAN NOT NULL DEFAULT FALSE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

  FOREIGN KEY (category_id)
    REFERENCES categories(id)
    ON DELETE SET NULL,

  FOREIGN KEY (partner_id)
    REFERENCES partners(id)
    ON DELETE SET NULL
);

CREATE TABLE orders (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  customer_name VARCHAR(100) NOT NULL,
  customer_email VARCHAR(150) NOT NULL,
  customer_address VARCHAR(255) NOT NULL,
  customer_city VARCHAR(100) NOT NULL,
  customer_phone VARCHAR(30),
  total_price DECIMAL(10, 2) NOT NULL,
  status ENUM('pending', 'confirmed', 'shipped', 'cancelled') NOT NULL DEFAULT 'pending',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE order_items (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  order_id INT UNSIGNED NOT NULL,
  product_id INT UNSIGNED,
  product_name VARCHAR(150) NOT NULL,
  quantity INT UNSIGNED NOT NULL,
  unit_price DECIMAL(10, 2) NOT NULL,
  subtotal DECIMAL(10, 2) NOT NULL,

  FOREIGN KEY (order_id)
    REFERENCES orders(id)
    ON DELETE CASCADE,

  FOREIGN KEY (product_id)
    REFERENCES products(id)
    ON DELETE SET NULL
);

INSERT INTO categories (name, slug, description) VALUES
('Abbigliamento', 'abbigliamento', 'Capi e accessori realizzati con materiali sostenibili, riciclati o biologici.'),
('Igiene', 'igiene-personale', 'Prodotti sostenibili per la cura quotidiana della persona.'),
('Cosmesi', 'cosmetici-naturali', 'Cosmetici naturali con ingredienti selezionati e packaging sostenibile.'),
('Animali', 'animali', 'Prodotti eco-friendly pensati per la cura degli animali domestici.'),
('Casa', 'casa-sostenibile', 'Soluzioni sostenibili per la pulizia e la gestione della casa.');

INSERT INTO partners 
(name, slug, description, website, logo, is_verified, sustainability_note)
VALUES
('OrganicWear', 'organicwear', 'Partner specializzato in abbigliamento sostenibile e materiali biologici.', 'https://example.com/organicwear', 'organicwear-logo.png', TRUE, 'Utilizza cotone biologico certificato e materiali riciclati.'),

('BambooLife', 'bamboolife', 'Partner specializzato in prodotti per l’igiene personale realizzati in bamboo e materiali plastic free.', 'https://example.com/bamboolife', 'bamboolife-logo.png', TRUE, 'Promuove alternative biodegradabili ai prodotti monouso in plastica.'),

('PureNest', 'purenest', 'Brand dedicato a cosmetici naturali e prodotti per la cura della persona.', 'https://example.com/purenest', 'purenest-logo.png', TRUE, 'Predilige ingredienti naturali e packaging a basso impatto ambientale.'),

('EcoPaw', 'ecopaw', 'Partner dedicato a prodotti sostenibili per animali domestici.', 'https://example.com/ecopaw', 'ecopaw-logo.png', TRUE, 'Propone accessori e prodotti biodegradabili per la cura degli animali.'),

('GreenHome', 'greenhome', 'Brand dedicato alla casa sostenibile e ai prodotti per la pulizia eco-friendly.', 'https://example.com/greenhome', 'greenhome-logo.png', TRUE, 'Sviluppa prodotti per ridurre sprechi, plastica e impatto ambientale domestico.');

INSERT INTO products 
(category_id, partner_id, name, slug, description, material, packaging, certification, eco_badge, origin, price, image, stock, is_featured)
VALUES
(1, 1, 'T-shirt in cotone biologico', 't-shirt-cotone-biologico', 'T-shirt realizzata in cotone biologico, morbida e pensata per ridurre l’impatto ambientale dell’abbigliamento quotidiano.', 'Cotone biologico', 'Packaging in carta riciclata', 'GOTS', 'Cotone bio', 'Italia', 24.90, 'tshirt-cotone-biologico.jpg', 35, TRUE),

(1, 1, 'Shopper in cotone riciclato', 'shopper-cotone-riciclato', 'Borsa shopper resistente e riutilizzabile, realizzata in cotone riciclato per sostituire le borse monouso.', 'Cotone riciclato', 'Fascetta in carta riciclata', NULL, 'Riutilizzabile', 'Italia', 9.90, 'shopper-cotone-riciclato.jpg', 50, TRUE),

(2, 2, 'Spazzolino in bamboo', 'spazzolino-in-bamboo', 'Spazzolino ecologico con manico in bamboo biodegradabile e setole delicate, pensato per ridurre l’uso quotidiano di plastica.', 'Bamboo naturale', 'Confezione in cartoncino riciclato', 'FSC', 'Plastic free', 'Italia', 3.99, 'spazzolino-bamboo.jpg', 70, TRUE),

(2, 2, 'Cotton fioc biodegradabili', 'cotton-fioc-biodegradabili', 'Cotton fioc realizzati con materiali compostabili, ideali per sostituire le alternative in plastica monouso.', 'Carta e cotone', 'Scatola in carta riciclata', NULL, 'Biodegradabile', 'Italia', 2.49, 'cotton-fioc-biodegradabili.jpg', 90, FALSE),

(3, 3, 'Shampoo solido naturale', 'shampoo-solido-naturale', 'Shampoo solido eco-friendly, senza flacone in plastica e con ingredienti naturali.', 'Ingredienti naturali', 'Carta riciclata', NULL, 'Plastic free', 'Italia', 6.90, 'shampoo-solido.jpg', 45, TRUE),

(3, 3, 'Sapone solido delicato', 'sapone-solido-delicato', 'Sapone naturale senza plastica, delicato sulla pelle e adatto all’uso quotidiano.', 'Ingredienti naturali', 'Fascia in carta riciclata', NULL, 'Zero waste', 'Italia', 4.90, 'sapone-solido-delicato.jpg', 55, TRUE),

(4, 4, 'Ciotola in bamboo per animali', 'ciotola-bamboo-animali', 'Ciotola resistente per animali domestici realizzata con fibre di bamboo, leggera e facile da pulire.', 'Fibre di bamboo', 'Cartoncino riciclato', NULL, 'Plastic free', 'Europa', 12.90, 'ciotola-bamboo-animali.jpg', 30, TRUE),

(4, 4, 'Sacchetti biodegradabili per animali', 'sacchetti-biodegradabili-animali', 'Rotoli di sacchetti biodegradabili pensati per la gestione quotidiana degli animali domestici.', 'Materiale biodegradabile', 'Confezione in carta riciclata', NULL, 'Biodegradabile', 'Italia', 5.90, 'sacchetti-biodegradabili-animali.jpg', 80, FALSE),

(5, 5, 'Detersivo eco-friendly', 'detersivo-eco-friendly', 'Detersivo ecologico con formula delicata e ingredienti a basso impatto ambientale.', 'Formula ecologica', 'Flacone riciclato', NULL, 'Packaging riciclato', 'Italia', 9.90, 'detersivo-eco.jpg', 25, FALSE),

(5, 5, 'Spugna naturale compostabile', 'spugna-naturale-compostabile', 'Spugna naturale biodegradabile per la pulizia della casa e della cucina.', 'Fibra naturale', 'Carta riciclata', NULL, 'Biodegradabile', 'Europa', 5.50, 'spugna-naturale-compostabile.jpg', 60, TRUE);

