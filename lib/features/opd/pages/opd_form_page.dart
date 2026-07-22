import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/utils/validators.dart';
import '../../../shared/widgets/app_text_field.dart';
import '../../../shared/widgets/primary_button.dart';
import '../../../models/opd_model.dart';
import '../providers/opd_provider.dart';

class OpdFormPage extends ConsumerStatefulWidget {
  final OpdModel? opd;
  const OpdFormPage({Key? key, this.opd}) : super(key: key);

  @override
  ConsumerState<OpdFormPage> createState() => _OpdFormPageState();
}

class _OpdFormPageState extends ConsumerState<OpdFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _singkatanController = TextEditingController();
  final _alamatController = TextEditingController();
  final _penanggungJawabController = TextEditingController();
  final _teleponController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.opd != null) {
      _namaController.text = widget.opd!.namaOpd;
      _singkatanController.text = widget.opd!.singkatan;
      _alamatController.text = widget.opd!.alamat;
      _penanggungJawabController.text = widget.opd!.namaPenanggungJawab;
      _teleponController.text = widget.opd!.nomorTelepon;
    }
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      final isEditing = widget.opd != null;
      final newOpd = OpdModel(
        idOpd: isEditing ? widget.opd!.idOpd : const Uuid().v4(),
        namaOpd: _namaController.text,
        singkatan: _singkatanController.text,
        alamat: _alamatController.text,
        namaPenanggungJawab: _penanggungJawabController.text,
        nomorTelepon: _teleponController.text,
        jumlahKendaraan: isEditing ? widget.opd!.jumlahKendaraan : 0,
      );

      if (isEditing) {
        ref.read(opdProvider.notifier).updateOpd(newOpd);
      } else {
        ref.read(opdProvider.notifier).addOpd(newOpd);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data OPD berhasil disimpan')),
      );
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.opd == null ? 'Tambah OPD' : 'Edit OPD'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.p16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppTextField(
                label: 'Nama OPD',
                controller: _namaController,
                validator: (val) => Validators.required(val, 'Nama OPD'),
              ),
              const SizedBox(height: AppSizes.p16),
              AppTextField(
                label: 'Singkatan',
                controller: _singkatanController,
                validator: (val) => Validators.required(val, 'Singkatan'),
              ),
              const SizedBox(height: AppSizes.p16),
              AppTextField(
                label: 'Alamat',
                controller: _alamatController,
                maxLines: 3,
                validator: (val) => Validators.required(val, 'Alamat'),
              ),
              const SizedBox(height: AppSizes.p16),
              AppTextField(
                label: 'Nama Penanggung Jawab',
                controller: _penanggungJawabController,
                validator: (val) => Validators.required(val, 'Nama Penanggung Jawab'),
              ),
              const SizedBox(height: AppSizes.p16),
              AppTextField(
                label: 'Nomor Telepon',
                controller: _teleponController,
                keyboardType: TextInputType.phone,
                validator: (val) => Validators.required(val, 'Nomor Telepon'),
              ),
              const SizedBox(height: AppSizes.p32),
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
