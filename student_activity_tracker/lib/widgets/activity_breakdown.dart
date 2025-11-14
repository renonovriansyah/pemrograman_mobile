// lib/widgets/activity_breakdown.dart

import 'package:flutter/material.dart';

class ActivityBreakdown extends StatelessWidget {
  const ActivityBreakdown({super.key});

  @override
  Widget build(BuildContext context) {
    final List<double> percentages = [0.10, 0.02, 0.13, 0.20, 0.25, 0.28];
    final List<String> labels = ['Mon', 'Move', 'Worsing', 'Workout', 'Reading', 'Stuy'];
    final double maxPercentage = percentages.reduce((a, b) => a > b ? a : b); // 0.28

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text(
          'Daily Activity Breakdown',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            // Kolom Persentase (kiri)
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: const [
                Text('10%', style: TextStyle(fontSize: 10, color: Colors.grey)),
                SizedBox(height: 50), 
                Text('2%', style: TextStyle(fontSize: 10, color: Colors.grey)),
                SizedBox(height: 35), 
                Text('13%', style: TextStyle(fontSize: 10, color: Colors.grey)),
                SizedBox(height: 10), 
              ],
            ),
            const SizedBox(width: 8),
            
            // Batang Grafik
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: List.generate(percentages.length, (index) {
                  double height = 120 * (percentages[index] / maxPercentage); 
                  
                  return Expanded(
                    child: Column(
                      children: [
                        Container(
                          height: height,
                          width: double.infinity,
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            color: index % 2 == 0 ? const Color(0xFF42A5F5) : const Color(0xFFFFB300), 
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(4),
                              topRight: Radius.circular(4),
                            ),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          labels[index],
                          style: const TextStyle(fontSize: 10, color: Colors.grey),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ],
    );
  }
}