import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../data/firestore_service.dart';
import '../../data/models/product_model.dart';
import '../cart/cart_model.dart';
import '../cart/cart_provider.dart';
import '../cart/cart_screen.dart';
import '../history/history_screen.dart';

class MenuScreen extends ConsumerWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Format Rupiah
    final currency = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    
    // Pantau jumlah item di keranjang
    final cartItems = ref.watch(cartProvider); 
    final totalItems = cartItems.fold(0, (sum, item) => sum + item.quantity);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Sizzle Burger Menu', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF720E1E),
        elevation: 0,
        actions: [
          // TOMBOL BARU: RIWAYAT
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HistoryScreen()),
              );
            },
            icon: const Icon(Icons.history),
            tooltip: "Riwayat Transaksi",
          ),
          
          // Icon Keranjang
          Stack(
            children: [
              IconButton(
                onPressed: () {
                   Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CartScreen()),
                  );
                }, 
                icon: const Icon(Icons.shopping_cart_outlined)
              ),
              if (totalItems > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Color(0xFFFFCD05),
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      totalItems.toString(),
                      style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 10),
                    ),
                  ),
                )
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter Kategori
          Container(
            height: 50,
            color: Colors.white,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              children: [
                _buildCategoryChip('Semua', true),
                _buildCategoryChip('Burger', false),
                _buildCategoryChip('Minuman', false),
                _buildCategoryChip('Sides', false),
              ],
            ),
          ),
          
          // GRID PRODUK (MENGAMBIL DARI FIREBASE / FIRESTORE)
          Expanded(
            child: StreamBuilder<List<Product>>(
              // PERUBAHAN UTAMA: Menggunakan Stream dari FirestoreService
              stream: FirestoreService().getProducts(),
              builder: (context, snapshot) {
                // 1. Loading State
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                
                // 2. Error State
                if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                }

                // 3. Empty State
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("Menu belum tersedia di Database"));
                }

                // 4. Data Loaded
                final products = snapshot.data!;

                return GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, 
                    childAspectRatio: 0.70,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true, 
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                          ),
                          builder: (context) => ProductDetailSheet(product: product),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4, offset: const Offset(0, 2))],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.orange[50],
                                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                                ),
                                child: Center(
                                  // Tampilkan Gambar (Untuk sementara Icon dulu jika path asset/url belum valid)
                                  child: Icon(Icons.lunch_dining, size: 60, color: Colors.orange[800]),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product.name,
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    currency.format(product.basePrice),
                                    style: const TextStyle(
                                      color: Color(0xFF720E1E), 
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(String label, bool isSelected) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Chip(
        label: Text(label),
        backgroundColor: isSelected ? const Color(0xFFFFCD05) : Colors.grey[200], 
        labelStyle: TextStyle(
          color: isSelected ? Colors.black : Colors.black54,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}

// --- POP UP DETAIL ---
class ProductDetailSheet extends ConsumerStatefulWidget {
  final Product product;
  const ProductDetailSheet({super.key, required this.product});

  @override
  ConsumerState<ProductDetailSheet> createState() => _ProductDetailSheetState();
}

class _ProductDetailSheetState extends ConsumerState<ProductDetailSheet> {
  Map<String, ProductOption> selectedVariants = {}; 
  List<ProductOption> selectedModifiers = []; 
  int quantity = 1;
  final TextEditingController notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Auto-select varian pertama
    for (var group in widget.product.variants) {
      if (group.options.isNotEmpty) {
        selectedVariants[group.name] = group.options.first;
      }
    }
  }

  @override
  void dispose() {
    notesController.dispose();
    super.dispose();
  }

  double get totalPrice {
    double total = widget.product.basePrice;
    selectedVariants.forEach((key, option) => total += option.priceEffect);
    for (var mod in selectedModifiers) {
      total += mod.priceEffect;
    }
    return total * quantity;
  }

  @override
  Widget build(BuildContext context) {
    final currency = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (_, controller) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Center(child: Container(width: 40, height: 5, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10)))),
              const SizedBox(height: 20),
              Text(widget.product.name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF720E1E))),
              const Divider(),

              Expanded(
                child: ListView(
                  controller: controller,
                  children: [
                    // VARIAN
                    ...widget.product.variants.map((group) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(group.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          ...group.options.map((option) {
                            return RadioListTile<ProductOption>(
                              title: Text(option.name),
                              secondary: option.priceEffect > 0 ? Text("+${currency.format(option.priceEffect)}") : null,
                              value: option,
                              groupValue: selectedVariants[group.name],
                              activeColor: const Color(0xFF720E1E),
                              onChanged: (value) => setState(() => selectedVariants[group.name] = value!),
                            );
                          }),
                          const SizedBox(height: 10),
                        ],
                      );
                    }),

                    // MODIFIERS
                    ...widget.product.modifiers.map((group) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(group.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          ...group.options.map((option) {
                            final isSelected = selectedModifiers.contains(option);
                            return CheckboxListTile(
                              title: Text(option.name),
                              secondary: option.priceEffect > 0 ? Text("+${currency.format(option.priceEffect)}") : null,
                              value: isSelected,
                              activeColor: const Color(0xFF720E1E),
                              onChanged: (bool? checked) {
                                setState(() {
                                  if (checked == true) {
                                    selectedModifiers.add(option);
                                  } else {
                                    selectedModifiers.remove(option);
                                  }
                                });
                              },
                            );
                          }),
                          const SizedBox(height: 10),
                        ],
                      );
                    }),
                    
                    const Text("Catatan Pesanan", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    TextField(controller: notesController, decoration: const InputDecoration(hintText: "Contoh: Jangan pakai bawang...")),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
              
              // TOMBOL ADD TO CART
              Container(
                padding: const EdgeInsets.only(top: 16),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF720E1E), padding: const EdgeInsets.symmetric(vertical: 16)),
                  onPressed: () {
                    final newItem = CartItem(
                      product: widget.product,
                      selectedVariants: Map.from(selectedVariants),
                      selectedModifiers: List.from(selectedModifiers),
                      quantity: quantity,
                      notes: notesController.text,
                    );
                    ref.read(cartProvider.notifier).addItem(newItem);
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${widget.product.name} masuk keranjang!")));
                  },
                  child: Center(child: Text("Tambah - ${currency.format(totalPrice)}", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}