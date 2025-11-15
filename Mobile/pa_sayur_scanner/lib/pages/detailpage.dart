import 'package:flutter/material.dart';
import '../models/vegetable.dart';

// Define the primary green color used in the UI
const Color primaryGreen = Color(0xFF4CAF50);

class DetailPage extends StatefulWidget {
  final int initialIndex;
  final List<Vegetable> vegetables;

  const DetailPage({
    super.key,
    required this.initialIndex,
    required this.vegetables,
  });

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late final PageController _pageController; // Controller untuk PageView
  late int currentIndex; // Indeks halaman saat ini

  @override
  void initState() { // Inisialisasi state
    super.initState();
    currentIndex = widget.initialIndex; // Set indeks awal dari widget
    _pageController = PageController(initialPage: currentIndex); // Inisialisasi PageController dengan halaman awal
  }

  @override
  void dispose() { // Hapus controller saat widget dihapus
    super.dispose();
    _pageController.dispose(); // Dispose PageController untuk membebaskan sumber daya
  }

  // Gambar sayur dengan Hero transition
  Widget heroImage(Vegetable vegetable) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Hero(
        tag: 'vegetable_${vegetable.id}',
        child: ClipRRect( // Membulatkan sudut gambar
          borderRadius: BorderRadius.circular(16),
          child: Image.asset(
            vegetable.pathImage,
            fit: BoxFit.cover,
            width: double.infinity,
            height: 300,
          ),
        ),
      ),
    );
  }

  // Deskripsi sayur (Layout pertama) berisi nama latin dan deskripsi
  Widget describeFirstLayoutImage(Vegetable vegetable, bool landscape) {
    return Padding(
      padding: landscape ? const EdgeInsets.all(20) : const EdgeInsets.all(0), // Jika landscape beri padding
      child: Column(
        children: [
          // Scientific Name
          Center(
            child: Text(
              '(${vegetable.namaLatin})',
              style: const TextStyle(
                fontSize: 22,
                fontStyle: FontStyle.italic,
                color: Colors.black54,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          const SizedBox(height: 20),

          // Description Section
          Text(
            vegetable.deskripsi,
            style: TextStyle(fontSize: 18, color: Colors.black),
            textAlign: TextAlign.justify, // Agar teks rata kiri-kanan
          ),
        ],
      ),
    );
  }

  // Deskripsi sayur (Layout kedua) berisi nutrisi, manfaat, dan harga
  Widget describeSecondLayoutImage(Vegetable vegetable, bool landscape) {
    return Padding(
      padding: landscape
          ? const EdgeInsets.all(0)
          : const EdgeInsets.symmetric(horizontal: 20.0),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // Rata kiri
        children: [
          if (!landscape) describeFirstLayoutImage(vegetable, landscape), // Jika potret, tampilkan deskripsi pertama
          if (!landscape) const SizedBox(height: 20), // Jika potret, beri jarak setelah deskripsi pertama
          
          // --- Nutrisi Section ---
          const Text(
            'Nutrisions:',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: primaryGreen,
            ),
          ),

          const SizedBox(height: 8),

          ...vegetable.nutrisi.map( // Loop melalui daftar nutrisi
            (nutrisi) => Padding(
              padding: const EdgeInsets.only(left: 10, bottom: 4),
              child: Text(
                '• $nutrisi',
                style: const TextStyle(fontSize: 18, height: 1.5),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // --- Manfaat Section (Benefits) ---
          const Text(
            'Benefits:',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: primaryGreen,
            ),
          ),

          const SizedBox(height: 8),

          ...vegetable.manfaat.map( // Loop melalui daftar manfaat
            (manfaat) => Padding(
              padding: const EdgeInsets.only(left: 10, bottom: 4),
              child: Text(
                '• $manfaat',
                style: const TextStyle(fontSize: 18, height: 1.5),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // --- Harga Section ---
          Text(
            'Harga: ${vegetable.harga}',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.orange,
            ),
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  // Layout untuk orientasi landscape (Row dengan dua kolom)
  Widget landscapeLayout(Vegetable vegetable, bool landscape) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            children: [
              heroImage(vegetable),
              describeFirstLayoutImage(vegetable, landscape),
            ],
          ),
        ),

        Expanded(
          child: Container(
            margin: const EdgeInsets.only(left: 20),
            child: describeSecondLayoutImage(vegetable, landscape),
          ),
        ),
      ],
    );
  }

  // Layout untuk orientasi potret (Full column)
  Widget portraitLayout(Vegetable vegetable, bool landscape) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        heroImage(vegetable),

        const SizedBox(height: 20),

        describeSecondLayoutImage(vegetable, landscape),

        const SizedBox(height: 20),
      ],
    );
  }

  // Combines image and description based on orientation
  Widget buildDetailPageContent(Vegetable vegetable) {
    // Access orientation directly within the function
    final landscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        landscape
            ? landscapeLayout(vegetable, landscape)
            : portraitLayout(vegetable, landscape),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize( // Untuk menambahkan warna latar pada bagian yang di atas AppBar
        preferredSize: const Size.fromHeight(0),
        child: AppBar(backgroundColor: primaryGreen),
      ),
      body: Stack(
        clipBehavior: Clip.none,
        children: [
          // Bagian Body PageView
          Padding(
            padding: const EdgeInsets.only(top: 86.0),
            child: PageView.builder(
              controller: _pageController, // Gunakan controller yang sudah dibuat
              onPageChanged: (index) => setState(() => currentIndex = index),
              itemCount: widget.vegetables.length,
              itemBuilder: (context, index) {
                final currentVegetable = widget.vegetables[index]; // Sayur saat ini

                return SingleChildScrollView(
                  // Call without passing the landscape parameter
                  child: buildDetailPageContent(currentVegetable),
                );
              },
            ),
          ),

          // Bagian AppBar Kustom dengan Tombol Kembali
          SafeArea(
            left: false, // nonaktifkan padding kiri
            right: false, // nonaktifkan padding kanan
            child: Container(
              height: 86, // Sama dengan padding top pada PageView
              width: double.infinity,
              decoration: BoxDecoration(color: primaryGreen),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Tombol Kembali
                      Align(
                        alignment: Alignment.topLeft,
                        child: Container(
                          margin: const EdgeInsets.only(top: 10, left: 10),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            icon: const Icon(
                              Icons.arrow_back_ios_new_rounded,
                              color: Colors.white,
                            ),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ),
                      ),

                      Text(
                        widget.vegetables[currentIndex].nama,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),

                      SizedBox(width: 60), // Disesuaikan agar Nama sayur berada di tengah
                    ],
                  ),

                  SizedBox(height: 10),

                  // Bagian lengkungan putih di bawah AppBar
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40),
                          topRight: Radius.circular(40),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
