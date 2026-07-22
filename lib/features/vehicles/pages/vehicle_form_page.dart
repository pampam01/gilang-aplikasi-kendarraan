import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/validators.dart';
import '../../../shared/widgets/app_text_field.dart';
import '../../../shared/widgets/primary_button.dart';
import '../../../models/vehicle_model.dart';
import '../../../data/repositories/mock_repository.dart';
import '../providers/vehicles_provider.dart';

class VehicleFormPage extends ConsumerStatefulWidget {
  final VehicleModel? vehicle;
  const VehicleFormPage({Key? key, this.vehicle}) : super(key: key);

  @override
  ConsumerState<VehicleFormPage> createState() => _VehicleFormPageState();
}

class _VehicleFormPageState extends ConsumerState<VehicleFormPage> {
  final _formKey = GlobalKey<FormState>();
  
  // Identitas Kendaraan
  final _nopolController = TextEditingController();
  final _norangkaController = TextEditingController();
  final _nomesinController = TextEditingController();
  final _merekController = TextEditingController();
  final _tipeController = TextEditingController();
  final _warnaController = TextEditingController();

  // Informasi Aset
  String _jenisKendaraan = 'Mobil Penumpang';
  final _tahunController = TextEditingController();
  final _nilaiAsetController = TextEditingController();
  String _sumberDana = 'APBD';
  String? _selectedOpd;

  // Status Kendaraan
  String _kondisi = 'Baik';
  String _statusPenggunaan = 'Digunakan';

  List<String> _opdList = [];

  @override
  void initState() {
    super.initState();
    _loadOpds();
    if (widget.vehicle != null) {
      final v = widget.vehicle!;
      _nopolController.text = v.nomorPolisi;
      _norangkaController.text = v.nomorRangka;
      _nomesinController.text = v.nomorMesin;
      _merekController.text = v.merek;
      _tipeController.text = v.tipe;
      _warnaController.text = v.warna;
      
      _jenisKendaraan = v.jenisKendaraan;
      _tahunController.text = v.tahunPerolehan.toString();
      _nilaiAsetController.text = v.nilaiAset.toInt().toString();
      _sumberDana = v.sumberDana;
      _selectedOpd = v.namaOpd;

      _kondisi = v.kondisi;
      _statusPenggunaan = v.statusPenggunaan;
    }
  }

  Future<void> _loadOpds() async {
    final opds = await MockRepository().getOpds();
    setState(() {
      _opdList = opds.map((e) => e.namaOpd).toList();
      if (_selectedOpd == null && _opdList.isNotEmpty) {
        _selectedOpd = _opdList.first;
      }
    });
  }

