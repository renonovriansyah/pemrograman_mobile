import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/habit.dart';

// Model data untuk Grafik Garis Tren (Wajib ada di sini)
class TrendChartData {
  final int dayOffset; // 0=Hari ini, 9=10 hari lalu
  final double completionRate; // Nilai 0 hingga 1.0 (0% sampai 100%)

  TrendChartData(this.dayOffset, this.completionRate);
}

class HabitProvider with ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // --- HELPER INTERNAL: Ambil data habit saat ini ---
  // Diperlukan untuk melakukan pengecekan reset dan target sebelum update
  Future<Habit?> _getHabit(String habitId) async {
    final doc = await _db.collection('habits').doc(habitId).get();
    if (!doc.exists) return null;
    return Habit.fromFirestore(doc, null);
  }


  // --- READ (Stream untuk Kebiasaan) - KODE ANDA YANG STABIL ---
  Stream<List<Habit>> get habitsStream {
    return _db
        .collection('habits')
        .where('userId', isEqualTo: 'user_abc')
        .withConverter<Habit>(
          fromFirestore: Habit.fromFirestore,
          toFirestore: (habit, _) => habit.toFirestore(),
        )
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }

  // CREATE
  Future<void> addHabit(Habit habit) async {
    // [PENTING] Simpan lastUpdated saat membuat habit baru
    habit.lastUpdated = Timestamp.fromDate(DateTime.now()); 
    await _db.collection('habits').doc(habit.id).set(habit.toFirestore());
  }

  // --- UPDATE (FUNGSI BARU: INCREMENT & RESET HARIAN) ---
  // Ganti panggilan lama updateHabitProgress dengan fungsi ini di HabitCard Anda!
  Future<void> incrementHabitProgress(String habitId, int incrementAmount) async {
    final currentHabit = await _getHabit(habitId);
    if (currentHabit == null) return;

    // 1. Cek Reset Harian
    int amountToSet = currentHabit.currentAmount;
    final now = DateTime.now();

    // Cek jika update terakhir bukan hari ini (tanggal berbeda)
    if (currentHabit.lastUpdated == null || currentHabit.lastUpdated!.toDate().day != now.day) {
      // Reset jumlah harian menjadi 0 karena hari sudah berganti
      amountToSet = 0;
    }
    
    // 2. Hitung Jumlah Baru
    int newAmount = amountToSet + incrementAmount;
    
    // 3. Batasi Target (Target Enforcement: tidak boleh melebihi targetAmount)
    if (newAmount > currentHabit.targetAmount) {
      newAmount = currentHabit.targetAmount;
    }
    
    // 4. Update Firestore
    await _db.collection('habits').doc(habitId).update({
      'currentAmount': newAmount,
      'lastUpdated': Timestamp.fromDate(now), // Simpan timestamp update terakhir
    });
  }

  // UPDATE (FUNGSI LAMA: UNTUK SETTING)
  Future<void> updateHabitDetails(Habit habit) async {
    await _db.collection('habits').doc(habit.id).update(
      {
        'title': habit.title,
        'targetAmount': habit.targetAmount,
        'unit': habit.unit,
      }
    );
  }
  
  // DELETE
  Future<void> deleteHabit(String habitId) async {
    await _db.collection('habits').doc(habitId).delete();
  }

  // FUNGSI REPORTING: TREN KEBIASAAN (DUMMY/PLACEHOLDER)
  List<TrendChartData> calculateTrend() {
    List<TrendChartData> data = [];
    
    // Menghasilkan 10 titik data tren dummy
    for (int i = 9; i >= 0; i--) {
      // Logika dummy: Membuat tren yang fluktuatif (rate antara 40% - 100%)
      double rate = (0.5 + (i % 3) * 0.1 - (i % 2) * 0.05).clamp(0.4, 1.0);
      data.add(TrendChartData(i, rate));
    }
    
    return data;
  }
}