import 'package:flutter/material.dart';
import 'pages/mainpage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/resultscan.dart';

void main() async {
  // Inisialisasi Flutter
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi Hive
  await Hive.initFlutter();

  // Registrasi adapter
  Hive.registerAdapter(ResultScanAdapter());

  // Buka box
  await Hive.openBox<ResultScan>('result_scans');
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vegetable Scanner',
      home: const MainPage(),
      debugShowCheckedModeBanner: false, // Nonaktifkan banner debug
    );
  }
}
