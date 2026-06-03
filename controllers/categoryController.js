import connection from "../config/db.js";

export async function index(req, res) {
  const sql = `
    SELECT 
      categories.id,
      categories.name,
      categories.slug,
      categories.description,
      COUNT(products.id) AS products_count
    FROM categories
    LEFT JOIN products
      ON categories.id = products.category_id
    GROUP BY 
      categories.id,
      categories.name,
      categories.slug,
      categories.description
    ORDER BY categories.name ASC
  `;

  const [categories] = await connection.query(sql);

  res.json({
    count: categories.length,
    data: categories,
  });
}

export async function productsByCategory(req, res) {
  const { slug } = req.params;

  const categorySql = `
    SELECT 
      id,
      name,
      slug,
      description
    FROM categories
    WHERE slug = ?
  `;

  const [categories] = await connection.query(categorySql, [slug]);

  if (categories.length === 0) {
    return res.status(404).json({
      message: "Category not found",
    });
  }

  const productsSql = `
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
    WHERE categories.slug = ?
    ORDER BY products.created_at DESC
  `;

  const [products] = await connection.query(productsSql, [slug]);

  res.json({
    category: categories[0],
    data: products,
  });
}
