import 'package:hive/hive.dart';

part 'resultscan.g.dart';

@HiveType(typeId: 1) 
class ResultScan extends HiveObject {
  @HiveField(0)
  int id;

  @HiveField(1)
  String pathImage;

  @HiveField(2)
  int vegetableId;

  @HiveField(3)
  DateTime scanDate;
  
  @HiveField(4)
  String? confidence;

  ResultScan({
    required this.id,
    required this.pathImage,
    required this.vegetableId,
    required this.scanDate,
    required this.confidence,
  });
}
