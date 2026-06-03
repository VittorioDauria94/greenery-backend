# Greenery Backend

REST API backend for **Greenery**, a fictional sustainable product aggregator / e-commerce platform focused on eco-friendly products selected from credible partners.

The backend manages products, categories, sustainable partners and orders. It also handles product image uploads, unique product slugs, server-side order total calculation and stock updates.

## Technologies

- Node.js
- Express
- MySQL
- mysql2
- CORS
- Multer
- Slugify

## Database name

```txt
greenery_db
```

## Project structure

```txt
greenery-backend/
├── app.js
├── config/
│   └── db.js
├── controllers/
│   ├── productController.js
│   ├── categoryController.js
│   ├── partnerController.js
│   └── orderController.js
├── routes/
│   ├── productRoutes.js
│   ├── categoryRoutes.js
│   ├── partnerRoutes.js
│   └── orderRoutes.js
├── middlewares/
│   ├── notFound.js
│   ├── errorsHandler.js
│   └── uploadProductImage.js
├── database/
│   └── schema.sql
├── public/
│   └── images/
│       └── products/
├── .env.example
├── .gitignore
├── package.json
├── package-lock.json
└── README.md
```

## Features

- MySQL database connection
- Products API
- Categories API
- Sustainable partners API
- Orders API
- Product image upload with Multer
- Product slug generation with Slugify
- Unique product slugs
- Product creation
- Full product update
- Partial product update
- Product deletion
- Basic order data validation
- Product existence check
- Stock availability check
- Server-side order total calculation
- Order items creation
- Product stock update after order creation
- MySQL transactions for order creation
- Not found middleware
- Error handler middleware
- Environment-based error responses

## Main database tables

```txt
categories
partners
products
orders
order_items
```

## Setup

Install dependencies:

```bash
npm install
```

Create a `.env` file based on `.env.example`.

Example `.env`:

```env
NODE_ENV=development

PORT=3000

DB_HOST=localhost
DB_USER=root
DB_PASSWORD=
DB_NAME=greenery_db
DB_PORT=3306

FRONTEND_URL=http://localhost:5173
```

Start the development server:

```bash
npm run dev
```

Start the production server:

```bash
npm start
```

The server will run at:

```txt
http://localhost:3000
```

## Database setup

To create the database, tables and initial seed data, run:

```txt
database/schema.sql
```

Using MySQL Workbench:

```txt
File > Open SQL Script
```

Then select `schema.sql` and execute the full script.

Using terminal, if the `mysql` command is available:

```bash
mysql -u root -p < database/schema.sql
```

## API endpoints

### Health check

```txt
GET /api/health
```

Example response:

```json
{
  "status": "ok",
  "message": "Greenery backend is running"
}
```

---

## Products

### Get all products

```txt
GET /api/products
```

Returns all products with related category and partner data.

Supported query params:

```txt
?category=igiene-personale
?search=bamboo
?featured=true
```

Examples:

```txt
GET /api/products
GET /api/products?category=igiene-personale
GET /api/products?search=bamboo
GET /api/products?featured=true
```

---

### Get product details

```txt
GET /api/products/:slug
```

Returns a single product by slug.

Example:

```txt
GET /api/products/spazzolino-in-bamboo
```

Error response if the product does not exist:

```json
{
  "message": "Product not found"
}
```

---

### Create product

```txt
POST /api/products
```

Creates a new product.

The request must be sent as:

```txt
form-data
```

Supported fields:

```txt
category_id
partner_id
name
description
material
packaging
certification
eco_badge
origin
price
stock
is_featured
image
```

The `image` field is optional and must be sent as a file.

Example fields:

```txt
category_id: 1
partner_id: 1
name: Bamboo razor
description: Sustainable razor with bamboo handle and replaceable blades.
material: Natural bamboo and steel
packaging: Recycled cardboard
certification: FSC
eco_badge: Plastic free
origin: Italy
price: 12.90
stock: 20
is_featured: true
image: image file
```

Example response:

```json
{
  "message": "Product created successfully",
  "data": {
    "id": 11,
    "name": "Bamboo razor",
    "slug": "bamboo-razor",
    "image": "images/products/file-name.jpg"
  }
}
```

