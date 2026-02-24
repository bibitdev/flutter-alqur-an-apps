class Dzikir {
  Dzikir({
    required this.id,
    required this.nama,
    required this.ar,
    required this.idn,
    required this.tentang,
    this.jumlah,
  });

  int id;
  String nama;
  String ar;
  String idn;
  String tentang;
  String? jumlah;

  factory Dzikir.fromJson(Map<String, dynamic> json) => Dzikir(
        id: json["id"],
        nama: json["nama"],
        ar: json["ar"],
        idn: json["idn"],
        tentang: json["tentang"],
        jumlah: json["jumlah"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nama": nama,
        "ar": ar,
        "idn": idn,
        "tentang": tentang,
        "jumlah": jumlah,
      };
}
