import '../../models/classification_model.dart';

final List<ClassificationModel> mockKondisiClassification = [
  ClassificationModel(kategori: 'Baik', jumlah: 98, persentase: 78.4),
  ClassificationModel(kategori: 'Rusak Ringan', jumlah: 20, persentase: 16.0),
  ClassificationModel(kategori: 'Rusak Berat', jumlah: 7, persentase: 5.6),
];

final List<ClassificationModel> mockJenisClassification = [
  ClassificationModel(kategori: 'Mobil Penumpang', jumlah: 60, persentase: 48.0),
  ClassificationModel(kategori: 'Mobil Barang', jumlah: 25, persentase: 20.0),
  ClassificationModel(kategori: 'Sepeda Motor', jumlah: 35, persentase: 28.0),
  ClassificationModel(kategori: 'Kendaraan Khusus', jumlah: 5, persentase: 4.0),
];
