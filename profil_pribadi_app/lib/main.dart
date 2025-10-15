// Impor package dasar Flutter dan package yang dibutuhkan
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

// --- Tautan/URL untuk aplikasi ---
final Uri _waUrl = Uri.parse("https://wa.me/6282289669969?text=Hello");
final Uri _emailUrl = Uri.parse("mailto:renonovriansyah9@gmail.com");
final Uri _instagramUrl = Uri.parse("https://instagram.com/renonvrnsyh11");
final Uri _project1Url = Uri.parse("https://renonovriansyah.github.io/skinkeran");
final Uri _project2Url = Uri.parse("https://renonovriansyah.github.io/tabeltugas");
final Uri _project3Url = Uri.parse("https://renonovriansyah.github.io/eduplay");
final Uri _project4Url = Uri.parse("https://renonovriansyah.github.io/jadwalkuliah");

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'M. Reno Novriansyah Portfolio',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color(0xFF38BDF8),
        fontFamily: 'Inter',
      ),
      // --- PERUBAHAN DI SINI ---
      // Mengarahkan ke SplashScreen sebagai halaman pertama
      home: const SplashScreen(),
    );
  }
}

// --- GANTI KODE SPLASHSCREEN LAMA DENGAN YANG INI ---
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const colorizeTextStyle = TextStyle(
      fontSize: 32.0,
      fontWeight: FontWeight.bold,
    );

    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF020617), // Awal (Biru Gelap)
              Color(0xFF111827), // Akhir (Abu-abu Gelap)
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // EFEK BINGKAI FOTO "BERNAPAS"
            TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0.0, end: 6.0),
              duration: const Duration(seconds: 2),
              builder: (context, value, child) {
                return Container(
                  padding: EdgeInsets.all(value), // Padding yg membesar-kecil
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.transparent,
                    border: Border.all(
                      color: const Color(0xFF38BDF8).withAlpha(128),
                      width: 1.5,
                    ),
                  ),
                  child: child,
                );
              },
              child: const CircleAvatar(
                radius: 80,
                backgroundImage: AssetImage('assets/images/profile.png'),
              ),
            ).animate(onComplete: (controller) => controller.repeat())
                .shimmer(delay: 2.seconds, duration: 1.8.seconds, color: const Color(0x8038BDF8)),

            const SizedBox(height: 30),

            // EFEK TEKS MENGETIK UNTUK NAMA
            AnimatedTextKit(
              animatedTexts: [
                TypewriterAnimatedText(
                  'M. Reno Novriansyah',
                  textStyle: colorizeTextStyle,
                  speed: const Duration(milliseconds: 100),
                  cursor: '_',
                ),
              ],
              totalRepeatCount: 1,
            ),

            const SizedBox(height: 12),

            // EFEK TEKS MENGETIK UNTUK TAGLINE
            AnimatedTextKit(
              animatedTexts: [
                TypewriterAnimatedText(
                  'Information Systems Student | Web Developer | Photographer',
                  textAlign: TextAlign.center,
                  textStyle: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF94A3B8),
                  ),
                  speed: const Duration(milliseconds: 50),
                  cursor: '',
                ),
              ],
              totalRepeatCount: 1,
              pause: const Duration(milliseconds: 1000),
            ),

            const SizedBox(height: 48),

            // Tombol muncul setelah animasi teks selesai
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF38BDF8),
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
              ),
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const PortfolioPage(),
                  ),
                );
              },
              icon: const Icon(
                Icons.arrow_forward,
                color: Color(0xFF020617),
              ),
              label: const Text(
                'Visit Profile',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF020617),
                  fontSize: 16,
                ),
              ),
            ).animate().fadeIn(delay: 6.seconds, duration: 1.seconds),
          ],
        ),
      ),
    );
  }
}

// --- Kode PortfolioPage dan widget lainnya tetap sama ---
class PortfolioPage extends StatefulWidget {
  const PortfolioPage({super.key});

  @override
  State<PortfolioPage> createState() => _PortfolioPageState();
}

