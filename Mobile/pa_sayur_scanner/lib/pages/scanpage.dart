import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import '../tools/tools.dart';
import 'dart:io';
import '../tools/vegetableclassifier.dart';
import 'package:image_picker/image_picker.dart';

// Define the primary green color used in the UI (Reusing from MainPage)
const Color primaryGreen = Color(0xFF4CAF50);

class ScanPage extends StatefulWidget {
  const ScanPage({super.key});

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  Tools tools = Tools();
  CameraController? _controller; // controller kamera
  Future<void>? _initializeControllerFuture; // untuk inisialisasi kamera
  VegetableClassifier classifier = VegetableClassifier(); // instance classifier
  bool isFlashOn = false; // status flash (nyala/mati)

  @override
  void initState() { // Inisialisasi kamera dan muat model
    super.initState();
    initializeCamera(); // Inisialisasi kamera
    classifier
        .loadModel() // Muat model dan label
        .then((_) { // Jika berhasil
          print("DEBUG: Model dan label berhasil dimuat");
        })
        .catchError((e) { // Jika gagal/error
          print("ERROR memuat model: $e");
        });
  }

  // Dispose controller
  @override  // Hapus controller kamera saat halaman dihapus
  void dispose() {
    _controller?.dispose(); // Dispose controller kamera untuk membebaskan sumber daya
    super.dispose();
  }

  // Inisialisasi kamera
  Future<void> initializeCamera() async {
    final cameras = await availableCameras(); // Dapatkan daftar kamera yang tersedia
    final firstCamera = cameras.first; // Gunakan kamera belakang (biasanya kamera pertama)

    final controller = CameraController( // Buat controller kamera
      firstCamera,
      ResolutionPreset.high, // Resolusi kamera tinggi
      enableAudio: false, // Nonaktifkan audio
    );
    _initializeControllerFuture = controller.initialize(); // Inisialisasi controller kamera

    if (mounted) { // Pastikan widget masih terpasang sebelum memperbarui state
      setState(() {
        _controller = controller; // Simpan controller kamera ke state
      });
    }
  }

  // Toggle flash on/off
  Future<void> toggleFlash() async {
    if (_controller == null) return; // Pastikan controller sudah diinisialisasi
    try {
      if (isFlashOn) { // Jika flash sedang menyala, matikan
        await _controller!.setFlashMode(FlashMode.off);
      } else { // Jika flash sedang mati, nyalakan
        await _controller!.setFlashMode(FlashMode.torch);
      }
      setState(() {
        isFlashOn = !isFlashOn; // Perbarui status flash
      });
    } catch (e) {
      debugPrint("Failed to toggle flash: $e");
    }
  }

  bool isTakingPicture = false; // Flag untuk mencegah multiple taps saat mengambil gambar

  // Ambil gambar dan klasifikasi (FIXED for Disposal Timing)
  Future<void> takePicture() async {
    if (_controller == null ||
        _initializeControllerFuture == null ||
        isTakingPicture)
      return; // Pastikan controller sudah diinisialisasi dan tidak sedang mengambil gambar

    setState(() => isTakingPicture = true); // Set flag untuk menandai proses pengambilan gambar sedang berlangsung

    try {
      await _initializeControllerFuture; // Pastikan kamera sudah siap
      final image = await _controller!.takePicture(); // Ambil gambar menggunakan kamera
      final File imageFile = File(image.path); // Konversi XFile ke File

      final result = await classifier.classifyImage(imageFile); // Kirim gambar ke model untuk diidentifikasi

      if (!mounted) return; // Pastikan widget masih terpasang sebelum melanjutkan

      if (result == null) { // Jika Mengembalikan null, tampilkan dialog gagal mengidentifikasi
        tools.failIdentificationDialog(context);
        return;
      }

      final predictedLabel = result.trim().toLowerCase().split(' - ')[0]; // Ambil label prediksi dari hasil identifikasi
      final confidenceIndex = result.split(' - ')[1]; // Ambil confidence index dari hasil identifikasi

      final matchedVegetable = tools.listVegetable.firstWhere( // Cocokkan label prediksi dengan data sayur
        (v) =>
            v.nama.trim().toLowerCase().replaceAll(' ', '_') == predictedLabel,
      );

      tools.saveScanResult( // Panggil fungsi untuk menyimpan hasil scan
        imageFile.path,
        matchedVegetable.id,
        confidenceIndex,
      );

      if (mounted) { // Pastikan widget masih terpasang sebelum menutup halaman dan mengirim hasil kembali
        Navigator.pop(context, {
          'matchedVegetable': matchedVegetable, // Kirim data sayur yang cocok kembali
          'imagePath': imageFile.path, // Kirim path gambar kembali
        });
      }
    } catch (e) {
      print("ERROR taking picture/classifying: $e");
    } finally {
      if (mounted) { // Pastikan widget masih terpasang sebelum memperbarui state
        setState(() => isTakingPicture = false); // Reset flag setelah proses pengambilan gambar selesai
      }
    }
  }

