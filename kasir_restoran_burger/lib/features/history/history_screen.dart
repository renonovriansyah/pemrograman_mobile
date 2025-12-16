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
  // Label filter yang sedang aktif (untuk UI)
  String _activeFilterLabel = 'Semua';
  // Range tanggal aktual untuk logic
  DateTimeRange? _selectedDateRange;

  // --- LOGIKA QUICK FILTER ---
  void _setFilter(String label) async {
    final now = DateTime.now();
    DateTimeRange? newRange;

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
      case 'Bulan Ini':
        newRange = DateTimeRange(
          start: DateTime(now.year, now.month, 1), 
          end: DateTime(now.year, now.month + 1, 0) // Akhir bulan
        );
        break;
      case 'Semua':
        newRange = null;
        break;
      case 'Custom':
        // Buka Kalender Custom
        final picked = await showDateRangePicker(
          context: context,
          firstDate: DateTime(2020),
          lastDate: now,
          initialDateRange: _selectedDateRange,
          builder: (context, child) {
            return Theme(
              data: ThemeData.light().copyWith(
                primaryColor: const Color(0xFF720E1E),
                colorScheme: const ColorScheme.light(primary: Color(0xFF720E1E), onPrimary: Colors.white),
                scaffoldBackgroundColor: Colors.white,
              ),
              child: child!,
            );
          },
        );
        if (picked != null) {
          newRange = picked;
        } else {
          return; // Batal pilih
        }
        break;
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

              // --- FILTER LOGIC ---
              final filteredDocs = allDocs.where((doc) {
                if (_selectedDateRange == null) return true;

                final data = doc.data() as Map<String, dynamic>;
                final timestamp = (data['timestamp'] as Timestamp).toDate();
                
                // Normalisasi jam agar akurat (Start 00:00:00 - End 23:59:59)
                final start = DateTime(_selectedDateRange!.start.year, _selectedDateRange!.start.month, _selectedDateRange!.start.day);
                final end = DateTime(_selectedDateRange!.end.year, _selectedDateRange!.end.month, _selectedDateRange!.end.day, 23, 59, 59);

                return timestamp.isAfter(start.subtract(const Duration(seconds: 1))) && 
                       timestamp.isBefore(end.add(const Duration(seconds: 1)));
              }).toList();

              // --- HITUNG SUMMARY ---
              double totalRevenue = 0;
              for (var doc in filteredDocs) {
                final data = doc.data() as Map<String, dynamic>;
                totalRevenue += (data['totalAmount'] ?? 0).toDouble();
              }

              return Column(
                children: [
                  // --- HEADER: SUMMARY & QUICK FILTER ---
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 1. FILTER CHIPS SCROLLABLE
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                          child: Row(
                            children: [
                              _buildFilterChip("Semua"),
                              _buildFilterChip("Hari Ini"),
                              _buildFilterChip("Kemarin"),
                              _buildFilterChip("7 Hari"),
                              _buildFilterChip("Bulan Ini"),
                              // Tombol Custom (Icon Kalender)
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: InkWell(
                                  onTap: () => _setFilter('Custom'),
                                  borderRadius: BorderRadius.circular(20),
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: _activeFilterLabel == 'Custom' ? const Color(0xFF720E1E) : Colors.grey[100],
                                      shape: BoxShape.circle,
                                      border: Border.all(color: _activeFilterLabel == 'Custom' ? const Color(0xFF720E1E) : Colors.grey[300]!)
                                    ),
                                    child: Icon(
                                      Icons.calendar_month_rounded, 
                                      size: 20,
                                      color: _activeFilterLabel == 'Custom' ? Colors.white : Colors.grey[600]
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // 2. INFO TANGGAL TERPILIH (Jika Custom/Range)
                        if (_selectedDateRange != null)
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                            child: Text(
                              "${DateFormat('dd MMM').format(_selectedDateRange!.start)} - ${DateFormat('dd MMM yyyy').format(_selectedDateRange!.end)}",
                              style: TextStyle(color: Colors.grey[600], fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                          ),

                        const SizedBox(height: 12),

                        // 3. SUMMARY CARDS
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
                              Icon(Icons.event_busy_rounded, size: 60, color: Colors.grey[300]),
                              const SizedBox(height: 12),
                              Text("Tidak ada data transaksi", style: TextStyle(color: Colors.grey[500], fontWeight: FontWeight.bold)),
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
                            final idShort = doc.id.substring(0, 8).toUpperCase();

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
                                      Container(
                                        height: 45, width: 45,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFF9F9F9),
                                          borderRadius: BorderRadius.circular(12),
                                          border: Border.all(color: Colors.grey[200]!)
                                        ),
                                        child: const Icon(Icons.receipt_long_rounded, color: Color(0xFF720E1E), size: 22),
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text("#$idShort", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                                            const SizedBox(height: 2),
                                            Text(dateStr, style: TextStyle(color: Colors.grey[600], fontSize: 11)),
                                          ],
                                        ),
                                      ),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Text(currency.format(total), style: const TextStyle(fontWeight: FontWeight.w900, color: Color(0xFF720E1E), fontSize: 14)),
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

  // --- WIDGET HELPER CHIP ---
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
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : Colors.grey[700],
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
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