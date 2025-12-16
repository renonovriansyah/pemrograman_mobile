import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_colors.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currency = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    final dateFormat = DateFormat('dd MMM yyyy, HH:mm');

    return Scaffold(
      appBar: AppBar(
        title: const Text("Riwayat Penjualan"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        // Mengambil data dari koleksi 'transactions', diurutkan dari yang terbaru (descending)
        stream: FirebaseFirestore.instance
            .collection('transactions')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          // 1. Loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // 2. Error / Kosong
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.history, size: 80, color: Colors.grey),
                  SizedBox(height: 16),
                  Text("Belum ada transaksi.", style: TextStyle(color: Colors.grey)),
                ],
              ),
            );
          }

          // 3. Tampilkan Data
          final docs = snapshot.data!.docs;
          
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: docs.length,
            separatorBuilder: (context, index) => const Divider(),
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;
              final total = (data['totalAmount'] ?? 0).toDouble();
              final method = data['paymentMethod'] ?? '-';
              
              // Konversi Timestamp Firebase ke DateTime Dart
              DateTime date;
              if (data['timestamp'] != null) {
                date = (data['timestamp'] as Timestamp).toDate();
              } else {
                date = DateTime.now();
              }

              return ListTile(
                contentPadding: EdgeInsets.zero,
                leading: CircleAvatar(
                  backgroundColor: AppColors.primaryRed.withAlpha(30), // Ganti withOpacity jadi withAlpha biar aman
                  child: const Icon(Icons.receipt_long, color: AppColors.primaryRed),
                ),
                title: Text(
                  currency.format(total),
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                subtitle: Text("${dateFormat.format(date)} • $method"),
                trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                onTap: () {
                  // Nanti bisa tambah fitur lihat detail / cetak ulang struk di sini
                  showDialog(
                    context: context, 
                    builder: (ctx) => AlertDialog(
                      title: const Text("Detail Transaksi"),
                      content: Text("ID: ${docs[index].id}\nTotal: ${currency.format(total)}"),
                    )
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}