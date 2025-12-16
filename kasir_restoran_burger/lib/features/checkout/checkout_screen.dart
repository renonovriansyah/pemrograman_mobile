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
  
  // Controller Nama
  final TextEditingController _nameController = TextEditingController();
  
  // Variable untuk Nomor Meja (Dropdown)
  int? selectedTable; 
  final List<int> tableNumbers = List.generate(10, (index) => index + 1);

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cartItems = ref.watch(cartProvider);
    final totalAmount = ref.watch(cartTotalProvider);
    final currency = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    final dateFormat = DateFormat('dd/MM/yyyy HH:mm');

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text("Konfirmasi Pembayaran", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        centerTitle: true,
        backgroundColor: const Color(0xFF720E1E),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: FadeInUp(
          duration: const Duration(milliseconds: 500),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- KERTAS STRUK (PREVIEW) ---
              _buildReceiptPreview(cartItems, totalAmount, currency, dateFormat),

              const SizedBox(height: 32),

              // --- 1. IDENTITAS PELANGGAN (NAMA & MEJA) ---
              const Text("Identitas Pesanan", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 12),
              
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Input Nama
                  Expanded(
                    flex: 2,
                    child: TextField(
                      controller: _nameController,
                      textCapitalization: TextCapitalization.words,
                      decoration: InputDecoration(
                        hintText: "Nama Pelanggan",
                        filled: true,
                        fillColor: Colors.white,
                        prefixIcon: const Icon(Icons.person_outline_rounded, color: Colors.grey),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey[200]!)),
                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF720E1E), width: 1.5)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  
                  // Dropdown Meja
                  Expanded(
                    flex: 1,
                    child: DropdownButtonFormField<int>(
                      initialValue: selectedTable,
                      hint: const Text("Meja"),
                      items: tableNumbers.map((number) {
                        return DropdownMenuItem(
                          value: number,
                          child: Text("Meja $number", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedTable = value;
                        });
                      },
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey[200]!)),
                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF720E1E), width: 1.5)),
                      ),
                      dropdownColor: Colors.white,
                      icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.grey),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // --- 2. PILIH METODE BAYAR ---
              const Text("Metode Pembayaran", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 12),
              Row(
                children: [
                  _paymentOption("TUNAI", Icons.payments_outlined),
                  const SizedBox(width: 16),
                  // UBAH DARI QRIS KE DANA
                  _paymentOption("DANA", Icons.qr_code_2_rounded), 
                ],
              ),

              // --- 3. TAMPILAN QR DANA ---
              // Logika diubah cek 'DANA'
              AnimatedSize(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                alignment: Alignment.topCenter,
                child: selectedPayment == 'DANA'
                    ? Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(top: 20),
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.blue[100]!), // Sedikit nuansa biru khas DANA
                          boxShadow: [BoxShadow(color: Colors.blue.withAlpha(10), blurRadius: 10, offset: const Offset(0, 5))]
                        ),
                        child: Column(
                          children: [
                            // Header Kecil DANA
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.account_balance_wallet, color: Colors.blue[700], size: 20),
                                const SizedBox(width: 8),
                                Text("Scan QR DANA", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue[800], fontSize: 16)),
                              ],
                            ),
                            const SizedBox(height: 16),
                            
                            // GAMBAR BARCODE (Pastikan assets/barcode.png adalah QR DANA Anda)
                            Image.asset(
                              'assets/barcode.png', 
                              height: 180, 
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  height: 180, width: 180,
                                  color: Colors.grey[100],
                                  child: const Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.broken_image_rounded, size: 40, color: Colors.grey),
                                      SizedBox(height: 8),
                                      Text("Barcode tidak ditemukan", style: TextStyle(fontSize: 10, color: Colors.grey)),
                                    ],
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 16),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(color: Colors.blue[50], borderRadius: BorderRadius.circular(8)),
                              child: Text(currency.format(totalAmount), style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18, color: Colors.blue[800])),
                            ),
                          ],
                        ),
                      )
                    : const SizedBox.shrink(),
              ),

              const SizedBox(height: 40),

              // --- TOMBOL FINAL ---
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF720E1E),
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    elevation: 4,
                    shadowColor: const Color(0xFF720E1E).withAlpha(100),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () {
                    if (cartItems.isEmpty) {
                      _showErrorSnackBar(context, "Keranjang kosong!");
                      return;
                    }
                    _processTransaction(context, ref);
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.payment_rounded, color: Colors.white, size: 24),
                      SizedBox(width: 12),
                      Text("BAYAR PESANAN", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1.0, color: Colors.white)),
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

  // --- HELPER WIDGETS ---

  Widget _paymentOption(String name, IconData icon) {
    final isSelected = selectedPayment == name;
    
    // Warna khusus jika DANA dipilih (Biru), jika Tunai (Maroon)
    Color activeColor = const Color(0xFF720E1E);
    if (name == 'DANA') activeColor = const Color(0xFF118EEA); // Biru DANA

    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => selectedPayment = name),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: isSelected ? activeColor.withAlpha(13) : Colors.white,
            border: Border.all(
              color: isSelected ? activeColor : Colors.grey[200]!, 
              width: isSelected ? 2 : 1
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: isSelected ? [] : [BoxShadow(color: Colors.grey.withAlpha(13), blurRadius: 5)],
          ),
          child: Column(
            children: [
              Icon(icon, color: isSelected ? activeColor : Colors.grey, size: 28),
              const SizedBox(height: 8),
              Text(
                name, 
                style: TextStyle(fontWeight: FontWeight.bold, color: isSelected ? activeColor : Colors.grey[600], fontSize: 14),
              ),
              if (isSelected)
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Icon(Icons.check_circle, size: 16, color: activeColor),
                )
            ],
          ),
        ),
      ),
    );
  }

  // Preview Struk
  Widget _buildReceiptPreview(List<CartItem> cartItems, double totalAmount, NumberFormat currency, DateFormat dateFormat) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withAlpha(13), blurRadius: 20, offset: const Offset(0, 10))],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Colors.black12, style: BorderStyle.none))),
            child: Column(
              children: [
                Image.asset('assets/logo.png', height: 50, errorBuilder: (_,__,___) => const Icon(Icons.lunch_dining, size: 48, color: Color(0xFF720E1E))),
                const SizedBox(height: 12),
                const Text("SIZZLE BURGER", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18, letterSpacing: 1.5, color: Color(0xFF720E1E))),
                const SizedBox(height: 20),
                _buildDashedLine(),
                const SizedBox(height: 16),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text("Tanggal", style: TextStyle(fontSize: 12, color: Colors.grey[600])), Text(dateFormat.format(DateTime.now()), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold))]),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
            child: Column(
              children: [
                _buildDashedLine(),
                const SizedBox(height: 16),
                if (cartItems.isEmpty) const Text("Keranjang Kosong")
                else ...cartItems.map((item) => Padding(padding: const EdgeInsets.only(bottom: 12.0), child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(4)), child: Text("${item.quantity}x", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
                  const SizedBox(width: 12),
                  Expanded(child: Text(item.product.name, style: const TextStyle(fontWeight: FontWeight.bold))),
                  Text(currency.format(item.totalPrice), style: const TextStyle(fontWeight: FontWeight.w600)),
                ]))),
                const SizedBox(height: 16), _buildDashedLine(), const SizedBox(height: 16),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text("TOTAL BAYAR", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)), Text(currency.format(totalAmount), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Color(0xFF720E1E)))]),
              ],
            ),
          ),
          Container(height: 16, decoration: const BoxDecoration(color: Color(0xFFF8F9FA), borderRadius: BorderRadius.vertical(top: Radius.circular(16)))),
        ],
      ),
    );
  }

  Widget _buildDashedLine() {
    return LayoutBuilder(builder: (context, constraints) {
      final dashCount = (constraints.constrainWidth() / (2 * 6.0)).floor();
      return Flex(direction: Axis.horizontal, mainAxisAlignment: MainAxisAlignment.spaceBetween, children: List.generate(dashCount, (_) => const SizedBox(width: 6.0, height: 1, child: DecoratedBox(decoration: BoxDecoration(color: Colors.grey)))));
    });
  }

  void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message), backgroundColor: Colors.red[700], behavior: SnackBarBehavior.floating));
  }

  // --- LOGIKA TRANSAKSI ---
  Future<void> _processTransaction(BuildContext context, WidgetRef ref) async {
    final cartItems = ref.read(cartProvider);
    final totalAmount = ref.read(cartTotalProvider);
    
    // 1. FORMAT NAMA PELANGGAN
    String name = _nameController.text.trim();
    if (name.isEmpty) name = "Pelanggan"; 
    
    // 2. GABUNGKAN DENGAN NOMOR MEJA
    String finalCustomerName = name;
    if (selectedTable != null) {
      finalCustomerName = "$name (Meja $selectedTable)";
    }

    showDialog(
      context: context, barrierDismissible: false,
      builder: (context) => const Dialog(backgroundColor: Colors.white, child: Padding(padding: EdgeInsets.all(24.0), child: Column(mainAxisSize: MainAxisSize.min, children: [CircularProgressIndicator(color: Color(0xFF720E1E)), SizedBox(height: 16), Text("Memproses Transaksi...", style: TextStyle(fontWeight: FontWeight.bold))]))),
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
        customerName: finalCustomerName, 
      );

      await PdfGenerator.printReceipt(cartItems, totalAmount, selectedPayment);

      if (!context.mounted) return; 
      Navigator.pop(context); 
      ref.read(cartProvider.notifier).clearCart();

      showDialog(
        context: context, barrierDismissible: false,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Column(children: [Icon(Icons.check_circle_rounded, color: Colors.green, size: 70), SizedBox(height: 12), Text("Transaksi Berhasil!", style: TextStyle(fontWeight: FontWeight.w900))]),
          content: Text("Pesanan untuk $finalCustomerName berhasil disimpan.", textAlign: TextAlign.center, style: const TextStyle(color: Colors.grey)),
          actionsAlignment: MainAxisAlignment.center,
          actions: [ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF720E1E), padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12)), onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst), child: const Text("TRANSAKSI BARU", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)))],
        ),
      );
    } catch (e) {
      if (!context.mounted) return;
      Navigator.pop(context); 
      _showErrorSnackBar(context, "Gagal memproses: $e");
    }
  }
}