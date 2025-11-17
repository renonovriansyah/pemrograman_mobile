// lib/widgets/habit_card.dart
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';
import '../models/habit.dart';
import '../providers/habit_provider.dart';

class HabitCard extends StatelessWidget {
  final Habit habit;
  const HabitCard({required this.habit, super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<HabitProvider>(context, listen: false);
    double percent = habit.currentAmount / habit.targetAmount;
    if (percent > 1.0) percent = 1.0; // Batasi maksimal 100%

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5)],
      ),
      padding: const EdgeInsets.all(10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // 1. Indikator Lingkaran
          CircularPercentIndicator(
            radius: 40.0, // Sedikit lebih kecil
            lineWidth: 8.0,
            animation: true,
            percent: percent,
            center: Text(
              "${(percent * 100).toInt()}%",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0, color: Colors.teal),
            ),
            circularStrokeCap: CircularStrokeCap.round,
            progressColor: Colors.teal,
            backgroundColor: Colors.teal.shade50, // Latar belakang yang lebih halus
          ),

          // 2. Judul
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Text(
              habit.title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
          ),

          // 3. Progres dan Tombol
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                '${habit.currentAmount}/${habit.targetAmount} ${habit.unit}',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 11),
              ),
              // Tombol untuk menambah progres
              InkWell(
                onTap: () {
                  // UPDATE Progress
                  int newAmount = habit.currentAmount + (habit.unit == 'ml' ? 100 : 1);
                  provider.updateHabitProgress(habit.id, newAmount);
                },
                child: const Icon(Icons.add_circle, color: Colors.green, size: 28),
              ),
            ],
          ),
          // Hapus tombol Delete dan Edit, dan pindahkan ke Modal/Long Press untuk UX yang lebih baik.
        ],
      ),
    );
  }
}