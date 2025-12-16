import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'cart_model.dart';

// StateNotifier untuk mengelola List<CartItem>
class CartNotifier extends StateNotifier<List<CartItem>> {
  CartNotifier() : super([]);

  // Tambah Item
  void addItem(CartItem item) {
    state = [...state, item];
  }

  // Hapus Item
  void removeItem(String cartId) {
    state = state.where((item) => item.id != cartId).toList();
  }

  // Update Jumlah (Qty)
  void updateQuantity(String cartId, int change) {
    state = [
      for (final item in state)
        if (item.id == cartId)
          CartItem(
            id: item.id,
            product: item.product,
            selectedVariants: item.selectedVariants,
            selectedModifiers: item.selectedModifiers,
            quantity: (item.quantity + change) > 0 ? (item.quantity + change) : 1, // Minimal 1
            notes: item.notes,
          )
        else
          item,
    ];
  }

  // Kosongkan Keranjang
  void clearCart() {
    state = [];
  }
}

// Global Provider yang bisa dipanggil di mana saja
final cartProvider = StateNotifierProvider<CartNotifier, List<CartItem>>((ref) {
  return CartNotifier();
});

// Provider turunan untuk hitung Total Belanjaan (Subtotal)
final cartTotalProvider = Provider<double>((ref) {
  final cart = ref.watch(cartProvider);
  return cart.fold(0, (sum, item) => sum + item.totalPrice);
});