import 'package:flutter/material.dart';
import 'package:vegetable_scanner/pages/resultpage.dart';
import 'scanpage.dart';
import '../tools/tools.dart';
import 'historypage.dart';
import 'detailpage.dart';
import 'aboutpage.dart';
import '../tools/vegetableclassifier.dart';
import 'dart:io';
import '../models/vegetable.dart';
import '../models/resultscan.dart';
import 'package:hive_flutter/hive_flutter.dart';

// Define the primary green color used in the UI
const Color primaryGreen = Color(0xFF4CAF50);

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  Tools tools = Tools();
  final Widget historyPageWidget = const HistoryPage();
  VegetableClassifier classifier = VegetableClassifier();
  Box<ResultScan> box = Hive.box<ResultScan>('result_scans'); // Membuka box Hive untuk ResultScan
  int currentPageIndex = 0; // 0: Home, 1: History

  Vegetable? latestScanVegetable; // Menyimpan sayuran hasil scan terbaru 
  String? latestScanImagePath; // Menyimpan path gambar hasil scan terbaru

  @override
  void initState() {
    super.initState();
    classifier
        .loadModel() // Memuat model TensorFlow Lite
        .then((_) { // Jika berhasil
          print("DEBUG: Model dan label json berhasil dimuat");
        })
        .catchError((e) { // Jika gagal/error
          print("ERROR memuat model: $e");
        });
  }

  // Bottom Navigation Bar
  Widget bottomNavigationBarWidget(bool landscape) {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(), // Membuat lekukan untuk FAB
      height: landscape ? 65 : 70,
      notchMargin: 8.0, // Jarak antara FAB dan BottomAppBar
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Expanded( // Menggunakan Expanded untuk mendistribusikan ruang secara merata
            child: InkWell( // Menambahkan efek sentuhan
              onTap: () => setState(() => currentPageIndex = 0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center, 
                children: [
                  Icon(
                    Icons.home,
                    color: currentPageIndex == 0
                        ? primaryGreen
                        : Colors.grey[600],
                  ),
                  Text(
                    'Home',
                    style: TextStyle(
                      color: currentPageIndex == 0
                          ? primaryGreen
                          : Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Expanded(child: SizedBox()),
          Expanded(
            child: InkWell(
              onTap: () => setState(() => currentPageIndex = 1),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.history_outlined,
                    color: currentPageIndex == 1
                        ? primaryGreen
                        : Colors.grey[600],
                  ),
                  Text(
                    'History',
                    style: TextStyle(
                      color: currentPageIndex == 1
                          ? primaryGreen
                          : Colors.grey[600],
                      fontSize: 12,
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

  // Vegetable Grid Display
  Widget vegetableGrid() {
    return Container(
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
      child: GridView.builder(
        shrinkWrap: true, // Agar GridView menyesuaikan ukurannya dengan kontennya
        physics: const NeverScrollableScrollPhysics(), // Nonaktifkan scroll pada GridView
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount( // Menentukan tata letak grid
          crossAxisCount: 3, // Jumlah kolom 3
          crossAxisSpacing: 5, // Jarak antar kolom 5 piksel
          mainAxisSpacing: 5, // Jarak antar baris 5 piksel
          childAspectRatio: 1, // Rasio aspek 1:1 (persegi)
        ),
        itemCount: tools.listVegetable.length,
        itemBuilder: (context, index) {
          final vegetableIndex = tools.listVegetable[index]; // Mendapatkan data sayuran berdasarkan indeks
          return GestureDetector( // Menambahkan gesture detector untuk mendeteksi ketukan
            onTap: () {
              Navigator.push(
                context,
                PageRouteBuilder( // Menggunakan PageRouteBuilder untuk transisi kustom
                  transitionDuration: const Duration(milliseconds: 400), // Durasi transisi 400 milidetik
                  pageBuilder: (_, animation, secondaryAnimation) =>
                      FadeTransition( // Efek fade transition
                        opacity: animation,
                        child: DetailPage( // Navigasi ke halaman detail
                          initialIndex: index,
                          vegetables: tools.listVegetable,
                        ),
                      ),
                ),
              );
            },
            child: Hero( // Menambahkan efek hero animation
              tag: 'vegetable_${vegetableIndex.id}', // Tag unik untuk setiap sayuran
              child: ClipRRect( // Membulatkan sudut gambar
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(vegetableIndex.pathImage, fit: BoxFit.cover),
              ),
            ),
          );
        },
      ),
    );
  }

  // App Bar Widget
  Widget appBarWidget(bool landscape) {
    return SliverAppBar(
      pinned: false, // Tetap terlihat saat di-scroll
      floating: true, // Muncul kembali saat di-scroll ke atas
      expandedHeight: 150.0, // Tinggi saat diperluas
      automaticallyImplyLeading: false, // Tidak menampilkan tombol kembali otomatis
      backgroundColor: primaryGreen,
      actions: [
        IconButton(
          icon: const Icon(Icons.info_outline, color: Colors.white),
          tooltip: 'About Us',
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AboutPage()), // Navigasi ke halaman About
            );
          },
        ),
      ],
      flexibleSpace: FlexibleSpaceBar( // Ruang fleksibel untuk app bar
        titlePadding: EdgeInsets.zero, // Menghilangkan padding default
        centerTitle: true,
        title: Padding(
          padding: EdgeInsets.only(bottom: landscape ? 10 : 15), // Sesuaikan padding bawah berdasarkan orientasi agar tidak overflowed
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/images/Logo.png',
                height: landscape ? 47.9 : 50,
                width: landscape ? 47.9 : 50,
              ),
              SizedBox(height: landscape ? 6 : 8),
              Text(
                'VeggieSnap',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: landscape ? 18.8 : 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Top Box Container (Kotak yang menjadi body dari grid)
  Widget topBoxContainer() {
    return SliverToBoxAdapter(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30), // Membulatkan sudut atas kiri
            topRight: Radius.circular(30), // Membulatkan sudut atas kanan
          ),
        ),
        child: vegetableGrid(),
      ),
    );
  }

  // Notification Scan Success
  Widget notificationScanSuccess(
    Vegetable? latestScanImagePath,
    String? imagePath,
    bool landscape,
  ) {
    return Align(
      alignment: Alignment.bottomCenter, // posisi di bagian bawah tengah
      child: Padding(
        padding: EdgeInsets.only(bottom: landscape ? 20.0 : 90.0), // sesuaikan padding bawah berdasarkan orientasi
        child: AnimatedOpacity(
          opacity: 1.0,
          duration: const Duration(milliseconds: 300),
          child: Container(
            height: landscape ? MediaQuery.of(context).size.height * 0.5 : 400, // 50% dari tinggi layar atau 400 piksel
            width: landscape ? 400 : MediaQuery.of(context).size.width * 0.9, // 90% dari lebar layar atau 400 piksel
            decoration: const BoxDecoration(
              color: primaryGreen,
              borderRadius: BorderRadius.all(Radius.circular(20)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10, // tingkat blur bayangan
                  offset: Offset(0, 5), // posisi bayangan di bawah container
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min, // agar kolom hanya sebesar isinya
                children: [
                  Text(
                    'It may be ${latestScanVegetable!.nama}!', // Menampilkan nama sayuran yang diidentifikasi
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Container(
                    width: landscape ? 100 : 250,
                    height: landscape ? 100 : 250,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle, // Membuat bentuk lingkaran   
                      border: Border.all(color: Colors.white, width: 2), // Membuat border putih di sekitar gambar
                    ),
                    child: ClipOval( // Membuat gambar berbentuk lingkaran
                      child: Image.file(File(imagePath!), fit: BoxFit.cover), // Menampilkan gambar hasil scan
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Access orientation directly within the function
    final landscape =
        MediaQuery.of(context).orientation == Orientation.landscape; // Cek orientasi layar
    Widget homeContent = CustomScrollView(
      slivers: <Widget>[appBarWidget(landscape), topBoxContainer()], // Memanggil app bar dan konten utama
    );

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ScanPage()), // Navigasi ke halaman scan
          );

          if (result != null && result is Map) { // Pastikan result bukan null dan bertipe Map
            setState(() {
              latestScanVegetable = result['matchedVegetable'] as Vegetable; // Mengambil sayuran hasil scan terbaru
              latestScanImagePath = result['imagePath'] as String; // Mengambil path gambar hasil scan terbaru

              if (currentPageIndex == 0) { // Jika halaman saat ini adalah halaman utama
                currentPageIndex = 1; // Beralih ke halaman hasil scan
              }

              List<ResultScan> scanResults = box.values.toList(); // Mengambil semua hasil scan dari Hive box dalam bentuk list
              List<ResultScan> sortedResults = scanResults.reversed.toList(); // Membalik urutan hasil scan untuk menampilkan yang terbaru terlebih dahulu

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ResultPage(
                    scanResults: sortedResults,
                    initialIndex: 0, // Menampilkan hasil scan terbaru terlebih dahulu
                    fromScanPage: true, // Menandai bahwa navigasi berasal dari halaman scan
                    notificationSuccess: notificationScanSuccess(latestScanVegetable, latestScanImagePath, landscape),
                  ),
                ),
              );
            });
          }
        },
        backgroundColor: primaryGreen,
        elevation: 2.0,
        shape: const CircleBorder(), // Membuat FAB berbentuk lingkaran
        child: const Icon(
          SquareScan.square_scan,
          color: Colors.white,
          size: 30,
        ),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked, // Menempatkan FAB di tengah bawah dengan lekukan
      bottomNavigationBar: bottomNavigationBarWidget(landscape), // Memanggil widget Bottom Navigation Bar

      body: SizedBox.expand( // Membuat widget memenuhi seluruh area layar
        child: Stack(
          fit: StackFit.expand, // Memperluas stack untuk mengisi seluruh ruang yang tersedia
          children: [
            Container(color: primaryGreen), // Latar belakang hijau
            <Widget>[homeContent, historyPageWidget][currentPageIndex], // Menampilkan halaman berdasarkan indeks halaman saat ini
          ],
        ),
      ),
    );
  }
}
