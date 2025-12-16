import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
    final total = (data['totalAmount'] ?? 0).toDouble();
    final items = List<Map<String, dynamic>>.from(data['items'] ?? []);
    final method = data['paymentMethod'] ?? '-';
    final cashier = data['cashierName'] ?? 'Admin';
    
    DateTime date;
    if (data['timestamp'] != null && data['timestamp'] is Timestamp) {
      date = (data['timestamp'] as Timestamp).toDate();
    } else {
      date = DateTime.now();
    }
    final dateStr = DateFormat('dd MMM yyyy, HH:mm').format(date);
    final idShort = documentId.length > 8 ? documentId.substring(0, 8).toUpperCase() : documentId;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA), // Background abu lembut
      appBar: AppBar(
        title: const Text("Detail Transaksi", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        centerTitle: true,
        backgroundColor: const Color(0xFF720E1E), // Header Merah Maroon
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // --- KARTU STRUK ---
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(15),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  )
                ],
              ),
              child: Column(
                children: [
                  // Header Struk
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: const Color(0xFF720E1E).withAlpha(10),
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                    ),
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/logo.png',
                          height: 50,
                          errorBuilder: (_, __, ___) => const Icon(Icons.lunch_dining, size: 50, color: Color(0xFF720E1E)),
                        ),
                        const SizedBox(height: 12),
                        const Text("SIZZLE BURGER", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18, letterSpacing: 1.2, color: Color(0xFF720E1E))),
                        const SizedBox(height: 4),
                        Text("Jln. Rasa Juara No. 1", style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.green[100],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text("Lunas • $method", style: TextStyle(color: Colors.green[800], fontWeight: FontWeight.bold, fontSize: 12)),
                        ),
                      ],
                    ),
                  ),

                  // Info Transaksi
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        _buildInfoRow("ID Transaksi", "#$idShort"),
                        _buildInfoRow("Waktu", dateStr),
                        _buildInfoRow("Kasir", cashier),
                        const SizedBox(height: 20),
                        _buildDashedLine(),
                        const SizedBox(height: 20),

                        // Daftar Item
                        ...items.map((item) => _buildItemRow(item, currency)),

                        const SizedBox(height: 20),
                        _buildDashedLine(),
                        const SizedBox(height: 20),

                        // Total
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Total Bayar", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                            Text(currency.format(total), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Color(0xFF720E1E))),
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                  // Footer Struk
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
                    ),
                    child: Text("Terima kasih telah berbelanja!", textAlign: TextAlign.center, style: TextStyle(color: Colors.grey[600], fontStyle: FontStyle.italic)),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // --- TOMBOL CETAK ULANG ---
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF720E1E),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 4,
                  shadowColor: const Color(0xFF720E1E).withAlpha(100),
                ),
                onPressed: () async {
                  try {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Menyiapkan PDF..."), duration: Duration(milliseconds: 500)),
                    );
                    await PdfGenerator.reprint(data, documentId);
                  } catch (e) {
                    debugPrint("ERROR UI: $e");
                    if (!context.mounted) return;
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text("Gagal Cetak"),
                        content: Text(e.toString()),
                        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text("Tutup"))],
                      ),
                    );
                  }
                },
                icon: const Icon(Icons.print_rounded, color: Colors.white),
                label: const Text("CETAK ULANG STRUK", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey[600])),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
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
    if (item['note'] != null && item['note'].isNotEmpty) details.add("Note: ${item['note']}");

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("${item['quantity']}x", style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF720E1E))),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item['productName'], style: const TextStyle(fontWeight: FontWeight.bold)),
                if (details.isNotEmpty)
                  Text(details.join(", "), style: TextStyle(color: Colors.grey[600], fontSize: 12, height: 1.2)),
              ],
            ),
          ),
          Text(currency.format(subTotal), style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
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
}