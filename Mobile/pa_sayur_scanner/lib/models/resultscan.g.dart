// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'resultscan.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ResultScanAdapter extends TypeAdapter<ResultScan> {
  @override
  final int typeId = 1;

  @override
  ResultScan read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ResultScan(
      id: fields[0] as int,
      pathImage: fields[1] as String,
      vegetableId: fields[2] as int,
      scanDate: fields[3] as DateTime,
      confidence: fields[4] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, ResultScan obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.pathImage)
      ..writeByte(2)
      ..write(obj.vegetableId)
      ..writeByte(3)
      ..write(obj.scanDate)
      ..writeByte(4)
      ..write(obj.confidence);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ResultScanAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
