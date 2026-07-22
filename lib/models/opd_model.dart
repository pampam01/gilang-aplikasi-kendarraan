class OpdModel {
  final String idOpd;
  final String namaOpd;
  final String singkatan;
  final String alamat;
  final String namaPenanggungJawab;
  final String nomorTelepon;
  final int jumlahKendaraan;

  OpdModel({
    required this.idOpd,
    required this.namaOpd,
    required this.singkatan,
    required this.alamat,
    required this.namaPenanggungJawab,
    required this.nomorTelepon,
    this.jumlahKendaraan = 0,
  });

  OpdModel copyWith({
    String? idOpd,
    String? namaOpd,
    String? singkatan,
    String? alamat,
    String? namaPenanggungJawab,
    String? nomorTelepon,
    int? jumlahKendaraan,
  }) {
    return OpdModel(
      idOpd: idOpd ?? this.idOpd,
      namaOpd: namaOpd ?? this.namaOpd,
      singkatan: singkatan ?? this.singkatan,
      alamat: alamat ?? this.alamat,
      namaPenanggungJawab: namaPenanggungJawab ?? this.namaPenanggungJawab,
      nomorTelepon: nomorTelepon ?? this.nomorTelepon,
      jumlahKendaraan: jumlahKendaraan ?? this.jumlahKendaraan,
    );
  }
}
