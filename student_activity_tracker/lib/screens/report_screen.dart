import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fl_chart/fl_chart.dart'; 
import 'package:provider/provider.dart';
import '../providers/activity_provider.dart';
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
                  child: _buildProductivityChart(), // Placeholder
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
                  child: _buildTimeDistributionChart(context), // REAL-TIME PIE CHART
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 1,
                  child: _buildHabitTrendChart(), // Placeholder
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
  
  // 1. Produktivitas Mingguan (Grafik Batang) - Placeholder
  Widget _buildProductivityChart() {
    return _buildChartCard(
      title: 'Produktivitas Mingguan',
      content: BarChart(
        BarChartData(
          // Placeholder data 
          barGroups: List.generate(7, (i) => BarChartGroupData(
            x: i, 
            barRods: [
              BarChartRodData(
                toY: i * 50 + 100 + (i == 5 ? 200 : 0), 
                color: i == 6 ? Colors.orange : Colors.teal,
                width: 16,
              )
            ]
          )),
          titlesData: FlTitlesData(
            show: true, 
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: true, getTitlesWidget: (value, meta) {
                const days = ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'];
                return SideTitleWidget(
                  axisSide: meta.axisSide,
                  child: Text(days[value.toInt()]),
                );
              })
            ),
            leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 40)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          gridData: const FlGridData(show: true, drawVerticalLine: false),
          borderData: FlBorderData(show: false),
        ),
      ),
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
        // Menggunakan fungsi perhitungan yang ada di provider
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
              sections: dataPoints.map((data) {
                final percentage = (data.durationMinutes / totalDuration) * 100;
                return PieChartSectionData(
                  value: data.durationMinutes,
                  color: data.color,
                  title: '${percentage.toStringAsFixed(0)}%',
                  radius: 80,
                  titleStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                );
              }).toList(),
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

  // 4. Tren Kebiasaan (Grafik Garis) - Placeholder
  Widget _buildHabitTrendChart() {
    return _buildChartCard(
      title: 'Tren Kebiasaan',
      content: Column(
        children: [
          Expanded(
            child: LineChart(
              LineChartData(
                minY: 10, 
                maxY: 30,
                lineBarsData: [
                  LineChartBarData(
                    spots: List.generate(10, (i) => FlSpot(i.toDouble(), i % 2 == 0 ? 15 : 20 + i.toDouble())),
                    isCurved: true,
                    dotData: const FlDotData(show: true),
                    color: Colors.teal,
                  )
                ],
                titlesData: const FlTitlesData(show: false),
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