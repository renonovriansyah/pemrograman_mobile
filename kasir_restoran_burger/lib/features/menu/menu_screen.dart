import 'package:animate_do/animate_do.dart'; 
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
    final currency = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    final cartItems = ref.watch(cartProvider); 
    final totalItems = cartItems.fold(0, (sum, item) => sum + item.quantity);

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        toolbarHeight: 70,
        titleSpacing: 24,
        title: Row(
          children: [
            // LOGO SECTION
            Container(
              height: 40, width: 40,
              decoration: BoxDecoration(
                color: const Color(0xFF720E1E),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Image.asset(
                  'assets/logo.png', 
                  fit: BoxFit.contain,
                  errorBuilder: (_,__,___) => const Icon(Icons.lunch_dining, color: Colors.white, size: 24),
                ),
              ),
            ),
            const SizedBox(width: 12),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'SIZZLE BURGER', 
                  style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1.2, color: Color(0xFF720E1E), fontSize: 20),
                ),
                Text(
                  'The Real Taste of Burger', 
                  style: TextStyle(fontWeight: FontWeight.w500, color: Colors.grey, fontSize: 10),
                ),
              ],
            ),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: Colors.grey[200], height: 1),
        ),
        actions: [
          _ActionButton(
            icon: Icons.history_edu_outlined, 
            label: "Riwayat",
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const HistoryScreen())),
          ),
          const SizedBox(width: 10),
          Padding(
            padding: const EdgeInsets.only(right: 24.0),
            child: Stack(
              alignment: Alignment.center,
              children: [
                _ActionButton(
                  icon: Icons.shopping_bag_outlined, 
                  label: "Order",
                  isActive: totalItems > 0,
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const CartScreen())),
                ),
                if (totalItems > 0)
                  Positioned(
                    right: 0, top: 0,
                    child: FadeInDown(
                      key: ValueKey(totalItems),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(color: Color(0xFFD32F2F), shape: BoxShape.circle),
                        child: Text(
                          totalItems.toString(),
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 10),
                        ),
                      ),
                    ),
                  )
              ],
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // 1. HEADER & BANNER AREA
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
            child: Column(
              children: [
                // BANNER PROMO
                Container(
                  width: double.infinity,
                  height: 140,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: const LinearGradient(
                      colors: [Color(0xFF720E1E), Color(0xFFA61B2E)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        // FIX: withOpacity(0.3) -> 0.3 * 255 = 77 -> withAlpha(77)
                        color: const Color(0xFF720E1E).withAlpha(77), 
                        blurRadius: 15, 
                        offset: const Offset(0, 8)
                      )
                    ]
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        right: -20, bottom: -20,
                        child: Icon(
                          Icons.fastfood, 
                          size: 180, 
                          // FIX: withOpacity(0.1) -> 0.1 * 255 = 25 -> withAlpha(25)
                          color: Colors.white.withAlpha(25),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Promo Spesial Hari Ini!", style: TextStyle(color: Color(0xFFFFCD05), fontWeight: FontWeight.bold, fontSize: 14)),
                            SizedBox(height: 8),
                            Text("Diskon 20%\nDouble Cheese Burger", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 24, height: 1.2)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                
                // CATEGORY CHIPS
                SizedBox(
                  height: 40,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      _buildCategoryChip('Semua', true),
                      _buildCategoryChip('Burger Premium', false),
                      _buildCategoryChip('Minuman', false),
                      _buildCategoryChip('Snack & Sides', false),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // 2. GRID PRODUK
          Expanded(
            child: StreamBuilder<List<Product>>(
              stream: FirestoreService().getProducts(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
                if (!snapshot.hasData || snapshot.data!.isEmpty) return _buildEmptyState();

                final products = snapshot.data!;

                return GridView.builder(
                  padding: const EdgeInsets.all(24),
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 240, 
                    childAspectRatio: 0.75,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                  ),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return FadeInUp(
                      delay: Duration(milliseconds: index * 50),
                      child: _ProductCardModern(product: product, currency: currency),
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

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.lunch_dining_outlined, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text("Menu Kosong", style: TextStyle(color: Colors.grey[400], fontSize: 18, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(String label, bool isSelected) {
    return Padding(
      padding: const EdgeInsets.only(right: 12.0),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 0),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF212121) : Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: isSelected ? Colors.transparent : Colors.grey[300]!),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.grey[600],
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
              fontSize: 13
            ),
          ),
        ),
      ),
    );
  }
}

// Tombol Action Bar Custom
class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isActive;

  const _ActionButton({required this.icon, required this.label, required this.onTap, this.isActive = false});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFFFFF4E5) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: isActive ? Border.all(color: const Color(0xFFFFCD05)) : null,
        ),
        child: Row(
          children: [
            Icon(icon, color: isActive ? const Color(0xFFB71C1C) : Colors.grey[800], size: 22),
            if (isActive) ...[
              const SizedBox(width: 8),
              Text(label, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFB71C1C))),
            ]
          ],
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
    // scale animasi
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
          // FIX: Gunakan Matrix4.diagonal3Values sesuai instruksi
          transform: Matrix4.diagonal3Values(scale, scale, 1.0), 
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                // FIX: withOpacity -> withAlpha (0.1 -> 25, 0.05 -> 13)
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
              // GAMBAR
              Expanded(
                child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Stack(
                    children: [
                      Center(
                        child: widget.product.imagePath.isNotEmpty
                          ? Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Image.asset(widget.product.imagePath, fit: BoxFit.contain, errorBuilder: (_,__,___) => const Icon(Icons.lunch_dining, size: 50, color: Colors.orange)),
                            )
                          : const Icon(Icons.lunch_dining, size: 50, color: Colors.orange),
                      ),
                      if (isHovered)
                        Positioned(
                          bottom: 8, right: 8,
                          child: FadeIn(
                            duration: const Duration(milliseconds: 200),
                            child: const CircleAvatar(
                              backgroundColor: Color(0xFF720E1E),
                              radius: 18,
                              child: Icon(Icons.add, color: Colors.white, size: 20),
                            ),
                          ),
                        )
                    ],
                  ),
                ),
              ),
              
              // TEXT DETAIL
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.product.category.toUpperCase(),
                      style: TextStyle(fontSize: 10, color: Colors.grey[500], fontWeight: FontWeight.bold, letterSpacing: 0.5),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.product.name,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, height: 1.2),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.currency.format(widget.product.basePrice),
                          style: const TextStyle(
                            color: Color(0xFF720E1E), 
                            fontWeight: FontWeight.w900,
                            fontSize: 16,
                          ),
                        ),
                      ],
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

// --- POP UP DETAIL (ProductDetailSheet) ---
// Bagian ini wajib ada agar tidak error 'undefined class'
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
              
              Text(widget.product.name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: Color(0xFF720E1E))),
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