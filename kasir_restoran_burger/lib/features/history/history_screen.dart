import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/widgets/app_background.dart'; // Import Background Wrapper
import 'transaction_detail_screen.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currency = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    return Scaffold(
      extendBodyBehindAppBar: true, // Agar background menyatu ke atas
      appBar: AppBar(
        title: const Text("Riwayat Transaksi"),
        centerTitle: true,
        backgroundColor: const Color(0xFF720E1E), // Konsisten Maroon
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      // MENGGUNAKAN APP BACKGROUND
      body: AppBackground(
        child: SafeArea(
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('transactions')
                .orderBy('timestamp', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              // 1. Loading
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator(color: Color(0xFF720E1E)));
              }

              // 2. Empty State (Kosong)
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.receipt_long_outlined, size: 80, color: Colors.grey[400]),
                      const SizedBox(height: 16),
                      Text(
                        "Belum ada riwayat transaksi", 
                        style: TextStyle(color: Colors.grey[500], fontWeight: FontWeight.bold, fontSize: 16)
                      ),
                    ],
                  ),
                );
              }

              final docs = snapshot.data!.docs;
              
              // 3. List Data
              return ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: docs.length,
                separatorBuilder: (context, index) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final data = docs[index].data() as Map<String, dynamic>;
                  final total = (data['totalAmount'] ?? 0).toDouble();
                  final method = data['paymentMethod'] ?? '-';
                  
                  // Safe Date Parsing
                  DateTime date;
                  if (data['timestamp'] != null && data['timestamp'] is Timestamp) {
                    date = (data['timestamp'] as Timestamp).toDate();
                  } else {
                    date = DateTime.now();
                  }
                  final dateStr = DateFormat('dd MMM yyyy, HH:mm').format(date);
                  final idShort = docs[index].id.substring(0, 8).toUpperCase();

                  return FadeInUp(
                    duration: const Duration(milliseconds: 300),
                    delay: Duration(milliseconds: index * 50),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TransactionDetailScreen(
                              data: data,
                              documentId: docs[index].id,
                            ),
                          ),
                        );
                      },
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(color: Colors.black.withAlpha(10), blurRadius: 8, offset: const Offset(0, 2))
                          ],
                        ),
                        child: Row(
                          children: [
                            // Icon Kotak
                            Container(
                              height: 50, width: 50,
                              decoration: BoxDecoration(
                                color: const Color(0xFFF9F9F9),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.grey[200]!)
                              ),
                              child: const Icon(Icons.receipt_long_rounded, color: Color(0xFF720E1E)),
                            ),
                            
                            const SizedBox(width: 16),
                            
                            // Info ID & Tanggal
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "#$idShort", 
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    dateStr, 
                                    style: TextStyle(color: Colors.grey[600], fontSize: 12)
                                  ),
                                ],
                              ),
                            ),
                            
                            // Harga & Status
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  currency.format(total), 
                                  style: const TextStyle(fontWeight: FontWeight.w900, color: Color(0xFF720E1E), fontSize: 16)
                                ),
                                const SizedBox(height: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.green[50],
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    "Lunas • $method", 
                                    style: TextStyle(fontSize: 10, color: Colors.green[800], fontWeight: FontWeight.bold)
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}