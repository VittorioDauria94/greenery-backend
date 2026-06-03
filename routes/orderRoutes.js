import express from "express";
import { store } from "../controllers/orderController.js";

const router = express.Router();

router.post("/", store);

export default router;
