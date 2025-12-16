class Product {
  final String id;
  final String name;
  final double basePrice;
  final String category;
  final String imagePath;
  final List<VariantGroup> variants;
  final List<ModifierGroup> modifiers;

  Product({
    required this.id,
    required this.name,
    required this.basePrice,
    required this.category,
    required this.imagePath,
    this.variants = const [],
    this.modifiers = const [],
  });

  // Convert dari Firebase (Map) ke Object Dart
  factory Product.fromMap(Map<String, dynamic> data, String documentId) {
    return Product(
      id: documentId,
      name: data['name'] ?? '',
      basePrice: (data['basePrice'] ?? 0).toDouble(),
      category: data['category'] ?? 'Other',
      imagePath: data['imagePath'] ?? '',
      variants: (data['variants'] as List<dynamic>?)
              ?.map((e) => VariantGroup.fromMap(e))
              .toList() ??
          [],
      modifiers: (data['modifiers'] as List<dynamic>?)
              ?.map((e) => ModifierGroup.fromMap(e))
              .toList() ??
          [],
    );
  }

  // Convert dari Object Dart ke Firebase (Map)
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'basePrice': basePrice,
      'category': category,
      'imagePath': imagePath,
      'variants': variants.map((e) => e.toMap()).toList(),
      'modifiers': modifiers.map((e) => e.toMap()).toList(),
    };
  }
}

class VariantGroup {
  final String name;
  final List<ProductOption> options;

  VariantGroup(this.name, this.options);

  factory VariantGroup.fromMap(Map<String, dynamic> map) {
    return VariantGroup(
      map['name'] ?? '',
      (map['options'] as List<dynamic>?)
              ?.map((e) => ProductOption.fromMap(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toMap() => {
        'name': name,
        'options': options.map((e) => e.toMap()).toList(),
      };
}

class ModifierGroup {
  final String name;
  final List<ProductOption> options;

  ModifierGroup(this.name, this.options);

  factory ModifierGroup.fromMap(Map<String, dynamic> map) {
    return ModifierGroup(
      map['name'] ?? '',
      (map['options'] as List<dynamic>?)
              ?.map((e) => ProductOption.fromMap(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toMap() => {
        'name': name,
        'options': options.map((e) => e.toMap()).toList(),
      };
}

class ProductOption {
  final String name;
  final double priceEffect;

  ProductOption(this.name, this.priceEffect);

  factory ProductOption.fromMap(Map<String, dynamic> map) {
    return ProductOption(
      map['name'] ?? '',
      (map['priceEffect'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toMap() => {
        'name': name,
        'priceEffect': priceEffect,
      };
}