import 'dart:convert';

class Bookmark {
  Bookmark({
    required this.surahNomor,
    required this.surahNamaLatin,
    required this.surahNama,
    required this.ayatNomor,
    required this.ayatAr,
    required this.ayatIdn,
    required this.createdAt,
  });

  int surahNomor;
  String surahNamaLatin;
  String surahNama;
  int ayatNomor;
  String ayatAr;
  String ayatIdn;
  DateTime createdAt;

  factory Bookmark.fromJson(Map<String, dynamic> json) => Bookmark(
        surahNomor: json["surah_nomor"],
        surahNamaLatin: json["surah_nama_latin"],
        surahNama: json["surah_nama"],
        ayatNomor: json["ayat_nomor"],
        ayatAr: json["ayat_ar"],
        ayatIdn: json["ayat_idn"],
        createdAt: DateTime.parse(json["created_at"]),
      );

  Map<String, dynamic> toJson() => {
        "surah_nomor": surahNomor,
        "surah_nama_latin": surahNamaLatin,
        "surah_nama": surahNama,
        "ayat_nomor": ayatNomor,
        "ayat_ar": ayatAr,
        "ayat_idn": ayatIdn,
        "created_at": createdAt.toIso8601String(),
      };

  /// Unique key for identifying a bookmark (surah + ayat combination)
  String get key => '${surahNomor}_$ayatNomor';

  static List<Bookmark> listFromJson(String str) =>
      List<Bookmark>.from(json.decode(str).map((x) => Bookmark.fromJson(x)));

  static String listToJson(List<Bookmark> data) =>
      json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
}
