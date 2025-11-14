// lib/widgets/summary_section.dart

import 'package:flutter/material.dart';

class SummarySection extends StatelessWidget {
  const SummarySection({super.key});

  // Widget Pembantu untuk Kartu Statistik (Total Hours & Streak)
  Widget _buildStatCard({required String title, required String value, required Color valueColor}) {
    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      color: const Color(0xFFF5F5F5), // Latar belakang abu-abu muda
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(title, style: const TextStyle(fontSize: 10, color: Colors.grey)),
            const SizedBox(height: 4),
            Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: valueColor)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        // Progress Circle (75% of Weekly Goal)
        Container(
          width: 150,
          height: 150,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.grey.shade200, width: 2),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              const SizedBox(
                width: 130,
                height: 130,
                child: CircularProgressIndicator(
                  value: 0.75, // 75%
                  strokeWidth: 14,
                  backgroundColor: Color(0xFFE0E0E0),
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF8BC34A)),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text('75%', style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold)),
                  Text('of Weekly Goal', style: TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(width: 10),

        // Total Hours Logged & Streak
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatCard(
                title: 'Total Hours Logged This Week',
                value: '20.5',
                valueColor: const Color(0xFF42A5F5), // Biru
              ),
              const SizedBox(height: 10),
              _buildStatCard(
                title: 'Streak:',
                value: '7 Days',
                valueColor: const Color(0xFFFF7043), // Oranye
              ),
            ],
          ),
        ),
      ],
    );
  }
}