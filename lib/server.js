// server.js
const express = require('express');
const mongoose = require('mongoose');
const bodyParser = require('body-parser');

const app = express();
const port = 3000;

// Middleware
app.use(bodyParser.json());

// MongoDB connection
mongoose.connect('mongodb://localhost:27017/wallets', {
  useNewUrlParser: true,
  useUnifiedTopology: true,
});

const db = mongoose.connection;
db.on('error', console.error.bind(console, 'connection error:'));
db.once('open', () => {
  console.log('Connected to MongoDB');
});

// Wallet model
const walletSchema = new mongoose.Schema({
  userId: String,
  balance: Number,
});

const Wallet = mongoose.model('Wallet', walletSchema);

// Payment model
const paymentSchema = new mongoose.Schema({
  userId: String,
  amount: Number,
  date: { type: Date, default: Date.now },
});

const Payment = mongoose.model('Payment', paymentSchema);

// Cart model
const cartSchema = new mongoose.Schema({
  userId: String,
  items: [
    {
      productId: String,
      quantity: Number,
      price: Number,
    },
  ],
  total: Number,
});

const Cart = mongoose.model('Cart', cartSchema);

// Order model
const orderSchema = new mongoose.Schema({
  userId: String,
  items: [
    {
      productId: String,
      quantity: Number,
      price: Number,
    },
  ],
  total: Number,
  date: { type: Date, default: Date.now },
  status: { type: String, default: 'active' },
  trackingInfo: {
    carrier: String,
    trackingNumber: String,
    estimatedDelivery: Date,
  },
});

const Order = mongoose.model('Order', orderSchema);

// Fund wallet endpoint
app.post('/api/wallets/fund', async (req, res) => {
  const { userId, amount } = req.body;

  if (!userId || !amount) {
    return res.status(400).send('User ID and amount are required');
  }

  try {
    let wallet = await Wallet.findOne({ userId });

    if (!wallet) {
      wallet = new Wallet({ userId, balance: 0 });
    }

    wallet.balance += amount;
    await wallet.save();

    // Save payment history
    const payment = new Payment({ userId, amount });
    await payment.save();

    res.status(200).send({ message: 'Wallet funded successfully', balance: wallet.balance });
  } catch (error) {
    res.status(500).send('Internal server error');
  }
});

// Get payment history endpoint
app.get('/api/payments', async (req, res) => {
  try {
    const payments = await Payment.find();
    res.status(200).send(payments);
  } catch (error) {
    res.status(500).send('Internal server error');
  }
});

// Get specified cart endpoint
app.get('/api/carts/:id', async (req, res) => {
  const { id } = req.params;

  try {
    const cart = await Cart.findById(id);
    if (!cart) {
      return res.status(404).send('Cart not found');
    }
    res.status(200).send(cart);
  } catch (error) {
    res.status(500).send('Internal server error');
  }
});

// Get specified order receipt endpoint
app.get('/api/orders/:id/receipt', async (req, res) => {
  const { id } = req.params;

  try {
    const order = await Order.findById(id);
    if (!order) {
      return res.status(404).send('Order not found');
    }
    res.status(200).send(order);
  } catch (error) {
    res.status(500).send('Internal server error');
  }
});

// Cancel specified order endpoint
app.post('/api/orders/:id/cancel', async (req, res) => {
  const { id } = req.params;

  try {
    const order = await Order.findById(id);
    if (!order) {
      return res.status(404).send('Order not found');
    }

    order.status = 'cancelled';
    await order.save();

    res.status(200).send({ message: 'Order cancelled successfully', order });
  } catch (error) {
    res.status(500).send('Internal server error');
  }
});

// Get specified order summary endpoint
app.get('/api/orders/:id', async (req, res) => {
  const { id } = req.params;

  try {
    const order = await Order.findById(id);
    if (!order) {
      return res.status(404).send('Order not found');
    }
    res.status(200).send(order);
  } catch (error) {
    res.status(500).send('Internal server error');
  }
});

// Get specified order tracking info endpoint
app.get('/api/orders/:id/track', async (req, res) => {
  const { id } = req.params;

  try {
    const order = await Order.findById(id);
    if (!order) {
      return res.status(404).send('Order not found');
    }
    res.status(200).send(order.trackingInfo);
  } catch (error) {
    res.status(500).send('Internal server error');
  }
});

// Get orders for a specified user endpoint
app.get('/api/users/:userId/orders', async (req, res) => {
  const { userId } = req.params;

  try {
    const orders = await Order.find({ userId });
    if (!orders.length) {
      return res.status(404).send('No orders found for this user');
    }
    res.status(200).send(orders);
  } catch (error) {
    res.status(500).send('Internal server error');
  }
});

app.listen(port, () => {
  console.log(`Server running on http://localhost:${port}`);
});