import 'package:flutter/material.dart';
import 'main.dart'; // Import AppColors dan FeedbackData

class FeedbackForm extends StatefulWidget {
  final String initialOrderId;
  final Function(FeedbackData) onSubmit;

  const FeedbackForm({
    super.key,
    required this.initialOrderId,
    required this.onSubmit,
  });

  @override
  State<FeedbackForm> createState() => _FeedbackFormState();
}

class _FeedbackFormState extends State<FeedbackForm> with SingleTickerProviderStateMixin {
  late FeedbackData _data;
  bool _emailOptIn = false;
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>(); 
  final TextEditingController _commentController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    
    // --- FITUR RESET FORM OTOMATIS: Dijalankan setiap kali key diubah ---
    _data = FeedbackData(orderId: widget.initialOrderId);
    _commentController.clear(); 
    _emailController.clear();
    _emailOptIn = false; 
    // -----------------------------------------------------------------

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.05), 
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _commentController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  bool _validateRatings() {
    return _data.foodRating > 0 && _data.deliveryRating > 0;
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      if (!_validateRatings()) {
         ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('⭐ Mohon berikan rating Makanan dan Pengiriman (minimal 1 bintang).'),
              backgroundColor: AppColors.primaryOrange,
            ),
          );
          return;
      }

      _data.comment = _commentController.text;
      _data.email = _emailOptIn ? _emailController.text : null;
      
      widget.onSubmit(_data);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              child: ImageFiltered(
                imageFilter: const ColorFilter.mode(Colors.black, BlendMode.color),
                child: Container(),
              ),
            ),
          ),
          
          Center(
            child: SlideTransition(
              position: _slideAnimation,
              child: FadeTransition(
                opacity: _controller,
                child: Form( 
                  key: _formKey,
                  child: FeedbackCard(
                    children: [
                      const HeaderWidget(
                        title: 'BERI KAMI MASUKAN!',
                        subtitle: 'Bantu kami untuk melayani lebih baik',
                        iconPath: 'assets/logo.png',
                      ),
                      OrderInfoWidget(orderId: _data.orderId),
                      const Divider(height: 30),
                      
                      // Rating Section
                      const FormLabel('Rating Makanan & Layanan'),
                      RatingGroup(
                        label: 'Kualitas Makanan',
                        initialRating: _data.foodRating,
                        onRatingChanged: (rating) {
                          setState(() => _data.foodRating = rating);
                        },
                      ),
                      const SizedBox(height: 15),
                      RatingGroup(
                        label: 'Kecepatan Pengiriman',
                        initialRating: _data.deliveryRating,
                        onRatingChanged: (rating) {
                          setState(() => _data.deliveryRating = rating);
                        },
                      ),
                      const Divider(height: 30),

                      // Comment Section
                      const FormLabel('Bagaimana pengalamanmu?'),
                      TextFormField(
                        controller: _commentController, 
                        maxLines: 4,
                        decoration: const InputDecoration(
                          hintText: 'Berikan saranmu di sini...',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Komentar wajib diisi.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),

                      // Preferences (Menggunakan RadioListTile untuk menghilangkan warning)
                      const FormLabel('Apakah Anda akan memesan lagi?'),
                      Column( 
                        children: [
                          RadioListTile<bool>(
                            title: const Text('Ya', style: TextStyle(color: AppColors.textGrey)),
                            value: true,
                            groupValue: _data.willReorder,
                            activeColor: AppColors.primaryOrange,
                            onChanged: (bool? value) {
                              setState(() => _data.willReorder = value ?? true);
                            },
                            contentPadding: EdgeInsets.zero,
                          ),
                          RadioListTile<bool>(
                            title: const Text('Tidak', style: TextStyle(color: AppColors.textGrey)),
                            value: false,
                            groupValue: _data.willReorder,
                            activeColor: AppColors.primaryOrange,
                            onChanged: (bool? value) {
                              setState(() => _data.willReorder = value ?? false);
                            },
                            contentPadding: EdgeInsets.zero,
                          ),
                        ],
                      ),


                      // Email Opt-in
                      Row(
                        children: [
                          Checkbox(
                            value: _emailOptIn,
                            activeColor: AppColors.primaryOrange,
                            onChanged: (bool? value) => setState(() => _emailOptIn = value ?? false),
                          ),
                          const Text('Ya, kirim ke email saya (Opsional)', style: TextStyle(color: AppColors.textGrey)),
                        ],
                      ),
                      if (_emailOptIn)
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: TextFormField(
                            controller: _emailController, 
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(
                              hintText: 'Masukkan email Anda',
                            ),
                            validator: (value) {
                              if (_emailOptIn && (value == null || value.isEmpty)) {
                                return 'Alamat email wajib diisi.';
                              }
                              final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                              if (_emailOptIn && !emailRegex.hasMatch(value!)) {
                                return 'Format email tidak valid.';
                              }
                              return null;
                            },
                          ),
                        ),
                      const SizedBox(height: 30),

                      CustomButton(
                        text: 'KIRIM MASUKAN',
                        onPressed: _submitForm, 
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ====================================================================
// ========================== COMMON WIDGETS ==========================
// ====================================================================

class FeedbackCard extends StatelessWidget {
  final List<Widget> children;
  const FeedbackCard({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 500,
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            // Perbaikan: Menggunakan withOpacity
            color: Colors.black.withAlpha(35), 
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: children,
        ),
      ),
    );
  }
}

class HeaderWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final String iconPath;
  final bool showHeart;

  const HeaderWidget({
    super.key,
    required this.title,
    required this.subtitle,
    required this.iconPath,
    this.showHeart = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(iconPath, height: 60), 
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryOrange,
              ),
            ),
            if (showHeart)
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: TweenAnimationBuilder<double>(
                  tween: Tween<double>(begin: 1.0, end: 1.1),
                  duration: const Duration(milliseconds: 700),
                  builder: (context, scale, child) {
                    return Transform.scale(
                      scale: scale,
                      child: child,
                    );
                  },
                  curve: Curves.easeInOut,
                  child: const Icon(Icons.favorite, color: Colors.red, size: 28),
                ),
              ),
          ],
        ),
        Text(subtitle, style: const TextStyle(color: Colors.grey)),
        const SizedBox(height: 20),
      ],
    );
  }
}

