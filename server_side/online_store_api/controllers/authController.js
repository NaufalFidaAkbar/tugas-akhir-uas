const User = require('../models/user');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');

const SECRET = process.env.JWT_SECRET || 'your_jwt_secret'; // Gunakan dari .env

exports.register = async (req, res) => {
  const { name, email, password } = req.body;

  const existing = await User.findOne({ email });
  if (existing) return res.status(400).json({ message: 'Email sudah digunakan' });

  const hashedPassword = await bcrypt.hash(password, 10);
  const user = new User({ name, email, password: hashedPassword });

  await user.save();
  res.status(201).json({ message: 'Registrasi berhasil' });
};

exports.login = async (req, res) => {
  const { email, password } = req.body;

  const user = await User.findOne({ email });
  if (!user) return res.status(404).json({ message: 'Pengguna tidak ditemukan' });

  const isMatch = await bcrypt.compare(password, user.password);
  if (!isMatch) return res.status(401).json({ message: 'Password salah' });

  const token = jwt.sign(
    { userId: user._id, isAdmin: user.isAdmin },
    SECRET,
    { expiresIn: '1d' }
  );

  res.json({
    message: 'Login berhasil',
    token,
    user: { id: user._id, name: user.name, email: user.email, isAdmin: user.isAdmin }
  });
};
