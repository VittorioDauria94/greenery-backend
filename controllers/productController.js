import connection from "../config/db.js";
import slugify from "slugify";

async function generateUniqueSlug(name) {
  const baseSlug = slugify(name, {
    lower: true,
    strict: true,
  });

  let slug = baseSlug;
  let counter = 2;

  while (true) {
    const [rows] = await connection.query(
      `
        SELECT id
        FROM products
        WHERE slug = ?
      `,
      [slug],
    );

    if (rows.length === 0) {
      return slug;
    }

    slug = `${baseSlug}-${counter}`;
    counter++;
  }
}

export async function index(req, res) {
  const { category, search, featured } = req.query;

  let sql = `
    SELECT 
      products.id,
      products.name,
      products.slug,
      products.description,
      products.material,
      products.packaging,
      products.certification,
      products.eco_badge,
      products.origin,
      products.price,
      products.image,
      products.stock,
      products.is_featured,
      categories.name AS category_name,
      categories.slug AS category_slug,
      partners.name AS partner_name,
      partners.slug AS partner_slug,
      partners.is_verified AS partner_is_verified
    FROM products
    LEFT JOIN categories
      ON products.category_id = categories.id
    LEFT JOIN partners
      ON products.partner_id = partners.id
    WHERE 1 = 1
  `;

  const params = [];

  if (category) {
    sql += ` AND categories.slug = ?`;
    params.push(category);
  }

  if (search) {
    sql += ` AND products.name LIKE ?`;
    params.push(`%${search}%`);
  }

  if (featured === "true") {
    sql += ` AND products.is_featured = TRUE`;
  }

  sql += ` ORDER BY products.created_at DESC`;

  const [products] = await connection.query(sql, params);

  res.json({
    count: products.length,
    data: products,
  });
}

export async function show(req, res) {
  const { slug } = req.params;

  const sql = `
    SELECT 
      products.id,
      products.name,
      products.slug,
      products.description,
      products.material,
      products.packaging,
      products.certification,
      products.eco_badge,
      products.origin,
      products.price,
      products.image,
      products.stock,
      products.is_featured,
      categories.name AS category_name,
      categories.slug AS category_slug,
      partners.name AS partner_name,
      partners.slug AS partner_slug,
      partners.description AS partner_description,
      partners.website AS partner_website,
      partners.logo AS partner_logo,
      partners.is_verified AS partner_is_verified,
      partners.sustainability_note AS partner_sustainability_note
    FROM products
    LEFT JOIN categories
      ON products.category_id = categories.id
    LEFT JOIN partners
      ON products.partner_id = partners.id
    WHERE products.slug = ?
  `;

  const [products] = await connection.query(sql, [slug]);

  if (products.length === 0) {
    return res.status(404).json({
      message: "Product not found",
    });
  }

  res.json({
    data: products[0],
  });
}

export async function store(req, res) {
  const {
    category_id,
    partner_id,
    name,
    description,
    material,
    packaging,
    certification,
    eco_badge,
    origin,
    price,
    stock,
    is_featured,
  } = req.body;

  if (!name || !description || !price) {
    return res.status(400).json({
      message: "Name, description and price are required",
    });
  }

  const slug = await generateUniqueSlug(name);

  const image = req.file ? `images/products/${req.file.filename}` : null;

  const sql = `
    INSERT INTO products
    (
      category_id,
      partner_id,
      name,
      slug,
      description,
      material,
      packaging,
      certification,
      eco_badge,
      origin,
      price,
      image,
      stock,
      is_featured
    )
    VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
  `;

  const params = [
    category_id || null,
    partner_id || null,
    name,
    slug,
    description,
    material || null,
    packaging || null,
    certification || null,
    eco_badge || null,
    origin || null,
    Number(price),
    image,
    Number(stock) || 0,
    is_featured === "true" || is_featured === true,
  ];

  const [result] = await connection.query(sql, params);

  res.status(201).json({
    message: "Product created successfully",
    data: {
      id: result.insertId,
      name,
      slug,
      image,
    },
  });
}
