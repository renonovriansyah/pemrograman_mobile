import 'package:cloud_firestore/cloud_firestore.dart';
import 'models/product_model.dart';

class FirestoreService {
  // Akses koleksi 'products' di Firebase
  final CollectionReference _productsRef =
      FirebaseFirestore.instance.collection('products');

  // 1. Ambil Data secara Realtime (Stream)
  Stream<List<Product>> getProducts() {
    return _productsRef.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Product.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }

  // 2. Cek apakah Kosong & Isi Data Awal
  Future<void> seedInitialData() async {
    final snapshot = await _productsRef.limit(1).get();
    if (snapshot.docs.isEmpty) {
      print("Firestore Kosong. Seeding data...");
      
      // Data Awal
      final List<Product> initialMenu = [
        Product(
          id: '', // ID digenerate otomatis oleh Firebase nanti
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
}