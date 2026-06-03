import express from "express";
import {
  index,
  productsByCategory,
} from "../controllers/categoryController.js";

const router = express.Router();

router.get("/", index);

router.get("/:slug/products", productsByCategory);

export default router;
