class Vegetable {
  int id;
  String nama;
  String namaLatin;
  String pathImage;
  String deskripsi;
  String harga;
  List<String> nutrisi;
  List<String> manfaat;

  Vegetable({
    required this.id,
    required this.nama,
    required this.namaLatin,
    required this.pathImage,
    required this.deskripsi,
    required this.harga,
    required this.nutrisi,
    required this.manfaat,
  });
}
