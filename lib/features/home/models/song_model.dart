import 'dart:convert';

List<SongModel> songsFromJson(String str) {
  final parsed = json.decode(str) as List<dynamic>;
  return parsed
      .map((dynamic x) => SongModel.fromMap(x as Map<String, dynamic>))
      .toList();
}

class SongModel {
  final String id;
  final String title;
  final String artist;
  final String hexCode;
  final String songUrl;
  final String thumbnail;

  SongModel({
    required this.id,
    required this.artist,
    required this.title,
    required this.hexCode,
    required this.songUrl,
    required this.thumbnail,
  });

  factory SongModel.fromMap(Map<String, dynamic> map) {
    return SongModel(
      id: (map['id'] ?? '') as String,
      artist: (map['artist'] ?? '') as String,
      title: (map['title'] ?? '') as String,
      hexCode: (map['hex_code'] ?? '') as String,
      songUrl: (map['song_url'] ?? '') as String,
      thumbnail: (map['thumbnail_url'] ?? '') as String,
    );
  }

  factory SongModel.fromJson(String source) =>
      SongModel.fromMap(json.decode(source) as Map<String, dynamic>);

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'title': title,
      'artist': artist,
      'hex_code': hexCode,
      'song_url': hexCode,
      'thumbnail': thumbnail,
    };
  }

  String toJson() => json.encode(toMap());

  SongModel copyWith({
    String? id,
    String? artist,
    String? title,
    String? hexCode,
    String? songUrl,
    String? thumbnail,
  }) {
    return SongModel(
      id: id ?? this.id,
      artist: artist ?? this.artist,
      title: title ?? this.title,
      hexCode: hexCode ?? this.hexCode,
      songUrl: songUrl ?? this.songUrl,
      thumbnail: thumbnail ?? this.thumbnail,
    );
  }
}
