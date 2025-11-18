import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fl_chart/fl_chart.dart'; 
import 'package:provider/provider.dart';
import '../providers/activity_provider.dart';
import '../providers/habit_provider.dart'; // Wajib: Import Habit Provider
import '../models/activity.dart'; 

class ReportScreen extends StatelessWidget {
  const ReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FFF7), 
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0), 
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Laporan & Analisis',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // Baris 1: Produktivitas Mingguan & Pola Kerja Mingguan
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 1,
                  child: _buildProductivityChart(context), // Bar Chart Dinamis
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 1,
                  child: _buildHeatmapChart(), // Placeholder
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Baris 2: Distribusi Kategori & Tren Kebiasaan
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 1,
                  child: _buildTimeDistributionChart(context), // Pie Chart Dinamis
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 1,
                  // [FINAL IMPLEMENTASI LINE CHART]
                  child: _buildHabitTrendChart(context), 
                ),
              ],
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  // --- WIDGET CHART UTAMA ---

  Widget _buildChartCard({required String title, required Widget content, Widget? legend}) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const Divider(height: 20),
            SizedBox(
              height: 250, // Tinggi tetap untuk semua chart
              child: content,
            ),
            if (legend != null) legend,
          ],
        ),
      ),
    );
  }
  
  // 1. Produktivitas Mingguan (Grafik Batang) - REAL-TIME
  Widget _buildProductivityChart(BuildContext context) { 
    final activityProvider = Provider.of<ActivityProvider>(context);

    return StreamBuilder<List<Activity>>(
      stream: activityProvider.activitiesStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildChartCard(
            title: 'Produktivitas Mingguan',
            content: const Center(child: CircularProgressIndicator()),
          );
        }
        
        final activities = snapshot.data ?? [];
        final weeklyData = activityProvider.calculateWeeklyProductivity(activities);

        final maxY = weeklyData.isEmpty 
            ? 5.0 
            : (weeklyData.map((e) => e.durationHours).reduce((a, b) => a > b ? a : b) * 1.2).clamp(1.0, double.infinity); 

        return _buildChartCard(
          title: 'Produktivitas Mingguan',
          content: BarChart(
            BarChartData(
              maxY: maxY,
              barGroups: weeklyData.map((data) => BarChartGroupData(
                x: data.dayIndex - 1, 
                barRods: [
                  BarChartRodData(
                    toY: data.durationHours,
                    color: data.durationHours >= (maxY / 2.5) ? Colors.teal : Colors.blueGrey.shade400,
                    width: 16,
                  )
                ]
              )).toList(),
              titlesData: FlTitlesData(
                show: true, 
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: true, getTitlesWidget: (value, meta) {
                    const days = ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'];
                    final dayIndex = value.toInt();
                    if (dayIndex < 0 || dayIndex >= days.length) { 
                        return SideTitleWidget(axisSide: meta.axisSide, child: Text(''));
                    }
                    return SideTitleWidget(
                      axisSide: meta.axisSide,
                      child: Text(days[dayIndex]),
                    );
                  })
                ),
                leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 40, interval: maxY / 5)),
                topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              gridData: const FlGridData(show: true, drawVerticalLine: false),
              borderData: FlBorderData(show: false),
            ),
          ),
          legend: Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Text('Total aktivitas terakhir: ${activities.length}'),
          ),
        );
      }
    );
  }

  // 2. Pola Kerja Mingguan (Heatmap) - Placeholder
  Widget _buildHeatmapChart() {
    return _buildChartCard(
      title: 'Pola Kerja Mingguan',
      content: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 7, // 7 Hari
          crossAxisSpacing: 4,
          mainAxisSpacing: 4,
        ),
        itemCount: 7 * 5, // 5 Minggu (Visual saja)
        itemBuilder: (context, index) {
          final opacityValue = (index % 10) / 10; 
          
          return Container( 
            decoration: BoxDecoration(
              color: Colors.teal.withAlpha((opacityValue.clamp(0.2, 1.0) * 255).round()), 
              borderRadius: BorderRadius.circular(4),
            ),
          );
        },
      ),
    );
  }
  
  // 3. Distribusi Waktu (Diagram Lingkaran) - REAL-TIME
  Widget _buildTimeDistributionChart(BuildContext context) { 
    final activityProvider = Provider.of<ActivityProvider>(context);
    
    return StreamBuilder<List<Activity>>(
      stream: activityProvider.activitiesStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildChartCard(
            title: 'Distribusi Waktu Berdasarkan Kategori',
            content: const Center(child: CircularProgressIndicator()),
          );
        }
        
        final activities = snapshot.data ?? [];
        final dataPoints = activityProvider.calculateTimeDistribution(activities); 
        final totalDuration = dataPoints.fold(0.0, (sum, item) => sum + item.durationMinutes);
        
        // Cek jika data kosong
        if (totalDuration == 1.0 && dataPoints.length == 1 && dataPoints.first.category == "Kosong") {
             return _buildChartCard(
                title: 'Distribusi Waktu Berdasarkan Kategori',
                content: const Center(child: Text("Belum ada data aktivitas.")),
             );
        }

        return _buildChartCard(
          title: 'Distribusi Waktu Berdasarkan Kategori',
          content: PieChart(
            PieChartData(
              sectionsSpace: 2,
              centerSpaceRadius: 40,
              sections: dataPoints.map((data) => PieChartSectionData(
                  value: data.durationMinutes,
                  color: data.color,
                  title: '${(data.durationMinutes / totalDuration * 100).toStringAsFixed(0)}%',
                  radius: 80,
                  titleStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                )
              ).toList(),
              borderData: FlBorderData(show: false),
            ),
          ),
          legend: Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: dataPoints.map((data) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  '${data.category} (${(data.durationMinutes / totalDuration * 100).toStringAsFixed(0)}%)', 
                  style: TextStyle(color: data.color, fontWeight: FontWeight.w600)),
              )).toList(),
            ),
          ),
        );
      }
    );
  }

  // 4. Tren Kebiasaan (Grafik Garis) - FINAL IMPLEMENTASI