  void _save() {
    if (_formKey.currentState!.validate() && _selectedOpd != null) {
      final isEditing = widget.vehicle != null;
      final newVehicle = VehicleModel(
        idKendaraan: isEditing ? widget.vehicle!.idKendaraan : const Uuid().v4(),
        nomorPolisi: _nopolController.text.toUpperCase(),
        nomorRangka: _norangkaController.text,
        nomorMesin: _nomesinController.text,
        merek: _merekController.text,
        tipe: _tipeController.text,
        warna: _warnaController.text,
        jenisKendaraan: _jenisKendaraan,
        tahunPerolehan: int.parse(_tahunController.text),
        nilaiAset: double.parse(_nilaiAsetController.text),
        sumberDana: _sumberDana,
        namaOpd: _selectedOpd!,
        kondisi: _kondisi,
        statusPenggunaan: _statusPenggunaan,
        tanggalInput: isEditing ? widget.vehicle!.tanggalInput : DateTime.now(),
      );

      if (isEditing) {
        ref.read(vehiclesProvider.notifier).updateVehicle(newVehicle);
      } else {
        ref.read(vehiclesProvider.notifier).addVehicle(newVehicle);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data kendaraan berhasil disimpan.')),
      );
      context.pop();
    }
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSizes.p16),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          color: AppColors.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.vehicle == null ? 'Tambah Kendaraan' : 'Edit Kendaraan'),
      ),
      body: _opdList.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(AppSizes.p16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildSectionTitle('Identitas Kendaraan'),
                    AppTextField(
                      label: 'Nomor Polisi',
                      controller: _nopolController,
                      validator: (val) => Validators.required(val, 'Nomor Polisi'),
                      onChanged: (val) {
                         // To uppercase automatically
                         if (val != null) {
                           _nopolController.value = _nopolController.value.copyWith(
                             text: val.toUpperCase(),
                           );
                         }
                      },
                    ),
                    const SizedBox(height: AppSizes.p12),
                    AppTextField(
                      label: 'Merek',
                      controller: _merekController,
                      validator: (val) => Validators.required(val, 'Merek'),
                    ),
                    const SizedBox(height: AppSizes.p12),
                    AppTextField(
                      label: 'Tipe',
                      controller: _tipeController,
                      validator: (val) => Validators.required(val, 'Tipe'),
                    ),
                    const SizedBox(height: AppSizes.p12),
                    AppTextField(
                      label: 'Warna',
                      controller: _warnaController,
                      validator: (val) => Validators.required(val, 'Warna'),
                    ),
                    const SizedBox(height: AppSizes.p12),
                    AppTextField(
                      label: 'Nomor Rangka',
                      controller: _norangkaController,
                      validator: (val) => Validators.required(val, 'Nomor Rangka'),
                    ),
                    const SizedBox(height: AppSizes.p12),
                    AppTextField(
                      label: 'Nomor Mesin',
                      controller: _nomesinController,
                      validator: (val) => Validators.required(val, 'Nomor Mesin'),
                    ),

                    const Divider(height: 32),
                    _buildSectionTitle('Informasi Aset'),
                    DropdownButtonFormField<String>(
                      value: _jenisKendaraan,
                      decoration: const InputDecoration(labelText: 'Jenis Kendaraan'),
                      items: ['Mobil Penumpang', 'Mobil Barang', 'Sepeda Motor', 'Kendaraan Khusus'].map((e) {
                        return DropdownMenuItem(value: e, child: Text(e));
                      }).toList(),
                      onChanged: (val) => setState(() => _jenisKendaraan = val!),
                    ),
                    const SizedBox(height: AppSizes.p12),
                    AppTextField(
                      label: 'Tahun Perolehan',
                      controller: _tahunController,
                      keyboardType: TextInputType.number,
                      validator: (val) => Validators.number(val, 'Tahun Perolehan'),
                    ),
                    const SizedBox(height: AppSizes.p12),
                    AppTextField(
                      label: 'Nilai Aset (Rp)',
                      controller: _nilaiAsetController,
                      keyboardType: TextInputType.number,
                      validator: (val) => Validators.number(val, 'Nilai Aset'),
                    ),
                    const SizedBox(height: AppSizes.p12),
                    DropdownButtonFormField<String>(
                      value: _sumberDana,
                      decoration: const InputDecoration(labelText: 'Sumber Dana'),
                      items: ['APBD', 'APBN', 'DAK', 'Lainnya'].map((e) {
                        return DropdownMenuItem(value: e, child: Text(e));
                      }).toList(),
                      onChanged: (val) => setState(() => _sumberDana = val!),
                    ),
                    const SizedBox(height: AppSizes.p12),
                    DropdownButtonFormField<String>(
                      value: _selectedOpd,
                      decoration: const InputDecoration(labelText: 'OPD Pengguna'),
                      items: _opdList.map((e) {
                        return DropdownMenuItem(value: e, child: Text(e, overflow: TextOverflow.ellipsis));
                      }).toList(),
                      onChanged: (val) => setState(() => _selectedOpd = val!),
                    ),

                    const Divider(height: 32),
                    _buildSectionTitle('Status Kendaraan'),
                    DropdownButtonFormField<String>(
                      value: _kondisi,
                      decoration: const InputDecoration(labelText: 'Kondisi'),
                      items: ['Baik', 'Rusak Ringan', 'Rusak Berat'].map((e) {
                        return DropdownMenuItem(value: e, child: Text(e));
                      }).toList(),
                      onChanged: (val) => setState(() => _kondisi = val!),
                    ),
                    const SizedBox(height: AppSizes.p12),
                    DropdownButtonFormField<String>(
                      value: _statusPenggunaan,
                      decoration: const InputDecoration(labelText: 'Status Penggunaan'),
                      items: ['Digunakan', 'Dipinjamkan', 'Tidak Digunakan', 'Dalam Perbaikan'].map((e) {
                        return DropdownMenuItem(value: e, child: Text(e));
                      }).toList(),
                      onChanged: (val) => setState(() => _statusPenggunaan = val!),
                    ),

                    const SizedBox(height: AppSizes.p48),
                    PrimaryButton(
                      text: 'Simpan Data',
                      onPressed: _save,
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