  // Fungsi untuk memilih gambar dari galeri (FIXED for Disposal Timing & Result Return)
  Future<void> pickImageFromGallery() async {
    final picker = ImagePicker(); // Inisialisasi ImagePicker
    final XFile? image = await picker.pickImage(source: ImageSource.gallery); // Buka galeri untuk memilih gambar
    if (image == null) return; // Jika tidak ada gambar yang dipilih, keluar dari fungsi

    final file = File(image.path); // Konversi XFile ke File
    final result = await classifier.classifyImage(file); // Kirim gambar ke model untuk diidentifikasi

    if (!mounted) return; // Pastikan widget masih terpasang sebelum melanjutkan

    if (result == null) { // Jika Mengembalikan null, tampilkan dialog gagal mengidentifikasi
      tools.failIdentificationDialog(context);
      return;
    }

    final predictedLabel = result.trim().toLowerCase().split(' - ')[0]; // Ambil label prediksi dari hasil identifikasi
    final confidenceIndex = result.split(' - ')[1]; // Ambil confidence index dari hasil identifikasi

    final matchedVegetable = tools.listVegetable.firstWhere(
      (v) => v.nama.trim().toLowerCase().replaceAll(' ', '_') == predictedLabel,
    ); // Cocokkan label prediksi dengan data sayur

    tools.saveScanResult(file.path, matchedVegetable.id, confidenceIndex);

    Navigator.pop(context, {
      'matchedVegetable': matchedVegetable, // Kirim data sayur yang cocok kembali
      'imagePath': file.path, // Kirim path gambar kembali
    });
  }

