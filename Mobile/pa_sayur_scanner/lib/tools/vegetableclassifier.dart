import 'dart:io';
import 'dart:typed_data';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';

class VegetableClassifier {
  late Interpreter _interpreter; // interpreter TFLite
  late List<String> _labels; // daftar label sayur

  // Memuat model dan label dari aset
  Future<void> loadModel() async {
    final labelsData = await rootBundle.loadString('assets/vegetable_labels.json'); // Memuat file label sayur json
    final Map<String, dynamic> jsonMap = json.decode(labelsData); // Decode JSON ke Map

    _labels = List.generate(jsonMap.length, (i) => jsonMap["$i"] ?? "Unknown"); // Buat daftar label dari Map ke List
    _interpreter = await Interpreter.fromAsset('assets/vegetable_model.tflite'); // Memuat model TFLite
  }

  // Klasifikasi gambar dan kembalikan label dengan confidence tertinggi
  Future<String?> classifyImage(File imageFile) async {
    img.Image? rawImage = img.decodeImage(await imageFile.readAsBytes()); // Decode gambar dari file
    if (rawImage == null) return null; // Kembalikan null jika gagal decode

    // Crop agar rasio 1:1 sebelum resize
    final cropped = img.copyResize(rawImage, width: 224, height: 224);

    // Siapkan input Float32List
    final input = Float32List(1 * 224 * 224 * 3);
    int index = 0;

    for (int y = 0; y < 224; y++) { // Looping setiap pixel pada kolom
      for (int x = 0; x < 224; x++) { // Looping setiap pixel pada baris
        final pixel = cropped.getPixel(x, y); // Dapatkan pixel pada koordinat (x, y)

        // Pastikan pakai fungsi getRed/Green/Blue agar nilai 0–255
        final r = pixel.r; // Merah
        final g = pixel.g; // Hijau
        final b = pixel.b; // Biru

        input[index++] = r / 255.0; // Normalisasi nilai merah
        input[index++] = g / 255.0; // Normalisasi nilai hijau
        input[index++] = b / 255.0; // Normalisasi nilai biru
      }
    }

    // Jalankan inferensi
    final inputBuffer = input.reshape([1, 224, 224, 3]); // Ubah bentuk input sesuai model
    final output = Float32List(_labels.length).reshape([1, _labels.length]); // Siapkan output buffer

    _interpreter.run(inputBuffer, output);

    // Analisis output untuk cari label dengan confidence tertinggi
    final prediction = List<double>.from(output[0]);
    final maxValue = prediction.reduce((a, b) => a > b ? a : b); // Cari nilai confidence tertinggi
    final maxIndex = prediction.indexOf(maxValue); // Dapatkan indeks label dengan confidence tertinggi

    final confidence = prediction[maxIndex];
    if (confidence < 0.6) return null; // Jika confidence di bawah 60%, kembalikan null

    print('Confidence values: $confidence'); 
    print('Prediction: ${prediction.take(5).toList()} ...'); 
    print('Max index: $maxIndex, Label: ${_labels[maxIndex]}');
    return '${_labels[maxIndex]} - ${(confidence * 100).toStringAsFixed(2)}%'; // Kembalikan label dan confidence dalam persen
  }
}
