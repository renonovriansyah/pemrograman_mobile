import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/item_belanja.dart';
import 'package:flutter/services.dart';
import 'dart:math';

class SmartShopPage extends StatefulWidget {
  const SmartShopPage({super.key});

  @override
  SmartShopPageState createState() => SmartShopPageState();
}

class SmartShopPageState extends State<SmartShopPage> {
  // LIST DATA
  List<ItemBelanja> _items = [];
  List<ItemBelanja> _filteredItems = []; // List hasil filter/search
  String _filterStatus = 'Semua';
  final TextEditingController _searchController = TextEditingController();

  // DATA STATIC
  final List<String> _categories = [
    'Daging & Ikan', 'Sayuran', 'Buah-buahan', 'Bumbu Dapur',
    'Minuman', 'Snack', 'Elektronik', 'Kebersihan', 'Lainnya'
  ];

  final Map<String, Color> _categoryColors = {
    'Daging & Ikan': Colors.redAccent,
    'Sayuran': Colors.green,
    'Buah-buahan': Colors.orange,
    'Bumbu Dapur': Colors.brown,
    'Minuman': Colors.blue,
    'Snack': Colors.amber,
    'Elektronik': Colors.purple,
    'Kebersihan': Colors.teal,
    'Lainnya': Colors.grey,
  };

  final List<String> _units = ['Pcs', 'Kg', 'Gram', 'Liter', 'Botol', 'Bks', 'Ikat', 'Buah'];

