// lib/widgets/quick_log_section.dart

import 'package:flutter/material.dart';

class QuickLogSection extends StatelessWidget {
  const QuickLogSection({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> quickLogs = [
      {'icon': Icons.book, 'color': const Color(0xFF42A5F5)},
      {'icon': Icons.directions_run, 'color': const Color(0xFFFFB300)},
      {'icon': Icons.menu_book, 'color': const Color(0xFF6D4C41)},
      {'icon': Icons.draw, 'color': const Color(0xFF9C27B0)},
      {'icon': Icons.add_a_photo, 'color': const Color(0xFFE53935)},
      {'icon': Icons.apple, 'color': const Color(0xFF66BB6A)},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quick Log',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 60,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: quickLogs.length,
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.only(right: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: quickLogs[index]['color'].withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: quickLogs[index]['color'], width: 1.5),
                ),
                child: Icon(
                  quickLogs[index]['icon'] as IconData,
                  color: quickLogs[index]['color'] as Color,
                  size: 28,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}