  // Widget Flash Button
  Widget buildFlashButton(bool landscape) {
    return SafeArea( // SafeArea untuk menghindari notch atau area tidak aman
      top: landscape ? false : true,
      bottom: landscape ? false : true,
      child: Align(
        alignment: landscape ? Alignment.topLeft : Alignment.topRight,
        child: Container(
          margin: landscape
              ? EdgeInsets.only(top: 15)
              : EdgeInsets.only(top: 10, right: 10),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: Icon(
              isFlashOn ? Icons.flash_on_rounded : Icons.flash_off_rounded,
              color: isFlashOn ? Colors.yellow : Colors.white,
              size: 26,
            ),
            onPressed: toggleFlash, // Panggil fungsi toggleFlash saat tombol ditekan
          ),
        ),
      ),
    );
  }

  // Custom Focus/Scan Frame Overlay
  Widget buildScanFrameOverlay(double aspectRatio) {
    return Center(
      child: AspectRatio( // Gunakan AspectRatio untuk menjaga rasio frame fokus
        aspectRatio: aspectRatio, // Samakan dengan rasio kamera
        child: LayoutBuilder( // Gunakan LayoutBuilder untuk mendapatkan ukuran area yang tersedia
          builder: (context, constraints) {
            return CustomPaint( // Gambar frame fokus menggunakan CustomPainter
              size: Size(constraints.maxWidth, constraints.maxHeight), // Ukuran sesuai dengan area yang tersedia
              painter: ScanFramePainter(), // Gunakan ScanFramePainter untuk menggambar frame fokus
            );
          },
        ),
      ),
    );
  }

  // Custom Camera Control Bar (Bottom Bar)
  Widget buildControlBar(bool landscape) {
    return Expanded(
      child: Container(
        color: Colors.transparent,
        child: landscape ? landscapeControlBar() : portraitControlBar(),
      ),
    );
  }

  // Control Bar for Landscape Orientation
  Widget landscapeControlBar() {
    return Row(
      children: [
        RotatedBox( // Menggunakan RotatedBox untuk memutar teks agar tetap tegak saat landscape
          quarterTurns: 3, // putar 270 derajat (teks tegak saat landscape)
          child: const Text(
            'Place the subject in focus',
            style: TextStyle(color: Colors.black, fontSize: 16),
          ),
        ),
        const SizedBox(width: 35),

        Column(
          children: <Widget>[
            SizedBox(height: 150),
            InkWell(
              onTap: isTakingPicture ? null : takePicture, // Jika sedang mengambil gambar, nonaktifkan tombol
              child: Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 4),
                  color: primaryGreen,
                  shape: BoxShape.circle, // Bentuk lingkaran
                ),
                child: isTakingPicture // Tampilkan indikator loading saat mengambil gambar
                    ? const Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      )
                    : null,
              ),
            ),

            SizedBox(height: 50),

            // Left: Photos/Gallery Button
            Expanded(
              child: InkWell(
                onTap: pickImageFromGallery,
                child: const Column(
                  mainAxisSize: MainAxisSize.min, // Supaya kolom hanya sebesar isinya
                  children: [
                    Icon(Icons.image_rounded, color: primaryGreen, size: 30),
                    Text(
                      'Photos',
                      style: TextStyle(
                        color: primaryGreen,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Right: Spacer
            const Expanded(child: SizedBox()),
          ],
        ),
      ],
    );
  }

  // Control Bar for Portrait Orientation
  Widget portraitControlBar() {
    return Column(
      children: [
        Center(
          child: Text(
            'Place the subject in focus',
            style: TextStyle(color: Colors.black, fontSize: 16),
          ),
        ),
        const SizedBox(height: 35),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            // Left: Photos/Gallery Button
            Expanded(
              child: InkWell(
                onTap: pickImageFromGallery, // Panggil fungsi pilih gambar dari galeri
                child: const Column(
                  mainAxisSize: MainAxisSize.min, // Supaya kolom hanya sebesar isinya
                  children: [
                    Icon(Icons.image_rounded, color: primaryGreen, size: 30),
                    Text(
                      'Photos',
                      style: TextStyle(
                        color: primaryGreen,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Center: Capture Button (Large Green Circle)
            InkWell(
              onTap: isTakingPicture ? null : takePicture,
              child: Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 4),
                  color: primaryGreen,
                  shape: BoxShape.circle,
                ),
                child: isTakingPicture
                    ? const Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      )
                    : null,
              ),
            ),

            // Right: Spacer
            const Expanded(child: SizedBox()),
          ],
        ),
      ],
    );
  }

  // Top Back Button (DISPOSAL FIXED)
  Widget buildBackButton(bool landscape) {
    return SafeArea( // Menggunakan SafeArea untuk menghindari notch atau area tidak aman
      child: Align( // Menggunakan Align untuk menempatkan tombol di sudut kiri atas
        alignment: landscape ? Alignment.bottomLeft : Alignment.topLeft,
        child: Container(
          margin: landscape
              ? EdgeInsets.only(right: 10)
              : EdgeInsets.only(top: 10, left: 10),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.white,
              size: 24,
            ),
            onPressed: () {
              Navigator.pop(context); // Kembali ke halaman sebelumnya
            },
          ),
        ),
      ),
    );
  }

  // Camera Preview Widgets for Different Orientations
  Widget landscapeCameraPreview(double aspectRatio, bool landscape) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(width: 100), // Ruang kosong di kiri untuk tombol kembali dan flash
        AspectRatio(
          aspectRatio: aspectRatio, // Gunakan rasio aspek yang sesuai (4:3)
          child: ClipRRect(child: CameraPreview(_controller!)), // Tampilkan preview kamera
        ),

        SizedBox(width: 20),

        // Bottom Control Bar (Photos & Capture Button)
        buildControlBar(landscape),
      ],
    );
  }

  // Camera Preview for Portrait Orientation
  Widget portraitCameraPreview(double aspectRatio, bool landscape) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 100), // Ruang kosong di atas untuk tombol kembali dan flash 
        AspectRatio(
          aspectRatio: aspectRatio,
          child: ClipRRect(child: CameraPreview(_controller!)), // Tampilkan preview kamera
        ),

        SizedBox(height: 20),

        // Bottom Control Bar (Photos & Capture Button)
        buildControlBar(landscape),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null || _initializeControllerFuture == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    } // Jika controller belum diinisialisasi, tampilkan indikator loading

    return FutureBuilder<void>(
      future: _initializeControllerFuture, // Tunggu hingga inisialisasi kamera selesai
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) { // Jika inisialisasi selesai
          final landscape =
              MediaQuery.of(context).orientation == Orientation.landscape; // Cek orientasi perangkat

          // Jika landscape, gunakan rasio 4:3, jika portrait gunakan 3:4
          final double aspectRatio = landscape ? 4 / 3 : 3 / 4;

          return Scaffold(
            body: Stack(
              children: [
                landscape
                    ? landscapeCameraPreview(aspectRatio, landscape)
                    : portraitCameraPreview(aspectRatio, landscape),

                buildBackButton(landscape), // Panggil tombol kembali

                buildFlashButton(landscape), // Panggil tombol flash

                landscape
                    ? Positioned(
                        left: 100, // Jika landscape, sesuaikan posisi kiri dengan ruang kosong
                        top: 0,
                        bottom: 0,
                        child: buildScanFrameOverlay(aspectRatio), // Panggil overlay frame scan
                      )
                    : Positioned(
                        top: 100, // Jika portrait, sesuaikan posisi atas dengan ruang kosong
                        left: 0,
                        right: 0,
                        child: buildScanFrameOverlay(aspectRatio), // Panggil overlay frame scan
                      ),
              ],
            ),
          );
        } else { // Jika masih dalam proses inisialisasi, tampilkan indikator loading
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
      },
    );
  }
}

