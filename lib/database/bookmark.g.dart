// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bookmark.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BookMarkAdapter extends TypeAdapter<BookMark> {
  @override
  final int typeId = 1;

  @override
  BookMark read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BookMark(
      name: fields[0] as String,
      link: fields[2] as String,
      size: fields[1] as String,
      thumb: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, BookMark obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.size)
      ..writeByte(2)
      ..write(obj.link)
      ..writeByte(3)
      ..write(obj.thumb);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BookMarkAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
