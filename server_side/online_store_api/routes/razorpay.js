// routes/razorpay.js
const express = require('express');
const router = express.Router();
const Razorpay = require('razorpay');

const razorpay = new Razorpay({
    key_id: process.env.RAZORPAY_KEY_ID,
    key_secret: process.env.RAZORPAY_SECRET,    
});

router.post('/razorpay-payment', async (req, res) => {
  try {
    const options = {
      amount: 100 * 100, // 100 rupee dalam paise
      currency: 'INR',
      receipt: 'receipt#1',
      payment_capture: 1,
    };

    const order = await razorpay.orders.create(options);
    res.json({
        key: process.env.RAZORPAY_KEY_ID,
      order_id: order.id,
      amount: order.amount,
      currency: order.currency,
    });
  } catch (err) {
    console.error('❌ Razorpay error:', err.message);
    res.status(500).json({ error: err.message });
  }
});

module.exports = router;
