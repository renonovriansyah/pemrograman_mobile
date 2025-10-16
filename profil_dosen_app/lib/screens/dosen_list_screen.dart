import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/dosen_provider.dart';
import '../models/dosen_model.dart';
import 'dosen_detail_screen.dart';
import 'login_screen.dart';
import 'profil_mahasiswa_screen.dart';
import '../providers/mahasiswa_provider.dart'; // <<< TAMBAHKAN IMPORT INI

class DosenListScreen extends StatelessWidget {
  const DosenListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dosenProvider = Provider.of<DosenProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Direktori Dosen'),
        backgroundColor: const Color(0xFF0A2647),
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const ProfilMahasiswaScreen()),
              );
            },
            icon: const Icon(Icons.account_circle),
            tooltip: 'Profil Mahasiswa',
          ),
          IconButton(
            onPressed: () {
              // Panggil fungsi logout
              Provider.of<MahasiswaProvider>(context, listen: false).logout();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
          ),
        ],
      ),
      body: Column(
        children: [
          _buildFilterSection(context, dosenProvider, theme),
          Expanded(
            child: dosenProvider.filteredDosen.isEmpty
                ? const Center(child: Text('Tidak ada dosen yang cocok.'))
                : ListView.builder(
                    itemCount: dosenProvider.filteredDosen.length,
                    itemBuilder: (context, index) {
                      final dosen = dosenProvider.filteredDosen[index];
                      return _buildDosenCard(context, dosen, theme);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  // ... (Sisa kode helper _buildFilterSection, _buildFilterChip, _buildDosenCard tetap sama, tidak perlu diubah) ...
  Widget _buildFilterSection(BuildContext context, DosenProvider provider, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      color: const Color(0xFF0A2647),
      child: Column(
        children: [
          TextField(
            onChanged: (value) => provider.updateSearchQuery(value),
            decoration: InputDecoration(
              hintText: 'Cari Nama / NIP...',
              hintStyle: TextStyle(color: Colors.grey[400]),
              prefixIcon: const Icon(Icons.search, color: Colors.white),
              filled: true,
              fillColor: const Color(0xFF1C3A5E),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
            ),
            style: const TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildFilterChip(context, 'Fakultas', provider.selectedFakultas, provider.allFakultas, (val) => provider.setFakultas(val)),
                _buildFilterChip(context, 'Status', provider.selectedStatus, provider.allStatus, (val) => provider.setStatus(val)),
                 if (provider.selectedFakultas != null || provider.selectedStatus != null)
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: ActionChip(
                      label: const Text('Reset'),
                      avatar: const Icon(Icons.clear, size: 16),
                      onPressed: () => provider.clearFilters(),
                    ),
                  )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildFilterChip(BuildContext context, String label, String? selectedValue, List<String> options, Function(String?) onSelected) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: ActionChip(
        avatar: Icon(selectedValue != null ? Icons.check_circle : Icons.filter_list, color: selectedValue != null ? Colors.white : null),
        label: Text(selectedValue ?? label),
        backgroundColor: selectedValue != null ? Colors.blueAccent : Colors.grey[200],
        labelStyle: TextStyle(color: selectedValue != null ? Colors.white : Colors.black87),
        onPressed: () async {
          final result = await showModalBottomSheet<String?>(
            context: context,
            builder: (ctx) {
              return Wrap(
                children: [
                  ListTile(
                    title: Text('Pilih $label', style: Theme.of(context).textTheme.titleLarge),
                  ),
                  ListTile(
                    title: Text('Semua $label'),
                    onTap: () => Navigator.of(ctx).pop(null),
                  ),
                  ...options.map((option) => ListTile(
                        title: Text(option),
                        onTap: () => Navigator.of(ctx).pop(option),
                      )),
                ],
              );
            },
          );
          onSelected(result);
        },
      ),
    );
  }

  Widget _buildDosenCard(BuildContext context, Dosen dosen, ThemeData theme) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => DosenDetailScreen(dosen: dosen)),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 35,
                backgroundImage: AssetImage(dosen.fotoUrl),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(dosen.nama, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text('NIP: ${dosen.nip}', style: theme.textTheme.bodySmall),
                    Text(dosen.fakultas, style: theme.textTheme.bodySmall),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: dosen.status == 'Aktif Mengajar' ? Colors.green.shade100 : Colors.orange.shade100,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        dosen.status,
                        style: TextStyle(
                          fontSize: 12,
                          color: dosen.status == 'Aktif Mengajar' ? Colors.green.shade800 : Colors.orange.shade800,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}