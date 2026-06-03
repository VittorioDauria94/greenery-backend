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
('Igiene personale', 'igiene-personale', 'Prodotti sostenibili per la cura quotidiana della persona.'),
('Casa sostenibile', 'casa-sostenibile', 'Soluzioni eco-friendly per la pulizia e la gestione della casa.'),
('Cucina plastic free', 'cucina-plastic-free', 'Prodotti riutilizzabili e alternativi alla plastica monouso.'),
('Accessori riutilizzabili', 'accessori-riutilizzabili', 'Accessori pensati per ridurre gli sprechi nella vita quotidiana.'),
('Cosmetici naturali', 'cosmetici-naturali', 'Cosmetici con ingredienti naturali e packaging sostenibile.');

INSERT INTO partners 
(name, slug, description, website, logo, is_verified, sustainability_note)
VALUES
('BambooLife', 'bamboolife', 'Partner specializzato in prodotti per l’igiene personale realizzati in bamboo.', 'https://example.com/bamboolife', 'bamboolife-logo.png', TRUE, 'Utilizza materiali biodegradabili e packaging plastic free.'),

('PureNest', 'purenest', 'Brand dedicato a prodotti naturali per la cura della persona e della casa.', 'https://example.com/purenest', 'purenest-logo.png', TRUE, 'Predilige ingredienti naturali e filiere a basso impatto.'),

('ReUse Lab', 'reuse-lab', 'Partner focalizzato su accessori riutilizzabili per cucina, spesa e tempo libero.', 'https://example.com/reuse-lab', 'reuse-lab-logo.png', TRUE, 'Promuove prodotti durevoli e alternative alla plastica monouso.'),

('GreenHome', 'greenhome', 'Brand dedicato alla casa sostenibile e ai prodotti per la pulizia eco-friendly.', 'https://example.com/greenhome', 'greenhome-logo.png', FALSE, 'Partner in fase di verifica, con prodotti orientati alla riduzione degli sprechi.');

INSERT INTO products 
(category_id, partner_id, name, slug, description, material, packaging, certification, eco_badge, origin, price, image, stock, is_featured)
VALUES
(1, 1, 'Spazzolino in bamboo', 'spazzolino-in-bamboo', 'Spazzolino ecologico con manico in bamboo biodegradabile e setole delicate, pensato per ridurre l’uso quotidiano di plastica.', 'Bamboo naturale', 'Confezione in cartoncino riciclato', 'FSC', 'Plastic free', 'Italia', 3.99, 'spazzolino-bamboo.jpg', 50, TRUE),

(1, 1, 'Cotton fioc biodegradabili', 'cotton-fioc-biodegradabili', 'Cotton fioc realizzati con materiali compostabili, ideali per sostituire le alternative in plastica monouso.', 'Carta e cotone', 'Scatola in carta riciclata', NULL, 'Biodegradabile', 'Italia', 2.49, 'cotton-fioc-biodegradabili.jpg', 80, FALSE),

(5, 2, 'Sapone solido naturale', 'sapone-solido-naturale', 'Sapone naturale senza plastica, delicato sulla pelle e adatto all’uso quotidiano.', 'Ingredienti naturali', 'Fascia in carta riciclata', NULL, 'Zero waste', 'Italia', 4.90, 'sapone-solido-naturale.jpg', 40, TRUE),

(5, 2, 'Shampoo solido', 'shampoo-solido', 'Shampoo solido eco-friendly, senza flacone in plastica e con ingredienti naturali.', 'Ingredienti naturali', 'Carta riciclata', NULL, 'Plastic free', 'Italia', 6.90, 'shampoo-solido.jpg', 35, TRUE),

(4, 3, 'Borraccia in acciaio', 'borraccia-in-acciaio', 'Borraccia riutilizzabile in acciaio inox, perfetta per ridurre l’uso di bottiglie in plastica.', 'Acciaio inox', 'Cartoncino riciclato', NULL, 'Riutilizzabile', 'Europa', 14.90, 'borraccia-acciaio.jpg', 25, TRUE),

(3, 3, 'Pellicola alimentare in cera d’api', 'pellicola-alimentare-cera-api', 'Alternativa riutilizzabile alla pellicola trasparente, realizzata con cera d’api naturale.', 'Cotone e cera d’api', 'Carta riciclata', NULL, 'Riutilizzabile', 'Italia', 8.50, 'pellicola-cera-api.jpg', 30, FALSE),

(3, 3, 'Sacchetti in cotone riutilizzabili', 'sacchetti-cotone-riutilizzabili', 'Set di sacchetti in cotone lavabili, ideali per spesa, frutta e verdura.', 'Cotone naturale', 'Fascetta in carta', NULL, 'Riutilizzabile', 'Italia', 7.90, 'sacchetti-cotone.jpg', 45, TRUE),

(2, 4, 'Spugna naturale', 'spugna-naturale', 'Spugna naturale biodegradabile per la pulizia della casa e della cucina.', 'Fibra naturale', 'Carta riciclata', NULL, 'Biodegradabile', 'Europa', 5.50, 'spugna-naturale.jpg', 60, FALSE),

(2, 4, 'Detersivo eco-friendly', 'detersivo-eco-friendly', 'Detersivo ecologico con formula delicata e ingredienti a basso impatto ambientale.', 'Formula ecologica', 'Flacone riciclato', NULL, 'Packaging riciclato', 'Italia', 9.90, 'detersivo-eco.jpg', 20, FALSE),

(1, 1, 'Pettine in legno', 'pettine-in-legno', 'Pettine resistente in legno naturale, alternativa sostenibile ai pettini in plastica.', 'Legno naturale', 'Cartoncino riciclato', 'FSC', 'Plastic free', 'Italia', 4.50, 'pettine-legno.jpg', 55, FALSE);