class OrderInfoWidget extends StatelessWidget {
  final String orderId;
  const OrderInfoWidget({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppColors.lightGreenBackground,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(12),
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Pesanan Anda',
            style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textDark),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Text(
                    'ID Pesanan: $orderId',
                    style: const TextStyle(color: AppColors.textGrey),
                  ),
                ),
              ),
              const SizedBox(width: 15),
              Image.asset('assets/burger.png', height: 60, width: 60, fit: BoxFit.cover),
            ],
          ),
        ],
      ),
    );
  }
}

class RatingGroup extends StatefulWidget {
  final String label;
  final int initialRating;
  final Function(int) onRatingChanged;

  const RatingGroup({
    super.key,
    required this.label,
    required this.initialRating,
    required this.onRatingChanged,
  });

  @override
  State<RatingGroup> createState() => _RatingGroupState();
}

class _RatingGroupState extends State<RatingGroup> {
  late int _rating;
  final List<String> _emojis = ['😞', '😐', '😊', '😁', '🤩'];

  @override
  void initState() {
    super.initState();
    _rating = widget.initialRating;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.label, style: const TextStyle(fontWeight: FontWeight.w500, color: AppColors.textGrey)),
        const SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(5, (index) {
            final starValue = index + 1;
            return GestureDetector(
              onTap: () {
                setState(() {
                  _rating = starValue;
                });
                widget.onRatingChanged(_rating);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.symmetric(horizontal: 2),
                curve: Curves.easeOut,
                child: Icon(
                  Icons.star,
                  color: starValue <= _rating ? AppColors.secondaryOrange : Colors.grey.shade300,
                  size: 35,
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: _emojis.asMap().entries.map((entry) {
            final index = entry.key;
            final emoji = entry.value;
            return AnimatedOpacity(
              duration: const Duration(milliseconds: 300),
              opacity: (index + 1) == _rating ? 1.0 : 0.4,
              child: Text(
                emoji,
                style: TextStyle(fontSize: (index + 1) == _rating ? 28 : 20),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isSecondary;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isSecondary = false,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        boxShadow: isSecondary
            ? null
            : [
                BoxShadow(
                  color: AppColors.primaryOrange.withAlpha(77), // Perbaikan: Menggunakan withOpacity
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(10),
          child: Ink(
            padding: const EdgeInsets.symmetric(vertical: 15),
            decoration: isSecondary
                ? BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.primaryOrange, width: 2),
                  )
                : BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    // Gradasi Warna
                    gradient: const LinearGradient(
                      colors: [AppColors.primaryOrange, AppColors.secondaryOrange],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                  ),
            child: Center(
              child: Text(
                text,
                style: TextStyle(
                  color: isSecondary ? AppColors.primaryOrange : Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class FormLabel extends StatelessWidget {
  final String text;
  const FormLabel(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, top: 10.0),
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textDark),
      ),
    );
  }
}