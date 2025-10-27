import 'package:flutter/material.dart';
import '../models/feedback_model.dart';

// Tambahkan SingleTickerProviderStateMixin untuk animasi
class FeedbackResultScreen extends StatefulWidget {
  final FeedbackData data;
  const FeedbackResultScreen({super.key, required this.data});

  @override
  State<FeedbackResultScreen> createState() => _FeedbackResultScreenState();
}

// Gunakan TickerProviderStateMixin untuk animasi berurutan (staggered)
class _FeedbackResultScreenState extends State<FeedbackResultScreen> with TickerProviderStateMixin {
  
  late AnimationController _controller;
  
  // List widget untuk memecah konten yang akan dianimasikan
  late List<Widget> _staggeredWidgets;
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500), // Durasi total animasi
      vsync: this,
    );
    
    // Siapkan list of widgets
    _staggeredWidgets = _buildContentList(context);
    
    // Jalankan animasi saat screen muncul
    _controller.forward();
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  
  // Fungsi helper untuk membangun list konten
  List<Widget> _buildContentList(BuildContext context) {
    // Definisi warna tema untuk konsistensi
    final Color primary = Theme.of(context).primaryColor;
    final Color accent = const Color(0xFF00bcd4); 

    return <Widget>[
      // 0. Header Utama
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Review of Submitted Feedback',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: primary),
          ),
          Divider(thickness: 3, color: accent, height: 30),
        ],
      ),

      // 1. User Details
      _buildSectionTitle(context, 'Submitted Details'),
      _buildResultRow('Name:', widget.data.name),
      _buildResultRow('Email:', widget.data.email),
      _buildResultRow('Role/Company:', widget.data.role.isEmpty ? "N/A (Not Provided)" : widget.data.role),

      // 2. Experience Ratings
      const SizedBox(height: 25),
      _buildSectionTitle(context, 'Experience Ratings'),
      _buildResultRow(
        'Overall Rating:', 
        '${widget.data.rating.toStringAsFixed(1)} out of 5', 
        isRating: true, 
        actualRating: widget.data.rating // Gunakan properti actualRating
      ),
      _buildResultRow('Product Quality:', widget.data.productQuality),
      _buildResultRow('Support Rating:', widget.data.customerSupportRating),

      // 3. Detailed Comments
      const SizedBox(height: 25),
      _buildSectionTitle(context, 'Detailed Comments'),
      _buildResultRow('Comment:', widget.data.comment.isEmpty ? "No detailed comments provided." : widget.data.comment, isMultiline: true),
      
      // 4. Spacer
      const SizedBox(height: 40),

      // 5. Button to return to form
      Center(
        child: ElevatedButton.icon(
          icon: const Icon(Icons.arrow_back_ios, size: 16, color: Colors.white),
          label: const Text('Back to Form', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
          onPressed: () => Navigator.pop(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: primary,
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 8,
          ),
        ),
      ),
    ];
  }

  // Widget animasi pembungkus
  Widget _buildAnimatedItem(Widget child, int index, int totalItems) {
    // Hitung interval animasi untuk efek berurutan
    final interval = 1.0 / totalItems;
    final start = index * interval;
    final end = (index + 1) * interval;

    // Pastikan end tidak melebihi 1.0
    final cappedEnd = end > 1.0 ? 1.0 : end;

    final animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(start, cappedEnd, curve: Curves.easeOut),
      ),
    );

    return FadeTransition(
      opacity: animation,
      child: SlideTransition(
        // Animasikan sedikit pergeseran vertikal
        position: Tween<Offset>(
          begin: const Offset(0, 0.5),
          end: Offset.zero,
        ).animate(animation),
        child: child,
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    // Karena kita menggunakan StatefulWidget, kita bisa menggunakan widget.data
    final Color primary = Theme.of(context).primaryColor;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Feedback Summary'),
        backgroundColor: primary,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: ListBody( // Gunakan ListBody untuk merender list of widgets yang sudah dianimasikan
            children: List.generate(_staggeredWidgets.length, (index) {
              return _buildAnimatedItem(_staggeredWidgets[index], index, _staggeredWidgets.length);
            }),
          ),
        ),
      ),
    );
  }

  // Helper widget to consistently style section titles (Disesuaikan untuk menerima warna tema)
  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0, top: 5.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: Theme.of(context).primaryColor.withAlpha(230),
        ),
      ),
    );
  }

  // Helper widget to display each result row (Diperluas untuk menerima actualRating)
  Widget _buildResultRow(String label, String value, {bool isRating = false, bool isMultiline = false, double? actualRating}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF0D47A1)),
          ),
          const SizedBox(height: 5),
          if (isRating && actualRating != null) 
            Row(
              children: [
                _buildStarRating(actualRating), // Menggunakan rating double
                const SizedBox(width: 8),
                Text(value, style: const TextStyle(fontSize: 16, color: Colors.black87)),
              ],
            )
          else 
            Text(value, 
              style: const TextStyle(fontSize: 16, color: Colors.black87, height: 1.4),
              maxLines: isMultiline ? 10 : 1,
              overflow: isMultiline ? TextOverflow.clip : TextOverflow.ellipsis,
            ),
          const Divider(height: 8, thickness: 0.5, color: Colors.grey),
        ],
      ),
    );
  }

  // Helper widget to display star icons for the rating (Tidak diubah)
  Widget _buildStarRating(double rating) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        IconData icon = Icons.star;
        Color color = Colors.grey.shade400;

        if (index < rating.floor()) {
          color = Colors.amber;
        } else if (index < rating && rating < index + 1) {
          icon = Icons.star_half;
          color = Colors.amber;
        }

        return Icon(icon, color: color, size: 20);
      }),
    );
  }
}