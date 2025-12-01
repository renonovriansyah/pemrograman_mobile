class CartItem {
  final String id;
  final String name;
  final String imageUrl;
  final double price;
  int quantity;
  final double rating;

  CartItem({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.quantity,
    required this.rating,
  });

  // Konversi dari JSON (untuk SharedPreferences)
  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'],
      name: json['name'],
      imageUrl: json['imageUrl'],
      price: json['price'],
      quantity: json['quantity'],
      rating: json['rating'],
    );
  }

  // Konversi ke JSON (untuk SharedPreferences)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'imageUrl': imageUrl,
      'price': price,
      'quantity': quantity,
      'rating': rating,
    };
  }
}