class _PortfolioPageState extends State<PortfolioPage> {
  // Fungsi untuk meluncurkan URL
  Future<void> _launchUrl(Uri url) async {
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Kita gunakan Stack untuk menumpuk gradien di belakang konten
      body: Stack(
        children: [
          // Latar belakang Gradien
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF020617), // Awal (Biru Gelap)
                  Color(0xFF111827), // Akhir (Abu-abu Gelap)
                ],
              ),
            ),
          ),
          // Konten yang bisa di-scroll
          ListView(
            children: [
              _buildHeroSection(),
              _buildSectionTitle('My Skills'),
              _buildSkillsSection(),
              _buildSectionTitle('Featured Projects'),
              _buildPortfolioSection(),
              _buildContactSection(),
              _buildFooter(),
            ]
                // Tambahkan animasi pada seluruh list
                .animate(interval: 100.ms)
                .fadeIn(duration: 600.ms, delay: 200.ms)
                .slide(begin: const Offset(0, 0.1), curve: Curves.easeOut),
          ),
        ],
      ),
    );
  }

  // Widget untuk bagian perkenalan
  Widget _buildHeroSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: Column(
        children: [
          const CircleAvatar(
            radius: 60,
            backgroundImage: AssetImage('assets/images/profile.png'),
          ),
          const SizedBox(height: 24),
          const Text(
            'M. Reno Novriansyah',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white),
          ),
          const SizedBox(height: 8),
          const Text(
            'Information Systems Student | Web Developer | Photographer',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF38BDF8),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            "An Information Systems student passionate about the intersection of technology and art. I tell stories through visually-driven websites, mobile development with Flutter, and freelance photography.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              color: Color(0xFF94A3B8),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  // Widget untuk judul setiap section
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 40, 24, 16),
      child: Text(
        title,
        style: const TextStyle(
            fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
      ),
    );
  }

  // Widget untuk bagian skill
  Widget _buildSkillsSection() {
    final skills = <String>[
      'Web Development',
      'Photography',
      'Flutter',
      'HTML & CSS',
      'JavaScript',
      'UI/UX Design',
    ];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Wrap(
          spacing: 12,
          runSpacing: 12,
          alignment: WrapAlignment.center,
          children: skills
              .map((skill) {
                return Chip(
                  label: Text(skill),
                  labelStyle: const TextStyle(
                      color: Color(0xFFE2E8F0), fontWeight: FontWeight.w600),
                  backgroundColor: const Color(0xFF1E293B),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  side: BorderSide.none,
                );
              })
              .toList()
              .animate(interval: 80.ms)
              .fadeIn(duration: 500.ms)
              .slideY(begin: 0.5, curve: Curves.easeOut)),
    );
  }

  // Widget untuk bagian portfolio
  Widget _buildPortfolioSection() {
    return SizedBox(
      height: 280,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        children: [
          _buildProjectCard(
            imagePath: 'assets/images/project1.png',
            title: 'SKIN / DIARY - Skincare Routine Reminder',
            description:
                'A web app that helps users build and track their skincare routines with smart reminders.',
            onViewDemo: () => _launchUrl(_project1Url),
          ),
          _buildProjectCard(
            imagePath: 'assets/images/project2.png',
            title: 'TableWork - Task Management Dashboard',
            description:
                'A task management dashboard designed for productivity, allowing users to efficiently organize their work.',
            onViewDemo: () => _launchUrl(_project2Url),
          ),
          _buildProjectCard(
            imagePath: 'assets/images/project3.png',
            title: 'EduPlay - Math Puzzle Game',
            description:
                'An interactive math puzzle game for kids that makes learning algebra an engaging experience.',
            onViewDemo: () => _launchUrl(_project3Url),
          ),
          _buildProjectCard(
            imagePath: 'assets/images/project4.png',
            title: 'TimeBlock Pro - Personal Academy Schedule',
            description:
                'Optimize your semester! This app provides a consolidated view of your class schedule, ensuring you never miss a lecture. Includes one-click access to all relevant course WhatsApp chats.',
            onViewDemo: () => _launchUrl(_project4Url),
          ),
        ]
            .animate(interval: 200.ms)
            .fadeIn(duration: 600.ms)
            .slideX(begin: 0.2, curve: Curves.easeOut),
      ),
    );
  }

  // Widget untuk satu kartu proyek
  Widget _buildProjectCard({
    required String imagePath,
    required String title,
    required String description,
    required VoidCallback onViewDemo,
  }) {
    return Container(
      width: 280,
      margin: const EdgeInsets.only(right: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        image: DecorationImage(
          image: AssetImage(imagePath),
          fit: BoxFit.cover,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onViewDemo,
        child: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black87],
                ),
              ),
            ),
            Positioned(
              bottom: 16,
              left: 16,
              right: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 14, color: Colors.white70),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget untuk bagian kontak
  Widget _buildContactSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40.0),
      child: Column(
        children: [
          const Text(
            "Interested in collaborating?",
            style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white),
          ),
          const SizedBox(height: 8),
          const Text(
            "Feel free to reach out to me.",
            style: TextStyle(fontSize: 16, color: Color(0xFF94A3B8)),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF38BDF8),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
            ),
            onPressed: () => _launchUrl(_emailUrl),
            child: const Text(
              'Send an Email',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF020617),
                  fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  // Widget untuk bagian footer
  Widget _buildFooter() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                // Menggunakan ikon WhatsApp dari Font Awesome
                icon: const FaIcon(FontAwesomeIcons.whatsapp),
                onPressed: () => _launchUrl(_waUrl),
                tooltip: 'WhatsApp',
                color: const Color(0xFF94A3B8),
              ),
              const SizedBox(width: 16),
              IconButton(
                // Menggunakan ikon Instagram dari Font Awesome
                icon: const FaIcon(FontAwesomeIcons.instagram),
                onPressed: () => _launchUrl(_instagramUrl),
                tooltip: 'Instagram',
                color: const Color(0xFF94A3B8),
              ),
              const SizedBox(width: 16),
              IconButton(
                // Menggunakan ikon Email dari Font Awesome
                icon: const FaIcon(FontAwesomeIcons.solidEnvelope),
                onPressed: () => _launchUrl(_emailUrl),
                tooltip: 'Email',
                color: const Color(0xFF94A3B8),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            '© ${DateTime.now().year} M. Reno Novriansyah. All Rights Reserved.',
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}