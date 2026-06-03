import express from "express";
import cors from "cors";

import productRoutes from "./routes/productRoutes.js";
import categoryRoutes from "./routes/categoryRoutes.js";
import partnerRoutes from "./routes/partnerRoutes.js";
import notFound from "./middlewares/notFound.js";
import errorsHandler from "./middlewares/errorsHandler.js";

const app = express();
const PORT = process.env.PORT || 3000;

app.use(
  cors({
    origin: process.env.FRONTEND_URL,
  }),
);

app.use(express.json());
app.use(express.static("public"));

app.get("/", (req, res) => {
  res.json({
    message: "Greenery API",
  });
});

app.get("/api/health", (req, res) => {
  res.json({
    status: "ok",
    message: "Greenery backend is running",
  });
});

app.use("/api/products", productRoutes);

app.use("/api/categories", categoryRoutes);

app.use("/api/partners", partnerRoutes);

app.use(notFound);

app.use(errorsHandler);

app.listen(PORT, () => {
  console.log(`Server is running on http://localhost:${PORT}`);
});
