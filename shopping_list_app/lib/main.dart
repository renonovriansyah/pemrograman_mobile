import 'package:flutter/material.dart';
import 'cart_item.dart'; // Pastikan path ini benar
import 'local_storage_service.dart'; // Pastikan path ini benar

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shopping Cart Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const ShoppingCartPage(),
    );
  }
}

class ShoppingCartPage extends StatefulWidget {
  const ShoppingCartPage({super.key});

  @override
  State<ShoppingCartPage> createState() => _ShoppingCartPageState();
}

class _ShoppingCartPageState extends State<ShoppingCartPage> {
  List<CartItem> _cartItems = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCartItems();
    // Tambahkan item dummy jika keranjang kosong saat pertama kali
    if (_cartItems.isEmpty) {
      _addInitialDummyItems();
    }
  }

  // --- FUNGSI MANAJEMEN DATA (CRUD) ---

  // READ: Memuat data dari SharedPreferences
  Future<void> _loadCartItems() async {
    final loadedItems = await LocalStorageService.getCartItems();
    setState(() {
      _cartItems = loadedItems;
      _isLoading = false;
    });
    // Jika tidak ada data tersimpan, tambahkan item dummy awal
    if (_cartItems.isEmpty) {
      _addInitialDummyItems();
    }
  }

  // CREATE: Menambahkan item dummy (hanya untuk demo)
  void _addInitialDummyItems() {
    final dummyItem1 = CartItem(
      id: '1',
      name: 'Cutor inc Pravrs',
      imageUrl: 'airpods.jpg', // Placeholder, ganti dengan aset gambar
      price: 120.00,
      quantity: 1,
      rating: 4.8,
    );
    final dummyItem2 = CartItem(
      id: '2',
      name: 'Datp Sionc Psavrs',
      imageUrl: 'jacket.jpg', // Placeholder, ganti dengan aset gambar
      price: 120.00,
      quantity: 1,
      rating: 4.1,
    );
    // Kita tambahkan item ke keranjang dan simpan
    if (!_cartItems.any((item) => item.id == dummyItem1.id)) {
      _cartItems.add(dummyItem1);
    }
    if (!_cartItems.any((item) => item.id == dummyItem2.id)) {
      _cartItems.add(dummyItem2);
    }
    _saveCartItems();
  }

  // UPDATE: Memperbarui kuantitas item
  void _updateQuantity(String id, int delta) {
    setState(() {
      final index = _cartItems.indexWhere((item) => item.id == id);
      if (index != -1) {
        _cartItems[index].quantity += delta;
        if (_cartItems[index].quantity < 1) {
          _cartItems[index].quantity = 1; // Jangan sampai kuantitas < 1
        }
      }
    });
    _saveCartItems();
  }

  // DELETE: Menghapus item dari keranjang
  void _removeItem(String id) {
    setState(() {
      _cartItems.removeWhere((item) => item.id == id);
    });
    _saveCartItems();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Item dihapus dari keranjang')),
    );
  }

  // SAVE: Menyimpan data ke SharedPreferences
  void _saveCartItems() {
    // Dipanggil setelah setiap perubahan (Add, Update, Delete)
    LocalStorageService.saveCartItems(_cartItems);
  }

  // --- FUNGSI PERHITUNGAN SUMMARY ---
  double get _subtotal {
    return _cartItems.fold(0.0, (sum, item) => sum + (item.price * item.quantity));
  }
  
  // Biaya pengiriman dan Diskon di-hardcode sesuai desain
  final double _shippingFee = 10.00;
  final double _discount = 20.00;

  double get total {
    return _subtotal + _shippingFee - _discount;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping Cart'),
        backgroundColor: const Color(0xFF0D47A1), // Warna gelap sesuai desain
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Bagian Daftar Item Keranjang
                Expanded(
                  // Menampilkan data secara dinamis
                  child: ListView.builder( 
                    padding: const EdgeInsets.all(16.0),
                    itemCount: _cartItems.length,
                    itemBuilder: (context, index) {
                      final item = _cartItems[index];
                      return _buildCartItemCard(item);
                    },
                  ),
                ),
                
                // Horizontal Rule
                const Divider(height: 1, thickness: 1),

                // Bagian Ringkasan Pesanan (Order Summary)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: _buildOrderSummary(),
                ),

                // Tombol Checkout
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      // Logika untuk proses checkout
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Proceed to Checkout tapped!')),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green, // Warna hijau sesuai desain
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Proceed to Checkout',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  // Widget untuk setiap item di keranjang (sesuai desain)
  Widget _buildCartItemCard(CartItem item) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 15.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            // Placeholder Gambar (Ganti dengan Image.asset atau Image.network)
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              //               child: Center(child: Text(item.id == '1' ? 'AirPods' : 'Jacket')),
            ),
            const SizedBox(width: 15),
            
            // Detail Produk
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 16),
                      const SizedBox(width: 4),
                      Text('${item.rating}'),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '\$${(item.price * item.quantity).toStringAsFixed(2)}',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.blue),
                  ),
                ],
              ),
            ),
            
            // Kontrol Kuantitas dan Hapus
            Row(
              children: [
                if (item.id == '2') // Tombol + dan - hanya di item kedua sesuai desain
                  Row(
                    children: [
                      _buildQuantityButton(
                        icon: Icons.remove, 
                        onTap: () => _updateQuantity(item.id, -1)
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text('${item.quantity}', style: const TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      _buildQuantityButton(
                        icon: Icons.add, 
                        onTap: () => _updateQuantity(item.id, 1)
                      ),
                    ],
                  ),
                
                // Tombol Hapus
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _removeItem(item.id),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  // Widget tombol kuantitas
  Widget _buildQuantityButton({required IconData icon, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Icon(icon, size: 16, color: Colors.grey),
      ),
    );
  }


  // Widget untuk Ringkasan Pesanan
  Widget _buildOrderSummary() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Order Summary',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        
        // Baris Subtotal
        _buildSummaryRow('Subtotal', _subtotal.toStringAsFixed(2), showDelete: true),
        
        // Baris Pengiriman
        _buildSummaryRow('Shipping', _shippingFee.toStringAsFixed(2), showDelete: true),
        
        // Baris Total (Diskon diwakili dengan nilai negatif di desain)
        _buildSummaryRow('Total', _discount.toStringAsFixed(2), isTotal: true, isNegative: true, showDelete: true),
        
        // Catatan: Jika 'Total' di desain adalah diskon, maka tampilannya berbeda. 
        // Jika Total adalah Total Akhir, maka tampilannya adalah:
        // _buildSummaryRow('Total', _total.toStringAsFixed(2), isTotal: true),
      ],
    );
  }

  // Widget baris Ringkasan
  Widget _buildSummaryRow(String title, String amount, {bool isTotal = false, bool isNegative = false, bool showDelete = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: isTotal ? 18 : 16,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isTotal ? Colors.black : Colors.grey[700],
            ),
          ),
          Row(
            children: [
              Text(
                '${isNegative ? '-' : ''}\$$amount',
                style: TextStyle(
                  fontSize: isTotal ? 18 : 16,
                  fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
                  color: isTotal ? Colors.black : (isNegative ? Colors.red : Colors.black),
                ),
              ),
              if (showDelete)
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                  onPressed: () {
                    // Logika untuk menghapus/mereset item ringkasan (optional)
                  },
                ),
            ],
          ),
        ],
      ),
    );
  }
}