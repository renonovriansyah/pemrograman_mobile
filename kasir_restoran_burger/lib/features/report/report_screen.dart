import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/widgets/app_background.dart';

class ReportScreen extends StatelessWidget {
  const ReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currencyCompact = NumberFormat.compactCurrency(locale: 'id_ID', symbol: ''); 

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("Laporan Penjualan"),
        centerTitle: true,
        backgroundColor: const Color(0xFF720E1E),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: AppBackground(
        child: SafeArea(
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('transactions').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator(color: Color(0xFF720E1E)));
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(child: Text("Belum ada data transaksi"));
              }

              final docs = snapshot.data!.docs;

              // --- 1. PROSES DATA GRAFIK ---
              final List<double> weeklySales = List.filled(7, 0.0);
              final today = DateTime.now();
              final List<String> weekLabels = [];

              for (int i = 6; i >= 0; i--) {
                final day = today.subtract(Duration(days: i));
                weekLabels.add(DateFormat('EEE', 'id_ID').format(day)); 
              }

              for (var doc in docs) {
                final data = doc.data() as Map<String, dynamic>;
                if (data['timestamp'] == null) continue;
                
                final timestamp = (data['timestamp'] as Timestamp).toDate();
                final total = (data['totalAmount'] ?? 0).toDouble();

                final difference = today.difference(timestamp).inDays;
                
                if (difference >= 0 && difference < 7) {
                  final index = 6 - difference;
                  weeklySales[index] += total;
                }
              }

              // --- 2. PROSES DATA TOP PRODUK ---
              final Map<String, int> productCount = {};
              for (var doc in docs) {
                final data = doc.data() as Map<String, dynamic>;
                final rawItems = data['items'] as List<dynamic>? ?? [];
                final items = rawItems.map((e) => e as Map<String, dynamic>).toList();

                for (var item in items) {
                  final name = item['productName'] as String;
                  final qty = item['quantity'] as int;
                  productCount[name] = (productCount[name] ?? 0) + qty;
                }
              }

              final sortedProducts = productCount.entries.toList()
                ..sort((a, b) => b.value.compareTo(a.value));
              final topProducts = sortedProducts.take(5).toList();

              // --- LOGIKA SKALA GRAFIK (PER 50 RIBU s/d 1 JUTA) ---
              double actualMax = 0;
              if (weeklySales.isNotEmpty) {
                 actualMax = weeklySales.reduce((a, b) => a > b ? a : b);
              }

              // 1. Kunci Interval di 50.000 (Sangat Rapat)
              const double yInterval = 50000; 

              // 2. Tentukan maxY
              // Minimal 1 Juta. Jika data lebih dari 1 Juta, ikuti data tertinggi.
              double maxY = actualMax;
              if (maxY < 1000000) {
                maxY = 1000000; // Force minimal 1 Juta
              }

              // 3. Bulatkan maxY ke kelipatan interval terdekat (agar grid rapi)
              maxY = (maxY / yInterval).ceil() * yInterval;

              return SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // KARTU GRAFIK
                    Container(
                      padding: const EdgeInsets.fromLTRB(16, 24, 24, 24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [BoxShadow(color: Colors.black.withAlpha(20), blurRadius: 10)],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(left: 8.0, bottom: 24),
                            child: Text("Omzet 7 Hari Terakhir", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          ),
                          
                          AspectRatio(
                            aspectRatio: 1.7, // Lebar & Pendek
                            child: BarChart(
                              BarChartData(
                                alignment: BarChartAlignment.spaceAround,
                                maxY: maxY,
                                barTouchData: BarTouchData(
                                  touchTooltipData: BarTouchTooltipData(
                                    tooltipBgColor: const Color(0xFF720E1E),
                                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                                      return BarTooltipItem(
                                        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0).format(rod.toY),
                                        const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                                      );
                                    },
                                  ),
                                ),
                                titlesData: FlTitlesData(
                                  show: true,
                                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                  
                                  // SUMBU Y (KIRI)
                                  leftTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      reservedSize: 45, 
                                      interval: yInterval, // Interval 50.000
                                      getTitlesWidget: (value, meta) {
                                        // Tampilkan label hanya setiap kelipatan 100rb biar teks tidak numpuk
                                        // (Tapi garis grid tetap 50rb)
                                        if (value % 100000 != 0) return const SizedBox(); 
                                        
                                        if (value == 0) return const SizedBox();
                                        return Text(
                                          currencyCompact.format(value),
                                          style: const TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold),
                                          textAlign: TextAlign.right,
                                        );
                                      },
                                    ),
                                  ),

                                  // SUMBU X (BAWAH)
                                  bottomTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      getTitlesWidget: (value, meta) {
                                        if (value < 0 || value >= weekLabels.length) return const SizedBox();
                                        return Padding(
                                          padding: const EdgeInsets.only(top: 8.0),
                                          child: Text(
                                            weekLabels[value.toInt()],
                                            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                gridData: FlGridData(
                                  show: true,
                                  drawVerticalLine: false,
                                  horizontalInterval: yInterval, // GARIS GRID MUNCUL TIAP 50 RIBU
                                  getDrawingHorizontalLine: (value) => FlLine(color: Colors.grey[100], strokeWidth: 1), // Garis lebih tipis
                                ),
                                borderData: FlBorderData(show: false),
                                barGroups: List.generate(7, (i) {
                                  return BarChartGroupData(
                                    x: i,
                                    barRods: [
                                      BarChartRodData(
                                        toY: weeklySales[i],
                                        color: i == 6 ? const Color(0xFF720E1E) : Colors.grey[300],
                                        width: 18,
                                        borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                                        backDrawRodData: BackgroundBarChartRodData(
                                          show: true,
                                          toY: maxY, 
                                          color: Colors.grey[50], 
                                        ),
                                      ),
                                    ],
                                  );
                                }),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),
                    const Text("Top 5 Menu Terlaris 🔥", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xFF720E1E))),
                    const SizedBox(height: 12),

                    // LIST TOP PRODUK
                    if (topProducts.isEmpty)
                      const Padding(
                        padding: EdgeInsets.all(20),
                        child: Text("Belum ada data penjualan produk.", style: TextStyle(color: Colors.grey)),
                      )
                    else
                      ...topProducts.map((entry) {
                        final index = topProducts.indexOf(entry) + 1;
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [BoxShadow(color: Colors.black.withAlpha(10), blurRadius: 5, offset: const Offset(0, 2))],
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 30, height: 30,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: index == 1 ? const Color(0xFFFFCD05) : const Color(0xFFF9F9F9),
                                  shape: BoxShape.circle,
                                  border: Border.all(color: index == 1 ? Colors.transparent : Colors.grey[300]!)
                                ),
                                child: Text("$index", style: TextStyle(fontWeight: FontWeight.bold, color: index == 1 ? const Color(0xFF720E1E) : Colors.grey)),
                              ),
                              const SizedBox(width: 16),
                              Expanded(child: Text(entry.key, style: const TextStyle(fontWeight: FontWeight.bold))),
                              Text("${entry.value} Terjual", style: const TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        );
                      }),
                      
                    const SizedBox(height: 40),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}