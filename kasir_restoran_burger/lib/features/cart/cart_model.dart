import 'package:uuid/uuid.dart';
import '../../data/models/product_model.dart';

class CartItem {
  final String id; // ID unik per item di keranjang
  final Product product;
  final Map<String, ProductOption> selectedVariants;
  final List<ProductOption> selectedModifiers;
  int quantity;
  String? notes;

  CartItem({
    String? id,
    required this.product,
    this.selectedVariants = const {},
    this.selectedModifiers = const [],
    this.quantity = 1,
    this.notes,
  }) : id = id ?? const Uuid().v4();

  // Hitung harga per item (Harga Dasar + Varian + Topping)
  double get pricePerItem {
    double total = product.basePrice;
    selectedVariants.forEach((key, option) => total += option.priceEffect);
    for (var mod in selectedModifiers) {
      total += mod.priceEffect;
    }
    return total;
  }

  double get totalPrice => pricePerItem * quantity;
}