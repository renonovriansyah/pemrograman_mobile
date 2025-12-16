import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../core/utils/pdf_generator.dart';
import '../../data/firestore_service.dart';
import '../cart/cart_model.dart';
import '../cart/cart_provider.dart';

class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({super.key});

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  String selectedPayment = 'TUNAI';

  @override
  Widget build(BuildContext context) {
    final cartItems = ref.watch(cartProvider);
    final totalAmount = ref.watch(cartTotalProvider);
    final currency = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    final dateFormat = DateFormat('dd/MM/yyyy HH:mm');

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      // --- CUSTOM HEADER ---
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: AppBar(
          title: const Text("Konfirmasi Pembayaran", style: TextStyle(fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 1)),
          centerTitle: true,
          backgroundColor: const Color(0xFF720E1E),
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(24))
          ),
        ),
      ),
      // ---------------------
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: FadeInUp(
          duration: const Duration(milliseconds: 500),
          child: Column(
            children: [
              // --- KERTAS STRUK ---
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(13), 
                      blurRadius: 20, 
                      offset: const Offset(0, 10)
                    )
                  ],
                ),
                child: Column(
                  children: [
                    // BAGIAN ATAS KERTAS (Header)
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: const BoxDecoration(
                        border: Border(bottom: BorderSide(color: Colors.black12, style: BorderStyle.none)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/logo.png', 
                            height: 50, 
                            errorBuilder: (_,__,___) => const Icon(Icons.lunch_dining, size: 48, color: Color(0xFF720E1E)),
                          ),
                          const SizedBox(height: 12),
                          const Text("SIZZLE BURGER", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18, letterSpacing: 1.5, color: Color(0xFF720E1E))),
                          const SizedBox(height: 4),
                          const Text("Jln. Rasa Juara No. 1", style: TextStyle(fontSize: 12, color: Colors.grey)),
                          const SizedBox(height: 20),
                          _buildDashedLine(),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Tanggal", style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                              Text(dateFormat.format(DateTime.now()), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Kasir", style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                              const Text("Admin", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // LIST ITEM & TOTAL (Bagian Isi)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                      child: Column(
                        children: [
                          _buildDashedLine(),
                          const SizedBox(height: 16),
                          if (cartItems.isEmpty)
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 20),
                              child: Text("Keranjang Kosong", style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic)),
                            )
                          else
                            ...cartItems.map((item) {
                              final noteText = item.notes != null && item.notes!.isNotEmpty ? " (${item.notes})" : "";
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(4)),
                                      child: Text("${item.quantity}x", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(item.product.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                                          if (item.selectedVariants.isNotEmpty || item.selectedModifiers.isNotEmpty)
                                            Text(
                                              _formatVariantDetails(item) + noteText,
                                              style: TextStyle(fontSize: 11, color: Colors.grey[600], height: 1.2),
                                            ),
                                        ],
                                      ),
                                    ),
                                    Text(currency.format(item.totalPrice), style: const TextStyle(fontWeight: FontWeight.w600)),
                                  ],
                                ),
                              );
                            }),

                          const SizedBox(height: 16),
                          _buildDashedLine(),
                          const SizedBox(height: 16),

                          // TOTAL SECTION
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Subtotal", style: TextStyle(fontSize: 14)),
                              Text(currency.format(totalAmount), style: const TextStyle(fontSize: 14)),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("TOTAL BAYAR", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
                              Text(
                                currency.format(totalAmount), 
                                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Color(0xFF720E1E)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 16,
                      decoration: const BoxDecoration(
                        color: Color(0xFFF8F9FA),
                        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // --- PILIH METODE BAYAR ---
              const Align(alignment: Alignment.centerLeft, child: Text("Metode Pembayaran", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
              const SizedBox(height: 12),
              Row(
                children: [
                  _paymentOption("TUNAI", Icons.payments_outlined),
                  const SizedBox(width: 16),
                  _paymentOption("QRIS", Icons.qr_code_scanner),
                ],
              ),

              const SizedBox(height: 40),

              // --- TOMBOL FINAL ---
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4CAF50),
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    elevation: 4,
                    shadowColor: Colors.green.withAlpha(102),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () {
                    if (cartItems.isEmpty) {
                      _showErrorSnackBar(context, "Keranjang kosong! Tambah menu dulu.");
                      return;
                    }
                    _processTransaction(context, ref);
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.print_rounded, color: Colors.white),
                      SizedBox(width: 10),
                      Text("SELESAIKAN PESANAN", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _paymentOption(String name, IconData icon) {
    final isSelected = selectedPayment == name;
    final primaryColor = const Color(0xFF720E1E);

    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => selectedPayment = name),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: isSelected ? primaryColor.withAlpha(13) : Colors.white,
            border: Border.all(
              color: isSelected ? primaryColor : Colors.grey[200]!, 
              width: isSelected ? 2 : 1
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: isSelected ? [] : [BoxShadow(color: Colors.grey.withAlpha(13), blurRadius: 5)],
          ),
          child: Column(
            children: [
              Icon(icon, color: isSelected ? primaryColor : Colors.grey, size: 28),
              const SizedBox(height: 8),
              Text(
                name, 
                style: TextStyle(
                  fontWeight: FontWeight.bold, 
                  color: isSelected ? primaryColor : Colors.grey[600],
                  fontSize: 14
                ),
              ),
              if (isSelected)
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Icon(Icons.check_circle, size: 16, color: primaryColor),
                )
            ],
          ),
        ),
      ),
    );
  }

  String _formatVariantDetails(CartItem item) {
    final List<String> details = [];
    item.selectedVariants.forEach((k, v) => details.add(v.name));
    for (var m in item.selectedModifiers) {
      details.add(m.name);
    }
    return details.join(", ");
  }

  Widget _buildDashedLine() {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final boxWidth = constraints.constrainWidth();
        const dashWidth = 6.0;
        final dashCount = (boxWidth / (2 * dashWidth)).floor();
        return Flex(
          direction: Axis.horizontal,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(dashCount, (_) {
            return const SizedBox(
              width: dashWidth,
              height: 1,
              child: DecoratedBox(decoration: BoxDecoration(color: Colors.grey)),
            );
          }),
        );
      },
    );
  }

  void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.warning_amber_rounded, color: Colors.white),
            const SizedBox(width: 10),
            Text(message),
          ],
        ),
        backgroundColor: Colors.red[700],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Future<void> _processTransaction(BuildContext context, WidgetRef ref) async {
    final cartItems = ref.read(cartProvider);
    final totalAmount = ref.read(cartTotalProvider);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: const Padding(
          padding: EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(color: Color(0xFF720E1E)),
              SizedBox(height: 16),
              Text("Memproses Transaksi...", style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );

    try {
      final List<Map<String, dynamic>> orderItems = cartItems.map((item) {
        return {
          'productName': item.product.name,
          'quantity': item.quantity,
          'priceAtMoment': item.product.basePrice,
          'totalPrice': item.totalPrice,
          'variants': item.selectedVariants.map((k, v) => MapEntry(k, v.name)),
          'modifiers': item.selectedModifiers.map((e) => e.name).toList(),
          'note': item.notes ?? '',
        };
      }).toList();

      await FirestoreService().saveOrder(
        totalAmount: totalAmount,
        paymentMethod: selectedPayment,
        items: orderItems,
      );

      await PdfGenerator.printReceipt(cartItems, totalAmount, selectedPayment);

      if (!context.mounted) return; 
      Navigator.pop(context); 

      ref.read(cartProvider.notifier).clearCart();

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Column(
            children: [
              Icon(Icons.check_circle_rounded, color: Colors.green, size: 70),
              SizedBox(height: 12),
              Text("Transaksi Berhasil!", style: TextStyle(fontWeight: FontWeight.w900)),
            ],
          ),
          content: const Text(
            "Data telah tersimpan di cloud dan struk telah dikirim ke printer.",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF720E1E),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              onPressed: () {
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              child: const Text("TRANSAKSI BARU", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
            ),
          ],
        ),
      );
    } catch (e) {
      if (!context.mounted) return;
      Navigator.pop(context); 
      _showErrorSnackBar(context, "Gagal memproses: $e");
    }
  }
}