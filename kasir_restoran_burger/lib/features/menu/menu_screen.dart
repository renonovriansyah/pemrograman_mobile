import 'package:animate_do/animate_do.dart'; 
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../core/widgets/app_background.dart'; 
import '../../data/firestore_service.dart';
import '../../data/models/product_model.dart';
import '../cart/cart_model.dart';
import '../cart/cart_provider.dart';
import '../cart/cart_screen.dart';
import '../history/history_screen.dart';

class MenuScreen extends ConsumerStatefulWidget {
  const MenuScreen({super.key});

  @override
  ConsumerState<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends ConsumerState<MenuScreen> {
  // 1. Variable State untuk Kategori Terpilih
  String selectedCategory = 'Semua Menu';

  // 2. Daftar Kategori (Urutan ini akan digunakan untuk sorting "Semua Menu")
  final List<String> categories = [
    'Semua Menu',
    'Burger Premium',
    'Minuman',
    'Sides',
    'Dessert', 
  ];

  @override
  Widget build(BuildContext context) {
    final currency = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    final cartItems = ref.watch(cartProvider); 
    final totalItems = cartItems.fold(0, (sum, item) => sum + item.quantity);

    return Scaffold(
      extendBodyBehindAppBar: true, 
      appBar: AppBar(
        titleSpacing: 20,
        toolbarHeight: 70,
        title: Row(
          children: [
            // LOGO SECTION
            Container(
              height: 40, width: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(color: Colors.black.withAlpha(20), blurRadius: 5)
                ]
              ),
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Image.asset(
                  'assets/logo.png', 
                  fit: BoxFit.contain,
                  errorBuilder: (_,__,___) => const Icon(Icons.lunch_dining, color: Color(0xFF720E1E), size: 24),
                ),
              ),
            ),
            const SizedBox(width: 12),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'SIZZLE BURGER', 
                  style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1.0, color: Colors.white, fontSize: 18),
                ),
                Text(
                  'The Real Taste', 
                  style: TextStyle(fontWeight: FontWeight.normal, color: Colors.white70, fontSize: 11),
                ),
              ],
            ),
          ],
        ),
        backgroundColor: const Color(0xFF720E1E),
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const HistoryScreen())),
            icon: const Icon(Icons.history_rounded, color: Colors.white, size: 28),
            tooltip: "Riwayat Transaksi",
          ),
          const SizedBox(width: 8),
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Stack(
              alignment: Alignment.center,
              children: [
                IconButton(
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const CartScreen())),
                  icon: const Icon(Icons.shopping_bag_outlined, color: Colors.white, size: 28),
                  tooltip: "Keranjang",
                ),
                if (totalItems > 0)
                  Positioned(
                    right: 4, top: 4,
                    child: FadeInDown(
                      key: ValueKey(totalItems),
                      duration: const Duration(milliseconds: 300),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFCD05), 
                          shape: BoxShape.circle,
                          border: Border.all(color: const Color(0xFF720E1E), width: 2)
                        ),
                        child: Text(
                          totalItems.toString(),
                          style: const TextStyle(color: Color(0xFF720E1E), fontWeight: FontWeight.w900, fontSize: 10),
                        ),
                      ),
                    ),
                  )
              ],
            ),
          ),
        ],
      ),
      
      body: AppBackground(
        child: SafeArea(
          child: Column(
            children: [
              // 1. BANNER PROMO & KATEGORI
              Container(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                child: Column(
                  children: [
                    // Banner
                    Container(
                      width: double.infinity,
                      height: 130,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: const LinearGradient(
                          colors: [Color(0xFF8B1E2F), Color(0xFFB71C1C)], 
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(color: const Color(0xFF720E1E).withAlpha(80), blurRadius: 10, offset: const Offset(0, 5))
                        ]
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            right: -10, bottom: -10,
                            child: Icon(Icons.fastfood_rounded, size: 150, color: Colors.white.withAlpha(20)),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(color: const Color(0xFFFFCD05), borderRadius: BorderRadius.circular(6)),
                                  child: const Text("PROMO HARI INI", style: TextStyle(color: Color(0xFF720E1E), fontWeight: FontWeight.w900, fontSize: 10)),
                                ),
                                const SizedBox(height: 8),
                                const Text("Diskon 20%\nDouble Cheese Burger", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 20, height: 1.2)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Kategori Chips (ListView Horizontal)
                    SizedBox(
                      height: 40,
                      child: ListView.builder( 
                        scrollDirection: Axis.horizontal,
                        itemCount: categories.length,
                        itemBuilder: (context, index) {
                          final category = categories[index];
                          final isSelected = selectedCategory == category;
                          return _buildCategoryChip(
                            label: category, 
                            isSelected: isSelected,
                            onTap: () {
                              setState(() {
                                selectedCategory = category;
                              });
                            }
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),

              // 2. GRID PRODUK DENGAN FILTER & SORTING
              Expanded(
                child: StreamBuilder<List<Product>>(
                  stream: FirestoreService().getProducts(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator(color: Color(0xFF720E1E)));
                    }
                    if (snapshot.hasError) {
                      return Center(child: Text("Error: ${snapshot.error}"));
                    }
                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return _buildEmptyState();
                    }

                    final allProducts = snapshot.data!;
                    
                    // A. FILTERING
                    var filteredProducts = allProducts.where((product) {
                      if (selectedCategory == 'Semua Menu') return true;
                      return product.category.toLowerCase() == selectedCategory.toLowerCase();
                    }).toList();

                    // B. SORTING (LOGIKA BARU DI SINI)
                    filteredProducts.sort((a, b) {
                      if (selectedCategory == 'Semua Menu') {
                        // 1. Jika "Semua Menu", urutkan berdasarkan Kategori dulu
                        // Kita cari index kategori produk di dalam list 'categories' class kita
                        // Agar urutannya: Burger -> Minuman -> Sides -> Dessert
                        int indexA = categories.indexWhere((c) => c.toLowerCase() == a.category.toLowerCase());
                        int indexB = categories.indexWhere((c) => c.toLowerCase() == b.category.toLowerCase());

                        // Jika kategori tidak ketemu di list (misal salah ketik di DB), lempar ke belakang
                        if (indexA == -1) indexA = 999;
                        if (indexB == -1) indexB = 999;

                        int categoryCompare = indexA.compareTo(indexB);

                        // Jika kategorinya sama, baru urutkan Nama A-Z
                        if (categoryCompare == 0) {
                          return a.name.compareTo(b.name);
                        }
                        return categoryCompare;
                      } else {
                        // 2. Jika Filter Kategori tertentu (misal Minuman), langsung urutkan Nama A-Z
                        return a.name.compareTo(b.name);
                      }
                    });

                    if (filteredProducts.isEmpty) {
                      return Center(
                        child: Text(
                          "Belum ada menu di kategori $selectedCategory",
                          style: TextStyle(color: Colors.grey[500]),
                        ),
                      );
                    }

                    return GridView.builder(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 220, 
                        childAspectRatio: 0.72,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                      ),
                      itemCount: filteredProducts.length,
                      itemBuilder: (context, index) {
                        final product = filteredProducts[index];
                        return FadeInUp(
                          delay: Duration(milliseconds: (index * 50).clamp(0, 500)), // Clamp biar gak kelamaan kalau item banyak
                          child: _ProductCardModern(product: product, currency: currency),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.lunch_dining_outlined, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text("Menu Belum Tersedia", style: TextStyle(color: Colors.grey[500], fontWeight: FontWeight.bold, fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildCategoryChip({required String label, required bool isSelected, required VoidCallback onTap}) {
    return Padding(
      padding: const EdgeInsets.only(right: 10.0),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF212121) : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: isSelected ? Colors.transparent : Colors.grey[300]!),
            boxShadow: isSelected ? [BoxShadow(color: Colors.black.withAlpha(50), blurRadius: 5, offset: const Offset(0, 2))] : null
          ),
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.grey[700],
              fontWeight: FontWeight.w600,
              fontSize: 12
            ),
          ),
        ),
      ),
    );
  }
}

// --- KARTU PRODUK MODERN ---
class _ProductCardModern extends StatefulWidget {
  final Product product;
  final NumberFormat currency;

  const _ProductCardModern({required this.product, required this.currency});

  @override
  State<_ProductCardModern> createState() => _ProductCardModernState();
}

class _ProductCardModernState extends State<_ProductCardModern> {
  bool isHovered = false; 

  @override
  Widget build(BuildContext context) {
    final scale = isHovered ? 1.03 : 1.0;

    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      cursor: SystemMouseCursors.click, 
      child: GestureDetector(
        onTap: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent, 
            builder: (context) => ProductDetailSheet(product: widget.product),
          );
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          transform: Matrix4.diagonal3Values(scale, scale, 1.0), 
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(isHovered ? 25 : 13),
                blurRadius: isHovered ? 20 : 10,
                offset: const Offset(0, 8),
              )
            ],
            border: Border.all(color: isHovered ? const Color(0xFF720E1E) : Colors.transparent, width: 2)
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF9F9F9),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Stack(
                    children: [
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: widget.product.imagePath.isNotEmpty
                              ? Image.asset(widget.product.imagePath, fit: BoxFit.contain, errorBuilder: (_,__,___) => const Icon(Icons.lunch_dining, size: 50, color: Colors.orange))
                              : const Icon(Icons.lunch_dining, size: 50, color: Colors.orange),
                        ),
                      ),
                      if (isHovered)
                        Positioned(
                          bottom: 6, right: 6,
                          child: FadeIn(
                            duration: const Duration(milliseconds: 200),
                            child: const CircleAvatar(
                              backgroundColor: Color(0xFF720E1E),
                              radius: 14,
                              child: Icon(Icons.add, color: Colors.white, size: 16),
                            ),
                          ),
                        )
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.product.category.toUpperCase(),
                      style: TextStyle(fontSize: 9, color: Colors.grey[500], fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      widget.product.name,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, height: 1.2),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      widget.currency.format(widget.product.basePrice),
                      style: const TextStyle(
                        color: Color(0xFF720E1E), 
                        fontWeight: FontWeight.w900,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

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
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Center(child: Container(width: 50, height: 5, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10)))),
              const SizedBox(height: 24),
              Text(widget.product.name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Color(0xFF720E1E))),
              const SizedBox(height: 10),
              const Divider(thickness: 1, height: 1),
              Expanded(
                child: ListView(
                  controller: controller,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  children: [
                    ...widget.product.variants.map((group) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(group.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          const SizedBox(height: 8),
                          ...group.options.map((option) {
                            return RadioListTile<ProductOption>(
                              title: Text(option.name),
                              secondary: option.priceEffect > 0 ? Text("+${currency.format(option.priceEffect)}", style: const TextStyle(fontWeight: FontWeight.w600)) : null,
                              value: option,
                              // ignore: deprecated_member_use
                              groupValue: selectedVariants[group.name],
                              activeColor: const Color(0xFF720E1E),
                              contentPadding: EdgeInsets.zero,
                              // ignore: deprecated_member_use
                              onChanged: (value) => setState(() => selectedVariants[group.name] = value!),
                            );
                          }),
                          const SizedBox(height: 16),
                        ],
                      );
                    }),
                    ...widget.product.modifiers.map((group) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(group.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          const SizedBox(height: 8),
                          ...group.options.map((option) {
                            final isSelected = selectedModifiers.contains(option);
                            return CheckboxListTile(
                              title: Text(option.name),
                              secondary: option.priceEffect > 0 ? Text("+${currency.format(option.priceEffect)}", style: const TextStyle(fontWeight: FontWeight.w600)) : null,
                              value: isSelected,
                              activeColor: const Color(0xFF720E1E),
                              contentPadding: EdgeInsets.zero,
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
                          const SizedBox(height: 16),
                        ],
                      );
                    }),
                    const Text("Catatan Pesanan", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 8),
                    TextField(
                      controller: notesController, 
                      decoration: InputDecoration(
                        hintText: "Contoh: Jangan pakai bawang...",
                        filled: true,
                        fillColor: Colors.grey[100],
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                      )
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.only(top: 16),
                decoration: const BoxDecoration(border: Border(top: BorderSide(color: Colors.black12))),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(12)),
                      child: Row(
                        children: [
                          IconButton(icon: const Icon(Icons.remove), onPressed: () => setState(() => quantity > 1 ? quantity-- : null)),
                          Text(quantity.toString(), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                          IconButton(icon: const Icon(Icons.add), onPressed: () => setState(() => quantity++)),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF720E1E), 
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          elevation: 2,
                        ),
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
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("${widget.product.name} masuk keranjang!"),
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: Colors.green[700],
                          ));
                        },
                        child: Text("Tambah - ${currency.format(totalPrice)}", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}