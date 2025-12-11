import 'package:flutter/material.dart';
import 'fade_animation.dart'; // Import animasi

class StepMinat extends StatelessWidget {
  final Map<String, bool> hobbies;
  final bool agreement;
  final Function(String, bool) onHobiChanged;
  final ValueChanged<bool> onAgreementChanged;
  final bool showAgreementError;

  const StepMinat({
    super.key,
    required this.hobbies,
    required this.agreement,
    required this.onHobiChanged,
    required this.onAgreementChanged,
    this.showAgreementError = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FadeAnimation(
          delay: 0,
          child: const Text(
            'Pilih Hobi & Minat',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 10),

        // Group Checkbox dalam Card
        FadeAnimation(
          delay: 0.5,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              children: [
                ...hobbies.keys.map((String key) {
                  return Column(
                    children: [
                      CheckboxListTile(
                        title: Text(key),
                        value: hobbies[key],
                        activeColor: Colors.indigo,
                        checkboxShape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        onChanged: (bool? val) {
                          if (val != null) onHobiChanged(key, val);
                        },
                      ),
                      // Divider tipis antar item, kecuali item terakhir
                      if (key != hobbies.keys.last)
                        Divider(height: 0, color: Colors.grey.shade100, indent: 16, endIndent: 16),
                    ],
                  );
                }),
              ],
            ),
          ),
        ),
        
        const SizedBox(height: 24),
        
        // Switch Persetujuan
        FadeAnimation(
          delay: 1,
          child: Container(
            decoration: BoxDecoration(
              color: showAgreementError ? Colors.red.shade50 : Colors.indigo.shade50,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: showAgreementError ? Colors.red.shade200 : Colors.indigo.shade100,
              ),
            ),
            child: SwitchListTile(
              title: const Text(
                'Saya setuju dengan syarat & ketentuan',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                'Data yang saya isi adalah benar dan dapat dipertanggungjawabkan.',
                style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
              ),
              value: agreement,
              activeThumbColor: Colors.green,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              onChanged: onAgreementChanged,
            ),
          ),
        ),
        
        // Pesan Error Visual
        if (showAgreementError)
          FadeAnimation(
            delay: 1.2,
            child: Padding(
              padding: const EdgeInsets.only(left: 16, top: 8),
              child: Row(
                children: [
                  const Icon(Icons.error_outline, size: 16, color: Colors.red),
                  const SizedBox(width: 8),
                  Text(
                    'Anda wajib menyetujui persyaratan ini.',
                    style: TextStyle(color: Colors.red.shade700, fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}