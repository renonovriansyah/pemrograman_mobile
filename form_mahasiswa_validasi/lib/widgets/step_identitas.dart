import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'fade_animation.dart'; // Import animasi

class StepIdentitas extends StatelessWidget {
  final TextEditingController namaController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final FocusNode emailFocusNode;
  final FocusNode phoneFocusNode;

  const StepIdentitas({
    super.key,
    required this.namaController,
    required this.emailController,
    required this.phoneController,
    required this.emailFocusNode,
    required this.phoneFocusNode,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Delay 0ms
        FadeAnimation(
          delay: 0,
          child: TextFormField(
            controller: namaController,
            decoration: const InputDecoration(
              labelText: 'Nama Lengkap',
              prefixIcon: Icon(Icons.person_outline),
            ),
            textInputAction: TextInputAction.next,
            onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(emailFocusNode),
            validator: (value) {
              if (value == null || value.isEmpty) return 'Nama wajib diisi';
              if (value.length < 3) return 'Nama terlalu pendek';
              return null;
            },
          ),
        ),
        const SizedBox(height: 16),
        
        // Delay 100ms (Muncul sedikit lebih lambat)
        FadeAnimation(
          delay: 1,
          child: TextFormField(
            controller: emailController,
            focusNode: emailFocusNode,
            decoration: const InputDecoration(
              labelText: 'Email Kampus',
              prefixIcon: Icon(Icons.email_outlined),
              hintText: 'nama@mahasiswa.ac.id',
            ),
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(phoneFocusNode),
            validator: (value) {
              if (value == null || value.isEmpty) return 'Email wajib diisi';
              if (!value.contains('@') || !value.contains('.')) return 'Format email salah';
              return null;
            },
          ),
        ),
        const SizedBox(height: 16),
        
        // Delay 200ms
        FadeAnimation(
          delay: 2,
          child: TextFormField(
            controller: phoneController,
            focusNode: phoneFocusNode,
            decoration: const InputDecoration(
              labelText: 'Nomor HP',
              prefixIcon: Icon(Icons.phone_iphone),
            ),
            keyboardType: TextInputType.phone,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            validator: (value) => (value == null || value.length < 10) ? 'Nomor HP tidak valid' : null,
          ),
        ),
      ],
    );
  }
}