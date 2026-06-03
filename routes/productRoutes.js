import express from "express";
import {
  index,
  show,
  store,
  update,
  destroy,
} from "../controllers/productController.js";
import uploadProductImage from "../middlewares/uploadProductImage.js";

const router = express.Router();

router.get("/", index);

router.get("/:slug", show);

router.post("/", uploadProductImage.single("image"), store);

router.put("/:id", uploadProductImage.single("image"), update);

router.delete("/:id", destroy);

export default router;
