import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../core/widgets/app_background.dart'; 
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
      extendBodyBehindAppBar: true, 
      appBar: AppBar(
        title: const Text("Pesanan Pelanggan"),
        centerTitle: true,
        backgroundColor: const Color(0xFF720E1E), 
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          if (cartItems.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep_rounded),
              tooltip: "Kosongkan Keranjang",
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    title: const Text("Hapus Semua Pesanan?"),
                    content: const Text("Tindakan ini tidak bisa dibatalkan. Keranjang akan menjadi kosong."),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context), 
                        child: const Text("Jangan", style: TextStyle(color: Colors.grey))
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF720E1E)),
                        onPressed: () {
                          ref.read(cartProvider.notifier).clearCart();
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Keranjang berhasil dikosongkan."))
                          );
                        },
                        child: const Text("Ya, Hapus", style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                );
              },
            )
        ],
      ),
      body: AppBackground(
        child: SafeArea(
          child: cartItems.isEmpty
              ? _buildEmptyState(context)
              : Column(
                  children: [
                    Expanded(
                      child: ListView.separated(
                        padding: const EdgeInsets.all(16),
                        itemCount: cartItems.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final item = cartItems[index];
                          return FadeInUp(
                            duration: const Duration(milliseconds: 300),
                            delay: Duration(milliseconds: index * 50),
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
                          BoxShadow(color: Colors.black.withAlpha(15), blurRadius: 20, offset: const Offset(0, -5))
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Total Tagihan", style: TextStyle(fontSize: 16, color: Colors.black87)),
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
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                elevation: 3,
                                shadowColor: const Color(0xFF720E1E).withAlpha(100),
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const CheckoutScreen()),
                                );
                              },
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("LANJUT PEMBAYARAN", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                                  SizedBox(width: 8),
                                  Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 20)
                                ],
                              ),
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

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(150), 
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.shopping_basket_outlined, size: 80, color: Colors.grey[400]),
            ),
            const SizedBox(height: 24),
            const Text("Belum Ada Pesanan", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF333333))),
            const SizedBox(height: 8),
            Text("Silakan pilih menu di halaman utama untuk memulai pesanan.", textAlign: TextAlign.center, style: TextStyle(color: Colors.grey[600], fontSize: 14)),
            const SizedBox(height: 32),
            SizedBox(
              width: 200,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF720E1E),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
                child: const Text("TAMBAH MENU", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            )
          ],
        ),
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
    // PERBAIKAN: Menambahkan kurung kurawal
    for (var m in item.selectedModifiers) {
      details.add(m.name);
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withAlpha(5), blurRadius: 5, offset: const Offset(0, 2))],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 70, height: 70,
            decoration: BoxDecoration(
              color: const Color(0xFFF9F9F9),
              borderRadius: BorderRadius.circular(8),
            ),
            child: item.product.imagePath.isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Image.asset(item.product.imagePath, fit: BoxFit.contain, errorBuilder: (_, __, ___) => const Icon(Icons.lunch_dining, color: Colors.orange)),
                  )
                : const Icon(Icons.lunch_dining, size: 30, color: Colors.orange),
          ),
          const SizedBox(width: 12),
          
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.product.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                
                if (details.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 2.0),
                    child: Text(details.join(", "), style: TextStyle(fontSize: 11, color: Colors.grey[600]), maxLines: 2, overflow: TextOverflow.ellipsis),
                  ),
                
                if (item.notes != null && item.notes!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 2.0),
                    child: Text("Catatan: ${item.notes}", style: const TextStyle(fontSize: 11, color: Color(0xFFD32F2F), fontStyle: FontStyle.italic)),
                  ),
                
                const SizedBox(height: 8),
                
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(currency.format(item.totalPrice), style: const TextStyle(fontWeight: FontWeight.w800, color: Color(0xFF720E1E))),
                    
                    Container(
                      height: 28,
                      decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(6)),
                      child: Row(
                        children: [
                          _QtyBtn(icon: Icons.remove, onTap: () {
                            if (item.quantity > 1) {
                              ref.read(cartProvider.notifier).updateQuantity(item.id, item.quantity - 1);
                            } else {
                              ScaffoldMessenger.of(context).hideCurrentSnackBar();
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Item dihapus."), duration: Duration(seconds: 1)));
                              ref.read(cartProvider.notifier).removeItem(item.id);
                            }
                          }),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(item.quantity.toString(), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
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
      borderRadius: BorderRadius.circular(6),
      child: Container(width: 28, height: 28, alignment: Alignment.center, child: Icon(icon, size: 14, color: Colors.black87)),
    );
  }
}