Widget _buildHabitTrendChart(BuildContext context) { 
  final habitProvider = Provider.of<HabitProvider>(context);
  final fullTrendData = habitProvider.calculateTrend();
  
  final trendData = fullTrendData.where((data) => data.dayOffset > 0).toList(); 

  // Menentukan batas sumbu X berdasarkan jumlah titik data (0 hingga 9)
  final double maxAxisX = trendData.length.toDouble() - 1; 

  if (trendData.isEmpty) {
     return _buildChartCard(
        title: 'Tren Kebiasaan',
        content: const Center(child: Text("Tidak ada data tren dalam 9 hari terakhir.")),
     );
  }

  return _buildChartCard(
    title: 'Tren Kebiasaan',
    content: Column(
      children: [
        Expanded(
          child: LineChart(
            LineChartData(
              // Pastikan batas sumbu X disetel dengan benar
              minX: 0, 
              maxX: maxAxisX, // Max index adalah 9 (10 titik)
              minY: 0, 
              maxY: 1.0, 
              lineBarsData: [
                LineChartBarData(
                  spots: trendData.asMap().entries.map((entry) {
                      final index = entry.key; // 0 sampai 8
                      final data = entry.value; // dayOffset 1 sampai 9
                      return FlSpot(index.toDouble(), data.completionRate);
                  }).toList(),
                  isCurved: true,
                  dotData: const FlDotData(show: true),
                  color: Colors.teal,
                )
              ],
              titlesData: FlTitlesData(
                show: true, 
                // --- Sumbu X (Bottom Titles) ---
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true, 
                    reservedSize: 25, 
                    interval: 2, // [UPDATED] Tampilkan setiap titik (1 hari lalu)
                    getTitlesWidget: (value, meta) {
                    final maxAxisX = trendData.length.toDouble() - 1; // 8.0 (untuk 9 titik)
                    final daysAgo = maxAxisX.toInt() - value.toInt() + 1;
                    
                    if (daysAgo < 1 || daysAgo > 9) { 
                        // [FIX 1 & 2] Hapus const dan pindahkan child ke akhir
                        return SideTitleWidget(axisSide: meta.axisSide, child: const Text('')); 
                    }
                    
                    return SideTitleWidget(
                        axisSide: meta.axisSide,
                        child: Text('$daysAgo hari lalu'), // [FIX 2] Child di akhir
                    );
                    }
                  )
                ),
                // --- Sumbu Y (Left Titles) ---
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true, 
                    reservedSize: 40, 
                    interval: 0.2, // Interval 20%
                    getTitlesWidget: (value, meta) {
                      return Text('${(value * 100).toInt()}%'); // Label dalam persentase
                    }
                  )
                ),
                topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              gridData: const FlGridData(show: true, drawVerticalLine: false),
              borderData: FlBorderData(show: false),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Align(
          alignment: Alignment.centerRight,
          child: ElevatedButton.icon(
            onPressed: () {},
            icon: const FaIcon(FontAwesomeIcons.filePdf, size: 16),
            label: const Text("Ekspor Laporan (PDF/CSV)"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal,
              foregroundColor: Colors.white,
            ),
          ),
        ),
      ],
    ),
  );
  }
}