const jwt = require('jsonwebtoken');

// Middleware untuk verifikasi token
const authMiddleware = (req, res, next) => {
  const token = req.header('Authorization')?.replace('Bearer ', '');

  if (!token) {
    return res.status(401).json({ message: 'Token tidak ditemukan' });
  }

  try {
    const decoded = jwt.verify(token, process.env.JWT_SECRET); // Pastikan kunci di .env sesuai
    req.user = { userId: decoded.userId };  // Menyimpan informasi user pada request
    next(); // Lanjutkan ke route berikutnya
  } catch (error) {
    res.status(401).json({ message: 'Token tidak valid' });
  }
};

module.exports = authMiddleware;
