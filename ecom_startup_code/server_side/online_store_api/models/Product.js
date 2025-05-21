const mongoose = require('mongoose');

const productSchema = new mongoose.Schema({
  name: {
    type: String,
    required: [true, 'Nama produk wajib diisi'],
    trim: true,
  },
  description: {
    type: String,
    trim: true,
    default: '',
  },
  quantity: {
    type: Number,
    required: [true, 'Jumlah stok wajib diisi'],
    min: [0, 'Jumlah tidak boleh negatif'],
  },
  price: {
    type: Number,
    required: [true, 'Harga wajib diisi'],
    min: [0, 'Harga tidak boleh negatif'],
  },
  offerPrice: {
    type: Number,
    default: 0,
    min: [0, 'Harga diskon tidak boleh negatif'],
  },
  proCategoryId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Category',
    required: [true, 'Kategori wajib dipilih'],
  },
  proSubCategoryId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'SubCategory',
    required: [true, 'Sub-kategori wajib dipilih'],
  },
  proBrandId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Brand',
    default: null,
  },
  proVariantTypeId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'VariantType',
    default: null,
  },
  proVariantId: {
    type: [String],
    default: [],
  },
  images: [
    {
      image: {
        type: Number,
        required: [true, 'Nomor gambar wajib diisi'],
        min: 1,
        max: 5,
      },
      url: {
        type: String,
        required: [true, 'URL gambar wajib diisi'],
      },
    },
  ],
}, {
  timestamps: true,
  versionKey: false, // Opsional: Hilangkan __v dari dokumen
});

const Product = mongoose.model('Product', productSchema);
module.exports = Product;
