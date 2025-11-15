import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/resultscan.dart';
import '../models/vegetable.dart';

class Tools {
  List<Vegetable> listVegetable = [ // Isi List dengan data sayur
    Vegetable(
      id: 1,
      nama: 'Bean',
      namaLatin: 'Phaseolus vulgaris',
      pathImage: 'assets/images/bean.jpg',
      deskripsi:
          'Bean atau buncis adalah sejenis polong-polongan yang dapat dimakan dari berbagai kultivar Phaseolus vulgaris. Buah, biji, dan daunnya dimanfaatkan orang sebagai sayuran. Sayuran ini kaya dengan kandungan protein. Ia dipercaya berasal dari Amerika Tengah dan Amerika Selatan.',
      harga: 'Rp 20.000 - Rp 35.000 per kg',
      nutrisi: [
        'Vitamin A',
        'Vitamin C',
        'Vitamin K',
        'Serat',
        'Protein nabati',
        'Antioksidan',
      ],

      manfaat: [
        'Meningkatkan daya tahan tubuh',
        'Menjaga kesehatan mata',
        'Baik untuk pencernaan',
        'Membantu menjaga kesehatan tulang',
      ],
    ),
    Vegetable(
      id: 2,
      nama: 'Bitter Gourd',
      namaLatin: 'Momordica charantia',
      pathImage: 'assets/images/bitter_gourd.jpg',
      deskripsi:
          'Bitter Gourd atau pare adalah tumbuhan merambat yang berasal dari wilayah Asia Tropis, terutama daerah India bagian barat, yaitu Assam dan Burma. Anggota suku labu-labuan atau Cucurbitaceae ini biasa dibudidayakan untuk dimanfaatkan sebagai sayuran maupun bahan pengobatan. Nama Momordica yang melekat pada nama binomialnya berarti "gigitan" yang menunjukkan pemerian tepi daunnya yang bergerigi menyerupai bekas gigitan.',
      harga: 'Rp 18.000 - Rp 25.000 per kg',
      nutrisi: [
        'Serat',
        'Zat besi',
        'Folat',
        'Kalsium',
        'Kalium',
        'Vitamin C',
        'Senyawa antidiabetes (charantin)',
      ],
      manfaat: [
        'Membantu menurunkan kadar gula darah',
        'Mendukung sistem imun',
        'Melancarkan pencernaan',
        'Mencegah anemia',
      ],
    ),
    Vegetable(
      id: 3,
      nama: 'Bottle Gourd',
      namaLatin: 'Lagenaria siceraria',
      pathImage: 'assets/images/bottle_gourd.jpg',
      deskripsi:
          'Bottle Gourd atau labu air atau labu sayur adalah sejenis labu yang buah mudanya dapat disayur dan buah tuanya dijadikan wadah air, tabung, kantung hias, ataupun koteka. Labu air masih berkerabat dekat dengan beligo dan rasanya pun bermiripan. Bentuk buahnya bervariasi, mulai dari membulat hingga lonjong memanjang. Tumbuhan ini diketahui sebagai salah satu tanaman budi daya tertua, tetapi ditanam bukan untuk bahan pangan melainkan untuk dijadikan alat rumah tangga. Karena bentuknya, peralatan laboratorium yang berbentuk menyerupai buah labu air juga dinamakan labu, seperti labu ukur dan labu Erlenmeyer.',
      harga: 'Rp 15.000 - Rp 29.000 per kg',
      nutrisi: [
        'Serat',
        'Vitamin C',
        'Zinc',
        'Kalium',
        'Kalsium',
        'Magnesium',
        'Air tinggi',
      ],
      manfaat: [
        'Menurunkan kolesterol',
        'Mengendalikan gula darah',
        'Melancarkan pencernaan',
        'Menjaga kesehatan tulang',
      ],
    ),
    Vegetable(
      id: 4,
      nama: 'Brinjal',
      namaLatin: 'Solanum melongena',
      pathImage: 'assets/images/brinjal.jpg',
      deskripsi:
          'Brinjal atau terong hijau dikenal secara botani sebagai Solanum melongena, varietas terong ini menonjol karena rona hijaunya yang cerah, yang berkisar dari warna terang hingga gelap, terkadang berbintik-bintik putih. Tidak seperti terong ungu yang lebih umum, Terong Hijau menawarkan profil rasa yang lebih ringan dan manis, menjadikannya tambahan yang lezat untuk berbagai hidangan. Teksturnya, setelah dimasak, menjadi empuk dan lembut, sehingga sempurna untuk menyerap rasa rempah-rempah dan saus.',
      harga: 'Rp 14.000 - Rp 22.000 per kg',
      nutrisi: [
        'Sulforaphane',
        'Vitamin C',
        'Vitamin K',
        'Serat',
        'Magnesium',
        'Fosfor',
        'Zat besi',
      ],

      manfaat: [
        'Melawan radikal bebas dan peradangan',
        'Mendukung kesehatan tulang',
        'Meningkatkan daya tahan tubuh',
      ],
    ),
    Vegetable(
      id: 5,
      nama: 'Broccoli',
      namaLatin: 'Brassica oleracea',
      pathImage: 'assets/images/broccoli.jpg',
      deskripsi:
          'Broccoli atau brokoli (Brassica oleracea L. Kelompok Italica) adalah tanaman yang sering dibudidayakan sebagai sayur. Brokoli adalah kultivar dari spesies yang sama dengan kubis dan kembang kol, yaitu Brassica oleracea. Brokoli berasal dari daerah Laut Tengah dan sudah sejak masa Yunani Kuno dibudidayakan. Sayuran ini masuk ke Indonesia belum lama (sekitar 1970-an) dan kini cukup populer sebagai bahan pangan.',
      harga: 'Rp 35.000 - Rp 55.000 per kg',
      nutrisi: [
        'Sulforaphane',
        'Vitamin C',
        'Vitamin K',
        'Serat',
        'Magnesium',
        'Fosfor',
        'Zat besi',
      ],
      manfaat: [
        'Melawan radikal bebas dan peradangan',
        'Mendukung kesehatan tulang',
        'Meningkatkan daya tahan tubuh',
      ],
    ),
    Vegetable(
      id: 6,
      nama: 'Cabbage',
      namaLatin: 'Brassica oleracea var. capitata',
      pathImage: 'assets/images/cabbage.jpg',
      deskripsi:
          'Cabbage atau kol atau kubis, yang mencakup sejumlah kultivar dari Brassica oleracea, merupakan tumbuhan dwimusim berdaun hijau, merah, atau putih yang dibudidayakan sebagai sayuran semusim untuk diambil kepala daunnya yang padat.',
      harga: 'Rp 7.000 - Rp 15.000 per kg',
      nutrisi: [
        'Vitamin A',
        'Vitamin C',
        'Vitamin B6',
        'Folat',
        'Zat besi',
        'Serat',
        'Antioksidan',
      ],
      manfaat: [
        'Baik untuk metabolisme energi',
        'Melindungi tubuh dari radikal bebas',
        'Mendukung sistem saraf',
        'Baik untuk pencernaan',
      ],
    ),
    Vegetable(
      id: 7,
      nama: 'Capsicum',
      namaLatin: 'Capsicum annuum',
      pathImage: 'assets/images/capsicum.jpg',
      deskripsi:
          'Capcisum atau paprika adalah tumbuhan penghasil buah yang berasa manis dan sedikit pedas dari suku terong-terongan atau Solanaceae. Buahnya yang berwarna hijau, kuning, merah, atau ungu sering digunakan sebagai campuran salad.',
      harga:
          'Hijau: Rp 35.000 - Rp 50.000/kg, Merah/Kuning: Rp 60.000 - Rp 90.000+/kg',
      nutrisi: [
        'Vitamin A',
        'Vitamin E',
        'Vitamin C',
        'Antioksidan (lutein, zeaxanthin)',
        'Capsaicin',
      ],
      manfaat: [
        'Menjaga kesehatan mata',
        'Melindungi sel dari kerusakan',
        'Meningkatkan daya tahan tubuh',
        'Meningkatkan metabolisme',
      ],
    ),
    Vegetable(
      id: 8,
      nama: 'Carrot',
      namaLatin: 'Daucus carota',
      pathImage: 'assets/images/carrot.jpg',
      deskripsi:
          'Carrot atau wortel atau lobak merah (Daucus carota) adalah tumbuhan biennial (siklus hidup 12 - 24 bulan) yang menyimpan karbohidrat dalam jumlah besar untuk tumbuhan tersebut berbunga pada tahun kedua. Batang bunga tumbuh setinggi sekitar 1 m, dengan bunga berwarna putih, dan rasa yang manis langu. Bagian yang dapat dimakan dari wortel adalah bagian umbi atau akarnya.',
      harga: 'Rp 17.000 - Rp 29.000 per kg',
      nutrisi: [
        'Beta-karoten (Vitamin A)',
        'Serat',
        'Vitamin K1',
        'Kalium',
        'Antioksidan',
      ],
      manfaat: [
        'Menjaga kesehatan mata',
        'Menurunkan kolesterol',
        'Baik untuk pencernaan',
      ],
    ),
    Vegetable(
      id: 9,
      nama: 'Cauliflower',
      namaLatin: 'Brassica oleracea',
      pathImage: 'assets/images/cauliflower.jpg',
      deskripsi:
          'Cauliflower atau kembang kol adalah salah satu dari beberapa sayuran yang dibudidayakan dari spesies Brassica oleracea dalam genus Brassica, yang termasuk dalam famili Brassicaceae (atau sawi-sawi). Kembang kol biasanya tumbuh dengan satu batang utama yang memiliki "kepala" besar dan bulat yang terbuat dari kuncup bunga putih atau putih pucat yang belum matang dan bergerombol rapat, yang disebut "dadih". Biasanya, hanya "kepala" yang dimakan.',
      harga: 'Rp 25.000 - Rp 40.000 per kg',
      nutrisi: [
        'Serat',
        'Kalsium',
        'Vitamin K',
        'Vitamin C',
        'Antioksidan (sulforaphane, indole)',
      ],
      manfaat: [
        'Melancarkan pencernaan',
        'Menjaga kesehatan tulang',
        'Anti-inflamasi',
        'Mendukung detoksifikasi tubuh',
      ],
    ),
    Vegetable(
      id: 10,
      nama: 'Cucumber',
      namaLatin: 'Cucumis sativus',
      pathImage: 'assets/images/cucumber.jpg',
      deskripsi:
          'Cucumber atau mentimun, timun, atau ketimun (Cucumis sativus) merupakan tumbuhan yang menghasilkan buah yang dapat dimakan. Buahnya biasanya dipanen ketika belum masak benar untuk dijadikan sayuran atau penyegar, tergantung jenisnya. Mentimun dapat ditemukan di berbagai hidangan dari seluruh dunia dan memiliki kandungan air cukup banyak di dalamnya sehingga berfungsi menyejukkan. Potongan buah mentimun juga digunakan untuk membantu melembapkan wajah serta banyak dipercaya dapat menurunkan tekanan darah tinggi.',
      harga: 'Rp 12.000 - Rp 20.000 per kg',
      nutrisi: [
        'Air tinggi',
        'Serat',
        'Vitamin K',
        'Kalium',
        'Antioksidan (flavonoid)',
      ],
      manfaat: [
        'Mencegah dehidrasi',
        'Melancarkan pencernaan',
        'Mengontrol berat badan',
        'Menjaga kesehatan tulang',
      ],
    ),
    Vegetable(
      id: 11,
      nama: 'Papaya',
      namaLatin: 'Carica papaya',
      pathImage: 'assets/images/papaya.jpg',
      deskripsi:
          'Papaya atau pepaya (Carica papaya) adalah tumbuhan berbuah yang berasal dari Amerika Tengah dan Amerika Selatan. Pepaya merupakan tanaman tropis yang banyak dibudidayakan di daerah tropis dan subtropis di seluruh dunia karena buahnya yang manis dan bergizi tinggi. Buah pepaya kaya akan vitamin C, vitamin A, folat, dan serat makanan, serta mengandung enzim papain yang membantu pencernaan protein.',
      harga: 'Rp 9.000 - Rp 15.000 per buah',
      nutrisi: ['Enzim papain', 'Serat', 'Vitamin C', 'Flavonoid', 'Kalium'],
      manfaat: [
        'Melancarkan pencernaan',
        'Meningkatkan daya tahan tubuh',
        'Membantu menjaga berat badan',
      ],
    ),
    Vegetable(
      id: 12,
      nama: 'Potato',
      namaLatin: 'Solanum tuberosum',
      pathImage: 'assets/images/potato.jpg',
      deskripsi:
          'Potato atau kentang (Solanum tuberosum) adalah tanaman umbi-umbian yang berasal dari Amerika Selatan, tepatnya di daerah pegunungan Andes. Kentang merupakan salah satu sumber karbohidrat utama di banyak negara dan telah menjadi makanan pokok bagi jutaan orang di seluruh dunia.',
      harga: 'Rp 17.000 - Rp 22.000 per kg',
      nutrisi: [
        'Karbohidrat kompleks',
        'Serat',
        'Vitamin C',
        'Kalium',
        'Vitamin B6',
        'Folat',
      ],
      manfaat: [
        'Sumber energi yang baik',
        'Menjaga tekanan darah stabil',
        'Baik untuk pencernaan',
      ],
    ),
    Vegetable(
      id: 13,
      nama: 'Pumpkin',
      namaLatin: 'Cucurbita pepo',
      pathImage: 'assets/images/pumpkin.jpg',
      deskripsi:
          'Pumpkin atau labu kuning (Cucurbita pepo) adalah tanaman berbunga yang termasuk dalam keluarga Cucurbitaceae. Labu biasanya memiliki kulit yang keras dan daging buah yang lembut serta berwarna oranye. Labu sering digunakan dalam berbagai hidangan, termasuk sup, pai, dan sebagai bahan tambahan dalam makanan penutup.',
      harga: 'Rp 10.000 - Rp 25.000 per kg',
      nutrisi: [
        'Vitamin A (beta-karoten)',
        'Vitamin C',
        'Serat',
        'Kalium',
        'Antioksidan (lutein, zeaxanthin)',
      ],
      manfaat: [
        'Menjaga kesehatan mata',
        'Meningkatkan sistem kekebalan tubuh',
        'Melancarkan pencernaan',
        'Baik untuk kesehatan jantung',
      ],
    ),
    Vegetable(
      id: 14,
      nama: 'Radish',
      namaLatin: 'Raphanus sativus',
      pathImage: 'assets/images/radish.jpg',
      deskripsi:
          'Radish atau lobak putih (Raphanus sativus) adalah sayuran akar yang termasuk dalam keluarga Brassicaceae. Lobak biasanya memiliki rasa yang pedas dan segar, dan dapat dimakan mentah atau dimasak.',
      harga: 'Rp 12.000 - Rp 22.000 per kg',
      nutrisi: [
        'Vitamin C',
        'Zinc',
        'Asam folat',
        'Kalium',
        'Kalsium',
        'Antioksidan',
      ],
      manfaat: [
        'Meningkatkan sistem kekebalan tubuh',
        'Mengontrol gula darah',
        'Menjaga kesehatan jantung',
      ],
    ),
    Vegetable(
      id: 15,
      nama: 'Tomato',
      namaLatin: 'Solanum lycopersicum',
      pathImage: 'assets/images/tomato.jpg',
      deskripsi:
          'Tomato atau tomat (Solanum lycopersicum) adalah tanaman berbunga yang berasal dari Amerika Selatan. Buahnya yang berwarna merah, kuning, atau hijau sering digunakan dalam berbagai hidangan, termasuk salad, saus, dan sup.',
      harga: 'Rp 19.000 - Rp 29.000 per kg',
      nutrisi: ['Vitamin A', 'Vitamin C', 'Likopen (antioksidan kuat)'],
      manfaat: [
        'Menjaga kesehatan mata',
        'Melawan radikal bebas',
        'Baik untuk kulit',
        'Melancarkan pencernaan',
      ],
    ),
  ];

