import 'package:flutter/material.dart';
import 'main.dart'; // Import AppColors, FeedbackData
import 'feedback_form.dart'; // Import common widgets (CustomButton, FeedbackCard, etc.)

class ReviewSummaryScreen extends StatelessWidget {
  final FeedbackData data;
  final VoidCallback onBackToHome;

  const ReviewSummaryScreen({
    super.key,
    required this.data,
    required this.onBackToHome,
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
                  title: 'MASUKAN ANDA',
                  subtitle: 'Bantu kami untuk melayani lebih baik',
                  iconPath: 'assets/logo.png',
                ),
                OrderInfoWidget(orderId: data.orderId), 
                const Divider(height: 30),

                // Detail Rating Review
                const FormLabel('Detail Pesanan'),
                ReviewRatingGroup(
                  label: 'Kualitas Makanan',
                  rating: data.foodRating,
                ),
                const SizedBox(height: 15),
                ReviewRatingGroup(
                  label: 'Kecepatan Pengiriman',
                  rating: data.deliveryRating,
                ),
                const Divider(height: 30),

                // Ulasan Review
                const FormLabel('Rating & Ulasan Anda'),
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Text(
                    data.comment.isNotEmpty ? data.comment : 'Tidak ada komentar diberikan.',
                    style: const TextStyle(color: AppColors.textGrey),
                  ),
                ),
                const SizedBox(height: 30),

                CustomButton(
                  text: 'KEMBALI KE BERANDA',
                  onPressed: onBackToHome, // Memicu reset form di FeedbackHomePage
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ReviewRatingGroup extends StatelessWidget {
  final String label;
  final int rating;
  final List<String> _emojis = const ['😞', '😐', '😊', '😁', '🤩'];

  const ReviewRatingGroup({
    super.key,
    required this.label,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w500, color: AppColors.textGrey)),
        const SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(5, (index) {
            return Icon(
              Icons.star,
              color: (index + 1) <= rating ? AppColors.secondaryOrange : Colors.grey.shade300,
              size: 30,
            );
          }),
        ),
        const SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: _emojis.asMap().entries.map((entry) {
            final index = entry.key;
            final emoji = entry.value;
            return Opacity(
              opacity: (index + 1) == rating ? 1.0 : 0.4,
              child: Text(
                emoji,
                style: TextStyle(fontSize: (index + 1) == rating ? 24 : 18),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}