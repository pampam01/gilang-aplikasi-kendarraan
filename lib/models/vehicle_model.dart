class VehicleModel {
  final String idKendaraan;
  final String nomorPolisi;
  final String nomorRangka;
  final String nomorMesin;
  final String merek;
  final String tipe;
  final String jenisKendaraan;
  final int tahunPerolehan;
  final String kondisi;
  final String statusPenggunaan;
  final double nilaiAset;
  final String namaOpd;
  final String warna;
  final String sumberDana;
  final DateTime tanggalInput;

  VehicleModel({
    required this.idKendaraan,
    required this.nomorPolisi,
    required this.nomorRangka,
    required this.nomorMesin,
    required this.merek,
    required this.tipe,
    required this.jenisKendaraan,
    required this.tahunPerolehan,
    required this.kondisi,
    required this.statusPenggunaan,
    required this.nilaiAset,
    required this.namaOpd,
    required this.warna,
    required this.sumberDana,
    required this.tanggalInput,
  });

  VehicleModel copyWith({
    String? idKendaraan,
    String? nomorPolisi,
    String? nomorRangka,
    String? nomorMesin,
    String? merek,
    String? tipe,
    String? jenisKendaraan,
    int? tahunPerolehan,
    String? kondisi,
    String? statusPenggunaan,
    double? nilaiAset,
    String? namaOpd,
    String? warna,
    String? sumberDana,
    DateTime? tanggalInput,
  }) {
    return VehicleModel(
      idKendaraan: idKendaraan ?? this.idKendaraan,
      nomorPolisi: nomorPolisi ?? this.nomorPolisi,
      nomorRangka: nomorRangka ?? this.nomorRangka,
      nomorMesin: nomorMesin ?? this.nomorMesin,
      merek: merek ?? this.merek,
      tipe: tipe ?? this.tipe,
      jenisKendaraan: jenisKendaraan ?? this.jenisKendaraan,
      tahunPerolehan: tahunPerolehan ?? this.tahunPerolehan,
      kondisi: kondisi ?? this.kondisi,
      statusPenggunaan: statusPenggunaan ?? this.statusPenggunaan,
      nilaiAset: nilaiAset ?? this.nilaiAset,
      namaOpd: namaOpd ?? this.namaOpd,
      warna: warna ?? this.warna,
      sumberDana: sumberDana ?? this.sumberDana,
      tanggalInput: tanggalInput ?? this.tanggalInput,
    );
  }
}
