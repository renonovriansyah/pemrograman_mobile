import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_colors.dart';
import 'cart_provider.dart';
import 'cart_model.dart';
import '../checkout/checkout_screen.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. Ambil data keranjang dari Provider
    final cartItems = ref.watch(cartProvider);
    final totalAmount = ref.watch(cartTotalProvider);
    
    // Format Rupiah
    final currency = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Pesanan Aktif"),
        actions: [
          // Tombol Hapus Semua (Opsional)
          if (cartItems.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep),
              onPressed: () {
                // Logic hapus semua
                ref.read(cartProvider.notifier).clearCart();
              },
            )
        ],
      ),
      body: cartItems.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_cart_outlined, size: 80, color: Colors.grey[300]),
                  const SizedBox(height: 16),
                  const Text("Keranjang Kosong", style: TextStyle(fontSize: 18, color: Colors.grey)),
                ],
              ),
            )
          : Column(
              children: [
                // LIST PESANAN
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: cartItems.length,
                    separatorBuilder: (context, index) => const Divider(),
                    itemBuilder: (context, index) {
                      final item = cartItems[index];
                      return _CartItemTile(item: item, currency: currency, ref: ref);
                    },
                  ),
                ),

                // FOOTER TOTAL & BAYAR
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(color: Colors.black.withAlpha(25), blurRadius: 10, offset: const Offset(0, -5))
                    ],
                  ),
                  child: SafeArea(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Total Pesanan", style: TextStyle(fontSize: 16)),
                            Text(
                              currency.format(totalAmount),
                              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.primaryRed),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const CheckoutScreen()),
                                );
                            },
                            child: const Text("BAYAR SEKARANG"),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
    );
  }
}

// Widget Terpisah untuk Tiap Item (Biar Rapi)
class _CartItemTile extends StatelessWidget {
  final CartItem item;
  final NumberFormat currency;
  final WidgetRef ref;

  const _CartItemTile({required this.item, required this.currency, required this.ref});

  @override
  Widget build(BuildContext context) {
    // Gabungkan nama varian dan modifier jadi satu string untuk subtitle
    final List<String> details = [];
    item.selectedVariants.forEach((k, v) => details.add(v.name));
    for (var m in item.selectedModifiers) {
      details.add(m.name);
    }
    if (item.notes != null && item.notes!.isNotEmpty) {
      details.add("Note: ${item.notes}");
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Jumlah (Qty)
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text("${item.quantity}x", style: const TextStyle(fontWeight: FontWeight.bold)),
        ),
        const SizedBox(width: 12),
        
        // Detail Produk
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(item.product.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              if (details.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text(
                    details.join(", "),
                    style: TextStyle(color: Colors.grey[600], fontSize: 13),
                  ),
                ),
              const SizedBox(height: 4),
              Text(currency.format(item.totalPrice), style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        ),

        // Tombol Edit Qty / Hapus
        Column(
          children: [
            IconButton(
              icon: const Icon(Icons.remove_circle_outline, color: Colors.grey),
              onPressed: () {
                if (item.quantity > 1) {
                  ref.read(cartProvider.notifier).updateQuantity(item.id, -1);
                } else {
                  // Jika sisa 1 dan dikurang, tanya mau hapus?
                  ref.read(cartProvider.notifier).removeItem(item.id);
                }
              },
            ),
            IconButton(
              icon: const Icon(Icons.add_circle_outline, color: AppColors.primaryRed),
              onPressed: () {
                ref.read(cartProvider.notifier).updateQuantity(item.id, 1);
              },
            ),
          ],
        )
      ],
    );
  }
}