  @override
  void initState() {
    super.initState();
    _loadItems();
    // Listener untuk Search Bar (Live Search)
    _searchController.addListener(_filterItems);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // --- LOGIC LOAD & SAVE ---

  Future<void> _loadItems() async {
    final prefs = await SharedPreferences.getInstance();
    String? itemsString = prefs.getString('smart_shop_list');
    if (itemsString != null) {
      List<dynamic> itemsJson = jsonDecode(itemsString);
      setState(() {
        _items = itemsJson.map((json) => ItemBelanja.fromJson(json)).toList();
        _filterItems(); // Jalankan filter saat data dimuat
      });
    }
  }

  Future<void> _saveItems() async {
    final prefs = await SharedPreferences.getInstance();
    List<Map<String, dynamic>> itemsJson = _items.map((item) => item.toJson()).toList();
    await prefs.setString('smart_shop_list', jsonEncode(itemsJson));
    _filterItems(); // Update tampilan setelah simpan
  }

  // LOGIC FILTER GABUNGAN (SEARCH + STATUS)
  void _filterItems() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      _filteredItems = _items.where((item) {
        // 1. Cek Status Filter
        bool statusMatch = true;
        if (_filterStatus == 'Belum') statusMatch = !item.sudahDibeli;
        if (_filterStatus == 'Sudah') statusMatch = item.sudahDibeli;
        
        // 2. Cek Search Query
        bool searchMatch = item.nama.toLowerCase().contains(query);

        return statusMatch && searchMatch;
      }).toList();
    });
  }

  // --- LOGIC GAMIFICATION (POP UP & MOTIVASI) ---
  void _checkCompletion() {
    int total = _items.length;
    int bought = _items.where((i) => i.sudahDibeli).length;
    int remaining = total - bought;

    if (total > 0 && remaining == 0) {
      // KONDISI 1: SELESAI SEMUA -> POP UP CELEBRATION
      _showCelebrationDialog();
    } else if (remaining > 0 && remaining <= 3) {
      // KONDISI 2: SISA SEDIKIT -> SNACKBAR MOTIVASI
      _showCustomSnackBar("Semangat! Tinggal $remaining item lagi!", Colors.orangeAccent);
    }
  }

  void _showCelebrationDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.emoji_events, size: 80, color: Colors.amber),
              const SizedBox(height: 10),
              const Text("Luar Biasa!", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.teal)),
              const SizedBox(height: 10),
              const Text("Semua belanjaan sudah terbeli.\nKamu sangat produktif hari ini!", textAlign: TextAlign.center),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))
                ),
                child: const Text("Tutup", style: TextStyle(color: Colors.white)),
              )
            ],
          ),
        );
      },
    );
  }

  // --- FITUR PRO: HAPUS SEMUA YANG SUDAH DIBELI ---
  void _deleteCompletedItems() {
    int count = _items.where((i) => i.sudahDibeli).length;
    if (count == 0) {
      _showCustomSnackBar('Tidak ada barang yang selesai.', Colors.grey);
      return;
    }

    setState(() {
      _items.removeWhere((item) => item.sudahDibeli);
    });
    _saveItems();
    _showCustomSnackBar('$count barang yang selesai telah dibersihkan.', Colors.purple);
  }

  // --- FITUR BARU: GENERATE DUMMY DATA ---
  void _generateDummyData() {
    List<ItemBelanja> dummyData = [
      ItemBelanja(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        nama: 'Daging Sapi Slice', jumlah: '500 Gram', kategori: 'Daging & Ikan', sudahDibeli: false),
      ItemBelanja(
        id: (DateTime.now().millisecondsSinceEpoch + 1).toString(),
        nama: 'Kecap Manis', jumlah: '1 Botol', kategori: 'Bumbu Dapur', sudahDibeli: true),
      ItemBelanja(
        id: (DateTime.now().millisecondsSinceEpoch + 2).toString(),
        nama: 'Mangga Harum Manis', jumlah: '2 Kg', kategori: 'Buah-buahan', sudahDibeli: false),
      ItemBelanja(
        id: (DateTime.now().millisecondsSinceEpoch + 3).toString(),
        nama: 'Pasta Gigi', jumlah: '2 Pcs', kategori: 'Kebersihan', sudahDibeli: true),
      ItemBelanja(
        id: (DateTime.now().millisecondsSinceEpoch + 4).toString(),
        nama: 'Keripik Kentang', jumlah: '3 Bks', kategori: 'Snack', sudahDibeli: false),
      ItemBelanja(
        id: (DateTime.now().millisecondsSinceEpoch + 5).toString(),
        nama: 'Kabel Data Type-C', jumlah: '1 Pcs', kategori: 'Elektronik', sudahDibeli: false),
      ItemBelanja(
        id: (DateTime.now().millisecondsSinceEpoch + 6).toString(),
        nama: 'Air Mineral Galon', jumlah: '1 Galon', kategori: 'Minuman', sudahDibeli: true),
      ItemBelanja(
        id: (DateTime.now().millisecondsSinceEpoch + 7).toString(),
        nama: 'Bayam & Kangkung', jumlah: '2 Ikat', kategori: 'Sayuran', sudahDibeli: false),
    ];

    setState(() {
      _items.addAll(dummyData); // Menambahkan ke list yang ada
    });
    _saveItems(); // Simpan ke storage
    _showCustomSnackBar('8 Item Dummy berhasil ditambahkan!', Colors.purpleAccent);
  }

  // --- FITUR PRO: COPY KE CLIPBOARD ---
  void _copyToClipboard() {
    if (_items.isEmpty) {
      _showCustomSnackBar('Daftar belanja kosong, tidak ada yang disalin.', Colors.grey);
      return;
    }

    StringBuffer sb = StringBuffer();
    sb.writeln("🛒 *Daftar Belanja SmartShop* 🛒\n");
    
    // Pisahkan yang belum dan sudah dibeli agar rapi
    List<ItemBelanja> belum = _items.where((i) => !i.sudahDibeli).toList();
    List<ItemBelanja> sudah = _items.where((i) => i.sudahDibeli).toList();

    if (belum.isNotEmpty) {
      sb.writeln("*Belum Dibeli:*");
      for (var item in belum) {
        sb.writeln("⬜ ${item.nama} (${item.jumlah})");
      }
      sb.writeln(""); // Enter
    }

    if (sudah.isNotEmpty) {
      sb.writeln("*Sudah Selesai:*");
      for (var item in sudah) {
        sb.writeln("✅ ~${item.nama}~ (${item.jumlah})");
      }
    }

    sb.writeln("\n_Dibuat dengan SmartShop App_");

    Clipboard.setData(ClipboardData(text: sb.toString())).then((_) {
      _showCustomSnackBar('Daftar belanja disalin! Siap ditempel di WA.', Colors.teal);
    });
  }

  // --- CRUD OPERATIONS ---

  void _addItem(String nama, String jumlah, String satuan, String kategori) {
    setState(() {
      _items.add(ItemBelanja(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        nama: nama,
        jumlah: '$jumlah $satuan',
        kategori: kategori,
      ));
    });
    _saveItems();
    _showCustomSnackBar('Barang berhasil ditambahkan!', Colors.green);
  }

  void _updateItem(String id, String nama, String jumlah, String satuan, String kategori) {
    int index = _items.indexWhere((item) => item.id == id);
    if (index != -1) {
      setState(() {
        _items[index].nama = nama;
        _items[index].jumlah = '$jumlah $satuan';
        _items[index].kategori = kategori;
      });
      _saveItems();
      _showCustomSnackBar('Barang berhasil diperbarui!', Colors.blueAccent);
    }
  }

  void deleteItem(String id) {
    setState(() {
      _items.removeWhere((item) => item.id == id);
    });
    _saveItems();
    _showCustomSnackBar('Barang dihapus.', Colors.redAccent);
  }

  void _toggleStatus(String id) {
    int index = _items.indexWhere((item) => item.id == id);
    if (index != -1) {
      setState(() {
        _items[index].sudahDibeli = !_items[index].sudahDibeli;
      });
      _saveItems();
      
      // LOGIC BARU: Cek Gamification saat status berubah
      if (_items[index].sudahDibeli) {
         _checkCompletion(); 
      }
    }
  }

  // Helper Konfirmasi Hapus
  Future<bool> _confirmDelete(ItemBelanja item) async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Hapus Item?"),
          content: Text("Yakin ingin menghapus '${item.nama}'?"),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text("Batal", style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
              child: const Text("Hapus", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
    return confirm ?? false;
  }

  // --- UI COMPONENTS ---

  void _showCustomSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar(); // Hapus snackbar lama biar responsif
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.info_outline, color: Colors.white),
            const SizedBox(width: 10),
            Text(message, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(20),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // DASHBOARD DENGAN ANIMASI PROGRESS BAR
  Widget _buildDashboard() {
    int total = _items.length;
    int terbeli = _items.where((item) => item.sudahDibeli).length;
    double percentage = total == 0 ? 0 : min(1.0, terbeli / total);
    int percentageBought = (percentage * 100).toInt();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 60, 24, 25),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft, end: Alignment.bottomRight,
          colors: [Color(0xFF009688), Color(0xFF2196F3)],
        ),
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 5))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('SmartShop List', style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold, letterSpacing: 1.0)),
              // MENU TITIK TIGA (POPUP MENU) - FITUR BARU
              // MENU TITIK TIGA (POPUP MENU)
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert, color: Colors.white),
                onSelected: (value) {
                  if (value == 'dummy') _generateDummyData();
                  if (value == 'clear_completed') _deleteCompletedItems();
                  if (value == 'share') _copyToClipboard(); // AKSI BARU
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  const PopupMenuItem<String>(
                    value: 'share', // MENU BARU
                    child: Row(children: [Icon(Icons.copy_all, color: Colors.blue), SizedBox(width: 10), Text('Salin Daftar Belanja')]),
                  ),
                  const PopupMenuItem<String>(
                    value: 'dummy',
                    child: Row(children: [Icon(Icons.playlist_add, color: Colors.teal), SizedBox(width: 10), Text('Isi Dummy Data')]),
                  ),
                  const PopupMenuItem<String>(
                    value: 'clear_completed',
                    child: Row(children: [Icon(Icons.delete_sweep, color: Colors.red), SizedBox(width: 10), Text('Hapus Yang Selesai')]),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 5),
          const Text('Kelola belanjaanmu dengan profesional', style: TextStyle(color: Colors.white70, fontSize: 14)),
          const SizedBox(height: 20),
          
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(color: Colors.white.withAlpha(51), borderRadius: BorderRadius.circular(20)),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Progress Belanja', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                    Text('$terbeli/$total Item ($percentageBought%)', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 10),
                Stack(
                  children: [
                    Container(height: 12, width: double.infinity, decoration: BoxDecoration(color: Colors.white30, borderRadius: BorderRadius.circular(10))),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 600), curve: Curves.easeOutCubic,
                          height: 12, width: constraints.maxWidth * percentage,
                          decoration: BoxDecoration(color: const Color(0xFF69F0AE), borderRadius: BorderRadius.circular(10), boxShadow: const [BoxShadow(color: Color(0xFF69F0AE), blurRadius: 6, spreadRadius: 1)]),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  // SEARCH BAR + FILTER
  Widget _buildFilterAndSearch() {
    List<String> filters = ['Semua', 'Belum', 'Sudah'];
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Cari barang...',
              prefixIcon: const Icon(Icons.search, color: Colors.teal),
              contentPadding: const EdgeInsets.symmetric(vertical: 0),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
        ),
        Container(
          height: 40,
          margin: const EdgeInsets.only(bottom: 10),
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            scrollDirection: Axis.horizontal,
            itemCount: filters.length,
            separatorBuilder: (c, i) => const SizedBox(width: 10),
            itemBuilder: (context, index) {
              String filter = filters[index];
              bool isSelected = _filterStatus == filter;
              return ChoiceChip(
                label: Text(filter),
                selected: isSelected,
                selectedColor: Colors.teal,
                backgroundColor: Colors.white,
                labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black87),
                onSelected: (selected) {
                  setState(() {
                    _filterStatus = filter;
                    _filterItems(); // Re-filter saat chip diklik
                  });
                },
              );
            },
          ),
        ),
      ],
    );
  }

  // DIALOG FORM (CREATE & UPDATE)
  void _showFormDialog({ItemBelanja? itemToEdit}) {
    final isEdit = itemToEdit != null;
    final namaController = TextEditingController(text: isEdit ? itemToEdit.nama : '');
    final jumlahController = TextEditingController(text: isEdit ? itemToEdit.jumlah.split(' ')[0] : '');
    
    String selectedCategory = isEdit ? itemToEdit.kategori : _categories[0];
    String selectedUnit = isEdit 
        ? (itemToEdit.jumlah.split(' ').length > 1 ? itemToEdit.jumlah.split(' ')[1] : _units[0]) 
        : _units[0];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setStateDialog) {
          return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
            ),
            padding: EdgeInsets.only(
              top: 25, left: 25, right: 25,
              bottom: MediaQuery.of(context).viewInsets.bottom + 25,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(child: Container(width: 50, height: 5, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10)))),
                const SizedBox(height: 20),
                Text(isEdit ? 'Edit Barang' : 'Tambah Item Baru', 
                     style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.teal)),
                const SizedBox(height: 20),
                
                TextField(
                  controller: namaController,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                    labelText: 'Nama Barang',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    filled: true, fillColor: Colors.grey[50],
                  ),
                ),
                const SizedBox(height: 15),
                
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: TextField(
                        controller: jumlahController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Jumlah',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          filled: true, fillColor: Colors.grey[50],
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      flex: 1,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _units.contains(selectedUnit) ? selectedUnit : _units[0],
                            isExpanded: true,
                            items: _units.map((String value) {
                              return DropdownMenuItem<String>(value: value, child: Text(value));
                            }).toList(),
                            onChanged: (newValue) => setStateDialog(() => selectedUnit = newValue!),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                
                const Text('Kategori:', style: TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    border: Border.all(color: Colors.teal.withAlpha(128)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _categories.contains(selectedCategory) ? selectedCategory : _categories[0],
                      isExpanded: true,
                      items: _categories.map((String category) {
                        return DropdownMenuItem<String>(
                          value: category,
                          child: Row(
                            children: [
                              CircleAvatar(radius: 5, backgroundColor: _categoryColors[category] ?? Colors.grey),
                              const SizedBox(width: 10),
                              Text(category),
                            ],
                          ),
                        );
                      }).toList(),
                      onChanged: (newValue) => setStateDialog(() => selectedCategory = newValue!),
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                
                SizedBox(
                  width: double.infinity, height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      if (namaController.text.isNotEmpty && jumlahController.text.isNotEmpty) {
                        if (isEdit) {
                          _updateItem(itemToEdit.id, namaController.text, jumlahController.text, selectedUnit, selectedCategory);
                        } else {
                          _addItem(namaController.text, jumlahController.text, selectedUnit, selectedCategory);
                        }
                        Navigator.pop(context);
                      } else {
                        _showCustomSnackBar('Mohon lengkapi data', Colors.orange);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      elevation: 2,
                    ),
                    child: Text(isEdit ? 'Update Barang' : 'Simpan Barang', 
                                style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // BI-DIRECTIONAL SWIPE CARD
  Widget _buildItemCard(ItemBelanja item) {
    return Dismissible(
      key: Key(item.id),
      // Izinkan geser ke Kanan (Edit) dan Kiri (Hapus)
      background: Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 25),
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.orangeAccent, // Warna Background Edit
          borderRadius: BorderRadius.circular(15),
        ),
        child: const Row(
          children: [
            Icon(Icons.edit, color: Colors.white, size: 32),
            SizedBox(width: 10),
            Text("Edit", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16))
          ],
        ),
      ),
      secondaryBackground: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 25),
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
        decoration: BoxDecoration(
          color: const Color(0xFFFF5252), // Warna Background Hapus
          borderRadius: BorderRadius.circular(15),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text("Hapus", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
            SizedBox(width: 10),
            Icon(Icons.delete_outline, color: Colors.white, size: 32)
          ],
        ),
      ),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          // GESER KE KANAN -> EDIT
          _showFormDialog(itemToEdit: item);
          return false; 
        } else {
          // GESER KE KIRI -> HAPUS
          return await _confirmDelete(item);
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
        decoration: BoxDecoration(
          color: item.sudahDibeli ? Colors.grey[100] : Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(13),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 1. Strip Warna Kategori
                Container(
                  width: 15,
                  color: item.sudahDibeli
                      ? Colors.grey[400]
                      : (_categoryColors[item.kategori] ?? Colors.grey),
                ),
                // 2. Konten Utama
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 0, 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          item.nama,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            decoration: item.sudahDibeli ? TextDecoration.lineThrough : null,
                            color: item.sudahDibeli ? Colors.grey : const Color(0xFF2D3436),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                  color: Colors.teal.withAlpha(26),
                                  borderRadius: BorderRadius.circular(4)),
                              child: Text(
                                item.jumlah,
                                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.teal[700]),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(item.kategori, style: TextStyle(fontSize: 11, color: Colors.grey[600])),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                // 3. Tombol Visible (Edit & Delete)
                if (!item.sudahDibeli)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        constraints: const BoxConstraints(),
                        padding: const EdgeInsets.all(8),
                        icon: const Icon(Icons.edit_outlined, color: Colors.orange, size: 22),
                        onPressed: () => _showFormDialog(itemToEdit: item),
                        tooltip: 'Edit',
                      ),
                      IconButton(
                        constraints: const BoxConstraints(),
                        padding: const EdgeInsets.all(8),
                        icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 22),
                        onPressed: () => _confirmDelete(item),
                        tooltip: 'Hapus',
                      ),
                    ],
                  ),
                // 4. Checkbox
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Transform.scale(
                    scale: 1.1,
                    child: Checkbox(
                      value: item.sudahDibeli,
                      activeColor: Colors.teal,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                      onChanged: (val) => _toggleStatus(item.id),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: Column(
        children: [
          _buildDashboard(),
          _buildFilterAndSearch(),
          Expanded(
            child: _filteredItems.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off, size: 80, color: Colors.grey[300]),
                        const SizedBox(height: 16),
                        Text('Item tidak ditemukan', style: TextStyle(fontSize: 16, color: Colors.grey[400])),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.only(top: 5, bottom: 80),
                    itemCount: _filteredItems.length,
                    itemBuilder: (context, index) {
                      return _buildItemCard(_filteredItems[index]);
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showFormDialog(),
        backgroundColor: Colors.teal,
        elevation: 4,
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
    );
  }
}