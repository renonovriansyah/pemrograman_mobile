import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/widgets/app_background.dart';
import '../../core/utils/pdf_generator.dart';

class TransactionDetailScreen extends StatelessWidget {
  final Map<String, dynamic> data;
  final String documentId;

  const TransactionDetailScreen({
    super.key,
    required this.data,
    required this.documentId,
  });

  @override
  Widget build(BuildContext context) {
    final currency = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    
    // --- PERSIAPAN DATA ---
    final total = (data['totalAmount'] ?? 0).toDouble();
    final items = List<Map<String, dynamic>>.from(data['items'] ?? []);
    final method = data['paymentMethod'] ?? '-';
    // AMBIL NAMA PELANGGAN (Default 'Umum' jika tidak ada di data lama)
    final customerName = data['customerName'] ?? 'Umum';
    
    DateTime date;
    if (data['timestamp'] != null && data['timestamp'] is Timestamp) {
      date = (data['timestamp'] as Timestamp).toDate();
    } else {
      date = DateTime.now();
    }
    final dateStr = DateFormat('dd/MM/yyyy HH:mm').format(date);

    return Scaffold(
      extendBodyBehindAppBar: true,
      // --- HEADER ---
      appBar: AppBar(
        title: const Text("Detail Transaksi", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: const Color(0xFF720E1E),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      // --- BODY ---
      body: AppBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                // 1. KERTAS STRUK
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
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
                      // --- HEADER STRUK ---
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: const BoxDecoration(
                          border: Border(bottom: BorderSide(color: Colors.black12, style: BorderStyle.none)),
                        ),
                        child: Column(
                          children: [
                            Image.asset(
                              'assets/logo.png',
                              height: 50,
                              errorBuilder: (_, __, ___) => const Icon(Icons.lunch_dining, size: 48, color: Color(0xFF720E1E)),
                            ),
                            const SizedBox(height: 12),
                            const Text("SIZZLE BURGER", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18, letterSpacing: 1.5, color: Color(0xFF720E1E))),
                            const SizedBox(height: 4),
                            const Text("Jln. Rasa Juara No. 1", style: TextStyle(fontSize: 12, color: Colors.grey)),
                            const SizedBox(height: 20),
                            
                            _buildDashedLine(),
                            const SizedBox(height: 16),
                            
                            // Info Pelanggan (BARU)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Pelanggan", style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                                Text(customerName, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                              ],
                            ),
                            const SizedBox(height: 4),

                            // Info Tanggal
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Tanggal", style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                                Text(dateStr, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                              ],
                            ),
                            const SizedBox(height: 4),

                            // Info Kasir
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Kasir", style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                                Text(data['cashierName'] ?? 'Admin', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                              ],
                            ),
                            const SizedBox(height: 4),

                            // Info Metode Pembayaran
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Metode", style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                                Text(method, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // --- LIST ITEM ---
                      Padding(
                        padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                        child: Column(
                          children: [
                            _buildDashedLine(),
                            const SizedBox(height: 16),
                            
                            // Looping Items
                            ...items.map((item) => _buildItemRow(item, currency)),

                            const SizedBox(height: 8),
                            _buildDashedLine(),
                            const SizedBox(height: 16),

                            // --- BAGIAN TOTAL ---
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text("Subtotal", style: TextStyle(fontSize: 14)),
                                Text(currency.format(total), style: const TextStyle(fontSize: 14)),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text("TOTAL BAYAR", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
                                Text(
                                  currency.format(total), 
                                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Color(0xFF720E1E)),
                                ),
                              ],
                            ),
                            
                            const SizedBox(height: 24),
                            const Text("Terima Kasih!", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            const Text("Follow IG: @sizzleburger", style: TextStyle(fontSize: 12, color: Colors.grey)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // 2. EFEK GERIGI BAWAH
                SizedBox(
                  height: 12,
                  width: double.infinity,
                  child: ClipPath(
                    clipper: ZigZagClipper(), 
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(color: Colors.black.withAlpha(10), blurRadius: 5, offset: const Offset(0, 5))
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // 3. TOMBOL CETAK ULANG
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
                    onPressed: () async {
                      try {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Menyiapkan Struk..."), duration: Duration(milliseconds: 500)));
                        await PdfGenerator.reprint(data, documentId);
                      } catch (e) {
                        if (context.mounted) {
                          showDialog(context: context, builder: (_) => AlertDialog(content: Text("Gagal cetak: $e")));
                        }
                      }
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.print_rounded, color: Colors.white),
                        SizedBox(width: 10),
                        Text("CETAK ULANG STRUK", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- STYLE ITEM ROW ---
  Widget _buildItemRow(Map<String, dynamic> item, NumberFormat currency) {
    final subTotal = (item['totalPrice'] ?? 0).toDouble();
    final variants = item['variants'] as Map<String, dynamic>? ?? {};
    final modifiers = List<String>.from(item['modifiers'] ?? []);
    
    List<String> details = [];
    variants.forEach((k, v) => details.add(v));
    details.addAll(modifiers);
    if (item['note'] != null && item['note'].isNotEmpty) {
      details.add("(${item['note']})");
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Kotak Kuantitas
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(4)),
            child: Text("${item['quantity']}x", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
          ),
          const SizedBox(width: 12),
          
          // Detail Produk
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item['productName'], style: const TextStyle(fontWeight: FontWeight.bold)),
                if (details.isNotEmpty)
                  Text(
                    details.join(", "),
                    style: TextStyle(fontSize: 11, color: Colors.grey[600], height: 1.2),
                  ),
              ],
            ),
          ),
          
          // Harga
          Text(currency.format(subTotal), style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildDashedLine() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final boxWidth = constraints.constrainWidth();
        const dashWidth = 6.0;
        final dashCount = (boxWidth / (2 * dashWidth)).floor();
        return Flex(
          direction: Axis.horizontal,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(dashCount, (_) => const SizedBox(width: dashWidth, height: 1, child: DecoratedBox(decoration: BoxDecoration(color: Colors.grey)))),
        );
      },
    );
  }
}

// --- CLIPPER GERIGI ---
class ZigZagClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height);
    var x = 0.0;
    var step = 10.0; 
    while (x < size.width) {
      path.lineTo(x + step / 2, size.height - 6); 
      path.lineTo(x + step, size.height);
      x += step;
    }
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }
  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}