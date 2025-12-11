import 'package:flutter/material.dart';
import 'fade_animation.dart'; // Jangan lupa import ini

class StepAkademik extends StatelessWidget {
  final String? selectedJurusan;
  final List<String> jurusanList;
  final double semester;
  final ValueChanged<String?> onJurusanChanged;
  final ValueChanged<double> onSemesterChanged;

  const StepAkademik({
    super.key,
    required this.selectedJurusan,
    required this.jurusanList,
    required this.semester,
    required this.onJurusanChanged,
    required this.onSemesterChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Animasi Dropdown
        FadeAnimation(
          delay: 0,
          child: DropdownButtonFormField<String>(
            decoration: const InputDecoration(
              labelText: 'Pilih Jurusan',
              prefixIcon: Icon(Icons.school_outlined),
              helperText: 'Pilih jurusan sesuai KTM',
            ),
            initialValue: selectedJurusan,
            items: jurusanList.map((jurusan) {
              return DropdownMenuItem(
                value: jurusan,
                child: Text(jurusan),
              );
            }).toList(),
            onChanged: onJurusanChanged,
            validator: (value) => value == null ? 'Jurusan wajib dipilih' : null,
          ),
        ),
        const SizedBox(height: 30),

        // Animasi Slider
        FadeAnimation(
          delay: 1,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Tingkat Semester',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.indigo.shade50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Semester ${semester.toInt()}',
                        style: const TextStyle(
                          color: Colors.indigo,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: Colors.indigo,
                    inactiveTrackColor: Colors.indigo.shade100,
                    thumbColor: Colors.pinkAccent,
                    overlayColor: Colors.pinkAccent.withAlpha(4),
                    trackHeight: 6.0,
                    thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10.0),
                  ),
                  child: Slider(
                    value: semester,
                    min: 1,
                    max: 8,
                    divisions: 7,
                    label: 'Sem ${semester.toInt()}',
                    onChanged: onSemesterChanged,
                  ),
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('1', style: TextStyle(color: Colors.grey, fontSize: 12)),
                    Text('8', style: TextStyle(color: Colors.grey, fontSize: 12)),
                  ],
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}