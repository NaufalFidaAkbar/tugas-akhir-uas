const multer = require('multer');
const path = require('path');

// File filter: hanya izinkan JPEG, JPG, PNG
const fileFilter = (req, file, cb) => {
  const allowedTypes = /jpeg|jpg|png/;
  const extname = allowedTypes.test(path.extname(file.originalname).toLowerCase());

  if (extname) {
    cb(null, true);
  } else {
    cb(new Error("Only .jpeg, .jpg, .png files are allowed!"));
  }
};

// Limit ukuran file: 5MB
const fileSizeLimit = 5 * 1024 * 1024; // 5MB

// Fungsi helper untuk membuat storage multer
const createStorage = (folderName) => {
  return multer.diskStorage({
    destination: (req, file, cb) => {
      cb(null, `./public/${folderName}`);
    },
    filename: (req, file, cb) => {
      const uniqueName = `${Date.now()}_${Math.floor(Math.random() * 1000)}${path.extname(file.originalname)}`;
      cb(null, uniqueName);
    }
  });
};

// Upload handler untuk kategori
const uploadCategory = multer({
  storage: createStorage('category'),
  fileFilter,
  limits: { fileSize: fileSizeLimit }
});

// Upload handler untuk produk
const uploadProduct = multer({
  storage: createStorage('products'),
  fileFilter,
  limits: { fileSize: fileSizeLimit }
});

// Upload handler untuk poster
const uploadPosters = multer({
  storage: createStorage('posters'),
  fileFilter,
  limits: { fileSize: fileSizeLimit }
});

module.exports = {
  uploadCategory,
  uploadProduct,
  uploadPosters,
};
