const express = require('express');
const router = express.Router();
const authMiddleware = require('../middleware/authMiddleware');
const User = require('../models/user');

// PUT /profile/update
router.put('/update', authMiddleware, async (req, res) => {
  const { name, email } = req.body;

  // Debugging: log userId dari token untuk memastikan token diterima dengan benar
  console.log('User ID dari token:', req.user.userId);

  try {
    // Mencari dan memperbarui user berdasarkan userId yang ada di token
    const user = await User.findByIdAndUpdate(
      req.user.userId, // Pastikan req.user.userId yang ada di token digunakan
      { name, email },
      { new: true } // Menampilkan data terbaru setelah update
    ).select('-password'); // Jangan sertakan password dalam response

    if (!user) {
      return res.status(404).json({ message: 'User tidak ditemukan' });
    }

    res.json({ message: 'Profil berhasil diperbarui', user });
  } catch (error) {
    res.status(500).json({ message: 'Gagal memperbarui profil', error: error.message });
  }
});

module.exports = router;
