import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_colors.dart';
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
    
    DateTime date;
    if (data['timestamp'] != null) {
      if (data['timestamp'] is Timestamp) {
        date = (data['timestamp'] as Timestamp).toDate();
      } else {
        date = DateTime.now();
      }
    } else {
      date = DateTime.now();
    }
    final dateStr = DateFormat('dd MMMM yyyy, HH:mm').format(date);

    return Scaffold(
      appBar: AppBar(title: const Text("Detail Transaksi")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [BoxShadow(color: Colors.black.withAlpha(10), blurRadius: 10)],
              ),
              child: Column(
                children: [
                  _rowInfo("ID Transaksi", documentId.length > 8 ? documentId.substring(0, 8).toUpperCase() : documentId),
                  const Divider(),
                  _rowInfo("Waktu", dateStr),
                  const Divider(),
                  _rowInfo("Kasir", data['cashierName'] ?? '-'),
                  const Divider(),
                  _rowInfo("Metode Bayar", data['paymentMethod'] ?? '-'),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            const Text("Daftar Pesanan", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 12),

            ...items.map((item) {
              final subTotal = (item['totalPrice'] ?? 0).toDouble();
              final variants = item['variants'] as Map<String, dynamic>? ?? {};
              final modifiers = List<String>.from(item['modifiers'] ?? []);
              
              List<String> details = [];
              variants.forEach((k, v) => details.add(v));
              details.addAll(modifiers);
              if (item['note'] != null && item['note'].isNotEmpty) {
                details.add("Note: ${item['note']}");
              }

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text("${item['quantity']}x", style: const TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item['productName'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          if (details.isNotEmpty)
                            Text(details.join(", "), style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                        ],
                      ),
                    ),
                    Text(currency.format(subTotal), style: const TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              );
            }),

            const SizedBox(height: 20),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                "Total: ${currency.format(total)}",
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.primaryRed),
              ),
            ),
          ],
        ),
      ),
      
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          try {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Menyiapkan PDF..."), duration: Duration(milliseconds: 500)),
            );

            await PdfGenerator.reprint(data, documentId);
            
          } catch (e) {
            debugPrint("ERROR UI: $e"); // Pakai debugPrint, bukan print
            
            if (!context.mounted) return; // Cek mounted sebelum showDialog

            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text("Gagal Cetak"),
                content: Text(e.toString()), 
                actions: [
                  TextButton(onPressed: () => Navigator.pop(context), child: const Text("Tutup"))
                ],
              ),
            );
          }
        },
        backgroundColor: AppColors.primaryRed,
        icon: const Icon(Icons.print),
        label: const Text("Cetak Ulang Struk"),
      ),
    );
  }

  Widget _rowInfo(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey[600])),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}