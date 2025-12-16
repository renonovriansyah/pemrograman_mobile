import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/widgets/app_background.dart'; 
import 'transaction_detail_screen.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  // Label filter yang sedang aktif
  String _activeFilterLabel = 'Semua';
  // Label khusus untuk tombol bulan
  String _monthButtonLabel = 'Pilih Bulan';
  
  // Range tanggal aktual
  DateTimeRange? _selectedDateRange;

  // --- 1. TAMBAHAN VARIABEL SEARCH ---
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // --- FUNGSI POPUP BULAN ---
  void _showMonthPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          height: 400,
          child: Column(
            children: [
              const Text(
                "Pilih Bulan",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xFF720E1E)),
              ),
              const SizedBox(height: 10),
              const Divider(),
              Expanded(
                child: ListView.builder(
                  itemCount: 13,
                  itemBuilder: (context, index) {
                    final date = DateTime(DateTime.now().year, DateTime.now().month - index);
                    // Gunakan locale 'id_ID' jika sudah diinit di main.dart, jika belum hapus parameternya
                    final monthName = DateFormat('MMMM yyyy', 'id_ID').format(date);

                    return ListTile(
                      title: Text(monthName, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.w500)),
                      onTap: () {
                        final start = DateTime(date.year, date.month, 1);
                        final end = DateTime(date.year, date.month + 1, 0, 23, 59, 59);

                        setState(() {
                          _selectedDateRange = DateTimeRange(start: start, end: end);
                          _activeFilterLabel = 'BulanCustom';
                          _monthButtonLabel = monthName;
                        });
                        
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // --- LOGIKA FILTER CHIPS ---
  void _setFilter(String label) {
    final now = DateTime.now();
    DateTimeRange? newRange;

    if (label != 'BulanCustom') {
      setState(() => _monthButtonLabel = 'Pilih Bulan');
    }

    switch (label) {
      case 'Hari Ini':
        newRange = DateTimeRange(start: now, end: now);
        break;
      case 'Kemarin':
        final yesterday = now.subtract(const Duration(days: 1));
        newRange = DateTimeRange(start: yesterday, end: yesterday);
        break;
      case '7 Hari':
        newRange = DateTimeRange(start: now.subtract(const Duration(days: 6)), end: now);
        break;
      case 'Semua':
        newRange = null;
        break;
      case 'BulanCustom':
        _showMonthPicker();
        return;
    }

    setState(() {
      _activeFilterLabel = label;
      _selectedDateRange = newRange;
    });
  }

  @override
  Widget build(BuildContext context) {
    final currency = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("Riwayat Transaksi"),
        centerTitle: true,
        backgroundColor: const Color(0xFF720E1E),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: AppBackground(
        child: SafeArea(
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('transactions')
                .orderBy('timestamp', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator(color: Color(0xFF720E1E)));
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return _buildEmptyState();
              }

              final allDocs = snapshot.data!.docs;

              // --- 2. LOGIKA FILTER (TANGGAL + NAMA) ---
              final filteredDocs = allDocs.where((doc) {
                final data = doc.data() as Map<String, dynamic>;
                
                // A. Cek Tanggal
                bool dateMatch = true;
                if (_selectedDateRange != null) {
                  final timestamp = (data['timestamp'] as Timestamp).toDate();
                  final start = DateTime(_selectedDateRange!.start.year, _selectedDateRange!.start.month, _selectedDateRange!.start.day);
                  final end = DateTime(_selectedDateRange!.end.year, _selectedDateRange!.end.month, _selectedDateRange!.end.day, 23, 59, 59);
                  
                  dateMatch = timestamp.isAfter(start.subtract(const Duration(seconds: 1))) && 
                              timestamp.isBefore(end.add(const Duration(seconds: 1)));
                }

                // B. Cek Pencarian Nama/ID
                bool searchMatch = true;
                if (_searchQuery.isNotEmpty) {
                  final query = _searchQuery.toLowerCase();
                  final customerName = (data['customerName'] ?? '').toString().toLowerCase();
                  final id = doc.id.toLowerCase();
                  
                  searchMatch = customerName.contains(query) || id.contains(query);
                }

                return dateMatch && searchMatch;
              }).toList();

              // --- HITUNG TOTAL ---
              double totalRevenue = 0;
              for (var doc in filteredDocs) {
                final data = doc.data() as Map<String, dynamic>;
                totalRevenue += (data['totalAmount'] ?? 0).toDouble();
              }

              return Column(
                children: [
                  // --- HEADER (SEARCH + FILTER + SUMMARY) ---
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withAlpha(10), blurRadius: 10, offset: const Offset(0, 5))
                      ]
                    ),
                    child: Column(
                      children: [
                        // A. SEARCH BAR (BARU)
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                          child: TextField(
                            controller: _searchController,
                            onChanged: (value) {
                              setState(() {
                                _searchQuery = value;
                              });
                            },
                            decoration: InputDecoration(
                              hintText: "Cari Nama Pelanggan...",
                              prefixIcon: const Icon(Icons.search, color: Colors.grey),
                              suffixIcon: _searchQuery.isNotEmpty 
                                ? IconButton(
                                    icon: const Icon(Icons.clear, color: Colors.grey),
                                    onPressed: () {
                                      _searchController.clear();
                                      setState(() => _searchQuery = '');
                                    },
                                  )
                                : null,
                              filled: true,
                              fillColor: Colors.grey[100],
                              contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(color: Color(0xFF720E1E), width: 1),
                              ),
                            ),
                          ),
                        ),

                        // B. FILTER CHIPS
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
                          child: Row(
                            children: [
                              _buildFilterChip("Semua"),
                              _buildFilterChip("Hari Ini"),
                              _buildFilterChip("Kemarin"),
                              _buildFilterChip("7 Hari"),
                              
                              // TOMBOL PILIH BULAN
                              Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: FilterChip(
                                  label: Row(
                                    children: [
                                      Icon(
                                        Icons.calendar_month_rounded, 
                                        size: 14, 
                                        color: _activeFilterLabel == 'BulanCustom' ? Colors.white : Colors.grey[700]
                                      ),
                                      const SizedBox(width: 6),
                                      Text(_monthButtonLabel),
                                    ],
                                  ),
                                  selected: _activeFilterLabel == 'BulanCustom',
                                  onSelected: (_) => _setFilter('BulanCustom'),
                                  backgroundColor: Colors.white,
                                  selectedColor: const Color(0xFF720E1E),
                                  checkmarkColor: Colors.white,
                                  showCheckmark: false,
                                  labelStyle: TextStyle(
                                    color: _activeFilterLabel == 'BulanCustom' ? Colors.white : Colors.grey[700],
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    side: BorderSide(color: _activeFilterLabel == 'BulanCustom' ? Colors.transparent : Colors.grey[300]!)
                                  ),
                                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // C. SUMMARY CARDS
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                          child: Row(
                            children: [
                              Expanded(
                                child: _buildSummaryCard(
                                  title: "Pendapatan",
                                  value: currency.format(totalRevenue),
                                  icon: Icons.monetization_on_rounded,
                                  color: Colors.green[700]!,
                                  bgColor: Colors.green[50]!,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _buildSummaryCard(
                                  title: "Transaksi",
                                  value: "${filteredDocs.length} Struk",
                                  icon: Icons.receipt_long_rounded,
                                  color: const Color(0xFF720E1E),
                                  bgColor: const Color(0xFF720E1E).withAlpha(20),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // --- LIST DATA ---
                  Expanded(
                    child: filteredDocs.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                _searchQuery.isNotEmpty ? Icons.search_off_rounded : Icons.event_busy_rounded, 
                                size: 60, 
                                color: Colors.grey[300]
                              ),
                              const SizedBox(height: 12),
                              Text(
                                _searchQuery.isNotEmpty 
                                  ? "Tidak ditemukan: \"$_searchQuery\""
                                  : "Tidak ada data transaksi",
                                style: TextStyle(color: Colors.grey[500], fontWeight: FontWeight.bold)
                              ),
                            ],
                          ),
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.all(16),
                          itemCount: filteredDocs.length,
                          separatorBuilder: (context, index) => const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final doc = filteredDocs[index];
                            final data = doc.data() as Map<String, dynamic>;
                            final total = (data['totalAmount'] ?? 0).toDouble();
                            final method = data['paymentMethod'] ?? '-';
                            DateTime date = (data['timestamp'] as Timestamp).toDate();
                            final dateStr = DateFormat('dd MMM, HH:mm').format(date);
                            
                            // 3. AMBIL NAMA PELANGGAN (Default 'Pelanggan')
                            final customerName = data['customerName'] ?? 'Pelanggan';

                            return FadeInUp(
                              duration: const Duration(milliseconds: 300),
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => TransactionDetailScreen(
                                        data: data,
                                        documentId: doc.id,
                                      ),
                                    ),
                                  );
                                },
                                borderRadius: BorderRadius.circular(16),
                                child: Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [
                                      BoxShadow(color: Colors.black.withAlpha(5), blurRadius: 5, offset: const Offset(0, 2))
                                    ],
                                  ),
                                  child: Row(
                                    children: [
                                      // Ganti ikon struk dengan ikon user jika ada nama
                                      Container(
                                        height: 45, width: 45,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFF9F9F9),
                                          borderRadius: BorderRadius.circular(12),
                                          border: Border.all(color: Colors.grey[200]!)
                                        ),
                                        child: const Icon(Icons.person_rounded, color: Color(0xFF720E1E), size: 24),
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            // TAMPILKAN NAMA PELANGGAN
                                            Text(
                                              customerName, 
                                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            const SizedBox(height: 2),
                                            Text(dateStr, style: TextStyle(color: Colors.grey[600], fontSize: 11)),
                                          ],
                                        ),
                                      ),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            currency.format(total), 
                                            style: const TextStyle(fontWeight: FontWeight.w900, color: Color(0xFF720E1E), fontSize: 14)
                                          ),
                                          const SizedBox(height: 4),
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                            decoration: BoxDecoration(color: Colors.green[50], borderRadius: BorderRadius.circular(4)),
                                            child: Text(method, style: TextStyle(fontSize: 9, color: Colors.green[800], fontWeight: FontWeight.bold)),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  // --- WIDGET HELPER ---
  Widget _buildFilterChip(String label) {
    final isSelected = _activeFilterLabel == label;
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (bool selected) {
          if (selected) _setFilter(label);
        },
        backgroundColor: Colors.white,
        selectedColor: const Color(0xFF720E1E),
        checkmarkColor: Colors.white,
        showCheckmark: false,
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : Colors.grey[700],
          fontWeight: FontWeight.w600,
          fontSize: 12
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: isSelected ? Colors.transparent : Colors.grey[300]!)
        ),
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
      ),
    );
  }

  Widget _buildSummaryCard({required String title, required String value, required IconData icon, required Color color, required Color bgColor}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 14, color: color),
              const SizedBox(width: 4),
              Text(title, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 10)),
            ],
          ),
          const SizedBox(height: 6),
          Text(value, style: TextStyle(color: color, fontWeight: FontWeight.w900, fontSize: 14), maxLines: 1, overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.receipt_long_outlined, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text("Belum ada riwayat transaksi", style: TextStyle(color: Colors.grey[500], fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}