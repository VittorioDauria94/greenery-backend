import multer from "multer";
import path from "path";

const storage = multer.diskStorage({
  destination: "public/images/products",
  filename: (req, file, cb) => {
    const fileExtension = path.extname(file.originalname);
    const uniqueName = `${Date.now()}-${Math.round(Math.random() * 1e9)}${fileExtension}`;

    cb(null, uniqueName);
  },
});

function fileFilter(req, file, cb) {
  const allowedMimeTypes = ["image/jpeg", "image/png", "image/webp"];

  if (!allowedMimeTypes.includes(file.mimetype)) {
    const error = new Error(
      "Invalid file type. Only JPG, PNG and WEBP are allowed.",
    );
    error.statusCode = 400;

    return cb(error);
  }

  cb(null, true);
}

const uploadProductImage = multer({
  storage,
  fileFilter,
  limits: {
    fileSize: 2 * 1024 * 1024,
  },
});

export default uploadProductImage;
