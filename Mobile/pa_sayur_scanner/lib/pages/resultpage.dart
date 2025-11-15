import 'package:flutter/material.dart';
import 'dart:io';
import '../models/resultscan.dart';
import '../models/vegetable.dart';
import 'package:intl/intl.dart';
import '../tools/tools.dart';

// Define the primary green color used in the UI
const Color primaryGreen = Color(0xFF4CAF50);

class ResultPage extends StatefulWidget {
  final int initialIndex; // Indeks hasil scan saat ini
  final List<ResultScan> scanResults;
  final bool fromScanPage; // Menandai apakah berasal dari halaman scan
  final Widget? notificationSuccess; // Fungsi Widget notifikasi sukses

  const ResultPage({
    super.key,
    required this.initialIndex,
    required this.scanResults,
    required this.fromScanPage,
    this.notificationSuccess,
  });

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  Tools tools = Tools();
  late PageController _pageController;
  late int currentIndex;
  bool get fromScanPage => widget.fromScanPage;
  bool durationNotification = true;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: currentIndex);
  }

  // Fungsi untuk mendapatkan data sayur berdasarkan id
  Vegetable getVegetableById(int id) {
    if (id > 0 && id <= tools.listVegetable.length) {
      return tools.listVegetable[id - 1]; // Jika id valid maka kembalikan sayur sesuai id
    } else {
      return tools.listVegetable.first; // Jika id tidak valid, kembalikan sayur pertama sebagai default
    }
  }

  // Gambar sayur dengan Hero transition
  Widget heroImage(ResultScan resultScan) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Hero(
        tag: 'scan_${resultScan.key}',
        child: AspectRatio(
          aspectRatio: 1,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.file(File(resultScan.pathImage), fit: BoxFit.cover),
          ),
        ),
      ),
    );
  }

  // Deskripsi sayur (Layout pertama) berisi nama latin dan deskripsi
  Widget describeFirstLayoutImage(Vegetable vegetable, bool landscape) {
    return Padding(
      padding: landscape ? const EdgeInsets.all(20) : const EdgeInsets.all(0),
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
            textAlign: TextAlign.justify,
          ),
        ],
      ),
    );
  }

  // Deskripsi sayur (Layout kedua) berisi nutrisi, manfaat, harga, confidence, dan tanggal scan
  Widget describeSecondLayoutImage(
    ResultScan resultScan,
    Vegetable vegetable,
    bool landscape,
  ) {
    return Padding(
      padding: landscape
          ? const EdgeInsets.all(0)
          : const EdgeInsets.symmetric(horizontal: 20.0),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!landscape) describeFirstLayoutImage(vegetable, landscape), // Jika potret, tampilkan deskripsi pertama juga
          if (!landscape) const SizedBox(height: 20),

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

          ...vegetable.nutrisi.map( // Loop untuk setiap nutrisi
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

          ...vegetable.manfaat.map( // Loop untuk setiap manfaat
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

          const SizedBox(height: 20),

          // Confidence
          Text(
            'Confidence: ${resultScan.confidence}',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),

          const SizedBox(height: 20),

          // Date scan
          Text(
            'Date Scan: ${DateFormat('dd MMM yyyy, HH:mm').format(resultScan.scanDate)}', 
            style: const TextStyle(
              fontSize: 16,
              fontStyle: FontStyle.italic,
              color: Colors.grey,
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
  
  // Layout untuk orientasi landscape (Row dengan dua kolom)
  Widget portraitLayout(
    ResultScan resultScan,
    Vegetable vegetable,
    bool landscape,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        heroImage(resultScan),

        const SizedBox(height: 20),

        describeSecondLayoutImage(resultScan, vegetable, landscape),

        const SizedBox(height: 20),
      ],
    );
  }

  // Layout untuk orientasi potret (Full column)
  Widget landscapeLayout(
    ResultScan resultScan,
    Vegetable vegetable,
    bool landscape,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            children: [
              heroImage(resultScan),
              describeFirstLayoutImage(vegetable, landscape),
            ],
          ),
        ),

        Expanded(
          child: Container(
            margin: const EdgeInsets.only(left: 20),
            child: describeSecondLayoutImage(resultScan, vegetable, landscape),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final landscape =
        MediaQuery.of(context).orientation == Orientation.landscape; // Cek orientasi layar

    // Jika berasal dari halaman scan, sembunyikan notifikasi setelah 2 detik
    if (fromScanPage) {
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) { // Pastikan widget masih terpasang di widget tree
          setState(() {
            durationNotification = false;
          });
        }
      });
    }

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
              controller: _pageController,
              onPageChanged: (index) => setState(() => currentIndex = index), // Update indeks saat halaman berubah
              itemCount: widget.scanResults.length,
              itemBuilder: (context, index) {
                final resultScan = widget.scanResults[index]; // Dapatkan hasil scan saat ini
                final vegetable = getVegetableById(resultScan.vegetableId); // Ambil data sayur berdasarkan id sayur dari hasil scan

                return SingleChildScrollView(
                  child: landscape
                      ? landscapeLayout(resultScan, vegetable, landscape)
                      : portraitLayout(resultScan, vegetable, landscape),
                );
              },
            ),
          ),

          if (fromScanPage && durationNotification) // Jika berasal dari halaman scan dan durasi notifikasi masih aktif
            widget.notificationSuccess ?? Container(), // Tampilkan notifikasi sukses

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
                        getVegetableById(
                          widget.scanResults[currentIndex].vegetableId,
                        ).nama,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white ,
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
