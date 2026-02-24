class Doa {
  Doa({
    required this.id,
    required this.nama,
    required this.ar,
    required this.idn,
    required this.tentang,
  });

  int id;
  String nama;
  String ar;
  String idn;
  String tentang;

  factory Doa.fromJson(Map<String, dynamic> json) => Doa(
        id: json["id"],
        nama: json["nama"],
        ar: json["ar"],
        idn: json["idn"],
        tentang: json["tentang"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nama": nama,
        "ar": ar,
        "idn": idn,
        "tentang": tentang,
      };
}
