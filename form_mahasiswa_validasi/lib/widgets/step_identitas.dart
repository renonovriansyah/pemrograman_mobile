import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'fade_animation.dart';

class StepIdentitas extends StatelessWidget {
  final TextEditingController namaController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController tglLahirController;
  final FocusNode emailFocusNode;
  final FocusNode phoneFocusNode;
  final VoidCallback onTapTglLahir;

  const StepIdentitas({
    super.key,
    required this.namaController,
    required this.emailController,
    required this.phoneController,
    required this.tglLahirController,
    required this.emailFocusNode,
    required this.phoneFocusNode,
    required this.onTapTglLahir,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Input Nama Lengkap (DENGAN VALIDASI BARU)
        FadeAnimation(
          delay: 0,
          child: TextFormField(
            controller: namaController,
            decoration: const InputDecoration(
              labelText: 'Nama Lengkap',
              prefixIcon: Icon(Icons.person_outline),
              hintText: 'Sesuai KTM',
            ),
            textInputAction: TextInputAction.next,
            onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(emailFocusNode),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Nama wajib diisi';
              }
              // REGEX: Hanya huruf, spasi, titik, dan petik satu (')
              // ^ = awal, $ = akhir, + = satu karakter atau lebih
              if (!RegExp(r"^[a-zA-Z\s\.\']+$").hasMatch(value)) {
                return 'Nama tidak boleh mengandung angka atau simbol lain';
              }
              if (value.length < 3) {
                return 'Nama terlalu pendek (min 3 karakter)';
              }
              return null; // Valid
            },
          ),
        ),
        const SizedBox(height: 16),
        
        // Input Tanggal Lahir
        FadeAnimation(
          delay: 0.5,
          child: TextFormField(
            controller: tglLahirController,
            readOnly: true,
            onTap: onTapTglLahir,
            decoration: const InputDecoration(
              labelText: 'Tanggal Lahir',
              prefixIcon: Icon(Icons.calendar_today_outlined),
              hintText: 'Pilih Tanggal',
            ),
            validator: (value) => (value == null || value.isEmpty) ? 'Tanggal lahir wajib diisi' : null,
          ),
        ),
        const SizedBox(height: 16),

        // Input Email
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
        
        // Input HP
        FadeAnimation(
          delay: 1.5,
          child: TextFormField(
            controller: phoneController,
            focusNode: phoneFocusNode,
            decoration: const InputDecoration(
              labelText: 'Nomor HP',
              prefixIcon: Icon(Icons.phone_iphone),
            ),
            keyboardType: TextInputType.phone,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            validator: (value) => (value == null || value.length < 10) ? 'Nomor HP tidak valid (min 10 angka)' : null,
          ),
        ),
      ],
    );
  }
}