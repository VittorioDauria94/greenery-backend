import connection from "../config/db.js";

export async function store(req, res) {
  const {
    customer_name,
    customer_email,
    customer_address,
    customer_city,
    customer_phone,
    items,
  } = req.body;

  if (
    !customer_name ||
    !customer_email ||
    !customer_address ||
    !customer_city ||
    !Array.isArray(items) ||
    items.length === 0
  ) {
    return res.status(400).json({
      message: "Missing required order data",
    });
  }

  const invalidItem = items.find((item) => {
    return (
      !item.product_id || !Number.isInteger(item.quantity) || item.quantity <= 0
    );
  });

  if (invalidItem) {
    return res.status(400).json({
      message: "Invalid order items",
    });
  }

  const mergedItems = items.reduce((acc, item) => {
    const existingItem = acc.find(
      (accItem) => accItem.product_id === item.product_id,
    );

    if (existingItem) {
      existingItem.quantity += item.quantity;
    } else {
      acc.push({
        product_id: item.product_id,
        quantity: item.quantity,
      });
    }

    return acc;
  }, []);

  const dbConnection = await connection.getConnection();

  try {
    await dbConnection.beginTransaction();

    const productIds = mergedItems.map((item) => item.product_id);
    const placeholders = productIds.map(() => "?").join(", ");

    const [products] = await dbConnection.query(
      `
        SELECT 
          id,
          name,
          price,
          stock
        FROM products
        WHERE id IN (${placeholders})
      `,
      productIds,
    );

    if (products.length !== productIds.length) {
      await dbConnection.rollback();

      return res.status(404).json({
        message: "One or more products were not found",
      });
    }

    let totalPrice = 0;

    const orderItems = mergedItems.map((item) => {
      const product = products.find(
        (product) => product.id === item.product_id,
      );

      if (product.stock < item.quantity) {
        throw Object.assign(new Error(`Not enough stock for ${product.name}`), {
          statusCode: 400,
        });
      }

      const unitPrice = Number(product.price);
      const subtotal = unitPrice * item.quantity;

      totalPrice += subtotal;

      return {
        product_id: product.id,
        product_name: product.name,
        quantity: item.quantity,
        unit_price: unitPrice,
        subtotal,
      };
    });

    const [orderResult] = await dbConnection.query(
      `
        INSERT INTO orders 
        (customer_name, customer_email, customer_address, customer_city, customer_phone, total_price)
        VALUES (?, ?, ?, ?, ?, ?)
      `,
      [
        customer_name,
        customer_email,
        customer_address,
        customer_city,
        customer_phone || null,
        totalPrice,
      ],
    );

    const orderId = orderResult.insertId;

    const orderItemsValues = orderItems.map((item) => [
      orderId,
      item.product_id,
      item.product_name,
      item.quantity,
      item.unit_price,
      item.subtotal,
    ]);

    await dbConnection.query(
      `
        INSERT INTO order_items
        (order_id, product_id, product_name, quantity, unit_price, subtotal)
        VALUES ?
      `,
      [orderItemsValues],
    );

    for (const item of orderItems) {
      await dbConnection.query(
        `
          UPDATE products
          SET stock = stock - ?
          WHERE id = ?
        `,
        [item.quantity, item.product_id],
      );
    }

    await dbConnection.commit();

    res.status(201).json({
      message: "Order created successfully",
      data: {
        order_id: orderId,
        total_price: Number(totalPrice.toFixed(2)),
      },
    });
  } catch (err) {
    await dbConnection.rollback();
    throw err;
  } finally {
    dbConnection.release();
  }
}
