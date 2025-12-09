class ItemBelanja {
  String id;
  String nama;
  String jumlah;
  String kategori; // Makanan, Minuman, Elektronik, Lainnya
  bool sudahDibeli;

  ItemBelanja({
    required this.id,
    required this.nama,
    required this.jumlah,
    required this.kategori,
    this.sudahDibeli = false,
  });

  // Konversi dari JSON (untuk load dari storage)
  factory ItemBelanja.fromJson(Map<String, dynamic> json) {
    return ItemBelanja(
      id: json['id'],
      nama: json['nama'],
      jumlah: json['jumlah'],
      kategori: json['kategori'],
      sudahDibeli: json['sudahDibeli'],
    );
  }

  // Konversi ke JSON (untuk save ke storage)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama': nama,
      'jumlah': jumlah,
      'kategori': kategori,
      'sudahDibeli': sudahDibeli,
    };
  }
}