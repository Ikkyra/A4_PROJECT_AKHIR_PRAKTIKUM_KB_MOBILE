import 'package:flutter/material.dart';

// Define your primary green color
const Color primaryGreen = Color(0xFF4CAF50);

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: primaryGreen,
        title: const Text(
          'About Us',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // App logo or header illustration
            Center(
              child: Column(
                children: [
                  Image.asset(
                    'assets/images/Logo.png',
                    width: 150,
                    height: 150,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Vegetable Scanner',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: primaryGreen,
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    '“Identify, Learn, and Eat Better.”',
                    style: TextStyle(
                      fontSize: 16,
                      fontStyle: FontStyle.italic,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            const Text(
              'What is Vegetable Scanner?',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: primaryGreen,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Vegetable Scanner adalah aplikasi seluler cerdas yang dirancang untuk mengidentifikasi berbagai jenis sayuran secara instan menggunakan kamera perangkat Anda.'
              'Cukup ambil foto, dan sistem pengenalan berbasis AI kami akan menganalisis dan menampilkan detail seperti nama sayuran, nama ilmiah, kandungan gizi, manfaat, dan perkiraan harga pasar.',
              style: TextStyle(fontSize: 16, height: 1.6),
              textAlign: TextAlign.justify,
            ),

            const SizedBox(height: 25),

            const Text(
              'Main Features:',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: primaryGreen,
              ),
            ),
            const SizedBox(height: 10),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('• Mengenali Sayuran Melalui Camera Atau Upload Foto', style: TextStyle(fontSize: 16, height: 1.6)),
                Text('• Informasi Lengkap Termasuk Nutrisi, Manfaat, dan Harga', style: TextStyle(fontSize: 16, height: 1.6)),
                Text('• Simpan riwayat pemindaian Anda untuk referensi di kemudian hari', style: TextStyle(fontSize: 16, height: 1.6)),
                Text('• Jelajahi sayuran secara manual melalui katalog kami', style: TextStyle(fontSize: 16, height: 1.6)),
              ],
            ),

            const SizedBox(height: 25),

            const Text(
              'Our Mission:',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: primaryGreen,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Kami bertujuan untuk mendorong kebiasaan makan yang lebih sehat dan meningkatkan kesadaran akan nilai gizi dari sayuran sehari-hari melalui teknologi pengenalan gambar modern. '
              'Dengan Vegetable Scanner, kami membawa informasi dan edukasi langsung ke ujung jari Anda — cepat, akurat, dan mudah diakses.',
              style: TextStyle(fontSize: 16, height: 1.6),
              textAlign: TextAlign.justify,
            ),

            const SizedBox(height: 25),

            const Text(
              'Developed By:',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: primaryGreen,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Aldi Daffa Arisyi - 2309106017\nRifki Abiyan - 2309106030\nAndhika Gagahrani Ektya - 2309106034\nRava Mahdi Mahdaveka - 2309106036\n',
              style: TextStyle(fontSize: 16, height: 1.6),
              textAlign: TextAlign.justify,
            ),

            const SizedBox(height: 40),

            Center(
              child: Column(
                children: const [
                  Divider(thickness: 1.2), // Membuat garis pemisah dengan ketebalan 1.2
                  SizedBox(height: 10),
                  Text(
                    'Version 1.0.0',
                    style: TextStyle(color: Colors.grey),
                  ),
                  Text(
                    '© 2025 Vegetable Scanner Team',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