  // Simpan hasil scan ke Hive
  void saveScanResult(String pathImage, int vegetableId, String confidence) {
    final box = Hive.box<ResultScan>('result_scans'); // Buka Hive box dengan nama 'result_scans'
    final createId = box.isEmpty // Buat ID unik untuk setiap hasil scan
    ? 1 // Jika box kosong, mulai dari ID 1
    : (box.keys.cast<int>().reduce((a, b) => a > b ? a : b) + 1); // Jika tidak, ambil ID tertinggi dan tambahkan 1
    
    final result = ResultScan( // Buat objek ResultScan baru
      id: createId,
      pathImage: pathImage,
      vegetableId: vegetableId,
      scanDate: DateTime.now(),
      confidence: confidence,
    );
    box.put(result.id, result); // Simpan objek ResultScan ke dalam Hive box
  }

  // Tampilkan dialog jika gagal identifikasi
  void failIdentificationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Gagal Mengidentifikasi'),
        content: const Text(
          'Model tidak dapat mengidentifikasi gambar ini.\n'
          'Coba gunakan gambar sayur yang lebih jelas.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}

// IconData untuk ikon custom SquareScan
class SquareScan {
  SquareScan._();

  static const _kFontFam = 'SquareScan'; // Nama font family
  static const String? _kFontPkg = null; // Paket font, null jika tidak ada

  static const IconData square_scan = IconData(0xe800, fontFamily: _kFontFam, fontPackage: _kFontPkg); // Kode ikon
}
