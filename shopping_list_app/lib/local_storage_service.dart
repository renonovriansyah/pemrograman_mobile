import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'cart_item.dart';

class LocalStorageService {
  static const String _cartKey = 'cartItems';

  // Mengambil data keranjang dari SharedPreferences
  static Future<List<CartItem>> getCartItems() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? cartString = prefs.getString(_cartKey);

    if (cartString == null) {
      return [];
    }

    // Mengkonversi string JSON kembali ke List<CartItem>
    final List<dynamic> jsonList = jsonDecode(cartString);
    return jsonList.map((json) => CartItem.fromJson(json)).toList();
  }

  // Menyimpan data keranjang ke SharedPreferences
  static Future<void> saveCartItems(List<CartItem> items) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    
    // Mengkonversi List<CartItem> ke List<Map>
    final List<Map<String, dynamic>> jsonList = 
        items.map((item) => item.toJson()).toList();
    
    // Mengkonversi List<Map> ke string JSON
    final String cartString = jsonEncode(jsonList);
    
    await prefs.setString(_cartKey, cartString);
  }
}