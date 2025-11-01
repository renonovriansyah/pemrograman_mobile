import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'feedback_form.dart';
import 'review_summary.dart';

void main() {
  runApp(const RestaurantFeedbackApp());
}

// =======================
// === PALET WARNA APLIKASI ===
// =======================
class AppColors {
  static const Color primaryOrange = Color(0xFFF0A202); 
  static const Color secondaryOrange = Color(0xFFF9C100); 
  static const Color lightGreenBackground = Color(0xFFE6FFE6); 
  static const Color textDark = Color(0xFF333333);
  static const Color textGrey = Color(0xFF555555);
}

class RestaurantFeedbackApp extends StatelessWidget {
  const RestaurantFeedbackApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Feedback Restoran',
      theme: ThemeData(
        fontFamily: 'Poppins',
        visualDensity: VisualDensity.adaptivePlatformDensity,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primaryOrange, 
        ).copyWith(
          primary: AppColors.primaryOrange,
          secondary: AppColors.secondaryOrange,
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: AppColors.primaryOrange, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.red, width: 2),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        ),
      ),
      home: const FeedbackHomePage(),
    );
  }
}

// =======================
// === STRUKTUR DATA FEEDBACK ===
// =======================
class FeedbackData {
  String orderId;
  int foodRating;
  int deliveryRating;
  String comment;
  String? email;
  bool willReorder;

  FeedbackData({
    required this.orderId,
    this.foodRating = 0,
    this.deliveryRating = 0,
    this.comment = '',
    this.email,
    this.willReorder = true,
  });
}

// =======================
// === LOGIKA NAVIGASI UTAMA (Stateful) ===
// =======================
class FeedbackHomePage extends StatefulWidget {
  const FeedbackHomePage({super.key});

  @override
  State<FeedbackHomePage> createState() => _FeedbackHomePageState();
}

class _FeedbackHomePageState extends State<FeedbackHomePage> {
  FeedbackData? lastFeedback;
  
  // Key untuk memaksa rebuild FeedbackForm saat mengisi ulang
  Key _formKey = UniqueKey(); 

  // Fungsi ID Otomatis
  String generateOrderId() {
    final now = DateTime.now();
    final formatter = DateFormat('yyyyMMdd-HHmmss');
    return '#${formatter.format(now)}';
  }

  void _handleSubmit(FeedbackData data) {
    setState(() {
      lastFeedback = data;
    });

    // Navigasi ke halaman Terima Kasih
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => ThankYouScreen(
          orderId: data.orderId,
          onViewReview: () => _handleViewReview(data),
          onFillAgain: _handleFillAgain,
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeOut;
          final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      ),
    );
  }

  void _handleViewReview(FeedbackData data) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ReviewSummaryScreen(
          data: data,
          onBackToHome: _handleFillAgain, // "Kembali ke Beranda" memicu reset
        ),
      ),
    );
  }

  void _handleFillAgain() {
    // 1. Hapus semua rute hingga yang pertama
    Navigator.of(context).popUntil((route) => route.isFirst);
    
    // 2. Update key, ini akan memaksa FeedbackForm dibuat ulang dan mereset isian
    setState(() {
      _formKey = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Tampilan awal (formulir)
    return FeedbackForm(
      key: _formKey, // Pasang Key untuk reset otomatis
      initialOrderId: generateOrderId(),
      onSubmit: _handleSubmit,
    );
  }
}

// =======================
// === WIDGET POP-UP "TERIMA KASIH" ===
// =======================
class ThankYouScreen extends StatelessWidget {
  final String orderId;
  final VoidCallback onViewReview;
  final VoidCallback onFillAgain;

  const ThankYouScreen({
    super.key,
    required this.orderId,
    required this.onViewReview,
    required this.onFillAgain,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Latar belakang dengan blur (Menggunakan .png)
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/background.png'), 
                fit: BoxFit.cover, // <-- Perbaikan BoxFit
              ),
            ),
            child: Container(
              color: Colors.black54, 
            ),
          ),
          Center(
            child: FeedbackCard( 
              children: [
                const HeaderWidget(
                  title: 'TERIMA KASIH!',
                  subtitle: 'Masukan Anda sudah terkirim.',
                  iconPath: 'assets/logo.png',
                  showHeart: true, 
                ),
                OrderInfoWidget(orderId: orderId),
                const SizedBox(height: 30),
                CustomButton(
                  text: 'LIHAT MASUKAN SAYA',
                  onPressed: onViewReview,
                ),
                const SizedBox(height: 15),
                CustomButton(
                  text: 'ISI LAGI FEEDBACK',
                  isSecondary: true, 
                  onPressed: onFillAgain,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}