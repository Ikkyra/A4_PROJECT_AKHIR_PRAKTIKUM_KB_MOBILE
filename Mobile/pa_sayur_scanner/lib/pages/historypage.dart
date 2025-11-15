import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/resultscan.dart';
import 'dart:io';
import 'resultpage.dart';

// Define the primary green color used in the UI
const Color primaryGreen = Color(0xFF4CAF50);

// Convert HistoryPage to a StatefulWidget
class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  // State for selection mode
  bool isSelecting = false;
  // Set to store keys of selected items
  final Set<dynamic> selectedKeys = {};

  // --- Deletion Logic ---
  void showDeleteDialog( 
    BuildContext context,
    Box<ResultScan> box,
    List<dynamic> keysToDelete,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete ${keysToDelete.length} scan result(s)?'),
          content: Text(
            'Are you sure you want to delete ${keysToDelete.length} selected item(s)?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), // Cancel
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                for (var key in keysToDelete) { // Hapus setiap item yang dipilih
                  final result = box.get(key); // Dapatkan entri dari Hive
                  if (result != null) { // Jika entri ada
                    final file = File(result.pathImage); // Dapatkan file gambar
                    if (await file.exists()) { // Cek apakah file gambar ada
                      await file.delete(); // Hapus file gambar dari perangkat
                    }
                    await box.delete(key); // Delete from Hive
                  }
                }

                // Reset selection state
                setState(() {
                  isSelecting = false; // Keluar dari mode seleksi
                  selectedKeys.clear(); // Bersihkan set seleksi
                });
                Navigator.pop(context); // Close dialog
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  // Toggle selection state
  void toggleSelection(dynamic key) {
    setState(() {
      if (selectedKeys.contains(key)) { // Jika sudah terpilih, hapus dari set
        selectedKeys.remove(key);
      } else {
        selectedKeys.add(key); // Jika belum terpilih, tambahkan ke set
      }

      // If selection set is empty, exit selection mode
      if (selectedKeys.isEmpty) { // Jika set seleksi kosong, keluar dari mode seleksi
        isSelecting = false;
      } else {
        isSelecting = true; // Masuk ke mode seleksi
      }
    });
  }

  // --- UI Widgets ---
  // AppBar Widget
  Widget appBarWidget(bool landscape) {
    return SliverAppBar(
      // about us
      pinned: false, // AppBar tidak tetap di atas saat di-scroll
      floating: true, // AppBar muncul kembali saat di-scroll ke atas
      expandedHeight: 150.0, // Tinggi AppBar saat diperluas
      automaticallyImplyLeading: false, // Tidak menampilkan tombol kembali otomatis
      backgroundColor: primaryGreen,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: EdgeInsets.zero, // Hilangkan padding default
        centerTitle: true,
        title: Padding(
          padding: EdgeInsets.only(bottom: landscape ? 10 : 15),
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
                'Snap History',
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
    return SliverToBoxAdapter( // Menggunakan SliverToBoxAdapter untuk menampung konten
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: ValueListenableBuilder( // Dengarkan perubahan pada box Hive
          valueListenable: Hive.box<ResultScan>('result_scans').listenable(), // Mendengarkan box 'result_scans'
          builder: (context, Box<ResultScan> box, _) {
            final scanResults = box.values.toList(); // Ambil semua hasil scan dari box dalam bentuk list
            final sortedResults = scanResults.reversed.toList(); // Membalik urutan hasil scan untuk menampilkan yang terbaru terlebih dahulu

            return Column(
              children: [
                _buildHistoryHeader(), // Panggil widget header

                if (scanResults.isNotEmpty) // Cek jika tidak kosong
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: historyGridWidget(box, sortedResults), // Panggil widget grid history
                  )
                else // Jika kosong, tampilkan pesan
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 250),
                    child: Center(
                      child: Text(
                        'No scan history found.',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  // Grid Widget for displaying history items
  Widget historyGridWidget(
    Box<ResultScan> box,
    List<ResultScan> sortedResults,
  ) {
    return LayoutBuilder( // Gunakan LayoutBuilder untuk mendapatkan constraints yang digunakan untuk menentukan tinggi GridView
      builder: (context, constraints) { 
        final screenHeight = MediaQuery.of(context).size.height; // Dapatkan tinggi layar

        return ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: screenHeight * 0.7, // tinggi minimal 70%
            maxHeight: screenHeight * 0.7, // tinggi maksimal 70%
          ),
          child: GridView.builder(
            padding: const EdgeInsets.only(top: 10),
            physics: const AlwaysScrollableScrollPhysics(), // Pastikan GridView dapat di-scroll
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, // Jumlah kolom 3
              crossAxisSpacing: 5, // jarak antar kolom
              mainAxisSpacing: 5, // jarak antar baris
              childAspectRatio: 1, // Rasio aspek 1:1 (persegi)
            ),
            itemCount: sortedResults.length, // Jumlah item dalam grid
            itemBuilder: (context, index) {
              final resultScan = sortedResults[index]; // Ambil hasil scan berdasarkan indeks
              final key = resultScan.key; // Ambil kunci dari hasil scan
              final imageFile = File(resultScan.pathImage);

              if (!imageFile.existsSync()) { // Jika file gambar tidak ada, hapus entri dari Hive
                if (key != null) { // Jika key tidak null
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    box.delete(key); // Hapus entri dari Hive
                  });
                }
                return const SizedBox.shrink(); // Kembalikan widget kosong
              }

              final isSelected = selectedKeys.contains(key); // Cek apakah item ini terpilih

              return GestureDetector(
                onTap: () {
                  if (isSelecting) {
                    toggleSelection(key); // Jika dalam mode seleksi, toggle seleksi
                  } else { // Jika tidak dalam mode seleksi, buka halaman hasil scan
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        transitionDuration: const Duration(milliseconds: 400),
                        pageBuilder: (_, animation, __) => FadeTransition(
                          opacity: animation,
                          child: ResultPage(
                            initialIndex: index,
                            scanResults: sortedResults,
                            fromScanPage: false, // Menandakan bahwa ini dari halaman history
                          ),
                        ),
                      ),
                    );
                  }
                },
                onLongPress: () => toggleSelection(key), // Toggle seleksi pada tekan lama
                child: Hero(
                  tag: 'scan_$key',
                  child: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: FileImage(imageFile),
                          ),
                        ),
                      ),
                      if (isSelecting) // Jika dalam mode seleksi, tampilkan overlay seleksi
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? primaryGreen.withOpacity(0.5)
                                  : Colors.black.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      if (isSelecting) // Jika dalam mode seleksi, tampilkan ikon seleksi
                        Positioned(
                          top: 5,
                          right: 5,
                          child: CircleAvatar(
                            radius: 12,
                            backgroundColor: isSelected
                                ? Colors.white
                                : Colors.white.withOpacity(0.7),
                            child: isSelected
                                ? const Icon(
                                    Icons.check,
                                    color: primaryGreen,
                                    size: 16,
                                  )
                                : null,
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  // Widget that includes status bar
  Widget _buildHistoryHeader() {
    return Padding(
      padding: const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 5),
                // Instruction Text
                Text(
                  isSelecting
                      ? '${selectedKeys.length} selected'
                      : 'Hold to Select',
                  style: const TextStyle(fontSize: 16, color: Colors.black54),
                ),
              ],
            ),
          ),
          // Selection/Delete Button
          if (isSelecting) // Jika dalam mode seleksi, tampilkan tombol hapus
            IconButton(
              icon: const Icon(
                Icons.delete_sweep_rounded,
                color: Colors.red,
                size: 30,
              ),
              onPressed: () {
                if (selectedKeys.isNotEmpty) { // Jika ada item yang terpilih
                  final box = Hive.box<ResultScan>('result_scans'); // Membuka box Hive untuk ResultScan
                  showDeleteDialog(context, box, selectedKeys.toList()); // Panggil dialog hapus
                }
              },
            )
          else
            // Placeholder for alignment/design consistency if needed
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey.shade300, width: 2),
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final landscape =
        MediaQuery.of(context).orientation == Orientation.landscape; // Cek orientasi layar
    final historyPage = CustomScrollView(
      slivers: <Widget>[appBarWidget(landscape), topBoxContainer()],
    );
    return historyPage;
  }
}
