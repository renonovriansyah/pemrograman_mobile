// lib/widgets/dynamic_stats_chart.dart
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/activity_stats.dart';

class DynamicStatsChart extends StatelessWidget {
  final List<ActivityStats> stats;
  const DynamicStatsChart({required this.stats, super.key});

  @override
  Widget build(BuildContext context) {
    // Cari nilai tertinggi untuk menentukan batas sumbu Y (agar grafik tidak penuh)
    final maxY = stats.isEmpty 
        ? 1.0 
        : stats.map((e) => e.durationHours).reduce((a, b) => a > b ? a : b) * 1.2;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      height: 250, // Tinggi tetap untuk grafik
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: maxY,
          // Sentuhan di batang grafik diaktifkan, tetapi tidak memberikan respons visual
          barTouchData: BarTouchData(enabled: true), 
          
          // --- Konfigurasi Label Sumbu X dan Y ---
          titlesData: FlTitlesData(
            show: true,
            // Sumbu X (Nama Aktivitas)
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  if (stats.isEmpty) return const SizedBox();
                  final title = stats[value.toInt()].title;
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    // Tampilkan hanya 4 huruf pertama (Contoh: DEEP)
                    child: Text(title.substring(0, title.length > 4 ? 4 : title.length).toUpperCase(),
                       style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                  );
                },
              ),
            ),
            // Sumbu Y (Durasi dalam Jam)
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30, // Ruang untuk label
                interval: maxY / 4, // Interval per 1/4 tinggi maksimum
                getTitlesWidget: (value, meta) => Text(value.toStringAsFixed(1), style: const TextStyle(fontSize: 10)),
              ),
            ),
            // Sembunyikan label atas dan kanan
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          
          // --- Garis dan Border ---
          gridData: const FlGridData(show: true, drawVerticalLine: false, horizontalInterval: 1),
          borderData: FlBorderData(show: true, border: Border.all(color: Colors.grey.shade300, width: 1)),
          
          // --- Data Batang Grafik ---
          barGroups: stats.asMap().entries.map((entry) {
            int index = entry.key;
            ActivityStats stat = entry.value;

            return BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                  toY: stat.durationHours,
                  color: stat.color,
                  width: 16,
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(4), topRight: Radius.circular(4)),
                ),
              ],
              // Opsional: Tampilkan durasi di atas batang
              showingTooltipIndicators: stat.durationHours > 0 ? [0] : [],
            );
          }).toList(),
        ),
      ),
    );
  }
}