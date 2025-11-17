import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fl_chart/fl_chart.dart'; 

class ReportScreen extends StatelessWidget {
  const ReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // [FIXED] Menghilangkan Provider di sini karena tidak digunakan di level ini, 
    // atau kita bisa memanggil StreamBuilder di sini jika kita ingin data.
    // Jika kita ingin passing provider, kita harus membuat class ini menjadi StatefulWidget
    // atau mengubah signature method build. Karena ini StatelessWidget, kita hilangkan.
    // final activityProvider = Provider.of<ActivityProvider>(context); 

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0), // Padding lebih besar untuk desktop feel
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Laporan & Analisis',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // Baris 1: Produktivitas Mingguan & Heatmap
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 1,
                  child: _buildProductivityChart(),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 1,
                  child: _buildHeatmapChart(),
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
                  child: _buildTimeDistributionChart(),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 1,
                  child: _buildHabitTrendChart(),
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
  
  // 1. Produktivitas Mingguan (Grafik Batang)
  Widget _buildProductivityChart() {
    return _buildChartCard(
      title: 'Produktivitas Mingguan',
      content: BarChart(
        BarChartData(
          // Placeholder data untuk 7 hari
          barGroups: List.generate(7, (i) => BarChartGroupData(
            x: i, 
            barRods: [
              BarChartRodData(
                toY: i * 50 + 100 + (i == 5 ? 200 : 0), // Nilai dummy
                color: i == 6 ? Colors.orange : Colors.teal,
                width: 16,
              )
            ]
          )),
          titlesData: FlTitlesData(
            show: true, 
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: true, getTitlesWidget: (value, meta) {
                const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                // [FIXED] Perbaikan urutan properti SideTitleWidget
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

  // 2. Peta Panas Produktivitas (Heatmap - menggunakan placeholder)
  Widget _buildHeatmapChart() {
    return _buildChartCard(
      title: 'Pola Kerja Mingguan',
      content: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 7, // 7 Hari
          crossAxisSpacing: 4,
          mainAxisSpacing: 4,
        ),
        itemCount: 7 * 5, // Contoh 5 minggu
        itemBuilder: (context, index) {
          final opacityValue = (index % 10) / 10;
          // [FIXED] Menggunakan variabel intensity agar warning hilang
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
  
  // 3. Distribusi Waktu (Diagram Lingkaran)
  Widget _buildTimeDistributionChart() {
    return _buildChartCard(
      title: 'Distribusi Waktu Berdasarkan Kategori',
      content: PieChart(
        PieChartData(
          sectionsSpace: 2,
          centerSpaceRadius: 40,
          sections: [
            PieChartSectionData(value: 60, color: Colors.blue, title: '60%'),
            PieChartSectionData(value: 20, color: Colors.orange, title: '20%'),
            PieChartSectionData(value: 10, color: Colors.green, title: '10%'),
            PieChartSectionData(value: 10, color: Colors.grey, title: '10%'),
          ],
          borderData: FlBorderData(show: false),
        ),
      ),
      legend: const Padding(
        padding: EdgeInsets.only(top: 10.0),
        child: Text("Kerja (60%), Istirahat (20%), Lainnya (20%)"),
      ),
    );
  }

  // 4. Tren Kebiasaan (Grafik Garis)
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