The slug is automatically generated from the product name.

If a product with the same slug already exists, the backend generates a unique slug:

```txt
bamboo-razor
bamboo-razor-2
bamboo-razor-3
```

---

### Full product update

```txt
PUT /api/products/:id
```

Fully updates an existing product.

The request must be sent as:

```txt
form-data
```

Main fields:

```txt
category_id
partner_id
name
description
material
packaging
certification
eco_badge
origin
price
stock
is_featured
image
```

The `image` field is optional.

If a new image is uploaded, the backend updates the product and removes the old image from:

```txt
public/images/products
```

Example response:

```json
{
  "message": "Product updated successfully",
  "data": {
    "id": 11,
    "name": "Premium bamboo razor",
    "slug": "premium-bamboo-razor",
    "image": "images/products/file-name.jpg"
  }
}
```

---

### Partial product update

```txt
PATCH /api/products/:id
```

Updates only the provided fields.

Example:

```txt
PATCH /api/products/11
```

Body `form-data`:

```txt
price: 15.90
stock: 30
```

In this case, only `price` and `stock` are updated. All other fields remain unchanged.

The `image` field is also optional. If a new image is uploaded, the old image is removed.

Example response:

```json
{
  "message": "Product modified successfully",
  "data": {
    "id": 11,
    "name": "Premium bamboo razor",
    "slug": "premium-bamboo-razor",
    "image": "images/products/file-name.jpg"
  }
}
```

---

### Delete product

```txt
DELETE /api/products/:id
```

Deletes a product from the database.

Example:

```txt
DELETE /api/products/11
```

Example response:

```json
{
  "message": "Product deleted successfully"
}
```

If the product has an image, the backend also tries to remove it from:

```txt
public/images/products
```

Error response if the product does not exist:

```json
{
  "message": "Product not found"
}
```

---

## Categories

### Get all categories

```txt
GET /api/categories
```

Returns all categories with the number of related products.

---

### Get products by category

```txt
GET /api/categories/:slug/products
```

Example:

```txt
GET /api/categories/igiene-personale/products
```

Error response if the category does not exist:

```json
{
  "message": "Category not found"
}
```

---

## Partners

### Get all partners

```txt
GET /api/partners
```

Returns all sustainable partners with the number of related products.

---

### Get partner details

```txt
GET /api/partners/:slug
```

Example:

```txt
GET /api/partners/bamboolife
```

Returns the partner details and related products.

Error response if the partner does not exist:

```json
{
  "message": "Partner not found"
}
```

---

## Orders

### Create order

```txt
POST /api/orders
```

Creates a new order.

Example body:

```json
{
  "customer_name": "Mario Rossi",
  "customer_email": "mario@email.com",
  "customer_address": "Via Roma 10",
  "customer_city": "Cagliari",
  "customer_phone": "3331234567",
  "items": [
    {
      "product_id": 1,
      "quantity": 2
    },
    {
      "product_id": 5,
      "quantity": 1
    }
  ]
}
```

Example response:

```json
{
  "message": "Order created successfully",
  "data": {
    "order_id": 1,
    "total_price": 22.88
  }
}
```

The total price is calculated on the backend using the product prices stored in the database.

The backend also checks that:

- required customer data is present
- products exist
- requested quantities are valid
- enough stock is available
- product stock is updated after order creation

## Error handling

In development mode, detailed error information is returned to help debugging.

In production mode, internal errors return a generic message:

```json
{
  "message": "Internal Server Error"
}
```

This prevents exposing sensitive technical details.

## Available scripts

```bash
npm run dev
```

Starts the server in development mode with `--watch`.

```bash
npm start
```

Starts the server normally.

## Project status

### Completed

- Express setup
- MySQL connection
- Database schema
- Initial seed data for products, categories and partners
- Products API
- Categories API
- Partners API
- Order creation API
- Product CRUD
- Product image upload
- Product slug generation
- Unique product slugs
- Not found middleware
- Error handler middleware
- Environment-based error handling

### To do

- Advanced validation
- Admin authentication
- Protected admin routes
- Category management
- Partner management
- Backend deployment
