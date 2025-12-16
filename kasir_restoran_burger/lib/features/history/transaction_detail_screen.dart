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
    
    DateTime date;
    if (data['timestamp'] != null && data['timestamp'] is Timestamp) {
      date = (data['timestamp'] as Timestamp).toDate();
    } else {
      date = DateTime.now();
    }
    final dateStr = DateFormat('dd MMM yyyy, HH:mm').format(date);
    
    final idShort = documentId.length > 8 ? documentId.substring(0, 8).toUpperCase() : documentId;

    return Scaffold(
      extendBodyBehindAppBar: true,
      // --- HEADER KOTAK STANDAR ---
      appBar: AppBar(
        title: const Text("Detail Transaksi"),
        centerTitle: true,
        backgroundColor: const Color(0xFF720E1E),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      // --- BACKGROUND GAMBAR ---
      body: AppBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // 1. KERTAS STRUK (BAGIAN PUTIH)
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    // Hanya melengkung di bagian atas
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withAlpha(10), blurRadius: 15, offset: const Offset(0, -2))
                    ],
                  ),
                  child: Column(
                    children: [
                      // --- LOGO & ALAMAT ---
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          border: Border(bottom: BorderSide(color: Colors.grey[200]!, style: BorderStyle.solid)),
                        ),
                        child: Column(
                          children: [
                            Image.asset(
                              'assets/logo.png',
                              height: 50,
                              errorBuilder: (_, __, ___) => const Icon(Icons.lunch_dining, size: 40, color: Color(0xFF720E1E)),
                            ),
                            const SizedBox(height: 12),
                            const Text("SIZZLE BURGER", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18, letterSpacing: 1.2, color: Color(0xFF720E1E))),
                            const SizedBox(height: 4),
                            Text("Jln. Rasa Juara No. 1", style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                            const SizedBox(height: 12),
                            // Badge Status Lunas
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.green[50],
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(color: Colors.green.withAlpha(50))
                              ),
                              child: Text("LUNAS • $method", style: TextStyle(fontSize: 10, color: Colors.green[800], fontWeight: FontWeight.bold)),
                            )
                          ],
                        ),
                      ),

                      // --- ISI ITEM & HARGA ---
                      Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          children: [
                            // Info Dasar
                            _buildInfoRow("ID Transaksi", "#$idShort"),
                            _buildInfoRow("Waktu", dateStr),
                            _buildInfoRow("Kasir", data['cashierName'] ?? 'Admin'),
                            
                            const SizedBox(height: 20),
                            _buildDashedLine(),
                            const SizedBox(height: 20),

                            // List Item (Looping)
                            ...items.map((item) => _buildItemRow(item, currency)),

                            const SizedBox(height: 20),
                            _buildDashedLine(),
                            const SizedBox(height: 20),

                            // Total Harga
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text("Total Bayar", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                Text(currency.format(total), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Color(0xFF720E1E))),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // 2. EFEK GERIGI (DIPERBAIKI: Menggunakan decoration agar tidak error)
                SizedBox(
                  height: 12,
                  width: double.infinity,
                  child: ClipPath(
                    clipper: ZigZagClipper(), 
                    child: Container(
                      decoration: BoxDecoration( // <-- PERBAIKAN DI SINI
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(color: Colors.black.withAlpha(10), blurRadius: 5, offset: const Offset(0, 5))
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // 3. TOMBOL CETAK
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF720E1E), // Warna Maroon
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 4,
                      shadowColor: const Color(0xFF720E1E).withAlpha(100),
                    ),
                    onPressed: () async {
                      try {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Menyiapkan PDF..."), duration: Duration(milliseconds: 500)));
                        await PdfGenerator.reprint(data, documentId);
                      } catch (e) {
                        // PERBAIKAN DI SINI: Cek mounted sebelum pakai context
                        if (context.mounted) {
                          showDialog(context: context, builder: (_) => AlertDialog(content: Text("Gagal cetak: $e")));
                        }
                      }
                    },
                    icon: const Icon(Icons.print_rounded, color: Colors.white),
                    label: const Text("CETAK ULANG STRUK", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
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

  // --- WIDGET PENDUKUNG ---

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
          Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildItemRow(Map<String, dynamic> item, NumberFormat currency) {
    final subTotal = (item['totalPrice'] ?? 0).toDouble();
    
    final variants = item['variants'] as Map<String, dynamic>? ?? {};
    final modifiers = List<String>.from(item['modifiers'] ?? []);
    
    List<String> details = [];
    variants.forEach((k, v) => details.add(v));
    details.addAll(modifiers);
    if (item['note'] != null && item['note'].isNotEmpty) {
      details.add("Note: ${item['note']}");
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("${item['quantity']}x", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF720E1E))),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item['productName'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                if (details.isNotEmpty)
                  Text(details.join(", "), style: TextStyle(fontSize: 11, color: Colors.grey[600], height: 1.2)),
              ],
            ),
          ),
          Text(currency.format(subTotal), style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildDashedLine() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final boxWidth = constraints.constrainWidth();
        const dashWidth = 5.0;
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

// --- CLIPPER GERIGI (Wajib ada) ---
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