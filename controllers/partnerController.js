import connection from "../config/db.js";

export async function index(req, res) {
  const sql = `
    SELECT 
      partners.id,
      partners.name,
      partners.slug,
      partners.description,
      partners.website,
      partners.logo,
      partners.is_verified,
      partners.sustainability_note,
      COUNT(products.id) AS products_count
    FROM partners
    LEFT JOIN products
      ON partners.id = products.partner_id
    GROUP BY
      partners.id,
      partners.name,
      partners.slug,
      partners.description,
      partners.website,
      partners.logo,
      partners.is_verified,
      partners.sustainability_note
    ORDER BY partners.name ASC
  `;

  const [partners] = await connection.query(sql);

  res.json({
    count: partners.length,
    data: partners,
  });
}

export async function show(req, res) {
  const { slug } = req.params;

  const partnerSql = `
    SELECT 
      id,
      name,
      slug,
      description,
      website,
      logo,
      is_verified,
      sustainability_note
    FROM partners
    WHERE slug = ?
  `;

  const [partners] = await connection.query(partnerSql, [slug]);

  if (partners.length === 0) {
    return res.status(404).json({
      message: "Partner not found",
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
    WHERE partners.slug = ?
    ORDER BY products.created_at DESC
  `;

  const [products] = await connection.query(productsSql, [slug]);

  res.json({
    partner: partners[0],
    data: products,
  });
}
