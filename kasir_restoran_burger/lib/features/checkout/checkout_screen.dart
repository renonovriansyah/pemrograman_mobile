import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_colors.dart';
import '../cart/cart_model.dart';
import '../cart/cart_provider.dart';

class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({super.key});

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  String selectedPayment = 'TUNAI'; // Default payment

  @override
  Widget build(BuildContext context) {
    final cartItems = ref.watch(cartProvider);
    final totalAmount = ref.watch(cartTotalProvider);
    final currency = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    final dateFormat = DateFormat('dd/MM/yyyy HH:mm');

    return Scaffold(
      backgroundColor: const Color(0xFFE5E5E5),
      appBar: AppBar(
        title: const Text("Konfirmasi Pembayaran"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // --- TAMPILAN KERTAS STRUK ---
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: const Offset(0, 5))],
              ),
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Logo / Header Struk
                  const Icon(Icons.lunch_dining, size: 48, color: AppColors.primaryRed),
                  const SizedBox(height: 8),
                  const Text("SIZZLE BURGER", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 20, letterSpacing: 1.5)),
                  const Text("Jalan Rasa Juara No. 1", style: TextStyle(fontSize: 12, color: Colors.grey)),
                  const Text("Telp: 0812-3456-7890", style: TextStyle(fontSize: 12, color: Colors.grey)),
                  const SizedBox(height: 20),
                  
                  // PERBAIKAN 1: Menghapus parameter 'style' yang error
                  const Divider(thickness: 2, color: Colors.black87),
                  
                  // Detail Transaksi
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Tanggal:", style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                      Text(dateFormat.format(DateTime.now()), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Kasir:", style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                      const Text("Admin", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  
                  // PERBAIKAN 2: Menggunakan Divider biasa sebagai pemisah (tanpa style error)
                  const Divider(height: 1, color: Colors.grey), 
                  const SizedBox(height: 4),
                  _buildDashedLine(), // Garis putus-putus custom di bawahnya
                  const SizedBox(height: 10),

                  // List Item (Looping)
                  ...cartItems.map((item) {
                    final noteText = item.notes != null && item.notes!.isNotEmpty ? " (${item.notes})" : "";
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("${item.quantity}x", style: const TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(item.product.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                                if (item.selectedVariants.isNotEmpty || item.selectedModifiers.isNotEmpty)
                                  Text(
                                    _formatVariantDetails(item) + noteText,
                                    style: const TextStyle(fontSize: 10, color: Colors.grey),
                                  ),
                              ],
                            ),
                          ),
                          Text(currency.format(item.totalPrice)),
                        ],
                      ),
                    );
                  }),

                  const SizedBox(height: 10),
                  _buildDashedLine(),
                  const SizedBox(height: 10),

                  // Total & Hitungan
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Subtotal", style: TextStyle(fontSize: 12)),
                      Text(currency.format(totalAmount), style: const TextStyle(fontSize: 12)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("TOTAL", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
                      Text(currency.format(totalAmount), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: AppColors.primaryRed)),
                    ],
                  ),
                ],
              ),
            ),
            
            Container(
              height: 10,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(10)),
              ),
            ),
            
            const SizedBox(height: 24),

            // --- PILIH METODE BAYAR ---
            const Align(alignment: Alignment.centerLeft, child: Text("Metode Pembayaran", style: TextStyle(fontWeight: FontWeight.bold))),
            const SizedBox(height: 8),
            Row(
              children: [
                _paymentOption("TUNAI", Icons.money),
                const SizedBox(width: 12),
                _paymentOption("QRIS", Icons.qr_code_2),
              ],
            ),

            const SizedBox(height: 32),

            // --- TOMBOL FINAL ---
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.success,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                ),
                onPressed: () {
                  _processTransaction(context, ref);
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.print, color: Colors.white),
                    SizedBox(width: 8),
                    Text("CETAK & SELESAI", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper: Widget Pilihan Pembayaran
  Widget _paymentOption(String name, IconData icon) {
    final isSelected = selectedPayment == name;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => selectedPayment = name),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            // PERBAIKAN 3: Menggunakan withAlpha(25) menggantikan withOpacity(0.1)
            // 255 * 0.1 = 25.5 dibulatkan jadi 25
            color: isSelected ? AppColors.primaryRed.withAlpha(25) : Colors.white,
            border: Border.all(color: isSelected ? AppColors.primaryRed : Colors.grey[300]!, width: 2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              Icon(icon, color: isSelected ? AppColors.primaryRed : Colors.grey),
              const SizedBox(height: 4),
              Text(name, style: TextStyle(fontWeight: FontWeight.bold, color: isSelected ? AppColors.primaryRed : Colors.grey)),
            ],
          ),
        ),
      ),
    );
  }

  // Helper: Format Text Varian
  String _formatVariantDetails(CartItem item) {
    final List<String> details = [];
    item.selectedVariants.forEach((k, v) => details.add(v.name));
    for (var m in item.selectedModifiers) {
      details.add(m.name);
    }
    return details.join(", ");
  }

  // Helper: Garis Putus-putus
  Widget _buildDashedLine() {
    return Row(
      children: List.generate(
        150 ~/ 5,
        (index) => Expanded(
          child: Container(
            color: index % 2 == 0 ? Colors.transparent : Colors.grey[300],
            height: 2,
          ),
        ),
      ),
    );
  }

  // LOGIC TRANSAKSI SELESAI
  void _processTransaction(BuildContext context, WidgetRef ref) {
    ref.read(cartProvider.notifier).clearCart();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Column(
          children: [
            Icon(Icons.check_circle, color: AppColors.success, size: 60),
            SizedBox(height: 10),
            Text("Pembayaran Berhasil!"),
          ],
        ),
        content: const Text("Struk sedang dicetak... (Simulasi)", textAlign: TextAlign.center),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            child: const Text("KEMBALI KE MENU"),
          ),
        ],
      ),
    );
  }
}