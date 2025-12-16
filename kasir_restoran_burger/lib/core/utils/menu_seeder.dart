import 'package:cloud_firestore/cloud_firestore.dart';

class MenuSeeder {
  static Future<void> seedMenu() async {
    final CollectionReference products = FirebaseFirestore.instance.collection('products');

    // Hapus data lama jika perlu (Opsional, hati-hati jika production)
    // await _clearProducts(products); 

    final List<Map<String, dynamic>> fullMenu = [
      // ==========================
      // KATEGORI: BURGER PREMIUM
      // ==========================
      {
        "name": "Sizzle Beef Burger",
        "category": "burger premium",
        "basePrice": 35000,
        "imagePath": "assets/beef_burger.png",
        "variants": [
          {
            "name": "Ukuran Patty",
            "options": [
              {"name": "Single", "priceEffect": 0},
              {"name": "Double", "priceEffect": 15000},
              {"name": "Triple", "priceEffect": 28000}
            ]
          }
        ],
        "modifiers": [
          {
            "name": "Extra Topping",
            "options": [
              {"name": "Cheese Slice", "priceEffect": 4000},
              {"name": "Bacon (Beef)", "priceEffect": 6000},
              {"name": "Egg", "priceEffect": 4000}
            ]
          }
        ]
      },
      {
        "name": "Sizzle Cheese Burger",
        "category": "burger premium",
        "basePrice": 28000,
        "imagePath": "assets/cheese_burger.png",
        "variants": [],
        "modifiers": [
          {
            "name": "Extra",
            "options": [
              {"name": "Extra Cheese", "priceEffect": 4000},
              {"name": "Pickles", "priceEffect": 2000}
            ]
          }
        ]
      },
      {
        "name": "McSpicy Chicken Burger",
        "category": "burger premium",
        "basePrice": 38000,
        "imagePath": "assets/chicken_burger.png",
        "variants": [
          {
            "name": "Level Pedas",
            "options": [
              {"name": "Original", "priceEffect": 0},
              {"name": "Spicy", "priceEffect": 0},
              {"name": "Extra Spicy", "priceEffect": 0}
            ]
          }
        ],
        "modifiers": []
      },
      {
        "name": "Fish Fillet Burger",
        "category": "burger premium",
        "basePrice": 34000,
        "imagePath": "assets/fish_burger.png",
        "variants": [],
        "modifiers": [
          {
            "name": "Sauce",
            "options": [
              {"name": "Extra Tartar Sauce", "priceEffect": 2000},
              {"name": "Extra Cheese", "priceEffect": 4000}
            ]
          }
        ]
      },

      // ==========================
      // KATEGORI: SIDES (SNACK)
      // ==========================
      {
        "name": "French Fries",
        "category": "sides",
        "basePrice": 12000,
        "imagePath": "assets/fries.png",
        "variants": [
          {
            "name": "Ukuran",
            "options": [
              {"name": "Small", "priceEffect": 0},
              {"name": "Medium", "priceEffect": 5000},
              {"name": "Large", "priceEffect": 9000}
            ]
          }
        ],
        "modifiers": [
          {
            "name": "Bumbu Shake",
            "options": [
              {"name": "BBQ Powder", "priceEffect": 2000},
              {"name": "Seaweed Powder", "priceEffect": 2000}
            ]
          }
        ]
      },
      {
        "name": "Chicken Nuggets",
        "category": "sides",
        "basePrice": 22000,
        "imagePath": "assets/nuggets.png",
        "variants": [
          {
            "name": "Isi",
            "options": [
              {"name": "4 pcs", "priceEffect": 0},
              {"name": "6 pcs", "priceEffect": 8000},
              {"name": "9 pcs", "priceEffect": 15000}
            ]
          }
        ],
        "modifiers": [
          {
            "name": "Saus Cocol",
            "options": [
              {"name": "BBQ Sauce", "priceEffect": 0},
              {"name": "Sweet & Sour", "priceEffect": 0},
              {"name": "Curry Sauce", "priceEffect": 0}
            ]
          }
        ]
      },
      {
        "name": "Sosis Goreng Jumbo",
        "category": "sides",
        "basePrice": 15000,
        "imagePath": "assets/sausage.png",
        "variants": [],
        "modifiers": [
          {
            "name": "Saus",
            "options": [
              {"name": "Mayonnaise", "priceEffect": 0},
              {"name": "Chili Sauce", "priceEffect": 0}
            ]
          }
        ]
      },
      {
        "name": "Nasi Uduk Sizzle",
        "category": "sides",
        "basePrice": 8000,
        "imagePath": "assets/rice.png",
        "variants": [],
        "modifiers": [
           {
            "name": "Tambahan",
            "options": [
              {"name": "Bawang Goreng", "priceEffect": 0},
              {"name": "Sambal Terasi", "priceEffect": 2000}
            ]
          }
        ]
      },
      {
        "name": "Ayam Goreng Crispy",
        "category": "sides",
        "basePrice": 18000,
        "imagePath": "assets/fried_chicken.png",
        "variants": [
           {
            "name": "Pilihan Potongan",
            "options": [
              {"name": "Dada (Breast)", "priceEffect": 0},
              {"name": "Paha Atas (Thigh)", "priceEffect": 0},
              {"name": "Paha Bawah (Drumstick)", "priceEffect": 0},
              {"name": "Sayap (Wing)", "priceEffect": -2000}
            ]
          },
          {
            "name": "Rasa",
            "options": [
              {"name": "Original", "priceEffect": 0},
              {"name": "Spicy", "priceEffect": 0}
            ]
          }
        ],
        "modifiers": []
      },

      // ==========================
      // KATEGORI: MINUMAN
      // ==========================
      {
        "name": "Coca Cola",
        "category": "minuman",
        "basePrice": 10000,
        "imagePath": "assets/coke.png",
        "variants": [
          {
            "name": "Ukuran",
            "options": [
              {"name": "Medium", "priceEffect": 0},
              {"name": "Large", "priceEffect": 4000}
            ]
          },
          {
            "name": "Es Batu",
            "options": [
              {"name": "Normal Ice", "priceEffect": 0},
              {"name": "Less Ice", "priceEffect": 0},
              {"name": "No Ice", "priceEffect": 0}
            ]
          }
        ],
        "modifiers": []
      },
      {
        "name": "Sprite",
        "category": "minuman",
        "basePrice": 10000,
        "imagePath": "assets/sprite.png",
        "variants": [
          {
            "name": "Ukuran",
            "options": [
              {"name": "Medium", "priceEffect": 0},
              {"name": "Large", "priceEffect": 4000}
            ]
          },
          {
            "name": "Es Batu",
            "options": [
              {"name": "Normal Ice", "priceEffect": 0},
              {"name": "Less Ice", "priceEffect": 0},
              {"name": "No Ice", "priceEffect": 0}
            ]
          }
        ],
        "modifiers": []
      },
      {
        "name": "Fanta Strawberry",
        "category": "minuman",
        "basePrice": 10000,
        "imagePath": "assets/fanta.png",
        "variants": [
          {
            "name": "Ukuran",
            "options": [
              {"name": "Medium", "priceEffect": 0},
              {"name": "Large", "priceEffect": 4000}
            ]
          },
          {
            "name": "Es Batu",
            "options": [
              {"name": "Normal Ice", "priceEffect": 0},
              {"name": "Less Ice", "priceEffect": 0},
              {"name": "No Ice", "priceEffect": 0}
            ]
          }
        ],
        "modifiers": []
      },
      {
        "name": "Es Teh Manis",
        "category": "minuman",
        "basePrice": 8000,
        "imagePath": "assets/icetea.png",
        "variants": [
           {
            "name": "Ukuran",
            "options": [
              {"name": "Medium", "priceEffect": 0},
              {"name": "Large", "priceEffect": 3000}
            ]
          },
          {
            "name": "Gula",
            "options": [
              {"name": "Normal Sugar", "priceEffect": 0},
              {"name": "Less Sugar", "priceEffect": 0},
              {"name": "Tawar (No Sugar)", "priceEffect": 0}
            ]
          }
        ],
        "modifiers": []
      },
      {
        "name": "Lemon Tea",
        "category": "minuman",
        "basePrice": 12000,
        "imagePath": "assets/lemontea.png",
        "variants": [
          {
            "name": "Suhu",
            "options": [
              {"name": "Ice (Dingin)", "priceEffect": 0},
              {"name": "Hot (Panas)", "priceEffect": 0}
            ]
          }
        ],
        "modifiers": []
      },
      {
        "name": "Air Mineral",
        "category": "minuman",
        "basePrice": 6000,
        "imagePath": "assets/water.png",
        "variants": [],
        "modifiers": []
      },
      {
        "name": "Milo Dinosaur",
        "category": "minuman",
        "basePrice": 18000,
        "imagePath": "assets/milo.png",
        "variants": [],
        "modifiers": [
          {
            "name": "Topping",
            "options": [
              {"name": "Extra Bubuk Milo", "priceEffect": 2000},
              {"name": "Cream Cheese", "priceEffect": 5000}
            ]
          }
        ]
      },

      // ==========================
      // KATEGORI: DESSERT (ES KRIM)
      // ==========================
      {
        "name": "Sundae Chocolate",
        "category": "dessert",
        "basePrice": 10000,
        "imagePath": "assets/sundae_choco.png",
        "variants": [],
        "modifiers": [
           {
            "name": "Topping",
            "options": [
              {"name": "Extra Sauce", "priceEffect": 2000},
              {"name": "Kacang", "priceEffect": 1000}
            ]
          }
        ]
      },
      {
        "name": "Sundae Strawberry",
        "category": "dessert",
        "basePrice": 10000,
        "imagePath": "assets/sundae_berry.png",
        "variants": [],
        "modifiers": []
      },
      {
        "name": "McFlurry Oreo",
        "category": "dessert",
        "basePrice": 14000,
        "imagePath": "assets/mcflurry.png",
        "variants": [],
        "modifiers": [
           {
            "name": "Extra",
            "options": [
              {"name": "Extra Oreo Crumb", "priceEffect": 3000},
              {"name": "Extra Choco", "priceEffect": 3000}
            ]
          }
        ]
      },
      {
        "name": "Ice Cream Cone",
        "category": "dessert",
        "basePrice": 5000,
        "imagePath": "assets/cone.png",
        "variants": [
           {
            "name": "Rasa",
            "options": [
              {"name": "Vanilla", "priceEffect": 0},
              {"name": "Choco", "priceEffect": 0},
              {"name": "Mix", "priceEffect": 0}
            ]
          }
        ],
        "modifiers": []
      },
       {
        "name": "Apple Pie",
        "category": "dessert",
        "basePrice": 12000,
        "imagePath": "assets/apple_pie.png",
        "variants": [],
        "modifiers": []
      }
    ];

    for (var item in fullMenu) {
      // Opsi: Cek dulu apakah menu dengan nama sama sudah ada agar tidak duplikat
      final existing = await products.where('name', isEqualTo: item['name']).get();
      if (existing.docs.isEmpty) {
        await products.add(item);
        print("Berhasil menambahkan menu: ${item['name']}");
      } else {
        print("Menu sudah ada: ${item['name']} (Dilewati)");
      }
    }
  }
}