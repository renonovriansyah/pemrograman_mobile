import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart'; 
import 'models/product_model.dart';

class FirestoreService {
  final CollectionReference _productsRef =
      FirebaseFirestore.instance.collection('products');
  
  final CollectionReference _transactionsRef =
      FirebaseFirestore.instance.collection('transactions');

  // 1. Ambil Data (Stream)
  Stream<List<Product>> getProducts() {
    return _productsRef.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Product.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }

  // 2. Seed Data Awal
  // (Fungsi ini jarang dipanggil lagi karena kita pakai MenuSeeder, tapi dibiarkan saja)
  Future<void> seedInitialData() async {
    final snapshot = await _productsRef.limit(1).get();
    if (snapshot.docs.isEmpty) {
      debugPrint("Firestore Kosong. Seeding data...");
      
      final List<Product> initialMenu = [
        Product(
          id: '',
          name: 'Sizzle Classic',
          basePrice: 35000,
          category: 'Burger',
          imagePath: 'assets/burger_classic.png',
          variants: [
            VariantGroup('Ukuran Patty', [
              ProductOption('Single', 0),
              ProductOption('Double', 15000),
            ])
          ],
          modifiers: [
            ModifierGroup('Extra Topping', [
              ProductOption('Cheese', 5000),
              ProductOption('Bacon', 7000),
            ])
          ],
        ),
        Product(
          id: '',
          name: 'Es Kopi Gula Aren',
          basePrice: 18000,
          category: 'Minuman',
          imagePath: 'assets/coffee.png',
        ),
      ];

      for (var p in initialMenu) {
        await _productsRef.add(p.toMap());
      }
    }
  }

  // 3. Simpan Transaksi (DIPERBARUI)
  Future<void> saveOrder({
    required double totalAmount,
    required String paymentMethod,
    required List<Map<String, dynamic>> items,
    required String customerName, // <--- TAMBAHAN: Wajib menerima nama pelanggan
    String cashierName = 'Admin',
  }) async {
    try {
      await _transactionsRef.add({
        'totalAmount': totalAmount,
        'paymentMethod': paymentMethod,
        'cashierName': cashierName,
        'customerName': customerName, // <--- TAMBAHAN: Simpan field ini ke Firestore
        'timestamp': FieldValue.serverTimestamp(),
        'items': items,
      });
      debugPrint("Transaksi Berhasil Disimpan ke Cloud!");
    } catch (e) {
      debugPrint("Gagal menyimpan transaksi: $e");
      rethrow;
    }
  }
}