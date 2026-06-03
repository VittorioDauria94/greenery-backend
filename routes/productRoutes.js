import express from "express";
import { index, show, store } from "../controllers/productController.js";
import uploadProductImage from "../middlewares/uploadProductImage.js";

const router = express.Router();

router.get("/", index);

router.get("/:slug", show);

router.post("/", uploadProductImage.single("image"), store);

export default router;