// Custom Painter for the corners of the focus frame
class ScanFramePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const double strokeWidth = 2.0; // Lebar garis sudut
    const double cornerLength = 50.0; // Panjang garis sudut
    final Paint paint = Paint() // Catat warna, lebar, dan gaya garis
      ..color = Colors.white
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final double centerX = size.width / 2; // Hitung titik tengah X
    final double centerY = size.height / 2; // Hitung titik tengah Y
    const double frameSizeRatio = 0.7; // Rasio ukuran frame terhadap sisi terpendek
    final double frameSize = size.shortestSide * frameSizeRatio; // Ukuran frame fokus
    final double halfFrame = frameSize / 2; // Setengah ukuran frame

    final Offset topLeft = Offset(centerX - halfFrame, centerY - halfFrame); // Koordinat sudut kiri atas
    final Offset topRight = Offset(centerX + halfFrame, centerY - halfFrame); // Koordinat sudut kanan atas
    final Offset bottomLeft = Offset(centerX - halfFrame, centerY + halfFrame); // Koordinat sudut kiri bawah
    final Offset bottomRight = Offset(centerX + halfFrame, centerY + halfFrame); // Koordinat sudut kanan bawah

    // Top-Left Corner
    canvas.drawLine(topLeft, topLeft.translate(cornerLength, 0), paint); // Garis horizontal
    canvas.drawLine(topLeft, topLeft.translate(0, cornerLength), paint);  // Garis vertikal

    // Top-Right Corner
    canvas.drawLine(topRight, topRight.translate(-cornerLength, 0), paint); // Garis horizontal
    canvas.drawLine(topRight, topRight.translate(0, cornerLength), paint);  // Garis vertikal

    // Bottom-Left Corner
    canvas.drawLine(bottomLeft, bottomLeft.translate(cornerLength, 0), paint); // Garis horizontal
    canvas.drawLine(bottomLeft, bottomLeft.translate(0, -cornerLength), paint); // Garis vertikal

    // Bottom-Right Corner
    canvas.drawLine( // Garis horizontal
      bottomRight,
      bottomRight.translate(-cornerLength, 0),
      paint,
    );
    canvas.drawLine( // Garis vertikal
      bottomRight,
      bottomRight.translate(0, -cornerLength),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
