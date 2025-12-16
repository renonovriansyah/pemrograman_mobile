import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../checkout/checkout_screen.dart';
import 'cart_model.dart';
import 'cart_provider.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartItems = ref.watch(cartProvider);
    final totalAmount = ref.watch(cartTotalProvider);
    final currency = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      // --- CUSTOM HEADER ---
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: AppBar(
          title: const Text("Keranjang Pesanan", style: TextStyle(fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 1)),
          centerTitle: true,
          backgroundColor: const Color(0xFF720E1E),
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          actions: [
            if (cartItems.isNotEmpty)
              IconButton(
                icon: const Icon(Icons.delete_sweep_rounded, color: Colors.white),
                tooltip: "Hapus Semua",
                onPressed: () {
                   showDialog(
                    context: context, 
                    builder: (_) => AlertDialog(
                      title: const Text("Hapus Semua?"),
                      content: const Text("Keranjang akan dikosongkan."),
                      actions: [
                        TextButton(onPressed: () => Navigator.pop(context), child: const Text("Batal")),
                        TextButton(
                          onPressed: () {
                            ref.read(cartProvider.notifier).clearCart();
                            Navigator.pop(context);
                          }, 
                          child: const Text("Hapus", style: TextStyle(color: Colors.red))
                        ),
                      ],
                    )
                  );
                },
              )
          ],
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(24))
          ),
        ),
      ),
      // ---------------------
      body: cartItems.isEmpty
          ? _buildEmptyState(context)
          : Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.all(20),
                    itemCount: cartItems.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final item = cartItems[index];
                      return FadeInUp(
                        duration: const Duration(milliseconds: 400),
                        delay: Duration(milliseconds: index * 100),
                        child: _CartItemCard(item: item, currency: currency, ref: ref),
                      );
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withAlpha(13), blurRadius: 20, offset: const Offset(0, -5))
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Total Pesanan", style: TextStyle(color: Colors.grey[600], fontSize: 16)),
                          Text(
                            currency.format(totalAmount),
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Color(0xFF720E1E)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF720E1E),
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            elevation: 4,
                            shadowColor: const Color(0xFF720E1E).withAlpha(100),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const CheckoutScreen()),
                            );
                          },
                          child: const Text("LANJUT KE PEMBAYARAN", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16, letterSpacing: 0.5)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_cart_outlined, size: 100, color: Colors.grey[300]),
          const SizedBox(height: 20),
          Text("Keranjang Kosong", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.grey[400])),
          const SizedBox(height: 10),
          const Text("Yuk, pesan burger favoritmu sekarang!", style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 30),
          OutlinedButton(
            onPressed: () => Navigator.pop(context),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Color(0xFF720E1E)),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text("LIHAT MENU", style: TextStyle(color: Color(0xFF720E1E), fontWeight: FontWeight.bold)),
          )
        ],
      ),
    );
  }
}

class _CartItemCard extends StatelessWidget {
  final CartItem item;
  final NumberFormat currency;
  final WidgetRef ref;

  const _CartItemCard({required this.item, required this.currency, required this.ref});

  @override
  Widget build(BuildContext context) {
    final List<String> details = [];
    item.selectedVariants.forEach((k, v) => details.add(v.name));
    for (var m in item.selectedModifiers) {
      details.add(m.name);
    }
    
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [BoxShadow(color: Colors.black.withAlpha(5), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 80, height: 80,
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: item.product.imagePath.isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(item.product.imagePath, fit: BoxFit.contain, errorBuilder: (_,__,___) => const Icon(Icons.lunch_dining, color: Colors.orange)),
                  )
                : const Icon(Icons.lunch_dining, size: 40, color: Colors.orange),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.product.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 4),
                if (details.isNotEmpty)
                  Text(details.join(", "), style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                if (item.notes != null && item.notes!.isNotEmpty)
                   Text("Note: ${item.notes}", style: const TextStyle(fontSize: 11, color: Color(0xFFD32F2F), fontStyle: FontStyle.italic)),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(currency.format(item.totalPrice), style: const TextStyle(fontWeight: FontWeight.w900, color: Color(0xFF720E1E))),
                    Container(
                      height: 32,
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          _QtyBtn(icon: Icons.remove, onTap: () {
                             if (item.quantity > 1) {
                               ref.read(cartProvider.notifier).updateQuantity(item.id, item.quantity - 1);
                             } else {
                               ref.read(cartProvider.notifier).removeItem(item.id);
                             }
                          }),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(item.quantity.toString(), style: const TextStyle(fontWeight: FontWeight.bold)),
                          ),
                          _QtyBtn(icon: Icons.add, onTap: () {
                            ref.read(cartProvider.notifier).updateQuantity(item.id, item.quantity + 1);
                          }),
                        ],
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _QtyBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _QtyBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 32, height: 32,
        alignment: Alignment.center,
        child: Icon(icon, size: 16, color: Colors.black87),
      ),
    );
  }
}