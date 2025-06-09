require('dotenv').config();

const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');
const helmet = require('helmet');
const asyncHandler = require('express-async-handler');
const path = require('path');

const app = express();

// Middleware
app.use(helmet());
app.use(cors());
app.use(express.json());

// Static files (opsional)
app.use('/image/products', express.static(path.join(__dirname, 'public/products')));
app.use('/image/category', express.static(path.join(__dirname, 'public/category')));
app.use('/image/poster', express.static(path.join(__dirname, 'public/posters')));

// MongoDB Connection
const MONGO_URL = process.env.MONGO_URL;

if (!MONGO_URL) {
  console.error('❌ MONGO_URL tidak ditemukan di .env');
  process.exit(1);
}

mongoose.connect(MONGO_URL, {
  serverSelectionTimeoutMS: 30000
}).then(() => {
  console.log('✅ Terhubung ke MongoDB');
}).catch(err => {
  console.error('❌ Gagal konek MongoDB:', err.message);
  process.exit(1);
});

// Routes
app.use('/auth', require('./routes/auth'));
app.use('/profile', require('./routes/profile'));
// Payment Routes
app.use('/payment', require('./routes/stripe'));
app.use('/payment', require('./routes/razorpay'));


// Root
app.get('/', asyncHandler(async (req, res) => {
  res.json({ success: true, message: '🚀 API aktif dan berjalan', data: null });
}));

// 404
app.use((req, res) => {
  res.status(404).json({ success: false, message: 'Route tidak ditemukan' });
});

// Error handler
app.use((err, req, res, next) => {
  console.error('❌ Terjadi error:', err.message);
  res.status(500).json({ success: false, message: err.message });
});

// Start server
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`🚀 Server berjalan di http://localhost:${PORT}`);
});
