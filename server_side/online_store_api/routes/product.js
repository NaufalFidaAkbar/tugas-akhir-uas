const express = require('express');
const router = express.Router();
const multer = require('multer');
const asyncHandler = require('express-async-handler');
const Product = require('../models/Product');
const { uploadProduct } = require('../uploadFile');

// ===================== GET ALL PRODUCTS =====================
router.get('/', asyncHandler(async (req, res) => {
  const products = await Product.find()
    .populate('proCategoryId', 'id name')
    .populate('proSubCategoryId', 'id name')
    .populate('proBrandId', 'id name')
    .populate('proVariantTypeId', 'id type');

  res.json({ success: true, message: "Products retrieved successfully.", data: products });
}));

// ===================== GET PRODUCT BY ID =====================
router.get('/:id', asyncHandler(async (req, res) => {
  const product = await Product.findById(req.params.id)
    .populate('proCategoryId', 'id name')
    .populate('proSubCategoryId', 'id name')
    .populate('proBrandId', 'id name')
    .populate('proVariantTypeId', 'id type');

  if (!product) {
    return res.status(404).json({ success: false, message: "Product not found." });
  }

  res.json({ success: true, message: "Product retrieved successfully.", data: product });
}));

// ===================== CREATE PRODUCT =====================
router.post('/', uploadProduct.fields([
  { name: 'image1', maxCount: 1 },
  { name: 'image2', maxCount: 1 },
  { name: 'image3', maxCount: 1 },
  { name: 'image4', maxCount: 1 },
  { name: 'image5', maxCount: 1 },
]), asyncHandler(async (req, res) => {
  const {
    name, description, quantity, price, offerPrice,
    proCategoryId, proSubCategoryId, proBrandId,
    proVariantTypeId, proVariantId
  } = req.body;

  if (!name || !quantity || !price || !proCategoryId || !proSubCategoryId) {
    return res.status(400).json({ success: false, message: "Required fields are missing." });
  }

  const imageUrls = [];
  ['image1', 'image2', 'image3', 'image4', 'image5'].forEach((field, index) => {
    if (req.files?.[field]?.length) {
      const file = req.files[field][0];
      imageUrls.push({
        image: index + 1,
        url: `http://localhost:3000/image/products/${file.filename}`
      });
    }
  });

  const newProduct = new Product({
    name,
    description,
    quantity,
    price,
    offerPrice: offerPrice || price, // Default to price if offerPrice not provided
    proCategoryId,
    proSubCategoryId,
    proBrandId,
    proVariantTypeId,
    proVariantId,
    images: imageUrls
  });

  await newProduct.save();
  res.status(201).json({ success: true, message: "Product created successfully." });
}));

// ===================== UPDATE PRODUCT =====================
router.put('/:id', uploadProduct.fields([
  { name: 'image1', maxCount: 1 },
  { name: 'image2', maxCount: 1 },
  { name: 'image3', maxCount: 1 },
  { name: 'image4', maxCount: 1 },
  { name: 'image5', maxCount: 1 },
]), asyncHandler(async (req, res) => {
  const product = await Product.findById(req.params.id);
  if (!product) {
    return res.status(404).json({ success: false, message: "Product not found." });
  }

  const {
    name, description, quantity, price, offerPrice,
    proCategoryId, proSubCategoryId, proBrandId,
    proVariantTypeId, proVariantId
  } = req.body;

  product.name = name || product.name;
  product.description = description || product.description;
  product.quantity = quantity || product.quantity;
  product.price = price || product.price;
  product.offerPrice = offerPrice || product.offerPrice;
  product.proCategoryId = proCategoryId || product.proCategoryId;
  product.proSubCategoryId = proSubCategoryId || product.proSubCategoryId;
  product.proBrandId = proBrandId || product.proBrandId;
  product.proVariantTypeId = proVariantTypeId || product.proVariantTypeId;
  product.proVariantId = proVariantId || product.proVariantId;

  // Update images if there are new ones
  ['image1', 'image2', 'image3', 'image4', 'image5'].forEach((field, index) => {
    if (req.files?.[field]?.length) {
      const file = req.files[field][0];
      const url = `http://localhost:3000/image/products/${file.filename}`;
      const imgIndex = product.images.findIndex(img => img.image === index + 1);
      if (imgIndex > -1) {
        product.images[imgIndex].url = url; // Update image URL if it already exists
      } else {
        product.images.push({ image: index + 1, url }); // Add new image
      }
    }
  });

  await product.save();
  res.json({ success: true, message: "Product updated successfully." });
}));

// ===================== DELETE PRODUCT =====================
router.delete('/:id', asyncHandler(async (req, res) => {
  const product = await Product.findByIdAndDelete(req.params.id);
  if (!product) {
    return res.status(404).json({ success: false, message: "Product not found." });
  }
  res.json({ success: true, message: "Product deleted successfully." });
}));

module.exports = router;
